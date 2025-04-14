#!/bin/bash

if [ -f /etc/redhat-release ]; then
    echo "CentOS / RHEL detected"
    SERVICE_NAME="httpd"
    INSTALL_CMD="sudo yum install -y httpd"
elif [ -f /etc/debian_version ]; then
    echo "Ubuntu / Debian detected"
    SERVICE_NAME="apache2"
    INSTALL_CMD="sudo apt update && sudo apt install -y apache2"
else
    echo "Unsupported OS"
    exit 1
fi

if systemctl status $SERVICE_NAME &>/dev/null; then
    echo "$SERVICE_NAME is already installed. Checking status..."

    if systemctl is-active --quiet $SERVICE_NAME; then
        echo "$SERVICE_NAME is already active"
    else
        echo "Starting $SERVICE_NAME..."
        sudo systemctl start $SERVICE_NAME
        if [ $? -eq 0 ]; then
            echo "$SERVICE_NAME started successfully"
        else
            echo "Failed to start $SERVICE_NAME"
            exit 1
        fi
    fi

    if systemctl is-enabled --quiet $SERVICE_NAME; then
        echo "$SERVICE_NAME is already enabled"
    else
        echo "Enabling $SERVICE_NAME..."
        sudo systemctl enable $SERVICE_NAME
        if [ $? -eq 0 ]; then
            echo "$SERVICE_NAME enabled successfully"
        else
            echo "Failed to enable $SERVICE_NAME"
            exit 1
        fi
    fi

else
    
    echo "$SERVICE_NAME is NOT installed. Installing..."
    $INSTALL_CMD
    if [ $? -eq 0 ]; then
        echo "$SERVICE_NAME installed successfully"
       
        echo "Starting $SERVICE_NAME..."
        sudo systemctl start $SERVICE_NAME
        if [ $? -eq 0 ]; then
            echo "$SERVICE_NAME started successfully"
        else
            echo "Failed to start $SERVICE_NAME"
            exit 1
        fi

        echo "Enabling $SERVICE_NAME..."
        sudo systemctl enable $SERVICE_NAME
        if [ $? -eq 0 ]; then
            echo "$SERVICE_NAME enabled successfully"
        else
            echo "Failed to enable $SERVICE_NAME"
            exit 1
        fi
    else
        echo "Failed to install $SERVICE_NAME"
        exit 1
    fi
fi

echo "Apache setup completed successfully."