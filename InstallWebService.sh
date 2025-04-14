#!/bin/bash

# check os famely
if [ -f /etc/redhat-release ]; then
    echo "CentOS / RHEL detected"
    SERVICE_NAME="httpd"
    INSTALL_WEB="sudo yum install -y httpd"
elif [ -f /etc/debian_version ]; then
    echo "Ubuntu / Debian detected"
    SERVICE_NAME="apache2"
    INSTALL_UDATE="sudo apt update -y"
    INSTALL_WEB="sudo apt install apache2 -y"
    $INSTALL_UDATE
else
    echo "Unsupported OS"
    exit 1
fi

# check if web service exist
if sudo systemctl status $SERVICE_NAME &>/dev/null; then
    echo "$SERVICE_NAME is already installed. Checking status..."

    # check if web service is active
    if sudo systemctl is-active --quiet $SERVICE_NAME; then
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

    # check if web service enabled
    if sudo systemctl is-enabled --quiet $SERVICE_NAME; then
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
    # install web service if nesesery
    echo "$SERVICE_NAME is NOT installed. Installing..."
    $INSTALL_WEB
    if [ $? -eq 0 ]; then
        echo "$SERVICE_NAME installed successfully"

        # make shure the web service is anble and active
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