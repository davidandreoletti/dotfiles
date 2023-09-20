# Install optimized python version X with brew
# libbzip2's shared lib might be have installed a libbz2.so.1.0. If so:
# - On linux: ln -s /usr/lib64/libbz2.so.1.0.*  /usr/lib64/libbz2.so.1.0
# - On macOS: not needed ?
alias pyenv_install="env PYTHON_CONFIGURE_OPTS='--enable-optimizations --with-lto' PYTHON_CFLAGS='-march=native -mtune=native' pyenv install"
