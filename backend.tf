terraform {
    backend "s3" {
        bucket = "Add your bucket name"
        key    = "Name of the folder which you created/statefile.tf
        region = "<Bucket-Region>"
        dynamodb_table = "Your DynamoDB table name"
    }   
}
