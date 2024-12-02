# MyGPT 🧠🚀  

**MyGPT** is a local, customizable, GPT-based assistant designed for interactive, human-like conversations. It uses the **Ollama CLI** for model inference, providing privacy-focused, high-performance AI that works entirely on your device.  

## 🌟 Features  

- **Runs Locally**: No data sent to the cloud, ensuring complete privacy.  
- **Interactive Conversations**: Engage with GPT models in real-time.  
- **Efficient Setup**: Automated installation script to get started quickly.  
- **Pre-Integrated Model**: Comes with the `llama3.2:1b` model for efficient and powerful responses.  

---

## 🚀 Installation  

### Prerequisites  

Ensure your system meets the following requirements:  
- **Python**: Version 3.8 or later.  
- **Pip**: Python package installer.  
- **Curl**: For downloading resources.  
- **Unix-like Environment**: Works on Linux and macOS.  

---

### Setup Instructions  

1. **Clone the Repository**  

   ```bash  
   git clone https://github.com/iamMD01/MyGPT.git
   cd MyGPT
   ```  

2. **Run the Installation Script**  

   The `setup.sh` script automates the setup process. Make it executable and run it:  

   ```bash  
   chmod +x setup.sh  
   ./setup.sh  
   ```  

   The script will:  
   - Set up a Python virtual environment and install required packages.  
   - Download the `llama3.2:1b` model.  
   - Add an alias `mygpt` for easy access.  

3. **Source the Updated Bash Configuration**  

   If the script doesn’t source your `~/.bashrc` automatically, run:  

   ```bash  
   source ~/.bashrc  
   ```  

---

## 🛠️ Usage  

Start MyGPT by typing:  

```bash  
mygpt  
```  

### Customization  

You can modify the **MyGPT** behavior by:  
- Editing the `mygpt.py` source file.  
- Passing arguments when running the script (if supported).  

---

## 📂 Directory Structure  

```plaintext  
MyGPT/  
├── .venv/          # Python virtual environment  
├── mygpt.py        # Main Python script  
├── setup.sh        # Installation script  
└── README.md       # Project documentation  
```  

---

## 🤝 Contributing  

We welcome contributions to MyGPT! Here's how you can help:  

1. Fork the repository.  
2. Create a new branch for your feature:  

   ```bash  
   git checkout -b feature-name  
   ```  

3. Commit your changes:  

   ```bash  
   git commit -m "Add feature-name"  
   ```  

4. Push the branch to your forked repository:  

   ```bash  
   git push origin feature-name  
   ```  

5. Open a pull request to the main repository.  

---

## 📜 License  

This project is licensed under the **MIT License**. You are free to use, modify, and distribute this software under the terms of the license.  

---

## 🙏 Credits  

- **Developer**: Your Name  
- **Powered by**: [Ollama CLI](https://ollama.com)  

---

## 🛡️ Support  

Encounter an issue or have questions? Open an issue in the repository or reach out via email: `youremail@example.com`.  

Let's build the future of local AI together! 🌟  