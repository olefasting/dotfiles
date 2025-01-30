# vim: set ts=8 sw=2 sts=2 et:

{ pkgs ? import <nixpkgs> {}}:

let
jupyterPort = pkgs.config.jupyterPort;
fhs = pkgs.buildFHSUserEnv {
  name = "julia-fhs";
  targetPkgs = pkgs: with pkgs;
    [
      git
      gitRepo
      gnupg
      autoconf
      curl
      procps
      gnumake
      utillinux
      m4
      gperf
      unzip
      libGL libGLU
      xorg.libXi xorg.libXmu freeglut
      xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib
      ncurses5
      stdenv.cc
      binutils


      julia_11

      # Arpack.jl
      arpack
      gfortran.cc
      (pkgs.runCommand "openblas64_" {} ''
        mkdir -p "$out"/lib/
        ln -s ${openblasCompat}/lib/libopenblas.so "$out"/lib/libopenblas64_.so.0
      '')

      # IJulia.jl
      mbedtls
      zeromq3
      python3Packages.jupyterlab
      # ImageMagick.jl
      imagemagickBig
      # HDF5.jl
      hdf5
      # Cairo.jl
      cairo
      gettext
      pango.out
      glib.out
      # Gtk.jl
      gtk3
      gdk_pixbuf
      # GZip.jl # Required by DataFrames.jl
      gzip
      zlib
      # GR.jl # Runs even without Xrender and Xext, but cannot save files, so those are required
      xorg.libXt
      xorg.libX11
      xorg.libXrender
      xorg.libXext
      glfw
      freetype
    ];
  multiPkgs = pkgs: with pkgs; [ zlib ];
  runScript = "bash";
  profile = with pkgs; ''
    export LD_LIBRARY_PATH="${glfw}/lib:${mesa}/lib:${freetype}/lib:${imagemagick}/lib:${portaudio}/lib:${libsndfile.out}/lib:${libxml2.out}/lib:${expat.out}/lib:${cairo.out}/lib:${pango.out}/lib:${gettext.out}/lib:${glib.out}/lib:${gtk3.out}/lib:${gdk_pixbuf.out}/lib:${cairo.out}:${tk.out}/lib:${tcl.out}/lib:${pkgs.sqlite.out}/lib:${pkgs.zlib}/lib"
    export EXTRA_LDFLAGS="-L/lib"
    export EXTRA_CCFLAGS="-I/usr/include"
    '';
  };
  shellHook = ''
    TEMPDIR=$(mktemp -d -p /tmp)
    mkdir -p $TEMPDIR
    cp -r ${pkgs.python3Packages.jupyterlab}/share/jupyter/lab/* $TEMPDIR
    chmod -R 755 $TEMPDIR
    echo "$TEMPDIR is the app directory"
    # start jupyterlab
    jupyter lab --app-dir=$TEMPDIR --port=${jupyterPort} --no-browser
  '';

in pkgs.stdenv.mkDerivation {
  name = "julia-shell";
  nativeBuildInputs = [fhs];
  shellHook = "exec julia-fhs";
}
