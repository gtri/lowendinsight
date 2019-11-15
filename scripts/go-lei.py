# import subprocess
# subprocess.run(["goda", "list", "./...:noroot"])
import json
import requests

from subprocess import Popen, PIPE, STDOUT

command = 'goda list ./...:noroot'
p = Popen(command, shell=True, stdin=PIPE, stdout=PIPE, stderr=STDOUT)
output = p.stdout.read().decode('UTF-8').splitlines()

output = [ x for x in output if "golang" not in x]
output = [ x for x in output if "gopkg" not in x]
output = ["https://" + x for x in output]

#for line in output:
#    print(line)

input = { "urls": output }

j = json.dumps(input)

print(j)

API_ENDPOINT = "http://localhost:4000/v1/analyze"
headers = {'Content-type': 'application/json'}
r = requests.post(url = API_ENDPOINT, json=j, headers=headers)

print(r.text)

