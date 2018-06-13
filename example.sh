curl -X POST -d '{"name":"I was created over https"}' http://127.0.0.1:4567/foos
curl -X GET http://127.0.0.1:4567/foos
curl -X PUT -d '{"name":"I was updated over https"}' http://127.0.0.1:4567/foos/35c43b88VE7mHJVLbHhfdfTRZPwr0Z
curl -X GET http://127.0.0.1:4567/foos/35c43b88VE7mHJVLbHhfdfTRZPwr0Z
curl -X DELETE http://127.0.0.1:4567/foos/35c43b88VE7mHJVLbHhfdfTRZPwr0Z
