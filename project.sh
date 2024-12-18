#!/bin/bash

# Constants
URL="https://picsum.photos/200/300"
BASE_DIR=$(pwd)
TEMP_DIR="$BASE_DIR/temp"

function printHelpMessage() {
    echo -e "\nUsage: $0 [ -p PATH | -t ] [ -o FILENAME ] [ -r RESOLUTION ]"
    echo "* -p PATH: Save the image to a specific path."
    echo "* -t: Save the image in the temp directory."
    echo "* -o FILENAME: Save the image with a specific name."
    echo "* -r RESOLUTION: Set a custom resolution for the image (e.g., 1920x1080)."
    echo "* -h | --help: Show this help message."
    echo -e "Example: $0 -p ~/Desktop -o my-wallpaper -r 1280x720\n"
}

# Function: Download image
function downloadImage() {
    local image_path=$1
    local file_name=$2
    local resolution=$3

    # Split the resolution into width and height
    local width=${resolution%x*}
    local height=${resolution#*x}

    # Ensure the target directory exists
    mkdir -p "$image_path"

    # Use curl to download the image
    curl -s "${URL}/${width}/${height}" -o "${image_path}/${file_name}" && \
        echo "Image saved to ${image_path}/${file_name}" || \
        echo "Failed to download the image."

    # Return back to the base directory
    cd "$BASE_DIR"
}


# Function: Save image based on user input
function saveImage() {
    local image_path=$TEMP_DIR
    local image_resolution="1920x1080"
    local image_name="image.jpeg"

    while [[ $# -gt 0 ]]; do
        case "$1" in
        -p)
            shift
            if [[ -d "$1" ]]; then
                image_path="$1"
            else
                echo "Error: Invalid path '$1'."
                exit 1
            fi
            ;;
        -t)
            image_path="$TEMP_DIR"
            ;;
        -o)
            shift
            if [[ "$1" != "" ]]; then
                image_name="$1"
            else
                echo "Error: Invalid filename."
                exit 1
            fi
            ;;
        -r)
            shift
            if [[ "$1" =~ ^[0-9]+x[0-9]+$ ]]; then
                image_resolution="$1"
            else
                echo "Error: Invalid resolution format. Use WIDTHxHEIGHT (e.g., 1920x1080)."
                exit 1
            fi
            ;;
        -h|--help)
            printHelpMessage
            exit 0
            ;;
        *)
            echo "Error: Unknown option '$1'."
            printHelpMessage
            exit 1
            ;;
        esac
        shift
    done

    # Download the image
    downloadImage "$image_path" "$image_name" "$image_resolution"
}

# Main script logic
if [[ $# -lt 1 ]]; then
    printHelpMessage
else
    saveImage "$@"
fi


#./project.sh -p ~/Desktop -o custom-wallpaper.jpg -r 1280x720
