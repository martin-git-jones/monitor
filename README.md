# monitor
To implement this, create a directory called monitor. Create a directory under monitor with your server name and subdirectories of that called scripts and output.
In the servername/scripts directory, copy the health-check scripts. There are example scripts in this repo that you can start with.
Place runScripts.py in the monitor directory. You can call runScripts.py from the crontab if required.
The output files that are created are the input to monitor-server.py, which can be accessed via port 8088, or change the code to the required port.
It displays a simple web page which can be sorted by clicking on the column headings.
