{ pkgs, ... }:
{
  home.packages = [
    (pkgs.python312.withPackages (
      p: with p; [
        black
        boto3
        boto3-stubs
        ipython
        isort
        numpy
        pip
        pynvim
        pytest
        virtualenv
      ]
    ))
  ];
}
