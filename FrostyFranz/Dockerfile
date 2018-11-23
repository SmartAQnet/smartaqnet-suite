FROM python:2

ADD FrostyFranz.py /
ADD Helper.py /
RUN pip install numpy
RUN pip install paho-mqtt
RUN pip install requests
RUN pip install kafka-python
CMD [ "python", "-u", "./FrostyFranz.py"]

