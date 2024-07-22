import json
import csv
import boto3
from io import StringIO

def lambda_handler(event, context):
    try:
        # Fetch customer data (this is a placeholder for actual data fetching logic)
        customer_data = [
            {'id': 1, 'name': 'John Doe', 'email': 'john@example.com'},
            {'id': 2, 'name': 'Jane Doe', 'email': 'jane@example.com'}
        ]

        # Prepare CSV export
        output = StringIO()
        writer = csv.DictWriter(output, fieldnames=['id', 'name', 'email'])
        writer.writeheader()
        writer.writerows(customer_data)
        
        # Get CSV content
        csv_content = output.getvalue()

        # Optionally, you could save this to S3 or another storage
        # s3 = boto3.client('s3')
        # s3.put_object(Bucket='your-bucket-name', Key='customer_data.csv', Body=csv_content)

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Customer data exported successfully',
                'data': csv_content
            })
        }
    except Exception as e:
        print(f"Error exporting customer data: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Customer data export failed',
                'error': str(e)
            })
        }
