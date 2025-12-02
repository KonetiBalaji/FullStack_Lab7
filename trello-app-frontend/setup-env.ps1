# PowerShell script to create .env file for frontend deployment
# IMPORTANT: Replace the placeholder values with your actual backend deployment values

Write-Host "Creating .env file template..." -ForegroundColor Cyan
Write-Host ""
Write-Host "Please enter your backend deployment values:" -ForegroundColor Yellow
Write-Host ""

$userPoolId = Read-Host "Enter User Pool ID (from CloudFormation outputs)"
$clientId = Read-Host "Enter User Pool Client ID (from CloudFormation outputs)"
$apiUrl = Read-Host "Enter API Gateway URL (from CloudFormation outputs)"
$region = Read-Host "Enter AWS Region (e.g., us-east-1)"

$envContent = @"
REACT_APP_USER_POOL_ID=$userPoolId
REACT_APP_USER_POOL_CLIENT_ID=$clientId
REACT_APP_API_URL=$apiUrl
REACT_APP_AWS_REGION=$region
"@

$envContent | Out-File -FilePath .env -Encoding utf8 -NoNewline

Write-Host ""
Write-Host "✅ .env file created successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Configuration:" -ForegroundColor Cyan
Write-Host "  User Pool ID: $userPoolId"
Write-Host "  Client ID: $clientId"
Write-Host "  API URL: $apiUrl"
Write-Host "  Region: $region"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Test locally: npm start"
Write-Host "  2. Deploy: See QUICK_DEPLOY.md or DEPLOYMENT_STEPS.md"
Write-Host ""

