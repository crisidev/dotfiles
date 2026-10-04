# Unlock the root LUKS volume with the TPM plus a PIN, the passphrase staying
# as the fallback. Like system-theme, it lives in /etc and /boot, out of
# home-manager's reach: `luks-tpm install|enroll|recovery|status|revert`
# changes the host with sudo, using the host's tools (the initrd has to match
# them, so nothing here comes from the store).
#
# The key is sealed to PCR 7 only: the Secure Boot state and the certificates
# that verified shim, GRUB and the kernel. A new Ubuntu-signed kernel doesn't
# change it; PCRs 8/9 (GRUB command line, kernel and initrd hashes) change on
# every update. PCR 7 doesn't cover the unsigned initrd or the command line,
# though, so without a PIN anyone holding the laptop could have the TPM
# unseal the key; the TPM's dictionary-attack lockout rate-limits PIN guesses.
#
# The PIN needs systemd-cryptsetup in the initrd, which initramfs-tools'
# cryptroot lacks, so install switches to dracut (Ubuntu's default since
# 25.10; it keeps an update-initramfs wrapper). The unlock options go on the
# kernel command line, which dracut reads whether or not it is hostonly.
#
# Firmware db/dbx updates, shim SBAT revocations or toggling Secure Boot
# change PCR 7: boot falls back to the passphrase, then `luks-tpm enroll`
# seals the key again.
#
# tries=0: systemd-cryptsetup's default of 3 counts loop iterations, not
# prompts. The TPM attempt takes one and a wrong passphrase is retried once
# unasked (the auto-discovered key file is dropped first), so a single typo
# exhausted it and left the initrd hanging behind Plymouth. A wrong PIN is
# re-asked on its own loop. rd.luks.options replaces the crypttab options
# outright, so deleting `tpm2-device=auto,` from it in the GRUB editor boots
# straight to the passphrase prompt (forgotten PIN).
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.luksTpm;
  device = "/dev/disk/by-uuid/${cfg.uuid}";
  dracutConf = "/etc/dracut.conf.d/90-luks-tpm.conf";
  grubConf = "/etc/default/grub.d/90-luks-tpm.cfg";
  luksOptions = "tpm2-device=auto,tries=0";

  luksTpm = pkgs.writeShellApplication {
    name = "luks-tpm";
    runtimeInputs = with pkgs; [
      coreutils
      gnugrep
    ];
    text = ''
      usage() {
        echo "usage: luks-tpm install|enroll|recovery|status|revert" >&2
        exit 1
      }
      [ $# -eq 1 ] || usage

      device=${lib.escapeShellArg device}
      uuid=${lib.escapeShellArg cfg.uuid}
      name=${lib.escapeShellArg cfg.name}

      status() {
        mokutil --sb-state || true
        if [ -x /usr/bin/dracut ]; then echo "initramfs: dracut"; else echo "initramfs: initramfs-tools"; fi
        for f in ${dracutConf} ${grubConf}; do
          if [ -f "$f" ]; then echo "present: $f"; else echo "missing: $f"; fi
        done
        if grep -q rd.luks.options /proc/cmdline; then
          echo "cmdline: rd.luks.options set"
        else
          echo "cmdline: rd.luks.options not set (reboot after install)"
        fi
        grep -E "^''${name}[[:space:]]" /etc/crypttab || true
        echo
        sudo systemd-cryptenroll "$device"
        # A TPM failure (PCR 7 changed: re-run enroll) shows up here before
        # the passphrase fallback.
        echo
        echo "this boot's unlock:"
        sudo journalctl -b -o cat -t systemd-cryptsetup || true
      }

      install() {
        [[ $(mokutil --sb-state) == *enabled* ]] || { echo "Secure Boot is off: PCR 7 would seal to an insecure state" >&2; exit 1; }
        [ -e /dev/tpmrm0 ] || { echo "no TPM 2.0 (/dev/tpmrm0)" >&2; exit 1; }

        if [ ! -x /usr/bin/dracut ]; then
          # dracut rebuilds every initrd: keep the other kernels' ones from
          # initramfs-tools as a known-good fallback.
          running=$(uname -r)
          for img in /boot/initrd.img-*-generic; do
            [ "$img" = "/boot/initrd.img-$running" ] || [ -e "$img.itools" ] || sudo cp "$img" "$img.itools"
          done
          sudo apt install dracut
        fi

        printf '%s\n' \
          '# dotfiles: luks-tpm (home/programs/luks-tpm.nix)' \
          'add_dracutmodules+=" crypt systemd-cryptsetup tpm2-tss lvm plymouth "' |
          sudo tee ${dracutConf} >/dev/null

        # Single quotes: GRUB_CMDLINE_LINUX expands when grub-mkconfig sources it.
        printf '%s\n' \
          '# dotfiles: luks-tpm (home/programs/luks-tpm.nix)' \
          "GRUB_CMDLINE_LINUX=\"\$GRUB_CMDLINE_LINUX rd.luks.name=$uuid=$name rd.luks.options=$uuid=${luksOptions}\"" |
          sudo tee ${grubConf} >/dev/null

        # crypttab too, so the real root (and dracut's hostonly copy) agree
        # with the command line. Strip then append, so reruns update it.
        sudo sed -i.bak -E "/^''${name}[[:space:]]/ {
          s/,(tpm2-device|tries)=[^,[:space:]]*//g
          s/^([^[:space:]]+[[:space:]]+[^[:space:]]+[[:space:]]+[^[:space:]]+[[:space:]]+[^[:space:]]+)/\1,${luksOptions}/
        }" /etc/crypttab

        # Not dracut --regenerate-all: it walks /lib/modules, which keeps
        # module dirs of long-removed kernels, and fails on them. Ubuntu's
        # wrapper only builds the installed ones (linux-version list).
        sudo update-initramfs -u -k all
        sudo update-grub
        echo
        echo "Reboot: the dracut initrd should ask for the passphrase as before."
        echo "If it doesn't boot, pick an older kernel in GRUB, press e and point initrd at its .itools image."
        echo "Once it boots, run 'luks-tpm enroll'."
      }

      enroll() {
        grep -q rd.luks.options /proc/cmdline || { echo "run 'luks-tpm install' and reboot first" >&2; exit 1; }
        # --wipe-slot drops the previous TPM seal, so this also re-seals after
        # a PCR 7 change.
        sudo systemd-cryptenroll "$device" --wipe-slot=tpm2 \
          --tpm2-device=auto --tpm2-pcrs=${cfg.pcrs} --tpm2-with-pin=yes
        echo
        echo "A wrong PIN is asked again. To skip the TPM for one boot (forgotten PIN),"
        echo "press e in GRUB and delete 'tpm2-device=auto,' from the linux line."
      }

      recovery() {
        echo "Store this key offline: it unlocks the disk like the passphrase."
        sudo systemd-cryptenroll "$device" --recovery-key
      }

      revert() {
        sudo systemd-cryptenroll "$device" --wipe-slot=tpm2
        sudo rm -f ${dracutConf} ${grubConf}
        sudo sed -i -E "/^''${name}[[:space:]]/ s/,(tpm2-device|tries)=[^,[:space:]]*//g" /etc/crypttab
        sudo update-initramfs -u -k all
        sudo update-grub
        echo "dracut stays (the passphrase works with it); to go back fully:"
        echo "  sudo apt install initramfs-tools cryptsetup-initramfs"
      }

      case $1 in
        install | enroll | recovery | status | revert) "$1" ;;
        *) usage ;;
      esac
    '';
  };
in
{
  options.luksTpm = {
    enable = lib.mkEnableOption "TPM2 + PIN unlock of the root LUKS volume (applied by hand with luks-tpm)";
    uuid = lib.mkOption {
      type = lib.types.str;
      description = "UUID of the LUKS partition (blkid / lsblk -f).";
    };
    name = lib.mkOption {
      type = lib.types.str;
      default = "dm_crypt-0";
      description = "Mapper name, as in /etc/crypttab.";
    };
    pcrs = lib.mkOption {
      type = lib.types.str;
      default = "7";
      description = "PCRs the key is sealed to (systemd-cryptenroll --tpm2-pcrs).";
    };
  };

  config = lib.mkIf cfg.enable { home.packages = [ luksTpm ]; };
}
