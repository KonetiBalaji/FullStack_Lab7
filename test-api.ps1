# PowerShell script to test the API endpoints
# Usage: .\test-api.ps1 -ApiUrl "https://your-api-id.execute-api.us-east-1.amazonaws.com/Prod"

param(
    [Parameter(Mandatory=$true)]
    [string]$ApiUrl
)

Write-Host "Testing Serverless CRUD API" -ForegroundColor Green
Write-Host "API URL: $ApiUrl" -ForegroundColor Cyan
Write-Host ""

# Test 1: Create an item
Write-Host "1. Creating a new item..." -ForegroundColor Yellow
$createBody = @{
    name = "Complete Lab 7"
    description = "Finish the serverless application lab"
    status = "in-progress"
    priority = "high"
    category = "assignment"
} | ConvertTo-Json

try {
    $createResponse = Invoke-RestMethod -Uri "$ApiUrl/items" -Method Post -Body $createBody -ContentType "application/json"
    $itemId = $createResponse.item.id
    Write-Host "✓ Item created successfully!" -ForegroundColor Green
    Write-Host "  Item ID: $itemId" -ForegroundColor Cyan
    Write-Host "  Response: $($createResponse | ConvertTo-Json -Depth 3)" -ForegroundColor Gray
    Write-Host ""
} catch {
    Write-Host "✗ Failed to create item: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Test 2: Get all items
Write-Host "2. Getting all items..." -ForegroundColor Yellow
try {
    $getAllResponse = Invoke-RestMethod -Uri "$ApiUrl/items" -Method Get
    Write-Host "✓ Retrieved all items!" -ForegroundColor Green
    Write-Host "  Count: $($getAllResponse.count)" -ForegroundColor Cyan
    Write-Host "  Response: $($getAllResponse | ConvertTo-Json -Depth 3)" -ForegroundColor Gray
    Write-Host ""
} catch {
    Write-Host "✗ Failed to get all items: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Get item by ID
Write-Host "3. Getting item by ID: $itemId..." -ForegroundColor Yellow
try {
    $getItemResponse = Invoke-RestMethod -Uri "$ApiUrl/items/$itemId" -Method Get
    Write-Host "✓ Retrieved item!" -ForegroundColor Green
    Write-Host "  Response: $($getItemResponse | ConvertTo-Json -Depth 3)" -ForegroundColor Gray
    Write-Host ""
} catch {
    Write-Host "✗ Failed to get item: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Update item
Write-Host "4. Updating item: $itemId..." -ForegroundColor Yellow
$updateBody = @{
    status = "completed"
    priority = "low"
} | ConvertTo-Json

try {
    $updateResponse = Invoke-RestMethod -Uri "$ApiUrl/items/$itemId" -Method Put -Body $updateBody -ContentType "application/json"
    Write-Host "✓ Item updated successfully!" -ForegroundColor Green
    Write-Host "  Response: $($updateResponse | ConvertTo-Json -Depth 3)" -ForegroundColor Gray
    Write-Host ""
} catch {
    Write-Host "✗ Failed to update item: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 5: Delete item
Write-Host "5. Deleting item: $itemId..." -ForegroundColor Yellow
try {
    $deleteResponse = Invoke-RestMethod -Uri "$ApiUrl/items/$itemId" -Method Delete
    Write-Host "✓ Item deleted successfully!" -ForegroundColor Green
    Write-Host "  Response: $($deleteResponse | ConvertTo-Json -Depth 3)" -ForegroundColor Gray
    Write-Host ""
} catch {
    Write-Host "✗ Failed to delete item: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 6: Verify deletion
Write-Host "6. Verifying deletion..." -ForegroundColor Yellow
try {
    $verifyResponse = Invoke-RestMethod -Uri "$ApiUrl/items/$itemId" -Method Get
    Write-Host "✗ Item still exists (unexpected)" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode -eq 404) {
        Write-Host "✓ Item successfully deleted (404 as expected)" -ForegroundColor Green
    } else {
        Write-Host "✗ Unexpected error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "All tests completed!" -ForegroundColor Green

