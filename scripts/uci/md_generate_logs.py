import os
import sys

def generate_markdown_for_logs(directory):
    # Print the title for the markdown file
    print("## Logs\n")

    # Walk through the directory recursively
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.log'):  # Process only log files
                log_file_path = os.path.join(root, file)
                file_name_without_extension = os.path.splitext(file)[0]  # Remove the .log extension

                # Print the details section for each log file
                print(f"### {file_name_without_extension}")
                print("<details>")
                print(f"  ```shell")

                # Print the contents of the log file
                with open(log_file_path, 'r') as log_file:
                    for line in log_file:
                        print(f"  {line}", end='')  # Avoid adding extra new lines

                # Close the details and code block sections
                print(f"  ```")
                print("</details>\n")


if __name__ == "__main__":
    # Check if the user provided the directory as an argument
    if len(sys.argv) != 2:
        print("Usage: python3 md_generate_logs.py <logs_directory>")
        sys.exit(1)

    # Directory to search for log files (from command-line argument)
    logs_directory = sys.argv[1]

    # Generate and print the markdown file content to the console
    generate_markdown_for_logs(logs_directory)