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
    echo -e "\033[1;31m[✓] MyGPT has been removed from your system.\033[0m"
}
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
# Step 4: Download the llama3.2:1b model
echo -e "\033[1;33m[*] Downloading llama3.2:1b model...\033[0m"
show_spinner "Downloading llama3.2:1b"
ollama pull llama3.2:1b
spin=0
echo -e "\033[1;32m[✓] Model llama3.2:1b downloaded.\033[0m"
# Step 5: Create MyGPT folder
echo -e "\033[1;33m[*] Creating MyGPT folder...\033[0m"
mkdir -p $HOME/MyGPT
echo -e "\033[1;32m[✓] MyGPT folder created.\033[0m"
# Step 6: Set up Python Virtual Environment
echo -e "\033[1;33m[*] Setting up Python virtual environment...\033[0m"
python3.12 -m venv $HOME/MyGPT/.venv
source $HOME/MyGPT/.venv/bin/activate
install_python_packages
echo -e "\033[1;32m[✓] Python virtual environment set up and packages installed.\033[0m"
# Step 7: Download source code for mygpt.py
echo -e "\033[1;33m[*] Downloading source code for mygpt.py...\033[0m"
REPO_URL="https://raw.githubusercontent.com/iamMD01/MyGPT/main/mygpt.py"
download_with_progress $REPO_URL "$HOME/MyGPT/mygpt.py"
# Step 8: Add aliases to bashrc
echo -e "\033[1;33m[*] Adding aliases to bashrc...\033[0m"
PYTHON_PATH="$HOME/MyGPT/.venv/bin/python $HOME/MyGPT/mygpt.py"
ALIAS_MYGPT="alias mygpt=\"$PYTHON_PATH\""
ALIAS_DELETE_MYGPT="alias delete_mygpt='bash $0 delete'"
if ! grep -Fxq "$ALIAS_MYGPT" $HOME/.bashrc; then
    echo $ALIAS_MYGPT >> $HOME/.bashrc
fi
if ! grep -Fxq "$ALIAS_DELETE_MYGPT" $HOME/.bashrc; then
    echo $ALIAS_DELETE_MYGPT >> $HOME/.bashrc
fi
