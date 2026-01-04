export_env_vars() {
    echo "=== DEBUG: env_functions.sh ==="
    echo "Checking if .env file exists..."
    if [ -f .env ]; then
        echo ".env file found! Contents:"
        cat .env
        echo "Reading .env line by line:"
        while IFS='=' read -r key value; do
            echo "Raw line: key='$key', value='$value'"
            if [[ -z "$key" || "$key" =~ ^\s*# || -z "$value" ]]; then
                echo "Skipping line (empty, comment, or no value)"
                continue
            fi

            key=$(echo "$key" | tr -d '[:space:]')
            value=$(echo "$value" | tr -d '[:space:]')
            value=$(echo "$value" | tr -d "'" | tr -d "\"")
            
            echo "Processed: key='$key', value='$value'"
            export "$key=$value"
            echo "Exported: $key=${!key}"
        done < .env
        echo "=== END DEBUG env_functions.sh ==="
    else
        echo ".env file not found"
        exit 1
    fi
}
