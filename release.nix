{
  nixpkgs ? <nixpkgs>,
  pkgs ? import nixpkgs {}
}:

let
  compilers = with pkgs; {
    gcc7 = stdenv;
    gcc8 = overrideCC stdenv gcc8;
    clang7 = overrideCC stdenv clang_7;
    clang8 = overrideCC stdenv clang_8;
  };

  boostLibs = {
    inherit (pkgs) boost166 boost167 boost168 boost169;
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
    (f "boost"  boostLibs)
  ];
in
  pkgs.lib.foldl (a: b: a // { "${b.name}" = b; }) {} (
    pkgs.lib.foldl (a: f: f a) originalDerivation overrides
  )
