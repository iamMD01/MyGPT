import ollama
import time
import sys
import threading
import itertools
import argparse
import subprocess
import matplotlib.pyplot as plt
from termcolor import colored  # Import termcolor for colored output

# ANSI escape codes for coloring text
GREEN = '\033[32m'      # Green color
ORANGE = '\033[38;5;196m'  # Orange color
BLUE = '\033[34m'       # Blue color
RESET = '\033[0m'       # Reset color

class ProgressSpinner:
    def __init__(self, message, style='dots'):
        self.message = message
        self.done = False
        self.spinner_styles = {
            'classic': itertools.cycle(['-', '/', '|', '\\']),
            'dots': itertools.cycle('⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'),
            'line': itertools.cycle('▁▂▃▄▅▆▇█▇▆▅▄▃▂▁'),
            'circle': itertools.cycle('◐◓◑◒'),
            'arrow': itertools.cycle('➳ ➲ ➤ ➭ ➯'),
            'braille': itertools.cycle('⣾⣽⣻⢿⡿⣟⣯⣷'),
            'star': itertools.cycle(['⭐', '🌟', '✨', '🌠'])
        }
        self.spinner = self.spinner_styles.get(style, self.spinner_styles['dots'])
        self.thread = None
        self.style = style

    def start(self):
        def spin():
            while not self.done:
                sys.stdout.write(f'\r{colored(self.message, "yellow")} {next(self.spinner)}')  # Using yellow color for the spinner message
                sys.stdout.flush()
                time.sleep(0.2)
        
        self.thread = threading.Thread(target=spin)
        self.thread.start()

    def stop(self, final_message=''):
        self.done = True
        if self.thread:
            self.thread.join()
        sys.stdout.write('\r' + ' ' * (len(self.message) + 2) + '\r')
        if final_message:
            print(colored(final_message, 'green'))  # Green color for success message

def list_available_models():
    """List available Ollama models"""
    try:
        models = subprocess.check_output(['ollama', 'list'], text=True)
        print(f"{BLUE}Available Ollama Models:{RESET}")
        print(models)
    except subprocess.CalledProcessError:
        print(f"{ORANGE}Error: Unable to list Ollama models.{RESET}")

def test_ollama_speed(model_name='llama3.2:1b', prompt="Tell me about the world", num_iterations=5, spinner_style='dots'):
    """Benchmark token generation speed for an Ollama model with progress visualization."""
    tokens_per_sec_list = []
    iteration_times = []
    iteration_tokens = []

    print(colored(f"\n{'='*50}", 'blue'))
    print(colored(f"🌟 Running Test for Model: {model_name} 🌟", 'blue'))
    print(colored(f"{'='*50}\n", 'blue'))
    
    print(f"📝 Prompt: {prompt}")
    print(f"🔄 Total Iterations: {num_iterations}")
    print(f"✨ Spinner Style: {spinner_style}\n")
    
    for i in range(num_iterations):
        spinner = ProgressSpinner(f"Iteration {i+1}/{num_iterations} - Generating", style=spinner_style)
        spinner.start()
        
        try:
            start_time = time.time()
            
            # Generate response from Ollama
            response = ollama.chat(
                model=model_name,
                messages=[{'role': 'user', 'content': prompt}]
            )
            
            end_time = time.time()
            
            response_tokens = len(response['message']['content'].split())
            iteration_time = end_time - start_time
            tokens_per_sec = response_tokens / iteration_time
            
            spinner.stop(f"✅ Iteration {i+1}: {response_tokens} tokens in {iteration_time:.2f} sec ({tokens_per_sec:.2f} tokens/sec)")
            
            tokens_per_sec_list.append(tokens_per_sec)
            iteration_times.append(iteration_time)
            iteration_tokens.append(response_tokens)
            
            time.sleep(0.5)
        
        except Exception as e:
            spinner.stop(f"❌ Error in iteration {i+1}: {str(e)}")
            break
    
    avg_tokens_per_sec = sum(tokens_per_sec_list) / len(tokens_per_sec_list)
    
    # Create graphing visualization
    plt.figure(figsize=(15, 5))
    plt.subplot(1, 3, 1)
    plt.bar(range(1, len(tokens_per_sec_list) + 1), tokens_per_sec_list, color='blue', alpha=0.7)
    plt.title('Tokens per Second', fontsize=10)
    plt.xlabel('Iteration')
    plt.ylabel('Tokens/sec')
    plt.grid(axis='y', linestyle='--', alpha=0.7)
    
    plt.subplot(1, 3, 2)
    plt.bar(range(1, len(iteration_times) + 1), iteration_times, color='green', alpha=0.7)
    plt.title('Iteration Time', fontsize=10)
    plt.xlabel('Iteration')
    plt.ylabel('Time (seconds)')
    plt.grid(axis='y', linestyle='--', alpha=0.7)
    
    plt.subplot(1, 3, 3)
    plt.bar(range(1, len(iteration_tokens) + 1), iteration_tokens, color='red', alpha=0.7)
    plt.title('Tokens Generated', fontsize=10)
    plt.xlabel('Iteration')
    plt.ylabel('Number of Tokens')
    plt.grid(axis='y', linestyle='--', alpha=0.7)
    
    plt.tight_layout()
    plt.suptitle(f'Ollama {model_name} Speed Test', fontsize=16)
    plt.savefig('ollama_speed_test.png')
    plt.close()
    
    results = {
        'model': model_name,
        'tokens_per_sec_list': tokens_per_sec_list,
        'iteration_times': iteration_times,
        'iteration_tokens': iteration_tokens,
        'avg_tokens_per_sec': avg_tokens_per_sec
    }
    
    print(colored("\n📊 Speed Test Summary:", 'cyan'))
    print(f"🏆 Average Tokens per Second: {avg_tokens_per_sec:.2f}")
    print(colored("🖼️ Graph saved as 'ollama_speed_test.png'", 'magenta'))
    
    return results

