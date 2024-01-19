f_docker_showContainersInNetwork() {
    # https://stackoverflow.com/a/43904733
    docker network inspect $1 -f "{{json .Containers }}"
}

f_docker_SSHIntoContainer() {
    local containerName="$1"
    local dockerContainerID="$(docker ps -a | grep \"$containerName\" | cut -d ' ' -f 1)"
    docker exec -it "$dockerContainerID" /bin/sh
}

f_docker_RemoveContainerByVolume() {
    local volumeRegex="$1"
    local volumeNames=$(docker volume ls --quiet | grep "$volumeRegex")
    local countVolume=$(echo "$volumeNames" | wc -l)

    if [ "$countVolume" -eq "1" ] && [ ! -z "$volumeNames" ]; then
        # One volume found only
        local containerIds=$(docker ps -a --filter volume="$volumeNames" --format {{.ID}})
        local countContainerId=$(echo "$containerIds" | wc -l)

        if [ "$countContainerId" -eq "1" ] && [ ! -z "$containerIds" ]; then
            docker rm "$containerIds" -f --volumes
        else
            echo -e "Containers associated to volume $volumeNames: \n$containerIds \n\nA single container can be delted at once."
        fi
    else
        echo -e "Volumes found: \n $volumeNames \n\n A single volume can be deleted at once."
    fi
}
