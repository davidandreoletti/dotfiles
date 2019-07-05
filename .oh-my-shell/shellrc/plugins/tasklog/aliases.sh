TASKLOG_CONFIG_FILE=$HOME/.config/tasklog/config.yml

alias submitWorklogToJira="python3 -m tasklog --config=$TASKLOG_CONFIG_FILE submitWorklog --fromFilePath=$HOME/Desktop/tasklogs.txt"
alias submitDailyToSlack="python3 -m tasklog  --config=$TASKLOG_CONFIG_FILE submitDaily   --fromFilePath=$HOME/Desktop/tasklogs.txt"

