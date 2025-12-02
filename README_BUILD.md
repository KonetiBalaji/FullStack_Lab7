# Building the Application - Python Version Issue

## Problem
You have Python 3.14 installed, but AWS Lambda supports up to Python 3.12. SAM requires an exact version match for validation.

## Solutions (Choose One)

### Solution 1: Use Docker (Recommended - Easiest)

1. **Install Docker Desktop**: https://www.docker.com/products/docker-desktop/
2. **Start Docker Desktop**
3. **Build with Docker**:
   ```powershell
   sam build --use-container
   ```

This uses the correct Python version inside a Docker container, regardless of your local Python version.

### Solution 2: Install Python 3.12

1. **Download Python 3.12**: https://www.python.org/downloads/release/python-3120/
2. **Install it** (you can have multiple Python versions)
3. **Update PATH** or use the full path:
   ```powershell
   # Add Python 3.12 to PATH temporarily
   $env:PATH = "C:\Python312;C:\Python312\Scripts;$env:PATH"
   
   # Verify
   python --version  # Should show 3.12.x
   
   # Build
   sam build
   ```

### Solution 3: Use the Build Script

Run the provided build script which will try multiple methods:

```powershell
.\build.ps1
```

### Solution 4: Use WSL2 (If Available)

If you have WSL2 with Python 3.12:

```bash
# In WSL2
cd /mnt/e/Data_Science_Portfolio/lab7
sam build
```

## Important Notes

- **Your code will run on Python 3.12 in AWS Lambda** regardless of your local Python version
- The template has been updated to use `python3.12` runtime
- Docker is the easiest solution as it handles version matching automatically
- You only need the correct Python version for **building**, not for running locally

## After Successful Build

Once the build succeeds, you can deploy:

```powershell
sam deploy --guided
```

## Quick Commands

```powershell
# Option 1: Docker (if installed and running)
sam build --use-container

# Option 2: If you have Python 3.12
sam build

# Option 3: Use build script
.\build.ps1
```

## Verify Your Setup

```powershell
# Check Python version
python --version

# Check if Docker is running
docker ps

# Check SAM version
sam --version
```

