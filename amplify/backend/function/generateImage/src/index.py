import json
import boto3
import base64

def handler(event, context):
    print("Received event: " + json.dumps(event))
    
    # 1. アプリから送られてきたプロンプト（命令文）を取り出す
    # bodyが文字列で来ることがあるので、辞書に変換する
    body = event.get('body')
    if isinstance(body, str):
        body = json.loads(body)
        
    prompt = body.get('prompt', 'A scenic view of Hakodate night view')
    
    # 2. Bedrock（AI）を使う準備
    bedrock = boto3.client(service_name='bedrock-runtime', region_name='us-east-1')
    
    # 3. AIへの注文票を作る
    payload = {
        "taskType": "TEXT_IMAGE",
        "textToImageParams": {
            "text": prompt,
            "negativeText": "low quality, bad anatomy, distorted"
        },
        "imageGenerationConfig": {
            "numberOfImages": 1,
            "height": 512,
            "width": 512,
            "cfgScale": 8.0
        }
    }
    
    # 4. AIに注文する
    try:
        response = bedrock.invoke_model(
           modelId='amazon.titan-image-generator-v2:0',
            contentType='application/json',
            accept='application/json',
            body=json.dumps(payload)
        )
        
        # 5. 完成した画像データを取り出す
        response_body = json.loads(response['body'].read())
        base64_image = response_body['images'][0]
        
        # 6. アプリに画像を返す
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': '*',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
            },
            'body': json.dumps({'image_data': base64_image})
        }
        
    except Exception as e:
        print(e)
        return {
            'statusCode': 500,
            'headers': {
                'Access-Control-Allow-Headers': '*',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
            },
            'body': json.dumps({'error': str(e)})
        }