#!/usr/bin/python

import os 
def walkDirs(parentdir):
    for item in os.listdir(parentdir):
        if os.path.isfile(parentdir + "/" + item):
            if parentdir.split("/")[-1] == "scripts":
              print "Running " + parentdir + "/" + item + "\n" 
              os.system("/bin/bash -l -s -c " + parentdir + "/" + item)
              #os.system(parentdir + "/" + item)
        else:
             walkDirs(parentdir + "/" + item)


walkDirs(".")
