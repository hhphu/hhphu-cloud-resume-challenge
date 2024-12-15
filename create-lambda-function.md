# Create Lambda function

![image](https://github.com/hhphu/Cloud/assets/45286750/cc2d8332-fa61-4cd9-8c64-2db831e3ae8b)

In this post, I will go over creating a lambda function to retrieve the view count and update it.


# CREATE LAMBDA FUNCTION
Go to the **AWS Lambda** service and create a new lambda function with the following options:
- Function name: hhphu-click-get-count
- Runtime: Python 3.12
- IN **Advanced settings** sectopm. check the box **Enable function URL**. This provides and endpoint for users to access the function
- Auth type: NONE. This means that anyone from the public can access and execute the function without having to provide authentication.
- Check the box: COnfigure cross-origin resource sharing (CORS): white list the sources from which the Lambda function can be fetched.

![image](https://github.com/hhphu/Cloud/assets/45286750/6d4db573-d743-495e-939d-3faa0b01f53a)

From the screenshot above, click the function URL and we should see the message from the default function.

![image](https://github.com/hhphu/Cloud/assets/45286750/8b37da92-f9d9-4638-9ab7-c83d19b89719)

# Edit Lambda code
Now we have to update the Lambda function to retrieve the count and update it

```python
import json
import boto3

dynamodb = boto3.resource('dynamodb')                # Request AWS DynamoDB
table = dynamodb.Table('hhphu.click-count')          # Retrieve the table name hhphu.click-count

def lambda_handler(event, context):
    response = table.get_item(Key={'id': 1})          # Retrive the item whose id=1
    views = response["Item"]["views"]                 # Extract the "views" attribute from the response
    views +=1
    
    response = table.put_item(Item={                  # Update the value of "views" in the table
        'id': 1,
        'views': views 
    })
    # TODO implement
    return (views)

```

Remember to save the change and deploy the function.

# Testing the function
Once the Lambda function is deployed, click its URL to test:

![image](https://github.com/hhphu/Cloud/assets/45286750/1fc3b37c-8c27-49db-83e8-214bfdb899ce)

We got Internal error. Try running "Test" in the Lambda dashboard, we got the follow error:

![image](https://github.com/hhphu/Cloud/assets/45286750/33e86415-a0b8-4307-a5b2-7a3937e0897f)

This is because the Lambda function does not have access to the DynamoDB. We need to create a policy that grants the Lambda function access to the DynamoDB's table. To do that:
- Click the **Configuration** tab
- Under the **Execurtion role** section, we see a role assigned to the Lambda function

   ![image](https://github.com/hhphu/Cloud/assets/45286750/23d54981-853e-46ce-857a-26be65ede3e2)

- Click the role name.
- On a new window, click **Add permissions** button > **Attach policies**
- Search "DynamoDB" and select **AmazonDynamoDBFullAccess** option > **Add Permission**

  ![image](https://github.com/hhphu/Cloud/assets/45286750/f656a82c-eb2b-405d-91f4-cc58d07fe1da)

Now that the Lambda function has full access to the DynamoDB, we shouldnt get Internal Server Error again.

![image](https://github.com/hhphu/Cloud/assets/45286750/1a7ea58b-2a12-40d4-b7a8-82cb20c2798a)

# Update JavaScript code on website to fetch the Lambda function
Here's the code to fetch the Lambda function

```javascript
async function updateCounter() {
    let response = await fetch(LAMBDA_URL);
    let data = await response.json();
}
```
Depending on how you build your website, you can choose how to display the data variable.
