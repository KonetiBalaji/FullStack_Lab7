# Lab 7 Cleanup Summary

## ✅ Cleanup Completed

### 1. **Deleted Build Artifacts**
- ✅ Deleted `.aws-sam` directory (SAM build artifacts)
- ✅ Deleted `trello-app-frontend/build` directory (old frontend build)

### 2. **Updated Configuration for Lab 7**
- ✅ Updated `samconfig.toml`:
  - Stack name changed to: `lab7-serverless-backend`
  - S3 prefix changed to: `lab7-serverless-backend`
- ✅ Updated `template.yaml` description to: "Lab 7 - Serverless Application with DynamoDB, Lambda, API Gateway, X-Ray Tracing, and CloudWatch"

## 📝 Important Notes About Ports

**Ports 3000 and 3001 are ONLY for local development** - they do NOT affect AWS deployment:

- **Local Development:**
  - Frontend: `http://localhost:3000` (React dev server)
  - Backend: `http://localhost:3000` (SAM local API Gateway)

- **AWS Deployment (No Ports Needed):**
  - **API Gateway:** Uses HTTPS on standard port 443 (e.g., `https://xxxxx.execute-api.us-east-1.amazonaws.com/prod`)
  - **Lambda Functions:** Serverless - no ports needed
  - **Frontend (Amplify/S3+CloudFront):** Uses HTTPS on standard port 443

**You don't need to configure any ports for AWS deployment!** The ports are only relevant when running locally for testing.

## 🚀 Ready for Fresh Lab 7 Deployment

Your project is now clean and ready for a fresh deployment as Lab 7:

1. **Backend Stack Name:** `lab7-serverless-backend`
2. **All build artifacts removed**
3. **Configuration updated for Lab 7**

## Next Steps

1. **Deploy Backend:**
   ```bash
   cd trello-app-backend
   sam build
   sam deploy
   ```

2. **After deployment, you'll get:**
   - API Gateway URL (HTTPS, no port needed)
   - DynamoDB table
   - All Lambda functions with X-Ray tracing enabled
   - CloudWatch logs configured

3. **Deploy Frontend (optional for Lab 7):**
   - Lab 7 focuses on backend (API Gateway, Lambda, DynamoDB)
   - Frontend deployment is optional but can be done via AWS Amplify

## AWS Resources Created

When you deploy, the following will be created with Lab 7 naming:

- **CloudFormation Stack:** `lab7-serverless-backend`
- **API Gateway:** TrelloAppApi (with X-Ray tracing)
- **DynamoDB Tables:** TasksTable, CommentsTable, ActivityLogTable
- **Lambda Functions:** All with X-Ray tracing enabled
- **CloudWatch Log Groups:** For all Lambda functions
- **Cognito User Pool:** For authentication (if needed)

---

**Note:** If you have any existing AWS resources from previous deployments, you may want to delete them manually from the AWS Console to avoid conflicts or costs.

