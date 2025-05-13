# Usage: mqtt_send_anon_message "localhost" "1883" "mytopic/" "my message"
alias mqtt_send_anon_message="f_mqtt_send_anonymous_message"

# Usage: tmqtt "mqtt://test.mosquitto.org" "#"
alias tmqtt='mqttui --broker '

# Usage: tmqtt_logs "mqtt://test.mosquitto.org" "#"
alias tmqtt_logs='mqttui log --broker '
