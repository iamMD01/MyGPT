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