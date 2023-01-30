import json
import random
import boto3
import sys
from datetime import datetime
from dateutil import tz
 
client = boto3.client('firehose')

def put_records(stream, count):

    JST = tz.gettz('Asia/Tokyo')
    UTC = tz.gettz("UTC")
    now = datetime.now(tz=UTC)
    jst_now = now.astimezone(JST)
    print(now)
    print(jst_now)
    
    for num in range(count):
        event = {}
        keylist = ['A1', 'A2', 'B1', 'B2', 'B3', 'C1']
        datalist = ['JP', 'UK', 'EU']
        event['key_name'] = random.choice(keylist)
        event['value'] = round(random.uniform(1.0, 200.0), 2)
        event['status'] = random.choice(['deleted', 'processing', 'done'])
        event['number'] = {}
        event['number']['type'] = 'IntegerType'
        event['number']['value'] = num
        event['list'] = datalist
        event['jst_datetime'] = jst_now.strftime('%Y-%m-%dT%H:%M:%S')
        event['jst_timestamp'] = int(jst_now.timestamp()) # epoch timestamp
        event_record = json.dumps(event)
    
        print(event_record)
        client.put_record(DeliveryStreamName=stream, Record={'Data': event_record})
 

if __name__ == '__main__':
    args = sys.argv[1:]  # 先頭はファイル名のため除外

    count = 10
    stream = args[0]

    if len(args) == 2:
        count = int(args[1])

    put_records(stream, count)
