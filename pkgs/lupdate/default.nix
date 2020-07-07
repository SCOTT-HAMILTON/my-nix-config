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

  pname = "lupdate";
  version = "5.14.4";

  src = ./src.tar.gz;
  
  # nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ patchelf makeWrapper ];

  postPatch = ''
    patchelf --set-interpreter ${glibc}/lib/ld-linux-x86-64.so.2 lupdate
  '';

  installPhase = ''
    install -Dm 555 lupdate $out/bin/.lupdate-wrapped
    makeWrapper $out/bin/.lupdate-wrapped $out/bin/lupdate \
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
