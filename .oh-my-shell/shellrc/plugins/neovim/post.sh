# Install python version required by neovim
pyenv install --skip-existing "${_NEOVIM_PYENV_VIRTUALENV_VERSION}"
# Create python environement for neovim only
pyenv virtualenv "${_NEOVIM_PYENV_VIRTUALENV_VERSION}" "${_NEOVIM_PYENV_VIRTUALENV_NAME}"
# Install neovim python dependencies
# src: https://neovim.io/doc/user/provider.html#provider-python
pyenv exec python -m pip install --upgrade pip
for pkg in pynvim
do
    pyenv shell "${_NEOVIM_PYENV_VIRTUALENV_NAME}" && \
        pyenv exec python -m pip install --upgrade "$pkg"
done
