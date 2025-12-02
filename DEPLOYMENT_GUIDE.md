# Step-by-Step Deployment Guide

This guide provides detailed instructions for deploying and testing your serverless application.

## Prerequisites Setup

### 1. Install AWS CLI
```powershell
# Download and install from: https://aws.amazon.com/cli/
# Verify installation
aws --version
```

### 2. Configure AWS Credentials
```powershell
aws configure
# Enter your:
# - AWS Access Key ID
# - AWS Secret Access Key
# - Default region (e.g., us-east-1)
# - Default output format (json)
```

### 3. Install AWS SAM CLI
```powershell
# Option 1: Download installer from https://aws.amazon.com/serverless/sam/
# Option 2: Using pip (if Python is installed)
pip install aws-sam-cli

# Verify installation
sam --version
```

## Deployment Steps

### Step 1: Navigate to Project Directory
```powershell
cd E:\Data_Science_Portfolio\lab7
```

### Step 2: Build the Application
```powershell
sam build
```
This will:
- Install dependencies from `requirements.txt`
- Package your Lambda functions
- Prepare the deployment package

### Step 3: Deploy the Application
```powershell
sam deploy --guided
```

**First-time deployment prompts:**
- **Stack Name**: `lab7-serverless-api`
- **AWS Region**: `us-east-1` (or your preferred region)
- **Confirm changes before deploy**: `Y`
- **Allow SAM CLI IAM role creation**: `Y` (required for first deployment)
- **Disable rollback**: `N` (keep default)
- **Save arguments to configuration file**: `Y` (saves to `samconfig.toml`)

**Subsequent deployments:**
```powershell
sam deploy
```

### Step 4: Capture API Endpoint
After deployment completes, note the API endpoint URL from the output:
```
Outputs:
  ItemsApi:
    Description: "API Gateway endpoint URL"
    Value: https://abc123xyz.execute-api.us-east-1.amazonaws.com/Prod/
```

**Save this URL** - you'll need it for testing and your lab submission.

## Testing the API

### Method 1: Using PowerShell Script
```powershell
.\test-api.ps1 -ApiUrl "https://your-api-id.execute-api.us-east-1.amazonaws.com/Prod"
```

### Method 2: Using curl (Git Bash or WSL)
```bash
# Make script executable
chmod +x test-api.sh

# Run tests
./test-api.sh https://your-api-id.execute-api.us-east-1.amazonaws.com/Prod
```

### Method 3: Manual Testing with PowerShell
```powershell
$apiUrl = "https://your-api-id.execute-api.us-east-1.amazonaws.com/Prod"

# Create item
$body = @{
    name = "Test Item"
    description = "This is a test"
    status = "pending"
} | ConvertTo-Json

Invoke-RestMethod -Uri "$apiUrl/items" -Method Post -Body $body -ContentType "application/json"

# Get all items
Invoke-RestMethod -Uri "$apiUrl/items" -Method Get
```

### Method 4: Using Postman
1. Open Postman
2. Create a new request
3. Set method to POST
4. Enter URL: `https://your-api-id.execute-api.us-east-1.amazonaws.com/Prod/items`
5. Go to Body tab → raw → JSON
6. Enter:
```json
{
  "name": "Test Item",
  "description": "Testing API",
  "status": "pending"
}
```
7. Click Send

## Collecting Evidence for Lab Submission

### 1. API Endpoint Test Evidence
**Screenshot or document showing:**
- The API endpoint URL
- A successful API call (curl command or Postman screenshot)
- The response showing created/retrieved item

**Example curl command:**
```bash
curl -X POST "https://abc123.execute-api.us-east-1.amazonaws.com/Prod/items" \
  -H "Content-Type: application/json" \
  -d '{"name":"Lab 7 Test","status":"pending"}'
```

### 2. API Gateway Dashboard Screenshot
1. Navigate to AWS Console → API Gateway
2. Click on your API (should be named something like `lab7-serverless-api`)
3. Take screenshot showing:
   - API name
   - Resources (`/items`, `/items/{id}`)
   - Methods (GET, POST, PUT, DELETE)
   - Lambda integrations
   - **Include timestamp and your NAU ID/email in the screenshot**

### 3. DynamoDB Table Screenshot
1. Navigate to AWS Console → DynamoDB → Tables
2. Click on `ItemsTable`
3. Take screenshot showing:
   - Table name
   - Primary key definition (`id` as partition key)
   - Go to "Explore table items" tab
   - Show at least one sample item
   - **Include timestamp and your NAU ID/email**

### 4. CloudWatch Monitoring Screenshot
1. Navigate to AWS Console → CloudWatch
2. **Lambda Metrics:**
   - Go to Metrics → AWS/Lambda
   - Select one of your functions (e.g., CreateItemFunction)
   - View graphs for: Invocations, Errors, Duration
3. **X-Ray Traces:**
   - Go to X-Ray → Traces
   - View service map showing API Gateway → Lambda → DynamoDB
   - Show a trace detail
4. Take screenshot(s) showing:
   - Lambda metrics dashboard
   - X-Ray service map or trace
   - **Include timestamp and your NAU ID/email**

## Verification Checklist

Before submitting, verify:

- [ ] All Lambda functions deployed successfully
- [ ] API Gateway endpoint is accessible
- [ ] Can create items via API
- [ ] Can retrieve items via API
- [ ] Can update items via API
- [ ] Can delete items via API
- [ ] DynamoDB table has items
- [ ] CloudWatch logs are being generated
- [ ] X-Ray traces are visible
- [ ] All screenshots include timestamp and NAU ID/email

## Troubleshooting

### Issue: "Access Denied" errors
**Solution**: Check IAM permissions. SAM creates roles automatically, but ensure your AWS credentials have CloudFormation, Lambda, API Gateway, and DynamoDB permissions.

### Issue: Lambda function timeout
**Solution**: Increase timeout in `template.yaml`:
```yaml
Globals:
  Function:
    Timeout: 30  # Increase from 10
```

### Issue: API Gateway returns 502
**Solution**: 
1. Check CloudWatch logs for the Lambda function
2. Verify Lambda function has correct IAM permissions
3. Check that environment variable `TABLE_NAME` is set correctly

### Issue: X-Ray traces not showing
**Solution**:
1. Ensure `Tracing: Active` is set in `template.yaml`
2. Wait a few minutes after making API calls
3. Check that X-Ray permissions are granted to Lambda functions

### Viewing Logs
```powershell
# View logs for a specific function
sam logs -n CreateItemFunction --stack-name lab7-serverless-api --tail

# Or use AWS CLI
aws logs tail /aws/lambda/CreateItemFunction --follow
```

## Cleanup (After Lab Submission)

To avoid ongoing charges, delete all resources:

```powershell
sam delete --stack-name lab7-serverless-api
```

This will delete:
- All Lambda functions
- API Gateway API
- DynamoDB table
- IAM roles
- CloudWatch log groups

## Additional Resources

- [AWS SAM Documentation](https://docs.aws.amazon.com/serverless-application-model/)
- [API Gateway Documentation](https://docs.aws.amazon.com/apigateway/)
- [Lambda Documentation](https://docs.aws.amazon.com/lambda/)
- [DynamoDB Documentation](https://docs.aws.amazon.com/dynamodb/)
- [X-Ray Documentation](https://docs.aws.amazon.com/xray/)

