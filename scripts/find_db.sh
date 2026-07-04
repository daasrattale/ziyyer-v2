#!/bin/zsh

HOME_DIR="$HOME"
DB_NAME="ziyyer.sqlite"
USERNAME="your_username"

echo "Home directory: $HOME_DIR"

DB_PATH=$(find "$HOME_DIR/Library/Developer/CoreSimulator/Devices/" -name "$DB_NAME" 2>/dev/null | head -n 1)

if [[ -z "$DB_PATH" ]]; then
  echo "Database '$DB_NAME' does not exist."
  exit 0
fi

echo "Database found: $DB_PATH"

while true; do
  read "DELETE_DB?Do you wish to delete the database? (y/n): "
  case "$DELETE_DB" in
    [Yy])
      rm -f "$DB_PATH"
      echo "Database deleted: $DB_PATH"
      break
      ;;
    [Nn])
      echo "Database was not deleted."
      break
      ;;
    *)
      echo "Please answer y or n."
      ;;
  esac
done