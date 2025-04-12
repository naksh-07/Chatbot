#!/bin/bash

# ⚙️ Function for Auto Interaction with Your Node [V2]
auto_interaction_v2() {
    echo "🚀 Starting Auto Interaction with Your Node [V2]..."
    check_python_version

    local script_path="$PWD/main.py"
    local log_file="$PWD/interaction_v2.log"
    local pid_file="$PWD/interaction_v2.pid"

    if [ ! -f "$script_path" ]; then
        echo "❌ Error: Python script not found at $script_path"
        return 1
    fi

    # Ensure virtual environment exists
    if [ ! -d "$PWD/env" ]; then
        echo "📦 Creating Python virtual environment..."
        python3 -m venv "$PWD/env"
    fi

    if [ ! -f "$PWD/env/bin/activate" ]; then
        echo "❌ Error: Failed to create virtual environment."
        return 1
    fi

    source "$PWD/env/bin/activate"

    # Check if requirements.txt exists
    if [ ! -f "$PWD/requirements.txt" ]; then
        echo "❌ Error: requirements.txt not found."
        deactivate
        return 1
    fi

    echo "📥 Installing required Python packages..."
    pip install -r "$PWD/requirements.txt"

    echo "🔥 Starting the Python script with nohup..."
    nohup python3 "$script_path" > "$log_file" 2>&1 &
    if [ $? -ne 0 ]; then
        echo "❌ Error: Failed to start Python script with nohup."
        deactivate
        return 1
    fi

    echo $! > "$pid_file"
    deactivate

    echo "✅ Auto Interaction V2 started in background."
    echo "📂 Logs: $log_file"
    echo "🔢 PID: $(cat $pid_file)"
}

# 🐍 Python setup check
check_python_version() {
    if command -v python3 > /dev/null; then
        echo "🐍 Python 3 is installed: $(python3 --version)"
        if ! dpkg -l | grep -q python3-venv; then
            echo "📥 Installing python3-venv package..."
            sudo apt update
            sudo apt install -y python3-venv
        fi
    else
        echo "⚠️ Python 3 not found. Installing now..."
        sudo apt update
        sudo apt install -y python3 python3-venv python3-pip
    fi
}

# 🏁 Default action: Run auto_interaction_v2
auto_interaction_v2