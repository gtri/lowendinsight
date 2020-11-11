import json
import requests

from subprocess import Popen, PIPE, STDOUT

command = 'goda list ./...:noroot'
p = Popen(command, shell=True, stdin=PIPE, stdout=PIPE, stderr=STDOUT)
output = p.stdout.read().decode('UTF-8').splitlines()

output = [ x for x in output if "golang" not in x]
output = [ x for x in output if "gopkg" not in x]
output = ["https://" + x for x in output]

j = json.dumps({"urls": output})

#print(j)

API_ENDPOINT = "http://localhost:4000/v1/analyze"
headers = {'Content-type': 'application/json'}
r = requests.post(url = API_ENDPOINT, data=j, headers=headers)

print(r.text.encode('utf-8').strip())

