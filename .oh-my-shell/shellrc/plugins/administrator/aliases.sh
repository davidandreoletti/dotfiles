# % admin, shell
# # Open shell session as administrator user
# ; usage: administrator_open_shell
alias administrator_open_shell="sudo su - administrator -c \"export ADMINISTRATOR_SHELL_OPEN='yes'; $SHELL -i -l \""
