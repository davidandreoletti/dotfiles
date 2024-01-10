TASKLOG_CONFIG_FILE=$HOME/.config/tasklog/config.yml

alias tasklog_submit_worklog_to_jira="python3 -m tasklog --config=$TASKLOG_CONFIG_FILE submitWorklog --fromFilePath=$HOME/Desktop/tasklogs.txt"
alias tasklog_submit_daily_to_slack="python3 -m tasklog  --config=$TASKLOG_CONFIG_FILE submitDaily   --fromFilePath=$HOME/Desktop/tasklogs.txt"

