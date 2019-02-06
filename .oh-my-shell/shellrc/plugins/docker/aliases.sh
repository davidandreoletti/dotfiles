# Show containers in a specific network
#  Usage: dockerShowContainersInNetwork "my-container-name" where my-container-name is taken from docker ps's CONTAINER NAME column
alias dockerShowContainersInNetwork="f_docker_showContainersInNetwork $1"

# SSH into a running docker container
# Usage: dockerSSHIntoContainer "my-container-name", where my-container-name is taken from docker ps's CONTAINER NAME column
alias dockerSSHIntoContainer="f_docker_SSHIntoContainer "

# Usage: dockerPruneSpecificDanglingImagesLayer  <image_id>
alias dockerPruneSpecificDanglingImagesLayer="docker rmi "

# Usage: dockerPruneAllDanglingImagesLayers 
alias dockerPruneAllDanglingImagesLayers="docker rmi \$(docker images -f dangling=true -q)"

# Usage: dockerRemoveContainerAndAssociatedVolumes "volume name"
alias dockerRemoveContainerAndAssociatedVolumes="f_docker_RemoveContainerAndAssociatedVolumes "

