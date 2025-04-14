#!/bin/bash

if ! systemctl status httpd &>/dev/null && ! systemctl status apache2 &>/dev/null; then
    echo "Apache is NOT installed. Installing..."

    if [ -f /etc/redhat-release ]; then
        echo " CentOS / RHEL"
        sudo yum install -y httpd
        SERVICE_NAME="httpd"
    elif [ -f /etc/debian_version ]; then
        echo " Ubuntu / Debian"
        sudo apt update && sudo apt install -y apache2
        SERVICE_NAME="apache2"
    else
        echo "Unsupported OS"
        exit 1
    fi

    echo "Apache installed successfully."

else
    echo "Failed to start Apache ($SERVICE_NAME)."
    exit 1
fi


