cloud watch alarm to sns topic in another region:
You can't directly send a CloudWatch alarm to an SNS topic in a different region. The error you're seeing, "The region of the ARN must be the same as the current one," is happening because CloudWatch alarms and the SNS topics they publish to must exist in the same AWS region. This is a limitation within the AWS ecosystem.

However, you can work around this limitation by setting up a solution where you forward the event from the SNS topic in one region to another SNS topic in a different region. Here’s how you could approach this:

Solution: Cross-region SNS Forwarding
Create an SNS topic in the source region (where the CloudWatch alarm is configured).

Create an SNS topic in the target region (where you want the events to be sent).

Create an AWS Lambda function in the source region that is triggered by the SNS topic.

Lambda Function:

The Lambda function will forward the received event from the source SNS topic to the SNS topic in the target region.

Use the AWS SDK in the Lambda function to publish the event to the SNS topic in the target region.

Here's an example Lambda function (in Python) that forwards events: