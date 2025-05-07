function f_mqtt_send_anonymous_message() {
	local host="$1"
	local port="$2"
	local topic="$3"
	local message="$4"

	mqttx pub -t "$topic" -q 1 -h "$host" -p "$port" -m "$message"
}
