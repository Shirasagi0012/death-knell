#!/bin/bash

# Get the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# For python virtual environment
source "$DIR"/get-score-venv/bin/activate

# Run the main.py
python "$DIR"/main.py -u "$STUDENT_ID" -p "$PASSWORD" -n "$NAME" \
    -y "$SCHOOL_YEAR" -s "$SEMESTER" \
    -w "$WEBHOOK_URL"