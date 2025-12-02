#!/bin/bash
# Bash script to test the API endpoints
# Usage: ./test-api.sh https://your-api-id.execute-api.us-east-1.amazonaws.com/Prod

if [ -z "$1" ]; then
    echo "Usage: $0 <API_URL>"
    echo "Example: $0 https://abc123.execute-api.us-east-1.amazonaws.com/Prod"
    exit 1
fi

API_URL="$1"

echo "Testing Serverless CRUD API"
echo "API URL: $API_URL"
echo ""

# Test 1: Create an item
echo "1. Creating a new item..."
CREATE_RESPONSE=$(curl -s -X POST "$API_URL/items" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Complete Lab 7",
    "description": "Finish the serverless application lab",
    "status": "in-progress",
    "priority": "high",
    "category": "assignment"
  }')

ITEM_ID=$(echo $CREATE_RESPONSE | grep -o '"id":"[^"]*' | cut -d'"' -f4)

if [ -n "$ITEM_ID" ]; then
    echo "✓ Item created successfully!"
    echo "  Item ID: $ITEM_ID"
    echo "  Response: $CREATE_RESPONSE"
    echo ""
else
    echo "✗ Failed to create item"
    echo "  Response: $CREATE_RESPONSE"
    exit 1
fi

# Test 2: Get all items
echo "2. Getting all items..."
GET_ALL_RESPONSE=$(curl -s -X GET "$API_URL/items")
echo "✓ Retrieved all items!"
echo "  Response: $GET_ALL_RESPONSE"
echo ""

# Test 3: Get item by ID
echo "3. Getting item by ID: $ITEM_ID..."
GET_ITEM_RESPONSE=$(curl -s -X GET "$API_URL/items/$ITEM_ID")
echo "✓ Retrieved item!"
echo "  Response: $GET_ITEM_RESPONSE"
echo ""

# Test 4: Update item
echo "4. Updating item: $ITEM_ID..."
UPDATE_RESPONSE=$(curl -s -X PUT "$API_URL/items/$ITEM_ID" \
  -H "Content-Type: application/json" \
  -d '{
    "status": "completed",
    "priority": "low"
  }')
echo "✓ Item updated successfully!"
echo "  Response: $UPDATE_RESPONSE"
echo ""

# Test 5: Delete item
echo "5. Deleting item: $ITEM_ID..."
DELETE_RESPONSE=$(curl -s -X DELETE "$API_URL/items/$ITEM_ID")
echo "✓ Item deleted successfully!"
echo "  Response: $DELETE_RESPONSE"
echo ""

# Test 6: Verify deletion
echo "6. Verifying deletion..."
VERIFY_RESPONSE=$(curl -s -w "\nHTTP_CODE:%{http_code}" -X GET "$API_URL/items/$ITEM_ID")
HTTP_CODE=$(echo "$VERIFY_RESPONSE" | grep "HTTP_CODE" | cut -d: -f2)

if [ "$HTTP_CODE" == "404" ]; then
    echo "✓ Item successfully deleted (404 as expected)"
else
    echo "✗ Unexpected response code: $HTTP_CODE"
fi

echo ""
echo "All tests completed!"

