#!/bin/bash

curl -vv -X POST "http://localhost:8080/CMSLite/api/ran/v1_0/setORANService" -H "asdfghjk: 0c9ddf46e39193a10f47101365493907" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"turnOn\": false}"
