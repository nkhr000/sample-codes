import json
from datetime import datetime
import time
import random
import boto3
import sys
 
client = boto3.client('firehose')

def put_records(stream, count):

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
        now = time.time()
        event[u'event_time'] = datetime.utcfromtimestamp(now).strftime('%Y-%m-%dT%H:%M:%S.%fZ')
        event_record = json.dumps(event)
    
        client.put_record(DeliveryStreamName=stream, Record={'Data': event_record})
 

if __name__ == '__main__':
    args = sys.argv[1:]  # 先頭はファイル名のため除外

    count = 10
    stream = args[0]

    if len(args) == 2:
        count = int(args[1])

    put_records(stream, count)
