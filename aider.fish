function aider --description "Automated Aider launcher with history size protection"
    set history_file ".aider.chat.history.md"
    if test -f $history_file
        # Get file size in bytes
        set file_size (math (stat -c %s $history_file))
        if test $file_size -gt 25000
            set backup_file "$history_file."(date +%s)".bak"
            mv $history_file $backup_file
            set kb_size (math -s1 "$file_size / 1024")
            echo -e "\e[0;33m[VIBE] Auto-archived large Aider history file ($kb_size KB) to prevent loading timeouts.\e[0m"
        end
    end
    # Call the actual aider binary
    command aider $argv
end
