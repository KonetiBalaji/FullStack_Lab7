# Optional: Adding Authentication to API Gateway

**Note**: Authentication is NOT required for Lab 7. This is provided as an optional enhancement.

## Current Status
Your API is currently **public** (no authentication required). This is fine for:
- Lab assignments
- Testing and development
- Learning purposes

## When to Add Authentication

Add authentication for:
- Production applications
- APIs handling sensitive data
- APIs that should be restricted

## Option 1: API Keys (Simple)

Add API key requirement to your template:

```yaml
Events:
  CreateItem:
    Type: Api
    Properties:
      Path: /items
      Method: post
      Auth:
        ApiKeyRequired: true
```

Then create and distribute API keys via AWS Console.

## Option 2: IAM Authentication

Requires AWS credentials for each request. More secure but more complex.

## Option 3: Cognito User Pools

Full user authentication system. Best for user-facing applications.

## For Lab 7

**You do NOT need to add authentication.** The lab requirements don't mention it, and public APIs are easier to test with curl/Postman.

## Security Note

Since this is a lab/learning environment:
- The API is public for easy testing
- You can delete the stack after submission
- For production, always add authentication

## If You Want to Add It Later

You can add authentication after deployment by:
1. Going to API Gateway Console
2. Selecting your API
3. Adding API Keys or Cognito authentication
4. Updating your test scripts to include auth headers

But again, **this is NOT required for Lab 7**.

