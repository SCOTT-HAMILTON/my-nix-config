{ pkgs
, lib
, stdenv
, gcc-unwrapped
, glibc
, glib
, zlib
, makeWrapper
, patchelf
}:
stdenv.mkDerivation rec {

  pname = "lrelease";
  version = "5.14.4";

  src = ./src.tar.gz;
  
  # nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ patchelf makeWrapper ];

  postPatch = ''
    patchelf --set-interpreter ${glibc}/lib/ld-linux-x86-64.so.2 lrelease
  '';

  installPhase = ''
    install -Dm 555 lrelease $out/bin/.lrelease-wrapped
    makeWrapper $out/bin/.lrelease-wrapped $out/bin/lrelease \
      --set LD_LIBRARY_PATH ${zlib}/lib:${lib.getLib gcc-unwrapped}/lib:${lib.getLib glib}/lib:/home/scott/Qt/5.14.1/gcc_64/lib
  '';

  meta = with lib; {
    description = "Lupdate";
    license = licenses.mit;
    homepage = "https://github.com/SCOTT-HAMILTON/Scripts";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
