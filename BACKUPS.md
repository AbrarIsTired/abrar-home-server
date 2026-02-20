
# Backup Strategy

Backups are automated to protect important data while keeping the process simple and maintainable.

---

## Scope

Currently backing up:

- Obsidian notes directory  
- Music library  

Additional directories can be added as needed.

---

## Backup Method

- Uses the script `scripts/backup.sh`  
- Creates timestamped ZIP archives for each target directory  
- Stores backups in dedicated directories on the primary server  
- Keeps only the 2 most recent backups to manage storage  
- Logs all operations to `/DATA/Backups/Logs`

This ensures redundancy while keeping storage usage under control.

---

## Restore Procedure

1. Navigate to the backup directory.  
2. Select the desired timestamped archive.  
3. Extract using `unzip`.  
4. Replace or merge into the target directory as needed.

---

## Future Improvements

- Move backup storage to dedicated storage drives instead of the OS drive for improved capacity and separation.  
