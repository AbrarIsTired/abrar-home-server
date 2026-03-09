#!/bin/bash
# backup.sh

# Error Guard. Exits upon error
set -e

# Global Vars
TIMESTAMP=$(date +"%m-%d-%Y")
mkdir -p "/DATA/Backups/Logs"
LOG_FILE="/DATA/Backups/Logs/simple_backup_$TIMESTAMP.log"

# Directing all script output into log file
exec >> "$LOG_FILE" 2>&1

# Total Backups Allowed
KEEP=2

# Backup Function
backup(){
    local TARGET_DIR="$1"
    local BACKUP_DIR="$2"
    local BACKUP_FILE="$3"

    mkdir -p "$BACKUP_DIR"
    echo "Backup Start: $TARGET_DIR at $TIMESTAMP"
    zip -r "/tmp/$BACKUP_FILE" "$TARGET_DIR"
    mv "/tmp/$BACKUP_FILE" "$BACKUP_DIR"
    
    # ls -1t = list files sorted newest first
    # tail -n +$((KEEP+1)) = skip newest KEEP files
    # everything else gets deleted
    ls -1t "$BACKUP_DIR" | tail -n +$((KEEP+1)) | xargs -r -I {} rm "$BACKUP_DIR/{}"
    echo "Backup Completed: $TARGET_DIR at $TIMESTAMP"
}

# Note: Cron is set to run this script everyday at 3AM

# Call function for Obsidian
backup "/DATA/Syncthing/Obsidian" "/DATA/Backups/Media/Notes Backups" "obsidian_backup_$TIMESTAMP.zip"
backup "/DATA/Media/Music" "/DATA/Backups/Media/Music Backups" "music_backup_$TIMESTAMP.zip"