def chat_with_model(model_name='llama3.2:1b', spinner_style='star'):
    """Interactive chat with the specified Ollama model"""
    print(f"{BLUE}🤖 MyGPT - Ollama Terminal Chat{RESET}")
    print(f"Chatting with model: {ORANGE}{model_name}{RESET}")
    print("Type 'exit' to quit, 'models' to list available models, 'setmodel <model_name>' to change model, 'testmodel' to run speed test")
    
    context = []  # Maintain conversation context
    
    while True:
        try:
            user_input = input(f"{GREEN}🙂 You:{RESET} ")
            
            # Special commands
            if user_input.lower() == 'exit':
                print("Bye Bye 👋👋👋...")
                break
            elif user_input.lower() == 'models':
                list_available_models()
                continue
            elif user_input.lower().startswith('setmodel '):
                new_model = user_input[len('setmodel '):].strip()
                print(f"{ORANGE}Changing model to {new_model}{RESET}")
                model_name = new_model
                continue
            elif user_input.lower() == 'testmodel':
                print(f"{ORANGE}Running speed test for model {model_name}...{RESET}")
                test_ollama_speed(model_name=model_name, spinner_style=spinner_style)
                continue
            
            # Start spinner for waiting time
            spinner = ProgressSpinner(f"Thinking...", style=spinner_style)
            spinner.start()
            
            try:
                # Generate response from Ollama with context
                response = ollama.chat(
                    model=model_name,
                    messages=[{'role': 'user', 'content': user_input}],
                    stream=False
                )
                
                # Stop the spinner and show the response
                spinner.stop(f"{ORANGE}🤖 MyGPT:{RESET} {response['message']['content']}")
                
            except Exception as e:
                spinner.stop(f"❌ Error: {str(e)}")
        
        except KeyboardInterrupt:
            print("\nInterrupted. Type 'exit' to quit.")

def main():
    """Main function to parse arguments and start the chat"""
    parser = argparse.ArgumentParser(description='MyGPT - Ollama Terminal Chat')
    parser.add_argument('-m', '--model', 
                        default='llama3.2:1b', 
                        help='Specify the Ollama model to use')
    parser.add_argument('-s', '--style', 
                        choices=['classic', 'dots', 'line', 'circle', 'arrow', 'braille', 'star'], 
                        default='dots', 
                        help='Specify the spinner style')
    
    args = parser.parse_args()
    chat_with_model(model_name=args.model, spinner_style=args.style)

if __name__ == '__main__':
    main()
