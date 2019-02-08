#!/bin/python
#   This program reads the ouput files and outputs a webpage here:
#    http://[IPADDRESS]:8088/monitor-server.py

from operator import itemgetter, attrgetter
from BaseHTTPServer import BaseHTTPRequestHandler,HTTPServer
import os
from os import curdir, sep
import cgi

global alerts
alerts = []
path="/var/lib/jenkins/monitor"
os.chdir(path)
def walkDirs(parentdir):
    for item in os.listdir(parentdir):
        if os.path.isfile(parentdir + "/" + item):
            if parentdir.split("/")[-1] == "output":
              readOutput(parentdir + "/" + item)
        else:
            walkDirs(parentdir + "/" + item)

def readOutput(outputFile):
    global alerts
    of = open(outputFile, "r")
    statusCode=of.readline()
    serviceName=of.readline()
    lastChecked=of.readline()
    description=of.readline()
    environment=of.readline()
    HOST=outputFile.split("/")[1]
    scriptName=outputFile.split("/")[-1]
    of.close
    newalert = (statusCode,serviceName,lastChecked,description,environment,HOST,scriptName)
    alerts.append( newalert)
    # delete the outputfile?
    # os.remove(outputFile)

PORT_NUMBER = 8088
#This class will handles any incoming request from
#the browser 
class myHandler(BaseHTTPRequestHandler):
	#Handler for the GET requests
	def do_GET(self):
                # Get the output files
                global alerts
                walkDirs(".")
                sorted(alerts, key=lambda x: x[1])
                sendReply = True
		if self.path=="/":
			self.path="/monitor-server.py?status"
                if self.path=="/monitor-server.py?environment":
                        alerts=sorted(alerts, key=lambda x: x[4])
                if self.path=="/monitor-server.py?service":
                        alerts=sorted(alerts, key=lambda x: x[1])
                if self.path=="/monitor-server.py?status":
                        alerts=sorted(alerts, key=lambda x: x[0],reverse=True)
                if self.path=="/monitor-server.py?hostname":
                        alerts=sorted(alerts, key=lambda x: x[5])
                if self.path=="/monitor-server.py?description":
                        alerts=sorted(alerts, key=lambda x: x[3])
                if self.path=="/monitor-server.py?timechecked":
                        alerts=sorted(alerts, key=lambda x: x[2])
                if self.path=="/monitor-server.py?scriptname":
                        alerts=sorted(alerts, key=lambda x: x[6])
                self.send_response(200)
                self.send_header('Content-type','text/html')
                self.end_headers()
                self.wfile.write("<html>")
                self.wfile.write("<title>Guidewire  dashboard</title></head><body><br/>")
                self.wfile.write("<b>GUIDEWIRE MONITOR</b>")
                self.wfile.write("<br/><br/><table>")
                self.wfile.write("<tr><td><a href=http://guidewire-jenkins.avivaaws.com:8088/monitor-server.py?status>Status</a></td>")
                self.wfile.write("<td><a href=http://guidewire-jenkins.avivaaws.com:8088/monitor-server.py?environment>Environment</a></td>")
                self.wfile.write("<td><a href=http://guidewire-jenkins.avivaaws.com:8088/monitor-server.py?service>Service</a></td>")
                self.wfile.write("<td><a href=http://guidewire-jenkins.avivaaws.com:8088/monitor-server.py?hostname>Hostname</a></td>")
                self.wfile.write("<td><a href=http://guidewire-jenkins.avivaaws.com:8088/monitor-server.py?description>Description</a></td>")
                self.wfile.write("<td><a href=http://guidewire-jenkins.avivaaws.com:8088/monitor-server.py?timechecked>Time Checked</a></td>")
                self.wfile.write("<td><a href=http://guidewire-jenkins.avivaaws.com:8088/monitor-server.py?scriptname>Script Name</a></td></tr>")
                for j in alerts:
                    self.wfile.write('<tr>')
                    for k in [0,4,1,5,3,2,6]: 
                          self.wfile.write('<td>'+str(j[k])+'</td>')
                    self.wfile.write('</tr>')
                self.wfile.write("</body></html>")

                alerts=[]
		try:


			return

		except IOError:
			self.send_error(404,'File Not Found: %s' % self.path)

	#Handler for the POST requests
	def do_POST(self):
                print "Post handling (todo)"
		if self.path=="/monitor-server.py":
			form = cgi.FieldStorage(
				fp=self.rfile, 
				headers=self.headers,
				environ={'REQUEST_METHOD':'POST',
		                 'CONTENT_TYPE':self.headers['Content-Type'],
			})

			self.send_response(200)
			self.end_headers()
			self.wfile.write("Post received!" % form["name"].value)
			return			
        def do_PUT(self):
               self.do_POST()			
			
try:
	#Create a web server and define the handler to manage the
	#incoming request
	server = HTTPServer(('', PORT_NUMBER), myHandler)
	print 'Started httpserver on port ' , PORT_NUMBER
	
	#Wait forever for incoming htto requests
	server.serve_forever()

except KeyboardInterrupt:
	print '^C received, shutting down the web server'
	server.socket.close()
