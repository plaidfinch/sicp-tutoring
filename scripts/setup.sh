#!/bin/bash
# Wrapper script - delegates to setup.py
exec "$(dirname "$0")/setup.py" "$@"
