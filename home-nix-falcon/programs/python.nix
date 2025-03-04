{ pkgs, ... }: {
  home.packages = with pkgs; [
    pre-commit
    poetry
    (python312.withPackages (p:
      with p; [
        black
        boto3
        boto3-stubs
        ipython
        isort
        pip
        pynvim
        pytest
        virtualenv
        numpy
      ]))
    uv
  ];
}
