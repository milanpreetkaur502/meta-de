#!/usr/bin/env python3

import requests
import paho.mqtt.client as mqtt
import os
import json
import ast
import time
import multiprocessing

with open(f"/etc/entomologist/ento.conf",'r') as file:
	data=json.load(file)
BUFFER_IMAGES_PATH = data["device"]["STORAGE_PATH"]

uploaded = 0
batchSize = 0 

TOPIC = None
QoS = None

def on_message(client, userdata, message):
	
	global uploaded
	global batchSize
	
	recievedPayload = message.payload.decode('utf-8')

	recievedPayload = ast.literal_eval(recievedPayload)
	filename = recievedPayload['file']

	os.remove(BUFFER_IMAGES_PATH+filename)

	uploaded += 1
	
	if uploaded == batchSize:
		uploaded = 0
		client.disconnect()
		



def on_connect(client, userdata, flags, rc):
	if rc == 0:
		print("Verification Client Connected")
		client.subscribe(TOPIC, QoS)
	else:
		print("Bad connection: Verification Client")
	

def start_verification(broker, port, interval, clientName, topic, qos, batch_size, rootCA, cert, privateKey):

	global batchSize
	global TOPIC
	global QoS
	
	TOPIC = topic
	QoS = qos
	batchSize = batch_size

	# AWS Subscription Client
	verifyClient = mqtt.Client(clientName)

	# Setting Cerificates
	verifyClient.tls_set(rootCA, cert, privateKey)

	# Callback function
	verifyClient.on_connect = on_connect
	verifyClient.on_message = on_message
	# Connecting and Subcribing to topic.
	verifyClient.connect(broker, port, interval)

	verifyClient.loop_forever()
