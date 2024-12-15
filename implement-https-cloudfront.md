# Implement secure connections HTTPS

![image](https://github.com/hhphu/Cloud/assets/45286750/3cb0551d-3828-4b40-8854-250a191ac3e5)

# Introduction
In this post, I will go over how to distribute the website using CloudFront. AWS CloudFront not only helps us implement HTTPS protocol for our website but also speeds up the content delivery.
To learn more about CloudFront, you can read this [article](https://aws.amazon.com/blogs/networking-and-content-delivery/amazon-s3-amazon-cloudfront-a-match-made-in-the-cloud/).

# Certificates issuance
First of all, I need to issue certificates for `hhphu.click` and `www.hhphu.click`, which can be done using **AWS Certificate Manager**. Also, make sure to select region `us-east-1` so that CloudFront can see the certificates.
1. Go to **Certificate Manager** > **Request**
2. Select **Request a public certificate** > **Next**
3. Enter `hhphu.click` in the **Fully qualified domain name** field.
4. Click **Add another name to this certificate**
5. Enter `www.hhphu.click` in the **Fully qualified domain name** field.
6. Leave the rest options as default > click **Request**

![image](https://github.com/hhphu/Cloud/assets/45286750/53a97a59-f5a1-4ce1-960d-0f9d0ad9b380)

An entry should be created when going to **AWS Certificate Manager > Certificates**

![image](https://github.com/hhphu/Cloud/assets/45286750/49e2305e-9d20-469c-92d0-24ecd4dad38d)

In order for AWS to issue certificate, I need to validate my ownership of the domains. Select the entry, then click **Create records in Route 53**

![image](https://github.com/hhphu/Cloud/assets/45286750/a766f30c-c6ea-4fcf-9055-8bb3c8c0b605)

Proceed to **Create records**

![image](https://github.com/hhphu/Cloud/assets/45286750/56911b27-505f-4997-bfca-5ff8602aee96)

This will take a bit for the certificates to be issued. Once the certificates are issued, proceed to **CloudFront**.


# Distributing content using CloudFront
Go to AWS CloudFront and create a new distribution with the following selections:
- Original domain: S3 bucket for `hhphu.click` (it should be available from the dropdown)

![image](https://github.com/hhphu/Cloud/assets/45286750/e788d820-551b-434b-b637-805944834ce0)

- Origin access: Origin access control settings (recommended) > **Create new OAC**
    - Origin domain: S3 bucket for `hhphu.click`
    - Description: OAC for hhphu.click
    -  **Create**
 
![image](https://github.com/hhphu/Cloud/assets/45286750/b61607be-48f2-4a09-ac41-bcf63aed3412)
  
- Copy the policy so we can use it later for the `hhphu.click` S3 bucket. `(*)`
  
- Scroll down to the Default cache behavior, in the **Viewer protocol policy**, check **Redirect HTTP to HTTPS**

![image](https://github.com/hhphu/Cloud/assets/45286750/4d014937-dc75-49a2-bd93-d8546d0be367)

- Select **Do not enable security protections** for the WAF and Use only **North America and Europe** option for the Price class in Settings.

![image](https://github.com/hhphu/Cloud/assets/45286750/bef41d06-5a73-4c1f-99ea-3504b8260b9a)

- In the **Settings** section, select the certificate for the site
- Alternate domain name: hhphu.click

  ![image](https://github.com/hhphu/Cloud/assets/45286750/9f94e8ec-bb5f-487b-99e7-8d4382025722)

### Edit hhphu.click S3 bucket
- Go to the `hhphu.click` S3 bucket and edit its permissions:
    - Set the bucket to private. With the above policy, CloudFront was able to gain access to `hhphu.click` S3 bucket. Hence, we don't need to expose the bucket to the public anymore.
    - Replace the existing policy with the one we just created from the step `(*)` above

  ![image](https://github.com/hhphu/Cloud/assets/45286750/4d8646b6-f921-4cf9-9f60-9b5cf6abe2cc)

Repeat the above steps for `www.hhphu.click`:
- Create a distribution for `www.hhphu.click`
- Create OAC for `www.hhphu.click`
- Modify `www.hhphu.click` S3 bucket's permissions

Once the distributions are created, we can test them by visiting the **Distribution domain name**

![image](https://github.com/hhphu/Cloud/assets/45286750/29f49e90-e29d-4fd5-8e44-0f3963560f8e)

# Configure DNS with Route 53
Now that we have CloudFront Distributions for our website. However, the url currently looks like `https://d2g606l27192i3.cloudfront.net`, which is not what I desired it to be. I want the URL to be `https://hhphu.click`

- Go to **Route 53** > **hhphu.click** hosted zone
- Select `hhphu.click` and edit its A record

![image](https://github.com/hhphu/Cloud/assets/45286750/6bc84098-4b51-4fdf-9edc-85a5fd6a66bd)

- In the **Route traffic to** section, change the selection to **Alias to CloudFront distribution**
- Choose the distribution associated with `hhphu.click` and **Save**

![image](https://github.com/hhphu/Cloud/assets/45286750/85337324-b9d5-425a-b809-a2728a2c77c4)

- Do the same for `www.hhphu.click`

![image](https://github.com/hhphu/Cloud/assets/45286750/e8365b1e-8e68-468b-9f58-7b5c6eb7de49)

Now that every is set. Wait for a few minutes for the change to take affect. And we should be able to view the website when visiting `hhphu.click`
