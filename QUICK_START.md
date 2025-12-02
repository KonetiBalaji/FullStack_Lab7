# Quick Start Guide

## Prerequisites Check
```powershell
# Verify AWS CLI
aws --version

# Verify SAM CLI
sam --version

# Verify AWS credentials
aws sts get-caller-identity
```

## Deploy in 3 Steps

### 1. Build
```powershell
sam build
```

### 2. Deploy
```powershell
sam deploy --guided
```
**First time only**: Follow prompts, save config as `Y`

**Subsequent deployments**:
```powershell
sam deploy
```

### 3. Test
```powershell
# Get your API URL from the deployment output, then:
.\test-api.ps1 -ApiUrl "https://your-api-id.execute-api.us-east-1.amazonaws.com/Prod"
```

## Quick Test Commands

### Create Item
```powershell
$api = "https://your-api-id.execute-api.us-east-1.amazonaws.com/Prod"
$body = '{"name":"Test","status":"pending"}' | ConvertFrom-Json | ConvertTo-Json
Invoke-RestMethod -Uri "$api/items" -Method Post -Body $body -ContentType "application/json"
```

### Get All Items
```powershell
Invoke-RestMethod -Uri "$api/items" -Method Get
```

## Get API URL After Deployment
```powershell
aws cloudformation describe-stacks --stack-name lab7-serverless-api --query "Stacks[0].Outputs[?OutputKey=='ItemsApi'].OutputValue" --output text
```

## View Logs
```powershell
sam logs -n CreateItemFunction --stack-name lab7-serverless-api --tail
```

## Cleanup
```powershell
sam delete --stack-name lab7-serverless-api
```

