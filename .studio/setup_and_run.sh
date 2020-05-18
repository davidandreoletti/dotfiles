# Automate setup + install + run instructions at https://github.com/marian-m12l/studio/blob/master/README_fr.md

# Copy binaries
cp -v ~/Library/Application\ Support/Luniitheque/lib/lunii-{device-gateway,device-wrapper,java-util}.jar .

# Get app token
TOKEN="$(cat ~/Library/Application\ Support/Luniitheque/.local.properties | grep "tokens=" | awk -F'=' '{print $2}' | sed -r 's/\\:/:/g' | jq '.tokens.access_tokens.data.firebase' | sed 's/"//g')"
#TOKEN="$(cat ~/Library/Application\ Support/Luniitheque/.local.properties | grep "token=" | awk -F'=' '{print $2}' | sed -r 's/\\:/:/g' | jq '.firebase')"
echo "API TOKEN: $TOKEN"

# Dowload packs metadata
mkdir -pv db && curl -v -X GET "https://lunii-data-prod.firebaseio.com/packs.json?auth=$TOKEN" > db/official.json

# Run app
eval "$(jenv init -)"
chmod 700 studio-web-ui-0.1.15/studio-macos.sh && jenv shell "14.0" && studio-web-ui-0.1.15/studio-macos.sh && sleep 10s && open "http://localhost:8080"
