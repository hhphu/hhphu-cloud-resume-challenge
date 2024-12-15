# Configure domain name for the website

![image](https://github.com/hhphu/Cloud/assets/45286750/37211040-0efe-4002-89d2-7772cf338ff4)

In this post, I will go over how I registered a domain name for my website and have the S3 bucket point to my domain name.

## Register a domain
Go to **AWS Route 53**. On the dashboard, in the **Register domain** section, I input domain name for my website `hhphu.click` -> Click **Check** button

![image](https://github.com/hhphu/Cloud/assets/45286750/5170dd8b-4ca8-4f92-9bf4-c38f47cde464)

As shown in the image, the domain is available. I go ahead and select the domain and **Proceed to checkout**.
**Note:** If you plan to use this domain name from now on, you can keep the box **Auto-renew** checked. Otherwise, uncheck it.
Finish the checkout process.

While waiting for the process to complete (which takes a few minutes), we can proceed to [create S3 buckets](./deploy-s3.md) for the website.

<a id="dns-configuration"><h2> DNS Configuration using AWS Route 53 </h2></a>
Go to **Route 53 > Hosted zones** and select `hhphu.click`. Click **Create record**

![image](https://github.com/hhphu/Cloud/assets/45286750/f37eb0c7-3bd6-4c69-a40c-67d59b88fdae)

If landed on this page, click **Switch to wizard** link.

![image](https://github.com/hhphu/Cloud/assets/45286750/48da7733-788b-4f92-8790-764ed76adcd8)

Select **Simple routing** > Next
**Define Simple record** with the following selections:
- Record name: hhphu.click
- Record type: A - Routes traffic to an IPv4 address and some AWS resources.
- Value/Route traffic to: Alias to S3 website endpoint
- Choose region: $REGION_OF_YOUR_BUCKET
- hhphu.click S3 bucket should be available for selection.
- Turn off **Evaluate target health**

![image](https://github.com/hhphu/Cloud/assets/45286750/4dee9ce1-4fff-4fa2-b5f3-b51745b0bb9c)


Repeat the same thing for `www.hhphu.click`:

![image](https://github.com/hhphu/Cloud/assets/45286750/94fc3fd4-0bfd-480d-826f-765284f97dd0)

Once the two records are defined, I can go ahead and **Create records**

Wait for a few minutes for the records to propagate.

Now entering `hhphu.click` should take us to the website. Entering `www.hhphu.click` should be redirected to `hhphu.click`.
