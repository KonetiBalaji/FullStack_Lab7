# Your API Endpoint Information

## API Base URL
```
https://cncr1memua.execute-api.us-east-1.amazonaws.com/Prod
```

## Available Endpoints

### 1. Create Item
- **Method**: POST
- **URL**: `https://cncr1memua.execute-api.us-east-1.amazonaws.com/Prod/items`
- **Body**:
```json
{
  "name": "Item Name",
  "description": "Item description",
  "status": "pending",
  "priority": "high",
  "category": "assignment"
}
```

### 2. Get All Items
- **Method**: GET
- **URL**: `https://cncr1memua.execute-api.us-east-1.amazonaws.com/Prod/items`

### 3. Get Item by ID
- **Method**: GET
- **URL**: `https://cncr1memua.execute-api.us-east-1.amazonaws.com/Prod/items/{id}`
- **Example**: `https://cncr1memua.execute-api.us-east-1.amazonaws.com/Prod/items/4857bdc5-9b35-4c1c-bab9-918720e130b0`

### 4. Update Item
- **Method**: PUT
- **URL**: `https://cncr1memua.execute-api.us-east-1.amazonaws.com/Prod/items/{id}`
- **Body**:
```json
{
  "status": "completed",
  "priority": "low"
}
```

### 5. Delete Item
- **Method**: DELETE
- **URL**: `https://cncr1memua.execute-api.us-east-1.amazonaws.com/Prod/items/{id}`

## Quick Test Commands (PowerShell)

```powershell
$apiUrl = "https://cncr1memua.execute-api.us-east-1.amazonaws.com/Prod"

# Create item
$body = '{"name":"Test Item","description":"Testing","status":"pending"}' | ConvertFrom-Json | ConvertTo-Json
Invoke-RestMethod -Uri "$apiUrl/items" -Method Post -Body $body -ContentType "application/json"

# Get all items
Invoke-RestMethod -Uri "$apiUrl/items" -Method Get

# Get item by ID (replace {id} with actual ID)
Invoke-RestMethod -Uri "$apiUrl/items/{id}" -Method Get

# Update item
$updateBody = '{"status":"completed"}' | ConvertFrom-Json | ConvertTo-Json
Invoke-RestMethod -Uri "$apiUrl/items/{id}" -Method Put -Body $updateBody -ContentType "application/json"

# Delete item
Invoke-RestMethod -Uri "$apiUrl/items/{id}" -Method Delete
```

## Quick Test Commands (curl)

```bash
API_URL="https://cncr1memua.execute-api.us-east-1.amazonaws.com/Prod"

# Create item
curl -X POST "$API_URL/items" \
  -H "Content-Type: application/json" \
  -d '{"name":"Test Item","description":"Testing","status":"pending"}'

# Get all items
curl -X GET "$API_URL/items"

# Get item by ID
curl -X GET "$API_URL/items/{id}"

# Update item
curl -X PUT "$API_URL/items/{id}" \
  -H "Content-Type: application/json" \
  -d '{"status":"completed"}'

# Delete item
curl -X DELETE "$API_URL/items/{id}"
```

## Stack Information
- **Stack Name**: `lab7-durga-fullstack-readyforDeploy`
- **Region**: `us-east-1`
- **DynamoDB Table**: `ItemsTable`

## For Lab Submission

Save this API endpoint URL for your submission document. You'll need to:
1. Include this URL in your submission
2. Show a successful API test (curl or Postman screenshot)
3. Include timestamp and your NAU ID/email in screenshots

