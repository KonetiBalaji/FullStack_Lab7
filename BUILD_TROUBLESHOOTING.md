# Build Troubleshooting Guide

## Issue: Python Version Mismatch

If you encounter errors like:
```
Binary validation failed for python, searched for python in following locations which did not satisfy constraints for runtime: python3.11
```

### Solution 1: Use Docker for Building (Recommended)

If your local Python version doesn't match the Lambda runtime, use Docker:

```powershell
# Build using Docker
sam build --use-container

# Deploy
sam deploy --guided
```

**Prerequisites:**
- Docker Desktop installed and running
- Docker daemon accessible

### Solution 2: Install Matching Python Version

If you prefer not to use Docker, install Python 3.12:

1. Download Python 3.12 from: https://www.python.org/downloads/
2. Install it (you can have multiple Python versions)
3. Update PATH or use full path to python3.12

### Solution 3: Use Python 3.12 Runtime (Already Updated)

The template has been updated to use `python3.12` which is the latest supported by AWS Lambda.

If you still have issues, try:

```powershell
# Clear SAM build cache
Remove-Item -Recurse -Force .aws-sam -ErrorAction SilentlyContinue

# Build again
sam build --use-container
```

### Solution 4: Manual Build with Docker

If `--use-container` doesn't work, you can manually specify:

```powershell
sam build --use-container --container-env-var-file .env
```

Or build in a Docker container manually:

```powershell
docker run -v "${PWD}:/var/task" public.ecr.aws/sam/build-python3.12:latest sam build
```

## Current Python Version Check

Check your Python version:
```powershell
python --version
```

AWS Lambda currently supports:
- Python 3.9
- Python 3.10
- Python 3.11
- Python 3.12 (latest)

## Alternative: Use Provided Runtime

If you have Python 3.11 or 3.12 installed but SAM can't find it:

1. Check where Python is installed:
   ```powershell
   where python
   ```

2. Add Python to PATH or use full path:
   ```powershell
   $env:PATH += ";C:\Path\To\Python312"
   ```

3. Verify SAM can find it:
   ```powershell
   sam --version
   python --version
   ```

## Quick Fix Commands

```powershell
# Option 1: Use Docker (easiest)
sam build --use-container

# Option 2: If Docker not available, try with explicit Python
$env:PATH = "C:\Python312;C:\Python312\Scripts;$env:PATH"
sam build

# Option 3: Clean and rebuild
Remove-Item -Recurse -Force .aws-sam
sam build --use-container
```

