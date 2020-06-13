{ stdenv, buildPythonPackage, pythonOlder, fetchFromGitHub, pyparsing, pytest }:

buildPythonPackage rec {
  # somehow Conda & Pypi have 0.12.5, despite commit: https://github.com/mozman/ezdxf/commit/799adffe172491741bf956e151560839f30b3fca#diff-3d0319a79bc9efbe982a594984ad1564
  # taking ezdxf from 0.12.4 to 0.13b0.
  version = "0.13b0";
  pname = "ezdxf";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "mozman";
    repo = "ezdxf";
    rev = "34f17dcfc5180e274d8596874130bb322be99968";
    sha256 = "1p6d7vgly8w589rm953q500xhb3wvm5igfsr040vglj823x7acbw";
  };

  checkInputs = [ pytest ];
  checkPhase = "pytest tests integration_tests";

  propagatedBuildInputs = [ pyparsing ];

  meta = with stdenv.lib; {
    description = "Python package to read and write DXF drawings (interface to the DXF file format)";
    homepage = "https://github.com/mozman/ezdxf/";
    license = licenses.mit;
    maintainers = with maintainers; [ hodapp ];
    platforms = platforms.unix;
  };
}
