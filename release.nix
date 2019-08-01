{
  nixpkgs ? <nixpkgs>,
  pkgs ? import nixpkgs {}
}:

let
  compilers = with pkgs; {
    gcc5 = overrideCC stdenv gcc5;
    gcc6 = overrideCC stdenv gcc6;
    gcc7 = stdenv;
    gcc8 = overrideCC stdenv gcc8;
    gcc9 = overrideCC stdenv gcc9;
  };

  originalDerivation = [ (pkgs.callPackage (import ./derivation.nix) {}) ];

  f = libname: libs: derivs: with pkgs.lib;
    concatMap (deriv:
      mapAttrsToList (libVers: lib:
        (deriv.override { "${libname}" = lib; }).overrideAttrs
          (old: { name = "${old.name}-${libVers}"; })
      ) libs
    ) derivs;

  overrides = [
    (f "stdenv" compilers)
  ];
in
  pkgs.lib.foldl (a: b: a // { "${b.name}" = b; }) {} (
    pkgs.lib.foldl (a: f: f a) originalDerivation overrides
  )
