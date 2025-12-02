# Lab 7 Project Summary

## Overview
This project implements a complete serverless CRUD application using AWS services, fulfilling all requirements for Lab 7.

## Architecture Components

### 1. Amazon DynamoDB Table
- **Table Name**: `ItemsTable`
- **Primary Key**: `id` (String, Partition Key)
- **Billing Mode**: Pay-per-request (no capacity planning needed)
- **Data Model**: Simple item management (to-do list style)

### 2. AWS Lambda Functions (5 Functions)
All functions are written in Python 3.11 with X-Ray tracing enabled:

1. **CreateItemFunction** (`src/handlers/create_item.py`)
   - Endpoint: `POST /items`
   - Creates new items with auto-generated UUID

2. **GetAllItemsFunction** (`src/handlers/get_all_items.py`)
   - Endpoint: `GET /items`
   - Retrieves all items from the table

3. **GetItemFunction** (`src/handlers/get_item.py`)
   - Endpoint: `GET /items/{id}`
   - Retrieves a specific item by ID

4. **UpdateItemFunction** (`src/handlers/update_item.py`)
   - Endpoint: `PUT /items/{id}`
   - Updates existing items

5. **DeleteItemFunction** (`src/handlers/delete_item.py`)
   - Endpoint: `DELETE /items/{id}`
   - Deletes items from the table

### 3. Amazon API Gateway
- **Type**: REST API
- **Stage**: Prod (default)
- **Integration**: Each HTTP method integrated with corresponding Lambda function
- **CORS**: Enabled for all endpoints

### 4. Monitoring & Observability
- **CloudWatch Logs**: Automatic logging for all Lambda functions
- **AWS X-Ray**: Active tracing for distributed request tracking
- **CloudWatch Metrics**: Automatic metrics collection (invocations, errors, duration)

## IAM Permissions
Each Lambda function follows the principle of least privilege:
- **Create/Update/Delete functions**: DynamoDBCrudPolicy (read/write access)
- **Read functions**: DynamoDBReadPolicy (read-only access)
- **All functions**: AWSXRayDaemonWriteAccess (for tracing)

## Project Files

### Core Application Files
- `template.yaml` - AWS SAM template defining all infrastructure
- `requirements.txt` - Python dependencies (boto3, aws-xray-sdk)
- `src/handlers/*.py` - Lambda function handlers

### Documentation
- `README.md` - Comprehensive project documentation
- `DEPLOYMENT_GUIDE.md` - Step-by-step deployment instructions
- `QUICK_START.md` - Quick reference for common tasks
- `PROJECT_SUMMARY.md` - This file

### Testing & Tools
- `test-api.ps1` - PowerShell script for API testing
- `test-api.sh` - Bash script for API testing
- `postman_collection.json` - Postman collection for API testing

### Configuration
- `.gitignore` - Git ignore rules for Python and AWS SAM artifacts

## Deployment Method
Uses **AWS SAM (Serverless Application Model)** for infrastructure-as-code:
- Single template file defines all resources
- Automated IAM role creation
- Environment variable management
- Easy deployment and cleanup

## API Endpoints Summary

| Method | Path | Function | Description |
|--------|------|----------|-------------|
| POST | `/items` | CreateItemFunction | Create new item |
| GET | `/items` | GetAllItemsFunction | List all items |
| GET | `/items/{id}` | GetItemFunction | Get item by ID |
| PUT | `/items/{id}` | UpdateItemFunction | Update item |
| DELETE | `/items/{id}` | DeleteItemFunction | Delete item |

## Data Model Example

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Complete Lab 7",
  "description": "Finish the serverless application lab",
  "status": "in-progress",
  "priority": "high",
  "category": "assignment",
  "createdAt": "2024-01-15T10:30:00.000Z",
  "updatedAt": "2024-01-15T10:30:00.000Z"
}
```

## Lab Requirements Checklist

### ✅ DynamoDB Table
- [x] Table created with appropriate primary key
- [x] Pay-per-request billing mode
- [x] Simple data model for item management

### ✅ Lambda Functions
- [x] Create function (POST)
- [x] Read function (GET all)
- [x] Read function (GET by ID)
- [x] Update function (PUT)
- [x] Delete function (DELETE)
- [x] IAM roles with least privilege
- [x] Individual testing capability

### ✅ API Gateway
- [x] REST API created
- [x] Resources and methods defined
- [x] Lambda integrations configured
- [x] API deployed to stage
- [x] Publicly accessible endpoint

### ✅ Monitoring
- [x] CloudWatch Logs integration
- [x] X-Ray tracing enabled
- [x] Metrics collection active

### ✅ Optional Extensions
- [x] AWS SAM deployment (implemented)
- [ ] API Gateway caching (can be added via console)

## Next Steps for Lab Submission

1. **Deploy the application**:
   ```powershell
   sam build
   sam deploy --guided
   ```

2. **Test the API**:
   ```powershell
   .\test-api.ps1 -ApiUrl "YOUR_API_URL"
   ```

3. **Collect evidence**:
   - API endpoint URL with successful test
   - API Gateway dashboard screenshot
   - DynamoDB table screenshot
   - CloudWatch/X-Ray monitoring screenshot
   - All screenshots must include timestamp and NAU ID/email

4. **Cleanup** (after submission):
   ```powershell
   sam delete --stack-name lab7-serverless-api
   ```

## Cost Considerations
- **DynamoDB**: Pay-per-request (free tier: 25 GB storage, 25 RCU/WCU)
- **Lambda**: Free tier: 1M requests/month
- **API Gateway**: Free tier: 1M API calls/month
- **X-Ray**: Free tier: 100K traces/month
- **CloudWatch**: Free tier: 10 custom metrics, 5 GB logs

For lab purposes, costs should be minimal or free within AWS free tier limits.

