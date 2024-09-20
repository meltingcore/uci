import json
import sys
import re


# Function to create a valid markdown anchor from a check name
def generate_anchor(text):
    # Convert to lowercase, replace spaces with hyphens, and remove special characters
    return re.sub(r'[^a-z0-9\-_]', '', text.lower().replace(' ', '-'))


# Function to generate markdown table from JSON
def json_to_markdown(data):
    # Create the header for the markdown table
    markdown_table = "| **Technology** | **Check** | **Result** |\n"
    markdown_table += "|:--------------:|:---------:|:----------:|\n"

    # Loop through the JSON data to generate the table rows, sorted by technology and check
    for technology in sorted(data.keys()):  # Sort technologies alphabetically
        checks = data[technology]
        for check in sorted(checks.keys()):  # Sort checks alphabetically
            result = checks[check]
            # Generate the anchor link for the check
            anchor = generate_anchor(check)
            if result == "successful":
                markdown_table += f"| {technology} | {check} | [✅](#{anchor}) |\n"
            elif result == "failed":
                markdown_table += f"| {technology} | {check} | [❌](#{anchor}) |\n"
            else:
                markdown_table += f"| {technology} | {check} | {result} |\n"

    return markdown_table


# Function to filter checks based on the specified type
def filter_checks(data, failed_only):
    if failed_only:
        return {tech: {check: result for check, result in checks.items() if result == "failed"}
                for tech, checks in data.items() if any(result == "failed" for result in checks.values())}
    return data


# Main function to load the JSON from the file and generate the markdown table
def main(json_file_path, filter_type):
    # Load JSON data from the specified file
    with open(json_file_path, 'r') as f:
        data = json.load(f)

    # Filter the checks based on the specified type
    failed_only = filter_type == "failed-checks"
    filtered_data = filter_checks(data, failed_only)

    # Generate and print the markdown table
    markdown_output = json_to_markdown(filtered_data)
    print(markdown_output)


# Ensure a file path and filter type are provided as command-line arguments
if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 md_table_generator.py <failed-checks|all-checks> <path_to_json_file>")
    else:
        filter_type = sys.argv[1]
        json_file_path = sys.argv[2]

        if filter_type not in ["failed-checks", "all-checks"]:
            print("Invalid option for <failed-checks|all-checks>. Use 'failed-checks' or 'all-checks'.")
            sys.exit(1)

        main(json_file_path, filter_type)