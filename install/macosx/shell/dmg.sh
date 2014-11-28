###############################################################################
# DMG format related functions
###############################################################################


# This function will download a DMG from a URL, mount it, find
# the `pkg` in it, install that pkg, and unmount the package.
# usage: install_dmg "Puppet" "http://someurl" "puppet"
function dmg_pkg_install() {
  local name="$1"
  local url="$2"
  local thecommand="$3"

  if which "${thecommand}" >/dev/null; then
    echo "${name} already installed"
    return
  fi

  local dmg_path=$(mktemp -t ${name}-dmg)

  echo "Installing: ${name}"

  # Download the package into the temporary directory
  echo "-- Downloading DMG..."
  echo "${url}"
  curl -L -o ${dmg_path} ${url} 2>/dev/null
  # Mount it
  echo "-- Mounting DMG..."
  local plist_path=$(mktemp -t puppet-bootstrap)
  
  hdiutil attach -plist ${dmg_path} > ${plist_path}
  mount_point=$(grep -E -o '/Volumes/[-.a-zA-Z0-9]+' ${plist_path})

  # Install. It will be the only pkg in there, so just find any pkg
  echo "-- Installing pkg..."
  pkg_path=$(find ${mount_point} -name '*.pkg' -mindepth 1 -maxdepth 1)
  installer -pkg ${pkg_path} -target / >/dev/null

  # Unmount
  echo "-- Unmounting and ejecting DMG..."
  hdiutil eject ${mount_point} >/dev/null
}

