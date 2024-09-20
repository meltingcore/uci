import os
import sys
import json
import re


# Function to create a valid markdown anchor from a check name
def generate_anchor(text):
    # Convert to lowercase, replace spaces with hyphens, and remove special characters
    return re.sub(r'[^a-z0-9\-_]', '', text.lower().replace(' ', '-'))


def load_failed_checks(json_file):
    # Load JSON data to extract failed checks
    with open(json_file, 'r') as f:
        data = json.load(f)

    # Collect all failed checks grouped by technology
    failed_checks = {}
    for technology, checks in data.items():
        failed_checks[technology] = {check for check, result in checks.items() if
                                     result == "failed"}

    return failed_checks


def load_all_checks(json_file):
    # Load JSON data to extract all checks
    with open(json_file, 'r') as f:
        data = json.load(f)

    return data


def generate_markdown_for_logs(directory, json_file_path, failed_only=False):
    # Load the appropriate checks (failed or all)
    if failed_only:
        checks_data = load_failed_checks(json_file_path)
    else:
        checks_data = load_all_checks(json_file_path)

    # Print the title for the markdown file
    print("## Logs\n")

    # Walk through the directory recursively to collect log files
    log_files = {}
    for root, dirs, files in os.walk(directory):
        dirs.sort()
        files.sort()

        for file in files:
            if file.endswith('.log'):  # Process only log files
                file_name_without_extension = os.path.splitext(file)[0]  # Remove the .log extension
                log_file_path = os.path.join(root, file)

                # Group log files by check name
                log_files[file_name_without_extension] = log_file_path

    # Generate markdown for each technology
    for technology, checks in checks_data.items():
        if checks:  # Only process if there are checks for this technology
            print(f"### {technology}\n")
            print("<details>\n<summary>Expand to view checks</summary>\n")

            # For each check under this technology
            for check in sorted(checks):
                if check in log_files:  # If we have a log file for this check
                    log_file_path = log_files[check]

                    # Generate the anchor link for the check
                    anchor = generate_anchor(check)

                    # Print the details section for each check
                    print(f"#### {check}\n")
                    print(f"<details>\n<summary id=\"{anchor}\">Expand to view logs for {check}</summary>\n")
                    print(f"```log\n")

                    # Print the contents of the log file
                    with open(log_file_path, 'r') as log_file:
                        for line in log_file:
                            print(f"  {line}", end='')  # Avoid adding extra new lines

                    # Close the details and code block sections
                    print(f"```\n")
                    print("</details>\n")
                else:
                    # If no log file is found for the check
                    print(f"#### {check} - No logs available\n")

            print("</details>\n")  # Close the technology section


if __name__ == "__main__":
    # Check if the user provided the necessary arguments
    if len(sys.argv) != 4:
        print(
            "Usage: python3 md_generate_logs.py <logs_directory> <failed-checks|all-checks> <path_to_json_file>")
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