FROM python:2

ADD Helper.py /
ADD FileWatcher.py /
RUN pip install paho-mqtt
RUN pip install requests
RUN pip install watchdog
RUN pip install kafka-python
CMD ["python2",  "./FileWatcher.py"]

