#!/bin/bash

# Global spinner variable
spin=1

# Function to display a colorful header with animations
show_header() {
    echo -e "\033[1;34m==============================================\033[0m"
    echo -e "\033[1;34m       🚀 MyGPT Setup - Interactive UI 🛠️\033[0m"
    echo -e "\033[1;34m==============================================\033[0m"
    sleep 1
}

# Enhanced function to display a loading spinner with custom message
show_spinner() {
    local message="$1"
    local spinner=( '⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏' )
    local spin_pid=$$ # Use current process ID for unique spinner
    
    # Start spinner in background
    (
        while [ $spin -eq 1 ]
        do
            for i in "${spinner[@]}"
            do
                echo -ne "\r\033[1;32m${i} $message \033[0m"
                sleep 0.1
            done
        done
    ) &
    
    # Store background process ID
    SPIN_PID=$!
}

# Function to stop spinner
stop_spinner() {
    spin=0
    # Wait a moment to ensure spinner stops
    sleep 0.5
    # Kill spinner process if it exists
    kill $SPIN_PID 2>/dev/null
    # Clear spinner line
    echo -ne "\r\033[K"
}

# Function to install python packages with a nice progress bar
install_python_packages() {
    packages=(
        "matplotlib"
        "termcolor"
        "rich"
        "ollama"
    )
    echo -e "\033[1;33m[*] Installing Python packages: \033[0m"
    spin=1
    show_spinner "Installing Python packages..."
    for package in "${packages[@]}"; do
        pip install $package > /dev/null 2>&1
    done
    stop_spinner
    echo -e "\033[1;32m[✓] Python packages installed successfully.\033[0m"
}

# Function to download files with progress and spinner
download_with_progress() {
    local URL=$1
    local DEST=$2
    echo -e "\033[1;33m[*] Downloading file from $URL...\033[0m"
    spin=1
    show_spinner "Downloading file..."
    curl -L $URL --progress-bar --output $DEST
    stop_spinner
    echo -e "\033[1;32m[✓] Download completed.\033[0m"
}

# Function to delete MyGPT installation
delete_mygpt() {
    echo -e "\033[1;31m[*] Deleting MyGPT...\033[0m"
    spin=1
    show_spinner "Deleting MyGPT installation..."
    rm -rf $HOME/MyGPT
    sed -i "/alias mygpt=/d" $HOME/.bashrc
    sed -i "/alias delete_mygpt=/d" $HOME/.bashrc
    source $HOME/.bashrc
    stop_spinner
    echo -e "\033[1;32m[✓] MyGPT deleted successfully.\033[0m"

        # Delete Ollama and models
    echo -e "\033[1;31m[*] Deleting Ollama and its models...\033[0m"
    if command -v ollama &> /dev/null; then
        # Remove Ollama CLI
        echo -e "\033[1;33m[*] Removing Ollama CLI...\033[0m"
        sudo rm -rf $HOME/.ollama
        sudo rm -rf /usr/local/bin/ollama
        echo -e "\033[1;32m[✓] Ollama CLI removed.\033[0m"
    else
        echo -e "\033[1;32m[✓] Ollama CLI not installed.\033[0m"
    fi

    # Delete any models (if any exist)
    echo -e "\033[1;33m[*] Removing Ollama models...\033[0m"
    rm -rf $HOME/.ollama/models

    echo -e "\033[1;31m[✓] MyGPT and Ollama have been removed from your system.\033[0m"

}

# Main setup function
setup_mygpt() {
    show_header

    # Step 1: Install python3.12-venv
    echo -e "\033[1;33m[*] Installing python3.12-venv package...\033[0m"
    spin=1
    show_spinner "Installing python3.12-venv..."
    sudo apt-get install -y python3.12-venv
    stop_spinner
    echo -e "\033[1;32m[✓] python3.12-venv package installed.\033[0m"
    sleep 1

    # Step 2: Navigate to home directory
    cd $HOME
    echo -e "\033[1;33m[*] Navigating to home directory...\033[0m"
    sleep 1

    # Step 3: Install Ollama CLI
    if ! command -v ollama &> /dev/null; then
        echo -e "\033[1;33m[*] Installing Ollama CLI...\033[0m"
        show_spinner "Installing Ollama CLI..."
        curl -fsSL https://ollama.com/install.sh | bash
    else
        echo -e "\033[1;32m[✓] Ollama CLI is already installed.\033[0m"
    fi
    echo -e "\033[1;32m[✓] Ollama installation complete.\033[0m"
    sleep 1

    # Step 4: Download the llama3.2:1b model
    echo -e "\033[1;33m[*] Downloading llama3.2:1b model...\033[0m"
    
    show_spinner "Downloading llama3.2:1b model..."
    ollama pull llama3.2:1b
    
    echo -e "\033[1;32m[✓] Model llama3.2:1b downloaded.\033[0m"
    sleep 1

    # Step 5: Create MyGPT folder
    echo -e "\033[1;33m[*] Creating MyGPT folder...\033[0m"
    spin=1
    show_spinner "Creating MyGPT folder..."
    mkdir -p $HOME/MyGPT
    stop_spinner
    echo -e "\033[1;32m[✓] MyGPT folder created.\033[0m"
    sleep 1

    # Step 6: Set up Python Virtual Environment
    echo -e "\033[1;33m[*] Setting up Python virtual environment...\033[0m"
    spin=1
    show_spinner "Creating virtual environment..."
    python3.12 -m venv $HOME/MyGPT/.venv
    source $HOME/MyGPT/.venv/bin/activate
    stop_spinner
    install_python_packages
    echo -e "\033[1;32m[✓] Python virtual environment set up and packages installed.\033[0m"
    sleep 1

    # Step 7: Download source code for mygpt.py
    echo -e "\033[1;33m[*] Downloading source code for mygpt.py...\033[0m"
    REPO_URL="https://raw.githubusercontent.com/iamMD01/MyGPT/main/mygpt.py"
    download_with_progress $REPO_URL "$HOME/MyGPT/mygpt.py"
    sleep 1

    # Step 8: Add aliases to bashrc
    echo -e "\033[1;33m[*] Adding aliases to bashrc...\033[0m"
    spin=1
    show_spinner "Configuring bash aliases..."
    PYTHON_PATH="$HOME/MyGPT/.venv/bin/python $HOME/MyGPT/mygpt.py"
    ALIAS_MYGPT="alias mygpt=\"$PYTHON_PATH\""
    ALIAS_DELETE_MYGPT="alias delete_mygpt='bash $HOME/MyGPT/setup.sh delete'"

    if ! grep -Fxq "$ALIAS_MYGPT" $HOME/.bashrc; then
        echo $ALIAS_MYGPT >> $HOME/.bashrc
    fi

    if ! grep -Fxq "$ALIAS_DELETE_MYGPT" $HOME/.bashrc; then
        echo $ALIAS_DELETE_MYGPT >> $HOME/.bashrc
    fi

    source $HOME/.bashrc
    stop_spinner
    echo -e "\033[1;32m[✓] Done 🚀🚀🚀 .\033[0m"

    # Final message
    echo -e "\033[1;32m🎉 Setup complete! MyGPT is installed in your system. To use it, type 'mygpt'. To delete it, type 'delete mygpt'.\033[0m"
}

# Main script logic
if [ "$1" == "delete" ]; then
    delete_mygpt
else
    setup_mygpt
fi