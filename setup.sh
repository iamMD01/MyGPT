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
        "ollama"  # Add ollama to the package list
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

# Function to download files with progress and size display
download_with_progress() {
    URL=$1
    DEST=$2
    echo -e "\033[1;33m[*] Downloading file from $URL...\033[0m"
    # Use curl to download the file and show progress
    curl -L $URL --progress-bar --output $DEST
    echo -e "\033[1;32m[✓] Download completed.\033[0m"
}

# Start of script
show_header

# Step 1: Go to Home Directory
cd $HOME
echo -e "\033[1;33m[*] Navigating to home directory...\033[0m"
sleep 1

# Step 2: Install Ollama (if not already installed)
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

# Step 3: Download the llama3.2:1b model
echo -e "\033[1;33m[*] Downloading llama3.2:1b model...\033[0m"
show_spinner "Downloading llama3.2:1b"
ollama pull llama3.2:1b
spin=0
echo -e "\033[1;32m[✓] Model llama3.2:1b downloaded.\033[0m"
sleep 1

# Step 4: Create the MyGPT folder
echo -e "\033[1;33m[*] Creating MyGPT folder...\033[0m"
mkdir -p $HOME/MyGPT
echo -e "\033[1;32m[✓] MyGPT folder created.\033[0m"
sleep 1

# Step 5: Set up Python Virtual Environment
echo -e "\033[1;33m[*] Setting up Python virtual environment...\033[0m"
python3 -m venv $HOME/MyGPT/.venv
source $HOME/MyGPT/.venv/bin/activate
install_python_packages
echo -e "\033[1;32m[✓] Python virtual environment set up and packages installed.\033[0m"
sleep 1

# Step 6: Download the source code for mygpt.py from GitHub
echo -e "\033[1;33m[*] Downloading source code for mygpt.py...\033[0m"
REPO_URL="https://raw.githubusercontent.com/iamMD01/MyGPT/main/mygpt.py"  # Correct raw GitHub URL
download_with_progress $REPO_URL "$HOME/MyGPT/mygpt.py"
sleep 1

# Step 7: Get the absolute path of the Python script
PYTHON_PATH="$HOME/MyGPT/.venv/bin/python $HOME/MyGPT/mygpt.py"

# Step 8: Add alias to bashrc for easy access
echo -e "\033[1;33m[*] Adding alias to bashrc...\033[0m"
ALIAS_COMMAND="alias mygpt=\"$PYTHON_PATH\""
if ! grep -Fxq "$ALIAS_COMMAND" $HOME/.bashrc; then
    echo $ALIAS_COMMAND >> $HOME/.bashrc
    echo -e "\033[1;32m[✓] Alias 'mygpt' added to bashrc. Use 'mygpt' to run the app!\033[0m"
else
    echo -e "\033[1;32m[✓] Alias 'mygpt' already exists.\033[0m"
fi

# Step 9: Go back to home directory and run mygpt
cd $HOME
echo -e "\033[1;33m[*] Returning to home directory...\033[0m"
sleep 1

echo -e "\033[1;33m[*] Sourcing bashrc...\033[0m"
source $HOME/.bashrc

# Final message
echo -e "\033[1;32m🎉 Setup complete! MyGPT is installed in your system. To use it type "mygpt".\033[0m"

