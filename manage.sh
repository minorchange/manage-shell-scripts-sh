# #!/bin/bash

# # Load Telegram Bot credentials from the configuration file
# CONFIG_FILE="./telegram.conf"  # Adjust this path as needed




# # Check if the configuration file exists
# if [ ! -f "$CONFIG_FILE" ]; then
#     echo "Configuration file $CONFIG_FILE not found!"
#     exit 1
# fi

# # Source the config file to import the BOT_TOKEN and CHAT_ID variables
# source "$CONFIG_FILE"


# # Function to send a Telegram notification
# send_telegram_message() {
#     local message=$1
#     curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d text="$message" >/dev/null
# }

# # Make sure a script path is provided
# if [ -z "$1" ]; then
#     echo "Usage: $0 <script_path>"
#     exit 1
# fi

# SCRIPT_PATH=$1
# SCRIPT_NAME=$(basename "$SCRIPT_PATH")

# # Send notification when the script starts
# send_telegram_message "🔔 Script '$SCRIPT_NAME' has started running."

# # Record the start time
# START_TIME=$(date '+%Y-%m-%d %H:%M:%S')

# # Run the script
# if bash "$SCRIPT_PATH"; then
#     STATUS="✅ Script '$SCRIPT_NAME' completed successfully."
# else
#     STATUS="❌ Script '$SCRIPT_NAME' failed."
# fi

# # Record the end time
# END_TIME=$(date '+%Y-%m-%d %H:%M:%S')


# # # Send completion notification with newlines using MarkdownV2
# # send_telegram_message "*Status:* ${STATUS}\n*Started at:* ${START_TIME}\n*Ended at:* ${END_TIME}"

# # Send completion notification
# send_telegram_message "$STATUS; Started at: $START_TIME; Ended at: $END_TIME"



#!/bin/bash

# Load Telegram Bot credentials from the configuration file
CONFIG_FILE="./telegram.conf"  # Adjust this path as needed

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
    echo "Usage: $0 <script_path>"
    exit 1
fi

SCRIPT_PATH=$1
SCRIPT_NAME=$(basename "$SCRIPT_PATH")

# Send notification when the script starts
send_telegram_message "🔔 Script '$SCRIPT_NAME' has started running."

# Record the start time
START_TIME=$(date '+%Y-%m-%d %H:%M:%S')

# Run the script and capture the output and error
OUTPUT=$(bash "$SCRIPT_PATH" 2>&1)
EXIT_STATUS=$?

# Record the end time
END_TIME=$(date '+%Y-%m-%d %H:%M:%S')

# Determine the status and send the appropriate notification
if [ $EXIT_STATUS -eq 0 ]; then
    STATUS="✅ Script '$SCRIPT_NAME' completed successfully."
    send_telegram_message "$STATUS; Started at: $START_TIME; Ended at: $END_TIME"
else
    STATUS="❌ Script '$SCRIPT_NAME' failed."
    send_telegram_message "$STATUS; Started at: $START_TIME; Ended at: $END_TIME"
    send_telegram_message "🛑 Error Details:\n$OUTPUT"
fi