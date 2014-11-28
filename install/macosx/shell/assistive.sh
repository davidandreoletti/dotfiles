###############################################################################
# Assistive device related functions
###############################################################################

assistive_enable_accessibility_api() {
    local db="/private/var/db/.AccessibilityAPIEnabled"
    sudo ${SUDO_OPTIONS} echo -n 'a' | sudo ${SUDO_OPTIONS} tee "$db" > /dev/null 2>&1; 
    sudo ${SUDO_OPTIONS} chmod 444 "$db"
}
