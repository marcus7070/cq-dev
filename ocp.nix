{ lib
  , buildPythonPackage
  , fetchFromGitHub
  , pythonOlder
  , pythonAtLeast
  , cmake
  , opencascade-occt
  , toml
  , logzero
  , pandas
  , joblib
  , pathpy
  , tqdm
  , jinja2
  , toposort
  , llvmPackages_9

  # , pyparsing
  # , opencascade
  # , stdenv
  # , python
  # , cmake
  # , swig
  # , ninja
  # , smesh
  # , freetype
  # , libGL
  # , libGLU
  # , libX11
  # , six
  # , makeFontsConf
  # , freefont_ttf
  # , documentation ? false
  # , sphinx
  # , sphinx_rtd_theme
  # , pytest
}:

buildPythonPackage rec {
  pname = "ocp";
  version = "7.4-RC1";

  src = fetchFromGitHub {
    owner = "CadQuery";
    repo = pname;
    rev = version;
    sha256 = "04qh9fdbs5bay0zrhb5qm512g06h3rb9rhh4dma8xv5hxybf68di";
    fetchSubmodules = true;
  };

  # src = ./ocp;

  disabled = pythonOlder "3.6" || pythonAtLeast "3.9";

  nativeBuildInputs = [
    cmake
    toml
    logzero
    pandas
    joblib
    pathpy
    tqdm
    jinja2
    toposort
    llvmPackages_9.clang-unwrapped.python
  ];

  buildInputs = [
    opencascade-occt
  ]; 

  propagatedBuildInputs = [
  ];

  checkInputs = [
  ];

  meta = with lib; {
    description = "Python wrapper for Opencascade Technology 7.4 generated using pywrap";
    homepage = "https://github.com/CadQuery/OCP";
    # license = licenses.asl20;  # not yet set
    maintainers = with maintainers; [ marcus7070 ];
  };
}
