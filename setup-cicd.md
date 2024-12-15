# Setting CI/CD for Front End using Github Actions

![image](https://github.com/hhphu/Cloud/assets/45286750/5a743c6b-f168-49d9-844c-a99b7cde58f1)

# INTRODUCTION
This blog post go through Continuous Integration & Continuous Deployment (CI/CD) for our website. Everytime I make changes to my website, I automate GitHub to deploy the changes to S3 bucket.
In other words, we don't have to log in AWS console and reupload files everytime we make changes.

# Create Git repository for our website
- On Github, create a new repository for the website.
- Inside the repository, create a folder `.github/workflows`
- Go into the `workflows` folder and create a yaml file for GitHub Action. The structure should look like this.

![image](https://github.com/hhphu/Cloud/assets/45286750/9dbb4422-bf51-4dcf-8c4c-2d0cecb63c1c)

```yml
name: Deploy portfolio changes to S3 bucket

on: 
  push: 
    branches:
      - main

jobs: 
  build: 
    runs-on: ubuntu-latest

    defaults: 
      run:
        working-directory: mini-portfolio

    steps:
    - uses: actions/checkout@v4
    - uses: actions/setup-node@v4

    - name: Install dependencies
      run: npm install

    - name: Build Website
      run: npm run build

    - name: Set AWS credentials
      uses: aws-actions/configure-aws-credentials@v4
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: 'us-west-2'
        
    - name: Copy to S3
      run: aws s3 sync ./build/. s3://hhphu.click
```

To setup GitHub secret keys and variables:
1. Go to Settings
2. In the Security section, select **Secrets and variables** > **Actions**
3. Add repository secret
