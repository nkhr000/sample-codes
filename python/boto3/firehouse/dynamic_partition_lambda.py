from __future__ import print_function
import base64
import json
from datetime import datetime
from dateutil import tz
 
def lambda_handler(firehose_records_input, context):
    # Create return value.
    firehose_records_output = {'records': []}

    # current timestamp
    JST = tz.gettz('Asia/Tokyo')
    UTC = tz.gettz("UTC")
    now = datetime.now(tz=UTC)
    jst_now = now.astimezone(JST)

    print(jst_now)  
 
    # Create result object.
    for record in firehose_records_input['records']:
        # Get user payload
        payload = base64.b64decode(record['data'])
        json_value = json.loads(payload)
 
        print("Record that was received")
        print(json_value)
        print("\n")
        firehose_record_output = {}
        partition_keys = {"status": json_value['status'],
                          "year": jst_now.strftime('%Y'),
                          "month": jst_now.strftime('%m'),
                          "date": jst_now.strftime('%d'),
                          "hour": jst_now.strftime('%H')
                          }
 
        # Create output Firehose record and add modified payload and record ID to it.
        firehose_record_output = {'recordId': record['recordId'],
                                  'data': record['data'],
                                  'result': 'Ok',
                                  'metadata': { 'partitionKeys': partition_keys }}
 
        # Must set proper record ID
        # Add the record to the list of output records.
 
        firehose_records_output['records'].append(firehose_record_output)
 
    # At the end return processed records
    return firehose_records_output