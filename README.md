# Serverless CRUD API with DynamoDB, Lambda, and API Gateway

This project implements a complete serverless application using AWS services:
- **Amazon DynamoDB**: NoSQL database for storing items
- **AWS Lambda**: Serverless functions for CRUD operations
- **Amazon API Gateway**: RESTful API endpoint
- **AWS X-Ray**: Distributed tracing for monitoring
- **Amazon CloudWatch**: Logging and monitoring

## Project Structure

```
.
├── template.yaml          # AWS SAM template
├── requirements.txt       # Python dependencies
├── README.md             # This file
├── test-api.sh          # API testing script
├── test-api.ps1         # PowerShell API testing script
└── src/
    └── handlers/
        ├── create_item.py    # POST /items
        ├── get_all_items.py  # GET /items
        ├── get_item.py       # GET /items/{id}
        ├── update_item.py    # PUT /items/{id}
        └── delete_item.py    # DELETE /items/{id}
```

## Prerequisites

1. **AWS Account** with appropriate permissions
2. **AWS CLI** installed and configured
3. **AWS SAM CLI** installed
   ```bash
   # Install AWS SAM CLI
   # Windows: Download from https://aws.amazon.com/serverless/sam/
   # Or use: pip install aws-sam-cli
   ```
4. **Python 3.11** (or compatible version)

## Deployment Instructions

### 1. Build the SAM Application

```bash
sam build
```

### 2. Deploy to AWS

```bash
sam deploy --guided
```

During guided deployment, you'll be prompted for:
- Stack Name: `lab7-serverless-api` (or your preferred name)
- AWS Region: Choose your region (e.g., `us-east-1`)
- Confirm changes: `Y`
- Allow SAM CLI IAM role creation: `Y`
- Disable rollback: `N` (default)
- Save arguments to configuration file: `Y`

Alternatively, deploy without prompts:

```bash
sam deploy --stack-name lab7-serverless-api --region us-east-1 --capabilities CAPABILITY_IAM --resolve-s3
```

### 3. Get API Endpoint

After deployment, the API endpoint URL will be displayed in the outputs. You can also retrieve it with:

```bash
aws cloudformation describe-stacks --stack-name lab7-serverless-api --query "Stacks[0].Outputs[?OutputKey=='ItemsApi'].OutputValue" --output text
```

## API Endpoints

Base URL: `https://{api-id}.execute-api.{region}.amazonaws.com/Prod`

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/items` | Create a new item |
| GET | `/items` | Get all items |
| GET | `/items/{id}` | Get item by ID |
| PUT | `/items/{id}` | Update an item |
| DELETE | `/items/{id}` | Delete an item |

## Testing the API

### Using curl (Linux/Mac/Git Bash)

```bash
# Set your API endpoint
API_URL="https://your-api-id.execute-api.us-east-1.amazonaws.com/Prod"

# Create an item
curl -X POST "$API_URL/items" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Complete Lab 7",
    "description": "Finish the serverless application lab",
    "status": "in-progress",
    "priority": "high"
  }'

# Get all items
curl -X GET "$API_URL/items"

# Get item by ID (replace {id} with actual ID from create response)
curl -X GET "$API_URL/items/{id}"

# Update an item
curl -X PUT "$API_URL/items/{id}" \
  -H "Content-Type: application/json" \
  -d '{
    "status": "completed",
    "priority": "low"
  }'

# Delete an item
curl -X DELETE "$API_URL/items/{id}"
```

### Using PowerShell (Windows)

See `test-api.ps1` script for examples.

### Using Postman

1. Import the collection from `postman_collection.json` (if available)
2. Set the `API_URL` environment variable
3. Run the requests

## Monitoring

### CloudWatch Logs

1. Navigate to AWS Console → CloudWatch → Log groups
2. Find log groups: `/aws/lambda/CreateItemFunction`, `/aws/lambda/GetAllItemsFunction`, etc.
3. View logs for each Lambda function invocation

### X-Ray Tracing

1. Navigate to AWS Console → X-Ray → Traces
2. View service map and traces
3. Analyze latency and identify bottlenecks

### CloudWatch Metrics

1. Navigate to AWS Console → CloudWatch → Metrics
2. View Lambda metrics: Invocations, Errors, Duration, Throttles
3. View API Gateway metrics: Count, Latency, 4XX/5XX errors

## Data Model

The DynamoDB table uses the following schema:

- **Primary Key**: `id` (String, Partition Key)
- **Attributes**:
  - `name` (String, required)
  - `description` (String, optional)
  - `status` (String, optional, default: "pending")
  - `category` (String, optional)
  - `priority` (String, optional)
  - `createdAt` (String, ISO timestamp)
  - `updatedAt` (String, ISO timestamp)

## Cleanup

To delete all resources:

```bash
sam delete --stack-name lab7-serverless-api
```

## Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure your AWS credentials have necessary permissions
2. **Function Timeout**: Increase timeout in `template.yaml` if needed
3. **DynamoDB Errors**: Check IAM roles have DynamoDB permissions
4. **API Gateway 502**: Check Lambda function logs in CloudWatch

### Viewing Logs

```bash
# View logs for a specific function
sam logs -n CreateItemFunction --stack-name lab7-serverless-api --tail
```

## Evidence Collection Checklist

For your lab submission, ensure you capture:

- [ ] API Gateway endpoint URL with successful curl/Postman test
- [ ] API Gateway dashboard screenshot (resources, methods, integrations)
- [ ] DynamoDB table overview screenshot (table name, primary key, sample item)
- [ ] CloudWatch dashboard screenshot (Lambda metrics, X-Ray traces)
- [ ] All screenshots include timestamp and your NAU ID/email

## Additional Features (Optional)

### API Gateway Caching

To enable caching, add to `template.yaml`:

```yaml
GetAllItems:
  Type: Api
  Properties:
    Path: /items
    Method: get
    RestApiId: !Ref ServerlessRestApi
    CacheKeyParameters:
      - method.request.path.id
    CacheTtlInSeconds: 300
```

Then update the API Gateway method configuration in the console.

## License

This project is for educational purposes as part of Lab 7.

