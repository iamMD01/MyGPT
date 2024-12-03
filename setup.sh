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
