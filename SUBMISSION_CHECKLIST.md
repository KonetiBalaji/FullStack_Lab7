# Lab 7 Submission Checklist

Use this checklist to ensure you have completed all requirements and collected all necessary evidence.

## Pre-Deployment Checklist

- [ ] AWS CLI installed and configured
- [ ] AWS SAM CLI installed
- [ ] AWS credentials configured with appropriate permissions
- [ ] Python 3.11 (or compatible) available
- [ ] Project files reviewed and understood

## Deployment Checklist

- [ ] Application built successfully (`sam build`)
- [ ] Application deployed successfully (`sam deploy --guided`)
- [ ] API endpoint URL captured from deployment output
- [ ] All Lambda functions visible in AWS Console
- [ ] DynamoDB table created and visible
- [ ] API Gateway API created and visible

## Functionality Testing Checklist

- [ ] **CREATE**: Successfully created an item via POST /items
- [ ] **READ (All)**: Successfully retrieved all items via GET /items
- [ ] **READ (One)**: Successfully retrieved item by ID via GET /items/{id}
- [ ] **UPDATE**: Successfully updated an item via PUT /items/{id}
- [ ] **DELETE**: Successfully deleted an item via DELETE /items/{id}
- [ ] Verified item appears in DynamoDB table
- [ ] Verified CloudWatch logs are being generated
- [ ] Verified X-Ray traces are visible

## Evidence Collection Checklist

### 1. API Endpoint Test Evidence
- [ ] Document or screenshot showing:
  - [ ] Public API endpoint URL
  - [ ] Example curl command or Postman request
  - [ ] Successful response (e.g., created item or retrieved item)
  - [ ] **Timestamp visible**
  - [ ] **NAU ID/email visible**

**Example format:**
```
API Endpoint: https://abc123.execute-api.us-east-1.amazonaws.com/Prod/

Test Command:
curl -X POST "https://abc123.execute-api.us-east-1.amazonaws.com/Prod/items" \
  -H "Content-Type: application/json" \
  -d '{"name":"Test Item","status":"pending"}'

Response:
{
  "message": "Item created successfully",
  "item": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "name": "Test Item",
    ...
  }
}

Timestamp: 2024-01-15 10:30:00
NAU ID: your-nau-id@nau.edu
```

### 2. API Gateway Dashboard Screenshot
- [ ] Navigate to: AWS Console → API Gateway
- [ ] Screenshot shows:
  - [ ] API name (e.g., `lab7-serverless-api`)
  - [ ] Resources: `/items` and `/items/{id}`
  - [ ] Methods: GET, POST, PUT, DELETE
  - [ ] Lambda integrations visible
  - [ ] **Timestamp visible** (browser/system clock)
  - [ ] **NAU ID/email visible** (add text overlay or include in screenshot)

### 3. DynamoDB Table Screenshot
- [ ] Navigate to: AWS Console → DynamoDB → Tables → ItemsTable
- [ ] Screenshot shows:
  - [ ] Table name: `ItemsTable`
  - [ ] Primary key definition: `id` (Partition key)
  - [ ] Navigate to "Explore table items" tab
  - [ ] At least one sample item visible with data
  - [ ] **Timestamp visible**
  - [ ] **NAU ID/email visible**

### 4. CloudWatch Monitoring Screenshot
- [ ] Navigate to: AWS Console → CloudWatch
- [ ] Screenshot shows:
  - [ ] Lambda metrics dashboard:
    - [ ] Navigate to Metrics → AWS/Lambda
    - [ ] Select one function (e.g., CreateItemFunction)
    - [ ] Graphs visible for: Invocations, Errors, Duration
  - [ ] X-Ray traces:
    - [ ] Navigate to X-Ray → Traces or Service Map
    - [ ] Service map showing: API Gateway → Lambda → DynamoDB
    - [ ] OR trace detail showing request flow
  - [ ] **Timestamp visible**
  - [ ] **NAU ID/email visible**

## Optional Extensions Checklist

- [ ] **AWS SAM Deployment**: ✅ Implemented (using SAM template)
- [ ] **API Gateway Caching**: 
  - [ ] Caching enabled for GET /items endpoint
  - [ ] Cache TTL configured (e.g., 300 seconds)
  - [ ] Screenshot of caching configuration

## Documentation Checklist

- [ ] All code files reviewed
- [ ] README.md reviewed
- [ ] Deployment guide followed
- [ ] Test scripts executed successfully

## Final Review

- [ ] All required screenshots captured
- [ ] All screenshots include timestamp
- [ ] All screenshots include NAU ID/email
- [ ] API endpoint is accessible and working
- [ ] All CRUD operations tested and working
- [ ] Monitoring evidence collected
- [ ] Submission document prepared (PDF or Word)
- [ ] Ready to submit!

## Quick Commands Reference

```powershell
# Get API URL
aws cloudformation describe-stacks --stack-name lab7-serverless-api --query "Stacks[0].Outputs[?OutputKey=='ItemsApi'].OutputValue" --output text

# Test API
.\test-api.ps1 -ApiUrl "YOUR_API_URL"

# View logs
sam logs -n CreateItemFunction --stack-name lab7-serverless-api --tail

# Cleanup (after submission)
sam delete --stack-name lab7-serverless-api
```

## Tips for Screenshots

1. **Include Timestamp**: 
   - Use Windows Snipping Tool or Snip & Sketch
   - Include system clock in screenshot
   - Or add timestamp text overlay

2. **Include NAU ID/Email**:
   - Add text box with your NAU ID/email
   - Or include it in a visible location
   - Can use image editing tool to add text

3. **Clear Screenshots**:
   - Ensure all relevant information is visible
   - Use full-screen or windowed screenshots
   - Zoom in if needed for clarity

4. **Organize Evidence**:
   - Create a single document (PDF/Word)
   - Label each screenshot clearly
   - Include brief descriptions

## Troubleshooting Before Submission

If something isn't working:

1. **API not accessible**: Check API Gateway deployment stage
2. **Lambda errors**: Check CloudWatch logs
3. **DynamoDB errors**: Check IAM permissions
4. **X-Ray not showing**: Wait a few minutes, make more API calls
5. **Missing data**: Create test items via API first

Good luck with your submission! 🚀

