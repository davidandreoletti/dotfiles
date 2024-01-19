# Show containers in a specific network
#  Usage: docker_show_containers_in_network "my-container-name" where my-container-name is taken from docker ps's CONTAINER NAME column
alias docker_show_containers_in_network="f_docker_showContainersInNetwork $1"

# SSH into a running docker container
# Usage: docker_ssh_into_container "my-container-name", where my-container-name is taken from docker ps's CONTAINER NAME column
alias docker_ssh_into_container="f_docker_SSHIntoContainer "

# Usage: docker_prune_specific_dangling_images_layer  <image_id>
alias docker_prune_specific_dangling_images_layer="docker rmi "

# Usage: docker_prune_all_dangling_images_layers
alias docker_prune_all_dangling_images_layers="docker rmi \$(docker images -f dangling=true -q)"

# Usage: docker_remove_container_by_volume "(partial) volume name"
alias docker_remove_container_by_volume="f_docker_RemoveContainerByVolume "

# Usage: docker_prune_all
alias docker_prune_all="docker system prune --all --force --volumes"

# Kill all running containers
# Usage: docker_kill_all
alias docker_kill_all="docker ps -q -a | xargs -n1 -I _ docker kill _"

# Delete all stopped containers
alias docker_delete_all_stopped_containers="docker ps -q -a | xargs -n1 -I _ docker rm _"

# Delete all stopped containers along with associated volumes
alias docker_delete_all_stopped_containers_and_associated_volumes="docker ps -q -a | xargs -n1 -I _ docker rm --volumes _"

# Delete all images
alias docker_delete_all_images="docker images -q | xargs -n1 -I _ docker rmi _"
