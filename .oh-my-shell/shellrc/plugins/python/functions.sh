function f_python_clean_artefacts() {
    local dirPath="$1"
    find "$dirPath" -type f -name "*.log" -exec command rm -vf {} \;
    find "$dirPath" -type f -name "*.pyc" -exec command rm -vf {} \;
    find "$dirPath" -type f -name "*.egg-info" -exec command rm -rvf {} \; 
}

