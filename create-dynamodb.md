# Create DynamoDB

![image](https://github.com/hhphu/Cloud/assets/45286750/f88777a0-bb88-4adf-8c04-a3f42af41aa3)

# INTRODUCTION
- This post will go through all steps to create a DynamoDB to store the number of visits everytime a user lands on the website

# CREATE TABLE
To create a table:
- Go to **DynamoDB** > **Table** > **Create Table**
- Table name: hhphu.click-count
- Partrition key: id and set it to Number
- **Create table**
 
    ![image](https://github.com/hhphu/Cloud/assets/45286750/04f3f46b-2c1f-45b2-8533-9fbefb951c2f)

**Initialize the key id's value**
- Select the databse & click **Actions** > **Create item**.
    - Enter value 1 for the key **_id_**
    - Add an attribute **views** with value 1
    - **Create item**
 
Once completed, we can click **Explore table** to verify the data

![image](https://github.com/hhphu/Cloud/assets/45286750/36b64ec7-0f38-4565-bc45-2bd5e61cfc90)



