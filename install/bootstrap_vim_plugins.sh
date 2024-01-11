if command -v vim >/dev/null 2>&1; then
  echo "Bootstraping Vim ..."
  command vim '+PlugUpdate' '+PlugClean!' '+PlugUpdate' '+qall'
fi

if command -v nvim >/dev/null 2>&1; then
  echo "Bootstraping NeoVim ..."
  command nvim '+PlugUpdate' '+PlugClean!' '+PlugUpdate' '+qall'
fi
