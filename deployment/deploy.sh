# Deployment Automation Script
#!/usr/bin/env bash

# Exit immediately if any command in the script fails
set -e

echo "=== 🐳 Building Hermetic Cross-Compile Toolchain Environment ==="
docker build -t hardware-tamper-compiler -f deployment/Dockerfile.cross-compile .

echo "=== 💾 Extracting Compiled Binary Security Artifact ==="
docker run --rm -v "$(pwd)"/deployment:/output hardware-tamper-compiler cp /dist/tamper_project.bin /output/

echo "=== 🎉 Success! Flashable binary generated at: deployment/tamper_project.bin ==="
