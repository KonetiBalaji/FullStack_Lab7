# Delete Old Resources for Fresh Lab 7 Deployment

## Issue Found

Existing resources from previous deployment are conflicting:
- ✅ DynamoDB Tables: TasksTable, CommentsTable, ActivityLogTable
- ✅ Cognito User Pool: TrelloAppUserPool

## Solution: Delete Old Resources

Run these commands to delete the existing resources:

### 1. Delete DynamoDB Tables

```powershell
# Delete TasksTable
aws dynamodb delete-table --table-name TasksTable

# Delete CommentsTable
aws dynamodb delete-table --table-name CommentsTable

# Delete ActivityLogTable
aws dynamodb delete-table --table-name ActivityLogTable
```

**Wait for deletion to complete** (check status):
```powershell
aws dynamodb describe-table --table-name TasksTable 2>&1 | Select-String "ResourceNotFoundException"
```

### 2. Delete Cognito User Pool

```powershell
# Delete the User Pool (replace with your actual User Pool ID)
aws cognito-idp delete-user-pool --user-pool-id us-east-1_Tx8ircMe3
```

### 3. Check for Other Resources

```powershell
# Check for SQS Queues
aws sqs list-queues --query 'QueueUrls[?contains(@, `activity`) || contains(@, `reminder`)]' --output table

# Check for API Gateway APIs
aws apigateway get-rest-apis --query 'items[?contains(name, `Trello`) || contains(name, `lab7`)].{Name:name,Id:id}' --output table

# Check for Lambda Functions
aws lambda list-functions --query 'Functions[?contains(FunctionName, `Task`) || contains(FunctionName, `Comment`) || contains(FunctionName, `Activity`)].FunctionName' --output table
```

### 4. After Deleting Resources

Once resources are deleted, try deploying again:

```powershell
cd trello-app-backend
sam build
sam deploy
```

## Alternative: Use Different Names

If you want to keep the old resources, you can modify the template to use different names for Lab 7.

