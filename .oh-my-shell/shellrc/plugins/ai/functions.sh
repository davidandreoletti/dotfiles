# Setup opendevin using official instructions: https://github.com/OpenDevin/OpenDevin/blob/51b3ae56c75d3f00bc717849e43a600e54b9683d/docs/documentation/LOCAL_LLM_GUIDE.md?plain=1#L1
f_ai_opendevin_run() {
	local model_name="$1"

	repo_name="opendevin_$(echo "$model_name" | sha256sum | cut -d' ' -f 1)"

	dir="${_DEFAULT_DEVELOPMENT_DIR}/AI_WORKSPACES/opendevin/"
	workspace_dir="$dir/workspace_${repo_name}"

	mkdir -p "$dir"
	mkdir -p "$workspace_dir"

	pushd "$dir"
		git -C "$repo_name" pull || \
			git clone "github.com:OpenDevin/OpenDevin.git" "$repo_name.git"

		pushd "${repo_name}.git"
			# Setup OpenDevin
			make build

			if ! test -f config.toml; then
				make setup-config

				sed -i 's/LLM_API_KEY=.*/LLM_API_KEY="ollama"/' config.toml
				sed -i "s/LLM_MODEL=.*/LLM_MODEL=\"${repo_name}\"/" config.toml
				sed -i 's/LLM_EMBEDDING_MODEL=.*/LLM_EMBEDDING_MODEL="local"/' config.toml
				sed -i 's|LLM_BASE_URL=.*|LLM_BASE_URL="http://localhost:11434"|' config.toml
				sed -i "s/WORKSPACE_DIR=.*/WORKSPACE_DIR=\"${workspace_dir}\"/" config.toml
			fi

			# Launch ollama is not running
			if curl --fail http://localhost:11434/api/tags; then
				:
			else
				echo "ollama is not serving"
				return 1
			fi

			# Run OpenDevin
			make build
			make run

			echo "Launching OpenDevin UI"
			open "http://localhost:3001"
		popd

	popd
}
