```json
{
  "commonArgs": {
    "--job-language": "python",
    "--enable-metrics": true,
    "--enable-continuous-cloudwatch-log": true,
    "--enable-spark-ui": true
  },
  "glueJobsProperty": [
    {
      "poc_Job_DI_Material_Master_Intermediate_Final_Load": {
        "customArgs": {
          "--TempDir": "s3://${BuildBucket}/tempdir",
          "--extra-py-files": "xxx",
          "--additional-python-modules": "xxx",
          "--sfdc_domain": "xxx",
          "--sfdc_endpoint": "xxx",
          "--db_name": "xxx",
          "--bucket": "xxx",
          "--iam": "aws_glue_master",
          "--sfdc_secrets": "xxx",
          "--rs_secret": "xxx",
          "--email_lambda_arn": "xxx",
          "--aws_account": "xxxx",
          "--email_receivers": "xxx"
        },
        "name": "joe",
        "email": "lokesh@mail.com"
      },
      "poc_Job_DI_Material_Master_Intermediate_Load": {},
      "jobTwo": {
        "name": "joe",
        "email": "lokesh@mail.com",
        "age": 10,
        "mobile": 9894586
      }
    }
  ]
}
```
