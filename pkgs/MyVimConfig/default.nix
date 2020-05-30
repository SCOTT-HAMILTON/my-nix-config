{ lib
, stdenv
, fetchFromGitHub
, coreutils
}:
stdenv.mkDerivation rec {

  pname = "Myvimconfig";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "SCOTT-HAMILTON";
    repo = "vimconfig";
    rev = "master";
    sha256 = "0f9fpgc16hscx73qf1yisf75bg07faqgkqp7g28jr8q5qbyzzmv4";
  };

  propagatedBuildInputs = [ coreutils ];

  patches = [ ./remove-pathogen.patch ];

  postPatch = ''
    find . -maxdepth 1 | egrep -v "^\./ftplugin$|^\./vimrc$|^\.$" | xargs -n1 -L1 -r -I{} rm -rf {}
  '';

  installPhase = ''
    mkdir $out
    cp -r ftplugin $out
    cp vimrc $out
  '';

  meta = {
    description = "My vim config";
    license = lib.licenses.mit;
    homepage = "https://github.com/SCOTT-HAMILTON/vimconfig";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = stdenv.lib.platforms.linux;
  };
}
