# Quick Deployment Guide

## Step 1: Deploy Backend First

Before deploying the frontend, make sure you have deployed the backend and have these values:

- API Gateway URL (from CloudFormation stack outputs)
- User Pool ID (from CloudFormation stack outputs)
- User Pool Client ID (from CloudFormation stack outputs)
- AWS Region (where you deployed)

## Step 2: Create .env File

Create a `.env` file in the `trello-app-frontend` folder with your backend values:

```bash
REACT_APP_USER_POOL_ID=your-user-pool-id
REACT_APP_USER_POOL_CLIENT_ID=your-client-id
REACT_APP_API_URL=https://your-api-gateway-url.execute-api.region.amazonaws.com/prod
REACT_APP_AWS_REGION=your-aws-region
```

**Windows PowerShell:**
```powershell
@"
REACT_APP_USER_POOL_ID=your-user-pool-id
REACT_APP_USER_POOL_CLIENT_ID=your-client-id
REACT_APP_API_URL=https://your-api-gateway-url.execute-api.region.amazonaws.com/prod
REACT_APP_AWS_REGION=your-aws-region
"@ | Out-File -FilePath .env -Encoding utf8
```

**Linux/Mac:**
```bash
cat > .env << EOF
REACT_APP_USER_POOL_ID=your-user-pool-id
REACT_APP_USER_POOL_CLIENT_ID=your-client-id
REACT_APP_API_URL=https://your-api-gateway-url.execute-api.region.amazonaws.com/prod
REACT_APP_AWS_REGION=your-aws-region
EOF
```

## Step 2: Test Locally

```bash
npm install
npm start
```

Visit `http://localhost:3000` and test:
- Sign up/Sign in
- Create a task
- Verify it works

## Step 3: Deploy to AWS

### Option A: AWS Amplify (Recommended - 5 minutes)

1. **Push to GitHub:**
   ```bash
   git add .
   git commit -m "Ready for deployment"
   git push
   ```

2. **Go to AWS Amplify Console:**
   - https://console.aws.amazon.com/amplify
   - Click "New app" → "Host web app"
   - Connect your GitHub repo

3. **Add Environment Variables:**
   ```
   REACT_APP_USER_POOL_ID = your-user-pool-id
   REACT_APP_USER_POOL_CLIENT_ID = your-client-id
   REACT_APP_API_URL = https://your-api-gateway-url.execute-api.region.amazonaws.com/prod
   REACT_APP_AWS_REGION = your-aws-region
   ```

4. **Deploy!** Your app will be live in ~5-10 minutes.

### Option B: S3 + CloudFront (Manual)

```bash
# 1. Build
npm run build

# 2. Create S3 bucket (replace 'your-unique-name')
aws s3 mb s3://trello-app-frontend-your-unique-name --region us-east-1

# 3. Enable static hosting
aws s3 website s3://trello-app-frontend-your-unique-name \
  --index-document index.html \
  --error-document index.html

# 4. Upload files
aws s3 sync build/ s3://trello-app-frontend-your-unique-name --delete

# 5. Make public (create bucket-policy.json first)
aws s3api put-bucket-policy \
  --bucket trello-app-frontend-your-unique-name \
  --policy file://bucket-policy.json
```

Then create CloudFront distribution via AWS Console.

## Step 4: Verify Connection

1. Open your deployed app
2. Sign up/Sign in (uses Cognito)
3. Create a task (saves to DynamoDB via API Gateway)
4. Check browser console (F12) for errors

## Troubleshooting

**CORS Errors?**
- Backend should already have CORS configured
- Verify API Gateway URL is correct (ends with `/prod`)

**Authentication Issues?**
- Verify User Pool ID and Client ID in `.env`
- Check browser console for errors

**Tasks Not Loading?**
- Check API Gateway URL
- Verify backend Lambda functions are working
- Check CloudWatch logs

---

**Need help?** See `DEPLOYMENT_STEPS.md` for detailed instructions.

