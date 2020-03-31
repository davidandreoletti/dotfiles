function f_python_clean_artefacts() {
    local dirPath="$1"
    find "$dirPath" -type f -name "*.log" -exec rm -vf {} \;
    find "$dirPath" -type f -name "*.pyc" -exec rm -vf {} \;
    find "$dirPath" -type f -name "*.egg-info" -exec rm -rvf {} \; 
}

