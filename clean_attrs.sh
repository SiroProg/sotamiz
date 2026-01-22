#!/bin/bash
find build -type f -exec xattr -c {} \; 2>/dev/null
find build -type d -exec xattr -c {} \; 2>/dev/null
