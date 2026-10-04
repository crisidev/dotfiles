{ pkgs, ... }:
let
  # Jellyfin 12.1 (Jellyfin.Controller/Model) targets net10.0, so plugins must
  # too. Use dotnetCorePackages.combinePackages to add other SDKs side by side.
  dotnet = pkgs.dotnetCorePackages.sdk_10_0;
in
{
  home.packages = [ dotnet ];

  home.sessionVariables = {
    # Language servers and `dotnet tool` apphosts look the SDK up here instead
    # of following the wrapped `dotnet` in PATH.
    DOTNET_ROOT = "${dotnet}/share/dotnet";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    DOTNET_NOLOGO = "1";
  };

  # `dotnet tool install -g` drops binaries here.
  home.sessionPath = [ "$HOME/.dotnet/tools" ];
}
