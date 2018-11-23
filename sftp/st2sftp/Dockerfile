FROM python:2

ADD DataLogger.py /
ADD Helper.py /
RUN pip install paho-mqtt
RUN pip install requests

CMD ["python", "-u", "./DataLogger.py"]

