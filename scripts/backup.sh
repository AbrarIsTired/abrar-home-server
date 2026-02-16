#!/bin/bash
# backup.sh

# Error Guard
set -e

# Global Vars
TIMESTAMP=$(date +"%m-%d-%Y")
mkdir -p "/DATA/Backups/Logs"
LOG_FILE="/DATA/Backups/Logs/simple_backup_$TIMESTAMP.log"
exec >> "$LOG_FILE" 2>&1

backup(){
    local TARGET_DIR="$1"
    local BACKUP_DIR="$2"
    local BACKUP_FILE="$3"

    mkdir -p "$BACKUP_DIR"
    echo "Backup Start: $TARGET_DIR at $TIMESTAMP"
    zip -r "/tmp/$BACKUP_FILE" "$TARGET_DIR"
    mv "/tmp/$BACKUP_FILE" "$BACKUP_DIR"
    echo "Backup Completed: $TARGET_DIR at $TIMESTAMP"
}

# Call function for Obsidian
backup "/DATA/Syncthing/Obsidian" "/DATA/Backups/Notes Backups" "obsidian_backup_$TIMESTAMP.zip"
backup "/DATA/Media/Music" "/DATA/Backups/Music Backups" "music_backup_$TIMESTAMP.zip"

