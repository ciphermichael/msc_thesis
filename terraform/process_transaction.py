import json

def lambda_handler(event, context):
    try:
        # Assuming the event contains transaction details
        transaction_id = event['transaction_id']
        amount = event['amount']
        payment_method = event['payment_method']
        
        # Process the transaction logic here
        # e.g., validate payment, update database, etc.

        # Simulate processing
        print(f"Processing transaction {transaction_id} of amount {amount} using {payment_method}.")

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Transaction processed successfully',
                'transaction_id': transaction_id
            })
        }
    except Exception as e:
        print(f"Error processing transaction: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Transaction processing failed',
                'error': str(e)
            })
        }
