{ lib
, mkDerivationWith
, python3Packages
, fetchFromGitHub
}:

mkDerivationWith python3Packages.buildPythonApplication {
  pname = "cq-editor";
  version = "0.1RC1";

  src = ./CQ-editor;

  propagatedBuildInputs = with python3Packages; [
    cadquery
    Logbook
    pyqt5
    pyparsing
    pyqtgraph
    # spyder592
    spyder
    pathpy
    # qtconsole592
    qtconsole
    requests
  ];

  postFixup = ''
    wrapQtApp "$out/bin/cq-editor"
  '';

  checkInputs = with python3Packages; [
    pytest
    pytest-xvfb
    pytest-mock
    pytestcov
    pytest-repeat
    pytest-qt
  ];

  checkPhase = ''
    pytest --no-xvfb
  '';

  # requires X server
  doCheck = false;

  meta = with lib; {
    description = "CadQuery GUI editor based on PyQT";
    homepage = "https://github.com/CadQuery/CQ-editor";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc marcus7070 ];
  };

}
