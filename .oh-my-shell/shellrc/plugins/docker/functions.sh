f_docker_showContainersInNetwork() {
    # https://stackoverflow.com/a/43904733
    docker network inspect $1 -f "{{json .Containers }}"
}

f_docker_SSHIntoContainer() {
	local containerName="$1"
	local dockerContainerID="`docker ps | grep \"$containerName\" | cut -d ' ' -f 1`"; 
	docker exec -it "$dockerContainerID" /bin/sh
}

f_docker_RemoveContainerAndAssociatedVolumes() {
    local volumeRegex="$1"
    local volumeName=`docker volume ls -q | grep "$volumeRegex"`
    local containerId=`docker ps --filter volume="$volumeName" --format {{.ID}}`
    docker rm "$containerId" -f --volumes
}

