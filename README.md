![archi](/tiktak.jpg)


**you must add file named:** _ _terraform.tfvars_ _ **that contain your aws credential**

> terraform apply -var-file="terraform.tfvars"

**When your stack is created, you can try it by the bellow command:**

> curl -X GET -H "x-api-key: **YOUR-GENERATED-API-KEY**"  -H "Content-Type: application/json" -d '{"key":"val"}'  https://42esqh701k.execute-api.eu-west-3.amazonaws.com/test/upload
