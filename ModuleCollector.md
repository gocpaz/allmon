# Collector #

Client-side metrics data acquisition (extraction) and transformation (aggregation).

Modules:
  * Agent (Monitoring API : plug-in-able structure)
    * Active agents (actively executing/collecting metrics from monitored system)
      * JMX
      * SMTP
      * SQL query
    * Passive agents (monitoring real interaction with a system)
      * Web client-side monitoring
      * Java calls monitoring
      * Servlet/Actions classes monitoring

  * Sender (sending data by asynchronous messaging; Active MQ)
  * Collector core (aggregating metrics before sending to server) - sending data every 60sec (conf) or every 64kB (conf), Apache Camel

## Diagram of supervised tiers (areas) of monitored system ##

![http://allmon.googlecode.com/svn/wiki/allmon-deployment-diagram-logical-overview-v1.03c.png](http://allmon.googlecode.com/svn/wiki/allmon-deployment-diagram-logical-overview-v1.03c.png)

## Agents for various layers monitoring ##

<table border='1'>
<tr><th>.</th><th>Application</th><th>Services</th><th>Physical</th></tr>
<tr><th>.</th><th>Your java app</th><th>Your web app.</th><th>JVM</th><th>DB</th><th>App.Server</th><th>Web Cont.</th><th>JMS Broker</th><th>OS</th><th>Net</th></tr>

<tr><th>PassiveAgent</th><th>JavaCallAgent</th><td>x</td><td>x</td><td><i></td></i><td><i></td></i><td><i></td></i><td><i></td></i><td><i></td></i><td><i></td></i><td><i></td></tr></i><tr><th>HttpClientAgent</th><td><i></td></i><td>x</td><td><i></td></i><td><i></td></i><td><i></td></i><td><i></td></i><td><i></td></i><td><i></td></i><td><i></td></tr></i><tr><th>JmsCallAgent</th><td>x</td><td>x</td><td><i></td></i><td><i></td></i><td><i></td></i><td><i></td></i><td>x</td><td><i></td></i><td><i></td></tr></i><tr><th>JmxNfServerAgent</th><td>x</td><td>x</td><td>?</td><td><i></td></i><td>?</td><td>?</td><td>?</td><td><i></td></i><td><i></td></tr></i>

<tr><th>ActiveAgent</th><th>JmxServerAgent</th><td>x</td><td>x</td><td>x</td><td><i></td></i><td>x</td><td>x</td><td>x</td><td><i></td></i><td><i></td></tr></i><tr><th>ShellCallAgent</th><td><i></td></i><td><i></td></i><td><i></td></i><td><i></td></i><td><i></td></i><td><i></td></i><td><i></td></i><td>x</td><td>x</td></tr>
<tr><th>PingAgent</th><td><i></td></i><td><i></td></i><td><i></td></i><td><i></td></i><td><i></td></i><td><i></td></i><td>x</td><td>x</td><td>x</td></tr>
<tr><th>DBCallAgent</th><td>x</td><td>x</td><td>x</td><td>.</td><td>.</td><td>.</td><td>.</td><td>.</td><td><i></td></tr></i><tr><th>UrlCallAgent</th><td><i></td></i><td>x</td><td>x</td><td><i></td></i><td><i></td></i><td>.</td><td><i></td></i><td><i></td></i><td>?</td></tr>
<tr><th>SnmpAgent</th><td><i></td></i><td><i></td></i><td><i></td></i><td>.</td><td>.</td><td>?</td><td>?</td><td>x</td><td>x</td></tr>
</table>


## Taxonomy of allmon agents ##

![http://allmon.googlecode.com/svn/wiki/allmon-deployment-diagram-logical-overview-v1.03d.png](http://allmon.googlecode.com/svn/wiki/allmon-deployment-diagram-logical-overview-v1.03d.png)

## Examples ##

### ShellCallAgent ###

  * vmstat - Gives statistics about virtual memory, disks, traps, and processor activity. Use it to determine system loading.
  * iostat - Gives processor statistics and I/O statistics for tty, disks, and CD-ROM drives.
  * netstat - Shows network status.