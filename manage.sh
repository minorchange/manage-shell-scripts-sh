#!/bin/bash


# Get the directory where a.sh is located
DIR_OF_THIS_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load Telegram Bot credentials from the configuration file
CONFIG_FILE="$DIR_OF_THIS_FILE/telegram.conf"  # Adjust this path as needed

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file $CONFIG_FILE not found!"
    exit 1
fi

# Source the config file to import the BOT_TOKEN and CHAT_ID variables
source "$CONFIG_FILE"

# Function to send a Telegram notification
send_telegram_message() {
    local message=$1
    local url="https://api.telegram.org/bot${BOT_TOKEN}/sendMessage"
    curl -s -X POST "$url" -d "chat_id=${CHAT_ID}" -d "text=${message}" >/dev/null
}

# Ensure a script path is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <script_path> [task_name]"
    exit 1
fi

SCRIPT_PATH=$1
SCRIPT_NAME=$(basename "$SCRIPT_PATH")

# Get the optional task name
TASK_NAME=$2

# Determine the script name to use in messages
if [ -n "$TASK_NAME" ]; then
    SCRIPT_DISPLAY_NAME="$TASK_NAME"
else
    SCRIPT_DISPLAY_NAME="$SCRIPT_NAME"
fi

# Record the start time
START_TIME=$(date '+%Y-%m-%d %H:%M:%S')

# Send notification when the script starts 🔔
send_telegram_message "$START_TIME: $SCRIPT_DISPLAY_NAME start"

# Run the script and capture the output and error
OUTPUT=$(bash "$SCRIPT_PATH" 2>&1)
EXIT_STATUS=$?

# Record the end time
END_TIME=$(date '+%Y-%m-%d %H:%M:%S')

# Determine the status and send the appropriate notification
if [ $EXIT_STATUS -eq 0 ]; then
    STATUS="$END_TIME: $SCRIPT_DISPLAY_NAME ✅"
else
    STATUS="$END_TIME: $SCRIPT_DISPLAY_NAME ❌"
    # Optionally, include the error details
    # STATUS="$STATUS\n\n🛑 Error Details:\n$OUTPUT"
fi

send_telegram_message "$STATUS"