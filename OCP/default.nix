{ lib
  , stdenv
  , buildPythonPackage
  , symlinkJoin
  , fetchFromGitHub
  , pythonOlder
  , pythonAtLeast
  , cmake
  , ninja
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
  , libcxx
  , gcc8
  , clang
  , pyparsing
  , pybind11
  , cymbal
  , schema
  , click
  , llvm_9
  , glibc
  , libglvnd
  , xlibs
  , python
  , gcc-unwrapped
}:
let

  conda-like-libs = symlinkJoin {
    name = "OCP-conda-like-libs";
    paths = [
      opencascade-occt
      llvmPackages_9.libclang
    ];
  };

  # intermediate step, do pybind, cmake in the next step
  ocp-pybound = stdenv.mkDerivation rec {
    pname = "pybound-ocp";
    version = "7.4-RC1";

    src = fetchFromGitHub {
      owner = "CadQuery";
      repo = "OCP";
      rev = version;
      sha256 = "04qh9fdbs5bay0zrhb5qm512g06h3rb9rhh4dma8xv5hxybf68di";
      fetchSubmodules = true;
    };
  
  phases = [
    "unpackPhase"
    "patchPhase"
    "buildPhase"
    "installPhase"
  ];

  CONDA_PREFIX = "${conda-like-libs}";

  nativeBuildInputs = [
    toml
    clang # the python package
    logzero
    pandas
    joblib
    pathpy
    tqdm
    jinja2
    toposort
    pyparsing
    pybind11
    cymbal
    schema
    click
    libcxx
    glibc
    glibc.dev
  ];

  # prePatch = ''
  #   # make sure we only refer to the headers from nixpkgs, not the vendored
  #   # headers that are only used in the mac build I think.
  #   rm -rf ./opencascade
  # '';

  patches = [
    ./py-fix.patch
    # note the order of the include paths in this patch are important, build
    # will fail if they are out of order
    ./includes.patch
    ./less-warnings.patch
  ];

  postPatch = ''
    substituteInPlace pywrap/bindgen/CMakeLists.j2 \
    --subst-var-by "python" "${python}"
    substituteInPlace pywrap/bindgen/utils.py \
    --subst-var-by "features_h" "${glibc.dev}/include" \
    --subst-var-by "limits_h" "${gcc8.cc}/lib/gcc/x86_64-unknown-linux-gnu/8.4.0/include-fixed" \
    --subst-var-by "type_traits" "${libcxx}/include/c++/v1" \
    --subst-var-by "stddef_h" "${gcc8.cc}/lib/gcc/x86_64-unknown-linux-gnu/8.4.0/include" \
    --subst-var-by "gldev" "${libglvnd.dev}" \
    --subst-var-by "libx11dev" "${xlibs.libX11.dev}" \
    --subst-var-by "xorgproto" "${xlibs.xorgproto}"
  '';

  preBuild = ''
    export PYBIND11_USE_CMAKE=1
    export PYTHONPATH=$PYTHONPATH:$(pwd)/pywrap 
  '';

  buildPhase = ''
    runHook preBuild
    echo "starting bindgen parse"
    python -m bindgen -n $NIX_BUILD_CORES parse ocp.toml out.pkl && \
    echo "finished bindgen parse" && \
    echo "starting transform" && \
    python -m bindgen -n $NIX_BUILD_CORES transform ocp.toml out.pkl out_f.pkl && \
    echo "finished bindgen transform" && \
    echo "starting generate" && \
    python -m bindgen -n $NIX_BUILD_CORES generate ocp.toml out_f.pkl && \
    echo "finished bindgen generate"
  '';

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
  '';
  };
    
in stdenv.mkDerivation rec {
  pname = "ocp";
  version = "7.4-RC1";

  src = ocp-pybound;

  disabled = pythonOlder "3.6" || pythonAtLeast "3.9";
  
  CONDA_PREFIX = "${conda-like-libs}";

  # phases = [ "unpackPhase" "patchPhase" "buildPhase" ];

  nativeBuildInputs = [
    cmake
    ninja
    toml
    clang # the python package
    # llvm_9
    # llvmPackages_9.clang
    logzero
    pandas
    joblib
    pathpy
    tqdm
    jinja2
    toposort
    pyparsing
    pybind11
    cymbal
    schema
    click
    # glibc.dev
    # llvmPackages_9.libcxx
    libcxx
    # llvmPackages_9.clang-unwrapped
    # gcc8.cc
    # glibc
  ];
  
  buildInputs = [
    libglvnd.dev
    xlibs.libX11.dev
    xlibs.xorgproto
    # glibc
    # glibc.dev
    # llvm_9
    gcc8.cc
  ]; 

  # probably need OCCT in that cmake prefix as well
  preConfigure = ''
    export CMAKE_PREFIX_PATH=${pybind11}/share/cmake/pybind11:$CMAKE_PREFIX_PATH
    export PYBIND11_USE_CMAKE=1
    cp -v ./*.pkl ./OCP/
  '';

  preBuild = ''
    # export CMAKE_INCLUDE_PATH=$CMAKE_INCLUDE_PATH:$(pwd)/opencascade
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-deprecated-declarations"
  '';

  propagatedBuildInputs = [
    opencascade-occt
  ];

  cmakeFlags = [
    "-S ../OCP"
  ];

  checkPhase = ''
    pushd .
    cd build
    python -c "import OCP"
    popd
  '';

  installPhase = ''
    dest=$(toPythonPath $out)
    install -D --mode=0555 --target=$dest ./*.so
  '';
    # install -D --target=$dest ${ocp-pybound}/*.pkl
    # echo "from .OCP import *" > $dest/__init__.py

  meta = with lib; {
    description = "Python wrapper for Opencascade Technology 7.4 generated using pywrap";
    homepage = "https://github.com/CadQuery/OCP";
    # license = licenses.asl20;  # not yet set
    maintainers = with maintainers; [ marcus7070 ];
  };
}
