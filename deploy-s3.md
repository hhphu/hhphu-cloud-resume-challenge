# Deploying S3 bucket for the website.

![image](https://github.com/hhphu/Cloud/assets/45286750/bd45bfe6-fc74-4b70-a70a-d1382b813d59)

# Introduction
In this post, I will go over steps to create S3 buckets for the website. 
**IMPORTANT:** The bucket name must match your domain name. In this case, it has to be `hhphu.click`.

There will be 2 buckets: one is `hhphu.click` and the other one is `www.hhphu.click`. One will act as the main bucket to host the website while the other will redirects the traffic to the main one. In my case, I choose `hhphu.click` as my main bucket, meaning if a user enter `www.hhphu.click`, he/sher will be redirected to `hhphu.click`


# Deploying S3 bucket using AWS Console
## Create main S3 bucket hhphu.click
From AWS console, go to S3 and click "Create bucket" button
  
  ![image](https://github.com/hhphu/Cloud/assets/45286750/1ab4a824-929c-481d-a7a1-1f4875512b05)
  
In the **Block all public access** section, the box is checked. This ensures that the bucket is not exposed to the public. Leave the rest of the options unchanged. 

Once the bucket is created, select the bucket and go to its **Properties** tab. Scroll down to the **Static website hosting** at the bottom and click Edit enable it.

In the Edit window, input **index.html** and **error.html** into the **Index Document field** and the **Error Document field**, respectively.

  ![image](https://github.com/hhphu/Cloud/assets/45286750/20624d86-43ed-44ff-8864-4b6e6e774e6f)

Upload the content of the website onto the bucket. In my case, it's going to be the **build folder** of my React application.
Once finished, select the bucket, go to **Permissions** tab and scroll down to the bottom and visit the URL in the Bucket website endpoint.

  ![image](https://github.com/hhphu/Cloud/assets/45286750/ef5d0a4b-7749-408c-94b0-f2ac190cf913)

We should get a 403 error. This is expected because we expose the bucket to the public, we haven't provided any permision for the public to get access. To do that, got to the bucket's **Permissions** tab, Edit the **Bucket Policy**. Paste the following policy:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::hhphu.click/*"
        }
    ]
}
```

**NOTE:** Make sure to replace `hhphu.click` with your bucket name.

Try visiting the website again. We should be able to see the content.

## Create redirecting S3 bucket www.hhphu.click
From AWS console, go to S3 and click "Create bucket" button
  
  ![image](https://github.com/hhphu/Cloud/assets/45286750/1ab4a824-929c-481d-a7a1-1f4875512b05)

I don't have to expose this bucket to the public as its main purpose is only to redirect traffic to `hhphu.click`

Once the bucket is created, got to its **Properties** tab and edit the **Static website hosting** section with the following selections:
- Static website hosting: Enable
- Hosting type: Redirect request for an object
- Host name: hhphu.click
- Protocol: none (I will come back and make changes to the Protocol once I issue a SSL/TLS certificate)

  ![image](https://github.com/hhphu/Cloud/assets/45286750/086893bb-890c-4b0a-9b4f-844e38225098)

Now that I have created the two buckets for the website. I need to [configure DNS using AWS Route 53](configure-dns-route53.md#dns-configuration).
