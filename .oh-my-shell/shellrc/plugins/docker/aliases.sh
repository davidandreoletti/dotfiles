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

# Usage: dockerRemoveContainerByVolume "(partial) volume name"
alias dockerRemoveContainerByVolume="f_docker_RemoveContainerByVolume "

# Usage: dockerPruneAll
alias dockerPruneAll="docker system prune --all --force --volumes"

# Kill all running containers
# Usage: dockerKillAll
alias dockerKillAll="docker ps -q -a | xargs -n1 -I _ docker kill _"

# Delete all stopped containers
alias dockerDeleteAllStoppedContainers="docker ps -q -a | xargs -n1 -I _ docker rm _"

# Delete all stopped containers along with associated volumes
alias dockerDeleteAllStoppedContainersAndAssociatedVolumes="docker ps -q -a | xargs -n1 -I _ docker rm --volumes _"

# Delete all images
alias dockerDeleteAllImages="docker images -q | xargs -n1 -I _ docker rmi _"
