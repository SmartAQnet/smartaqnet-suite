import paho.mqtt.client as mqtt
import datetime
import os
import json
import requests
import sys
import Helper

basepath = '/root/sftp/volumes/saqn/'
#basepath = './'
smartaqnetHome = 'smartaqnet-dev.teco.edu'
def on_connect(client, userdata, flags, rc):
     print ('Starting to log data.')
    
    # client.subscribe("v1.0/Things")
     client.subscribe("v1.0/Datastreams")
     client.subscribe("v1.0/MultiDatastreams")

     if rc==0:
         print("Connected")
     else:
         print("Bad connection")

def on_message(client, userdata, msg):
    payload = msg.payload
    topic = msg.topic.replace(':', '/').split('/')[-1]
    print("Receiving new message with topic: " + topic)

    data_raw = json.loads(payload.decode("utf-8"))
    data = Helper.popKeys(data_raw)
    print(data)
    uid = data.get('@iot.id',{})
    path = basepath + uid
    if not uid: 
        print("WARNING: No @iot.id specified, not creating a new path for Entity.")
    else:
        print(path)
        if os.path.exists(path):
            print("WARNING: Another Entity with the same name may already exist or a race condition already triggered path creation before!")
        else:
            os.mkdir(path, 0777)
            fh = os.path.join(path, 'SensorThings.json') 
            print('Saving JSON into file...')
            print(data)
            with open(fh, 'w') as outfile:
                outfile.write(json.dumps(data))
            os.chmod(path, 0o777)
            os.chmod(fh, 0o777) 
 
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect(smartaqnetHome, 1883, 60)
client.loop_forever()

