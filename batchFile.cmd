CD
CD C:\Users\Admin\Desktop\Upload code program\cli
arduino-cli board list
arduino-cli core update-index --additional-urls http://arduino.esp8266.com/stable/package_esp8266com_index.json
arduino-cli core search esp8266 --additional-urls http://arduino.esp8266.com/stable/package_esp8266com_index.json
arduino-cli compile --fqbn esp8266:esp8266:d1 sourceCode
arduino-cli upload -p COM7 --fqbn esp8266:esp8266:d1 sourceCode
pause
