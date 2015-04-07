# Active and Passive approaches to real-time monitoring #

Active and passive and synthetic monitoring are complementary techniques of performance monitoring in modern scalable, distributed systems. Please, find in below knol article a very good description of Active and Passive monitoring for Web solutions: http://knol.google.com/k/bill-fuesz/active-vs-passive-web-performance/.

## Passive (Real user monitoring) ##

This approach let you monitor actual (real) interaction with a system. Metrics collected using this approach can be used to determine the actual service-level quality delivered to end-users and to detect errors or potential performance in the system.

  * Can be very helpful in troubleshooting performance problems once they have occurred.
  * The most important drawback of this method is that something in the system has to be performed (triggered externally) to take and collect any metrics. We will have no defined service level if no action is called.

## Active (Synthetic) ##

This technique basis on created scripts to simulate an action which end-user or other functionality would take in the system. Those scripts continuously monitor at specified intervals for performance and availability reasons various system metrics.

  * Active monitoring test calls add (artificial - not real) load to system
  * Applying this approach we can have almost constant knowledge about service level in our system (if something happen we might know about it even before end-users notice a problem)

Articles:
  * Bill Fuesz knol article about Active/Passive Web Monitoring - http://knol.google.com/k/bill-fuesz/active-vs-passive-web-performance/
  * Passive vs. Active Monitoring (by Les Cottrell - SLAC) - http://www.slac.stanford.edu/comp/net/wan-mon/passive-vs-active.html

  * Active monitoring in web applications - http://en.wikipedia.org/wiki/Synthetic_monitoring
  * Passive monitoring in web apps - http://en.wikipedia.org/wiki/Real_user_monitoring



# Needed Instrumentation #

Considering performance monitoring we have to understand potential efects of our observations on a observed artefact.

## Heisenberg uncertainty principle and Observer effect ##

source: http://en.wikipedia.org/wiki/Uncertainty_principle

"The measurement of position necessarily disturbs a particle's momentum, and vice versa. This makes the uncertainty principle a kind of observer effect."

This explanation is not incorrect, and was used by both Heisenberg and Bohr. But they were working within the philosophical framework of logical positivism. In this way of looking at the world, the true nature of a physical system, inasmuch as it exists, is defined by the answers to the best-possible measurements which can be made in principle. So when they made arguments about unavoidable disturbances in any conceivable measurement, it was obvious to them that this uncertainty was a property of the system, not of the devices.

Today, logical positivism has become unfashionable in many cases, so the explanation of the uncertainty principle in terms of observer effect can be misleading. For one, this explanation makes it seem to the non positivist that the disturbances are not a property of the particle, but a property of the measurement process

source: http://en.wikipedia.org/wiki/Observer_effect_(information_technology)

"In information technology, the observer effect is the potential impact of the act of observing a process output while the process is running. For example: if a process uses a log file to record its progress, the process could slow. Furthermore, the act of viewing the file while the process is running could cause an I/O error in the process, which could, in turn, cause it to stop.

Another example would be observing the performance of a CPU by running both the observed and observing programs on the same CPU, which will lead to inaccurate results because the observer program itself affects the CPU performance (modern, heavily cached and pipelined CPUs are particularly affected by this kind of observation).

Observing (or rather, debugging) a running program by modifying its source code (such as adding extra output or generating log files) or by running it in a debugger may sometimes cause certain bugs to diminish or change their behavior, creating extra difficulty for the person trying to isolate the bug (see Heisenbug)."


# Agent vs. Agentless #

[Server Monitoring - Monitoring Enterprise Servers - Agent or Agentless?](http://knol.google.com/k/anonymous/server-monitoring/3o4z1jgc0p47b/2?domain=knol.google.com&locale=en#)


# Service Checks #

"The best way to check something out it to try using it"

if you want to monitor your web site the best way to do this is to try emulate real user and try to check this out continously


## What is Service Health Check ? ##

Health check is a essence of active monitoring.


## How to use Service Health Check ##

  * What can be a service check
  * What technologies
    * 
  * What metrics

## Internal Allmon Health Checks ##

  * Allmon has set of internal service helth checks (SHC), which:
    * confirm/prove that allmon works - casn be used with correlation to other SHCs in monitoring systems
    * ...



# Metrics #

![http://www.ignitesocialmedia.com/wp-content/uploads/2009/02/social-media-monitoring-funnel-final.png](http://www.ignitesocialmedia.com/wp-content/uploads/2009/02/social-media-monitoring-funnel-final.png)


## Software ##

### Java (JVM) ###

  * Threads count
  * Java heap metrics
    * Memory allocation after GC
    * GC durations
    * Heap size (young, tenured generations)

### Database ###

  * Open connection count
  * Active sessions count

## Hardware ##

### Operating System level metrics ###

  * CPU utilization
  * Open/active network connection count

### Network ###

(you can use many different tools especially created for this purpose)


# Storage (metrics persistence) #

[DataModelRnD](DataModelRnD.md)

# Analysis #

TODO