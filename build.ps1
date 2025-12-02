# Build script with Python version workaround
# This script helps build the SAM application when Python version doesn't match exactly

Write-Host "Building SAM Application..." -ForegroundColor Green

# Check if Docker is available
$dockerAvailable = $false
try {
    docker --version | Out-Null
    docker ps | Out-Null
    $dockerAvailable = $true
    Write-Host "Docker is available. Using container build..." -ForegroundColor Cyan
    sam build --use-container
} catch {
    Write-Host "Docker not available. Trying alternative methods..." -ForegroundColor Yellow
    
    # Try to find Python 3.12 or 3.11
    $pythonVersions = @("python3.12", "python3.11", "py -3.12", "py -3.11")
    $pythonFound = $false
    
    foreach ($pyCmd in $pythonVersions) {
        try {
            $version = & $pyCmd --version 2>&1
            if ($version -match "Python 3\.(11|12)") {
                Write-Host "Found compatible Python: $version" -ForegroundColor Green
                Write-Host "Attempting build with $pyCmd..." -ForegroundColor Cyan
                
                # Try building - SAM might accept it
                sam build
                $pythonFound = $true
                break
            }
        } catch {
            continue
        }
    }
    
    if (-not $pythonFound) {
        Write-Host "`nNo compatible Python version found." -ForegroundColor Red
        Write-Host "`nSolutions:" -ForegroundColor Yellow
        Write-Host "1. Install Docker Desktop and run: sam build --use-container" -ForegroundColor White
        Write-Host "2. Install Python 3.12 from: https://www.python.org/downloads/" -ForegroundColor White
        Write-Host "3. Use WSL2 with Python 3.12 installed" -ForegroundColor White
        Write-Host "`nNote: Your code will run on Python 3.12 in Lambda regardless of your local version." -ForegroundColor Cyan
        exit 1
    }
}

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nBuild successful! You can now deploy with: sam deploy --guided" -ForegroundColor Green
} else {
    Write-Host "`nBuild failed. See error messages above." -ForegroundColor Red
}

