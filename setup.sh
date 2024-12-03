#!/bin/bash

# Function to display a colorful header with animations
show_header() {
    echo -e "\033[1;34m==============================================\033[0m"
    echo -e "\033[1;34m       🚀 MyGPT Setup - Interactive UI 🛠️\033[0m"
    echo -e "\033[1;34m==============================================\033[0m"
    sleep 1
}

# Function to display a loading spinner
show_spinner() {
    spinner=( '⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏' )
    while [ $spin -eq 1 ]
    do
        for i in "${spinner[@]}"
        do
            echo -ne "\r\033[1;32m${i} $1 \033[0m"
            sleep 0.1
        done
    done
}

# Function to install python packages with a nice progress bar
install_python_packages() {
    packages=(
        "matplotlib"
        "termcolor"
        "rich"
        "ollama"
    )
    echo -e "\033[1;33m[*] Installing Python packages: \033[1;37m${packages[*]}\033[0m"
    sleep 1
    for package in "${packages[@]}"; do
        echo -e "\033[1;33m[+] Installing ${package}...\033[0m"
        show_spinner "Installing ${package}"
        pip install $package > /dev/null 2>&1
        spin=0
        echo -e "\033[1;32m[✓] ${package} installed successfully.\033[0m"
    done
}

# Function to download files with progress
download_with_progress() {
    URL=$1
    DEST=$2
    echo -e "\033[1;33m[*] Downloading file from $URL...\033[0m"
    curl -L $URL --progress-bar --output $DEST
    echo -e "\033[1;32m[✓] Download completed.\033[0m"
}

# Function to delete MyGPT installation
delete_mygpt() {
    echo -e "\033[1;31m[*] Deleting MyGPT...\033[0m"
    rm -rf $HOME/MyGPT
    sed -i "/alias mygpt=/d" $HOME/.bashrc
    sed -i "/alias delete_mygpt=/d" $HOME/.bashrc
    source $HOME/.bashrc
    echo -e "\033[1;32m[✓] MyGPT deleted successfully.\033[0m"

    # # Delete Ollama and models
    # echo -e "\033[1;31m[*] Deleting Ollama and its models...\033[0m"
    # if command -v ollama &> /dev/null; then
    #     # Remove Ollama CLI
    #     echo -e "\033[1;33m[*] Removing Ollama CLI...\033[0m"
    #     rm -rf $HOME/.ollama
    #     rm -rf /usr/local/bin/ollama
    #     echo -e "\033[1;32m[✓] Ollama CLI removed.\033[0m"
    # else
    #     echo -e "\033[1;32m[✓] Ollama CLI not installed.\033[0m"
    # fi

    # # Delete any models (if any exist)
    # echo -e "\033[1;33m[*] Removing Ollama models...\033[0m"
    # rm -rf $HOME/.ollama/models

    # echo -e "\033[1;31m[✓] MyGPT and Ollama have been removed from your system.\033[0m"
}

# Main setup function
setup_mygpt() {
    show_header

    # Step 1: Install python3.12-venv
    echo -e "\033[1;33m[*] Installing python3.12-venv package...\033[0m"
    sudo apt-get install -y python3.12-venv
    echo -e "\033[1;32m[✓] python3.12-venv package installed.\033[0m"
    sleep 1

    # Step 2: Navigate to home directory
    cd $HOME
    echo -e "\033[1;33m[*] Navigating to home directory...\033[0m"
    sleep 1

    # Step 3: Install Ollama CLI
    if ! command -v ollama &> /dev/null; then
        echo -e "\033[1;33m[*] Installing Ollama CLI...\033[0m"
        show_spinner "Installing Ollama"
        curl -fsSL https://ollama.com/install.sh | bash
    else
        echo -e "\033[1;32m[✓] Ollama CLI is already installed.\033[0m"
    fi
    spin=0
    echo -e "\033[1;32m[✓] Ollama installation complete.\033[0m"
    sleep 1

    # Step 4: Download the llama3.2:1b model
    echo -e "\033[1;33m[*] Downloading llama3.2:1b model...\033[0m"
    show_spinner "Downloading llama3.2:1b"
    ollama pull llama3.2:1b
    spin=0
    echo -e "\033[1;32m[✓] Model llama3.2:1b downloaded.\033[0m"
    sleep 1

    # Step 5: Create MyGPT folder
    echo -e "\033[1;33m[*] Creating MyGPT folder...\033[0m"
    mkdir -p $HOME/MyGPT
    echo -e "\033[1;32m[✓] MyGPT folder created.\033[0m"
    sleep 1

    # Step 6: Set up Python Virtual Environment
    echo -e "\033[1;33m[*] Setting up Python virtual environment...\033[0m"
    python3.12 -m venv $HOME/MyGPT/.venv
    source $HOME/MyGPT/.venv/bin/activate
    install_python_packages
    echo -e "\033[1;32m[✓] Python virtual environment set up and packages installed.\033[0m"
    sleep 1

    # Step 7: Download source code for mygpt.py
    echo -e "\033[1;33m[*] Downloading source code for mygpt.py...\033[0m"
    REPO_URL="https://raw.githubusercontent.com/iamMD01/MyGPT/main/mygpt.py"
    download_with_progress $REPO_URL "$HOME/MyGPT/mygpt.py"
    sleep 1

    # Step 8: Add aliases to bashrc
    # Added global aliases for 'mygpt' and 'delete_mygpt' to .bashrc, 
    # ensuring they work from any directory. The 'delete_mygpt' alias 
    # now points to the full path of the setup script for easy execution.

echo -e "\033[1;33m[*] Adding aliases to bashrc...\033[0m"
PYTHON_PATH="$HOME/MyGPT/.venv/bin/python $HOME/MyGPT/mygpt.py"
ALIAS_MYGPT="alias mygpt=\"$PYTHON_PATH\""
ALIAS_DELETE_MYGPT="alias delete_mygpt='bash $HOME/MyGPT/setup.sh delete'"

# Check if the aliases are already in .bashrc
if ! grep -Fxq "$ALIAS_MYGPT" $HOME/.bashrc; then
    echo $ALIAS_MYGPT >> $HOME/.bashrc
fi

if ! grep -Fxq "$ALIAS_DELETE_MYGPT" $HOME/.bashrc; then
    echo $ALIAS_DELETE_MYGPT >> $HOME/.bashrc
fi

# Ensure the changes take effect by sourcing .bashrc
source $HOME/.bashrc

echo -e "\033[1;32m[✓] Aliases added and bashrc sourced successfully.\033[0m"


    # Step 9: Source bashrc
    source $HOME/.bashrc

    # Final message
    echo -e "\033[1;32m🎉 Setup complete! MyGPT is installed in your system. To use it, type 'mygpt'. To delete it, type 'delete mygpt'.\033[0m"

    
}

# Main script logic
if [ "$1" == "delete" ]; then
    delete_mygpt
else
    setup_mygpt
fi
