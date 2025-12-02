# PowerShell script to delete old resources for fresh Lab 7 deployment
# WARNING: This will delete all data in the tables!

Write-Host "========================================" -ForegroundColor Red
Write-Host "WARNING: This will DELETE existing resources!" -ForegroundColor Red
Write-Host "All data in DynamoDB tables will be lost!" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red
Write-Host ""

$confirm = Read-Host "Are you sure you want to delete old resources? (yes/no)"
if ($confirm -ne "yes") {
    Write-Host "Cancelled." -ForegroundColor Yellow
    exit
}

Write-Host ""
Write-Host "Deleting resources..." -ForegroundColor Cyan
Write-Host ""

# Delete DynamoDB Tables
Write-Host "1. Deleting DynamoDB Tables..." -ForegroundColor Yellow
try {
    Write-Host "   Deleting TasksTable..." -ForegroundColor Gray
    aws dynamodb delete-table --table-name TasksTable 2>&1 | Out-Null
    Write-Host "   ✓ TasksTable deletion initiated" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Error deleting TasksTable: $_" -ForegroundColor Red
}

try {
    Write-Host "   Deleting CommentsTable..." -ForegroundColor Gray
    aws dynamodb delete-table --table-name CommentsTable 2>&1 | Out-Null
    Write-Host "   ✓ CommentsTable deletion initiated" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Error deleting CommentsTable: $_" -ForegroundColor Red
}

try {
    Write-Host "   Deleting ActivityLogTable..." -ForegroundColor Gray
    aws dynamodb delete-table --table-name ActivityLogTable 2>&1 | Out-Null
    Write-Host "   ✓ ActivityLogTable deletion initiated" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Error deleting ActivityLogTable: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "   Waiting for tables to be deleted (this may take a minute)..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Check if tables are deleted
$tablesDeleted = $true
$tables = @("TasksTable", "CommentsTable", "ActivityLogTable")
foreach ($table in $tables) {
    $result = aws dynamodb describe-table --table-name $table 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ⚠ $table still exists, waiting..." -ForegroundColor Yellow
        $tablesDeleted = $false
    }
}

if ($tablesDeleted) {
    Write-Host "   ✓ All tables deleted" -ForegroundColor Green
}

# Delete Cognito User Pool
Write-Host ""
Write-Host "2. Deleting Cognito User Pool..." -ForegroundColor Yellow
try {
    Write-Host "   Deleting TrelloAppUserPool (us-east-1_Tx8ircMe3)..." -ForegroundColor Gray
    aws cognito-idp delete-user-pool --user-pool-id us-east-1_Tx8ircMe3 2>&1 | Out-Null
    Write-Host "   ✓ User Pool deletion initiated" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Error deleting User Pool: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Resource deletion initiated!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Note: DynamoDB table deletion may take a few minutes to complete." -ForegroundColor Yellow
Write-Host "You can check status with:" -ForegroundColor Yellow
Write-Host "  aws dynamodb describe-table --table-name TasksTable" -ForegroundColor Gray
Write-Host ""
Write-Host "Once resources are deleted, you can deploy with:" -ForegroundColor Cyan
Write-Host "  sam build" -ForegroundColor White
Write-Host "  sam deploy" -ForegroundColor White
Write-Host ""

