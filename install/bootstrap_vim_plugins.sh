for cmd in vim nvim;
do
    if command -v $cmd >/dev/null 2>&1; then
      echo "Bootstraping $cmd ..."
      command $cmd '+PlugUpgrade!' '+PlugUpdate' '+PlugClean!' '+PlugUpdate' '+qall'
    fi
done
