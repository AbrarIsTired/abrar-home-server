# Backups

Automated daily backup of important data (Obsidian vault, music library) into rotating zip archives.

## What it does

- Zips the target directory and saves it with a date-stamped filename
- Keeps only the most recent `KEEP` backups per directory (currently 2), deleting older ones automatically
- Logs every run to `/Abrar_SMB/Backups/Logs/`, one log file per day
- Runs daily via cron at 3 AM

## Script

See [scripts/backup.sh](scripts/backup.sh).

```bash
# Cron entry
0 3 * * * /Abrar_SMB/Programming\ \&\ Scripts/Bash/backup.sh
```

## Currently backed up

| Source | Destination |
|---|---|
| Obsidian Vault (Syncthing) | `/Abrar_SMB/Backups/Notes Backups` |
| Music library (Jellyfin) | `/Abrar_SMB/Backups/Music Backups` |

## Debugging notes

A couple of real issues hit while setting this up, worth keeping for reference:

**`bad interpreter: No such file or directory` (`^M` in the error)** — the script had Windows-style line endings (CRLF) from being edited on Windows before being copied to the server. Bash reads the `\r` as part of the shebang path. Fixed with:
```bash
sed -i 's/\r$//' backup.sh
```

**`zip: command not found`** — `zip` wasn't installed on the server. Installed with `sudo apt install zip`.

**`zip I/O error: Disk quota exceeded`** — happened partway through zipping the Music library. Misleading error name: there was no actual disk quota configured (confirmed with `quota -u <user>`, which wasn't even installed), and the real disk had hundreds of GB free. The actual cause: the script originally built the zip in `/tmp` before moving it to the final destination, and `/tmp` here is `tmpfs` — backed by RAM, not disk. The Music library was large enough to exceed available `tmpfs` space. Fixed by writing the zip directly to the final backup directory instead of staging it in `/tmp`:
```bash
# Before
zip -r "/tmp/$BACKUP_FILE" "$TARGET_DIR"
mv "/tmp/$BACKUP_FILE" "$BACKUP_DIR"

# After
zip -r "$BACKUP_DIR/$BACKUP_FILE" "$TARGET_DIR"
```
