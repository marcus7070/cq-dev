{ lib
  , buildPythonPackage
  , isPy3k
  , pythonOlder
  , fetchFromGitHub
  , pyparsing
  , opencascade
  , stdenv
  , python
  , cmake
  , swig
  , ninja
  , smesh
  , freetype
  , libGL
  , libGLU
  , libX11
  , six
  , makeFontsConf
  , freefont_ttf
  , documentation ? false
  , sphinx
  , sphinx_rtd_theme
}:

let 
  pythonocc-core-cadquery = stdenv.mkDerivation {
    pname = "pythonocc-core-cadquery";
    version = "0.18.2";

    src = fetchFromGitHub {
      owner = "CadQuery";
      repo = "pythonocc-core";
      # no proper release to to use, this commit copied from the Anaconda receipe
      rev = "701e924ae40701cbe6f9992bcbdc2ef22aa9b5ab";
      sha256 = "07zmiiw74dyj4v0ar5vqkvk30wzcpjjzbi04nsdk5mnlzslmyi6c";
    };

    nativeBuildInputs = [ 
      cmake
      swig
      ninja
    ];

    buildInputs = [
      python
      opencascade
      smesh
      freetype
      libGL
      libGLU
      libX11
    ];

    propagatedBuildInputs = [
      six
    ];

    cmakeFlags = [
      "-Wno-dev"
      "-DPYTHONOCC_INSTALL_DIRECTORY=${placeholder "out"}/${python.sitePackages}/OCC"
      "-DSMESH_INCLUDE_PATH=${smesh}/include/smesh"
      "-DSMESH_LIB_PATH=${smesh}/lib"
      "-DPYTHONOCC_WRAP_SMESH=TRUE"
    ];
  };

  sphinx-build = if documentation then
    python.pkgs.sphinx.overrideAttrs (super: {
      propagatedBuildInputs = super.propagatedBuildInputs or [] ++ [ python.pkgs.sphinx_rtd_theme ];
      postFixup = super.postFixup or "" + ''
        # Do not propagate Python
        rm $out/nix-support/propagated-build-inputs
      '';
    })
  else null;


in
  buildPythonPackage rec {
    pname = "cadquery";
    version = "2.0RC0";

    outputs = [ "out" ] ++ (lib.optional documentation "doc");
  
    # src = fetchFromGitHub {
    #   owner = "CadQuery";
    #   repo = pname;
    #   rev = version;
    #   sha256 = "1xgd00rih0gjcnlrf9s6r5a7ypjkzgf2xij2b6436i76h89wmir3";
    # };

    src = ./cadquery ;
  
    nativeBuildInputs = lib.optionals documentation [ sphinx sphinx_rtd_theme ];
  
    buildInputs = [
      opencascade
    ]; 
  
    propagatedBuildInputs = [
      pyparsing
      pythonocc-core-cadquery
    ];
  
    # If the user wants extra fonts, probably have to add them here
    FONTCONFIG_FILE = makeFontsConf {
      fontDirectories = [ freefont_ttf ];
    };

    # Build errors on 2.7 and >=3.8 (officially only supports 3.6 and 3.7).
    disabled = !(isPy3k && (pythonOlder "3.8"));

    # Documentation
    postBuild = lib.optionalString documentation ''
      PYTHONPATH=$PYTHONPATH:$(pwd)
      ./build-docs.sh
      mkdir -p $doc
      cp -r target/docs $doc
    '';
    doCheck = false;
  
    meta = with lib; {
      description = "Parametric scripting language for creating and traversing CAD models";
      homepage = "https://github.com/CadQuery/cadquery";
      license = licenses.asl20;
      maintainers = with maintainers; [ costrouc marcus7070 ];
    };
  }
