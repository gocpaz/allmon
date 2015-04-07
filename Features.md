# Introduction #

Below you can find a list of features which are supported by allmon.

# Features list #

  * Active and passive monitoring
  * Scalar and vector metrics
  * Distributed and multitier metrics acquisition (allmon-clients can be distributed across your infrastructure and monitori many tiers)
  * Highly scalable design
  * Metrics collection has been desin to emphasize run-time isolation (non intrusiveness)
  * Low utlization overhead - low performance footprint
  * Metrics transfer is based on messaging
    * connectivity
    * loosely coupling
    * reliable
    * not interfering
  * Design for generic analysis
    * Event correlation
      * Correlation resources utilization with application actions
    * Anomaly detection
    * System responses, utilizations
    * Users behaviour (users activity, used parameters, thrown exception, etc.)
    * Measuring application behaviour
    * ...
  * Compatible with monitoring standards (SNMP, JMX, ...)
  * Platform independent (java implementation)

# Manifesto (Vision) #

  * Deliver stable and easy to maintain code by using test driven development approaches
  * Optimize for performance and usability.
  * Make allmon easy-to-use by providing examples, easy-to-understand APIs and architecture.
  * Allow for easy extensibility by carefully building up the architecture
  * Make allmon worth using by showing how to solve real-world examples.


---


## Buzzwords ##

  * auditability
    * code manipulation
    * aop
    * injections by annotations
  * preventing performance issues
  * flexible and easy in use
  * high-performance
  * allmon vs standard monitoring
  * why allmon
    * unblocking inserts to database
    * unblocking remote calls