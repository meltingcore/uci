import json
import sys


# Function to generate markdown table from JSON
def json_to_markdown(data):
    # Create the header for the markdown table
    markdown_table = "| **Technology** | **Check** | **Result** |\n"
    markdown_table += "|:--------------:|:---------:|:----------:|\n"

    # Loop through the JSON data to generate the table rows
    for technology, checks in data.items():
        for check, result in checks.items():
            markdown_table += f"| {technology} | {check} | {result} |\n"

    return markdown_table


# Main function to load the JSON from the file and generate the markdown table
def main(json_file_path):
    # Load JSON data from the specified file
    with open(json_file_path, 'r') as f:
        data = json.load(f)

    # Generate and print the markdown table
    markdown_output = json_to_markdown(data)
    print(markdown_output)


# Ensure a file path is provided as a command-line argument
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 md_table_generator.py <path_to_json_file>")
    else:
        json_file_path = sys.argv[1]
        main(json_file_path)