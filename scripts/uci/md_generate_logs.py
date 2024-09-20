import os
import sys
import json

def load_failed_checks(json_file):
    # Load JSON data to extract failed checks
    with open(json_file, 'r') as f:
        data = json.load(f)

    # Collect all failed checks
    failed_checks = set()
    for technology, checks in data.items():
        for check, result in checks.items():
            if result == "failed":
                failed_checks.add(check)

    return failed_checks

def generate_markdown_for_logs(directory, json_file_path, failed_only=False):
    # Load the JSON file for reference
    failed_checks = load_failed_checks(json_file_path) if failed_only else None

    # Print the title for the markdown file
    print("## Logs\n")

    # Walk through the directory recursively
    for root, dirs, files in os.walk(directory):
        # Sort directories and files in alphabetical order
        dirs.sort()
        files.sort()

        for file in files:
            if file.endswith('.log'):  # Process only log files
                file_name_without_extension = os.path.splitext(file)[0]  # Remove the .log extension

                # If failed_only is True, only include failed checks
                if failed_checks is None or file_name_without_extension in failed_checks:
                    log_file_path = os.path.join(root, file)

                    # Print the details section for each log file
                    print(f"### {file_name_without_extension}\n")
                    print("<details>\n")
                    print(f"```log\n")

                    # Print the contents of the log file
                    with open(log_file_path, 'r') as log_file:
                        for line in log_file:
                            print(f"  {line}", end='')  # Avoid adding extra new lines

                    # Close the details and code block sections
                    print(f"```\n")
                    print("</details>\n")


if __name__ == "__main__":
    # Check if the user provided the necessary arguments
    if len(sys.argv) != 4:
        print("Usage: python3 md_generate_logs.py <logs_directory> <failed-checks|all-checks> <path_to_json_file>")
        sys.exit(1)

    # Directory to search for log files (from command-line argument)
    logs_directory = sys.argv[1]
    filter_type = sys.argv[2]
    json_file_path = sys.argv[3]

    if filter_type == "failed-checks":
        # Generate logs only for failed checks
        generate_markdown_for_logs(logs_directory, json_file_path, failed_only=True)
    elif filter_type == "all-checks":
        # Generate logs for all checks
        generate_markdown_for_logs(logs_directory, json_file_path, failed_only=False)
    else:
        print("Invalid option for <failed-checks|all-checks>. Use 'failed-checks' or 'all-checks'.")
        sys.exit(1)