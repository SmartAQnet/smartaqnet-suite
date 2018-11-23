import time  
from watchdog.observers import Observer  
from watchdog.events import PatternMatchingEventHandler 
import sys
import json
import hashlib
import os
import requests
from kafka import KafkaProducer, SimpleProducer, KafkaClient
import Helper
#basepath = "./Data/"
basepath = '/root/sftp/volumes/saqn/'

url = 'http://smartaqnet-dev.teco.edu:8080/FROST-Server/v1.0'

kafkaHome = Helper.Helper.Kafkas["dev"].split("/")[-1]


class MyHandler(PatternMatchingEventHandler):
    ignore_patterns = ["*.desc, *.swp"]
    def process(self, event):
        """
        event.event_type
            'modified' | 'created' | 'moved' | 'deleted'
        event.is_directory
            True | False
        event.src_path
            path/to/observed/file
        """
#        print event.src_path, event.event_type  

    def on_modified(self, event):
        if event.is_directory is False:

            print(event.src_path)

            src_path = event.src_path.split("/")
            filenameWithType = src_path[-1].split(".")
            filetype = filenameWithType[-1]
            filename = filenameWithType[0]
            iot_id = src_path[-2]
            print(iot_id)
            #ds_id_from_path = path.split("Datastreams/ | MultiDatastreams/",1)[1]
            ds_id = {}
            ds_id['@iot.id'] = iot_id



           # filehash = hashlib.sha1(event.src_path).hexdigest()
            descFile = event.src_path + '.observation.json'
            BLOCKSIZE = 65536
            hasher = hashlib.sha1()
            try:
                with open(event.src_path, 'rb') as afile:
                    buf = afile.read(BLOCKSIZE)
                    while len(buf) > 0:
                        hasher.update(buf)
                        buf = afile.read(BLOCKSIZE)
                print("hash computed")
                filehash = hasher.hexdigest()
            except:
                print("hash could not be computed")
            try:
                with open(descFile) as f:
                    data = json.load(f)
                    
                    data['Datastream'] = ds_id
                    print('ds_id', data['Datastream'])
                    sha1_hash = data['result']
                    #print(sha1_hash)
                    urn = "urn:sha1:" + filehash
                    #print(urn, sha1_hash)
                    if urn == sha1_hash:
                        print("linking...", data)
                        if os.path.isfile(os.path.abspath(basepath + urn)) is False:
                            print("create urn")
                            os.link(os.path.abspath(event.src_path), os.path.abspath(basepath + urn))
                        else:
                            print("urn exist")

                        request_post = requests.post(url + "/Observations",  json.dumps(data))
                  #      if (reuqest_post.status_code  == 201):
                  #          print("Creation successful")
                  #      else:
                  #          print("Error")
                  #          for chunk in request_post.iter_content(chunk_size=128):
                  #              print(chunk)
                        producer.send("fileparser", key = urn, value=data)
                        producer.flush()
            except IOError as ioerr:
                 print("IO error: {0}".format(ioerr))
            except OSError as oserr:
                print("OS error: {0}".format(oserr))
            except:
                print("Unexpected error:", sys.exc_info()[0])

         #       print( os.path.abspath(event.src_path),  os.path.abspath(basepath))
            #print path, event.event_type, hash
    
    def on_created(self, event):
        self.process(event)

if __name__ == '__main__':
    producer = KafkaProducer(bootstrap_servers= kafkaHome + ':9092', value_serializer=lambda v:json.dumps(v).encode('utf-8'))

    observer = Observer()
    observer.schedule(MyHandler(), path=basepath, recursive=True)
    observer.start()
    print("Watch OUT!")
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()

    observer.join()
