
Terraform readme
------

You can manage azure resources in multiple ways, if you know service account credentials pass those as variables:
```shell script
export ARM_CLIENT_ID=
export ARM_CLIENT_SECRET=
```
You can use your account (portal.azure.com) as well:

Install azure-cli, and then do
```shell script
az login
```

In order to use storage account (bucket) where .tf file is placed, use this ENV 
```shell script
export ARM_ACCESS_KEY
```

After that you should be fine to do 
```shell script
terraform plan
terraform apply
```