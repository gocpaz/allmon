# ToDo List #

  * Priority: high (M), medium (OS), low (C); (MOSCoW - Must Ought Should Could and Won't - http://en.wikipedia.org/wiki/MoSCoW_Method)
    * M - MUST have this.
    * OS - OUGHT/SHOULD have this if at all possible.
    * C - COULD have this if it does not affect anything else.
    * W - WON'T have this time but WOULD like in the future.
  * Items: (code), (docs), (design), (research), (test)
  * Progress: not done (o), finished (x), not needed (-)


---


## [Collector](ModuleCollector.md) (`*`) (allmon-client) ##
  1. Extraction (metrics data acquisition),
  1. Transformation (aggregating metrics to packets) and transport to Loader

  * (M) (x) (code) Add an optional parameter for scheduler which specifies a shift for active monitoring agents tasks - preventing running huge list of tasks at once.

  * (M) (o) (code) Research option of persisting not sent yet messages by local agent metric buffer, when client side broker is not available. At this stage allmon is not storing acquired metrics in this case at all, due to maxim “primum non nocere” – first, do not harm.

  * (M) (x) (code) Create parameter which is responsible for client side heartbeat check of broker instance. Now this value is hard-coded.

  * (M) (x) (design) Design generic agent API and sender which can be used for various metrics collection purposes (passive: systems usage monitoring; active: health checks, heartbeats, metrics sampling, etc.)
    * (M) (x) (code) To increase performance of acquiring metrics process review possibility of collecting and caching metrics before sending them to agent (to the first 'for aggregating' queue).
      * (C) (o) (code) Throttling mechanism will be added - i.e. over 100k messages not sent because of broker failure will be suspended.
        * (W) (o) (code) Messages can  be send to disk and resent to broker when is available.
    * (M) (x/o) (code) Design various metrics agents strategies for different agents.
      * (W) (o) (code) Creating a new metrics message sender based on log4j appender mechanism
      * (W) (o) (code) Creating agent (base on HttpCallAgent) which can be used to monitor how google (or any other browser site) is positioning certain pages/services.

  * (O) (x) (code) Finish simple scheduler for active monitoring

  * (O) (o) (code) Add XML mechanism of setting parameters for active metrics scheduler - Tomasz.Koscinski

  * (O) (o/x) (code) Creating base (framework) for various listener agents for active and passive monitoring, with the most important examples (parsing file, ..., etc.)

  * (C) (x) (code) Check and improve performance of metrics wrapper and aggregation strategy.

  * (C) (o) (design) Review and test having agents behind proxies.

  * (C) (o) (test) Test separate allmon components in either wrong configuration scenarios or other software failures
    * (C) (x/o) (test) Agent work if ActiveMQ instance is down

  * (C) (o) (design) Design agent for client side web application user behaviour/experience monitoring

  * (W) (o) (design) Evaluate compressing aggregated messages sent to allmon-server. This option could be suggested either for very remote agents or agents behind weak network connection. Crucial will be appropriate aggregation settings.

  * (W) (o) (code) Add mechanism similar to check sum or redundancy check sending message used for potential errors, lack of transfers detection.

  * (W) (o) (code) Allmon can monitor itself modules instances, JMS broker, JVMs, and database.

  * (W) (o) (research) Time synchronization for agents instances – low priority, depend rather on NTP protocol time synchronization.

  * (W) (o) (code) Encrypting metric messages send from allmon clients to server. Adding authorization mechanism for collectors. Low priority – allmon is intended to be an internal tool.

## [Loader](ModuleLoader.md) (`*`) (allmon-server) ##
  1. Loading data to the database
  1. Transforming data to allmetrics allmon schema

  * (M) (x) (research) Research in allmon potential schema models
    * (x) (code) Design and implement allmetrics and allgeneric schemas
    * (x) (test) Load test future multidimensional analysis queries, and choose which will better work with generic metrics data

  * (M) (x) (code) Finish loading mechanism in allmon-server
    * (M) (x) (code) Load metrics data to RawMetrics table
    * (M) (x) (code) Extracting RawMetrics data and loading them to allmetrics schema
    * (?) (-) (design) Linking entry and exit points

  * (O) (o) (code) Extends loading mechanism by adding storing parameters and exceptions details.

  * (O) (o) (design) Solve problem different times on remote clients - metrics events time synchronization issue!

  * (O) (o) (design) Add structure(s) holding events and related directly to calendar (Calendar of events)

  * (O) (o) (design) Add structures/functionality for hierarchies in resources and sources in allmetric schema. Ex: for java methods calls extract hierarchy of packages in resource/source, for action classes extract hierarchy of users if possible.

  * (W) (o) (research) Deploy loader in a cloud.

## [Miner](ModuleMiner.md) (`**`) ##
  1. Mining knowledge from collected in the database data,
  1. Statistical analysis,
  1. Correlation across set up dimensions

  * (o) (design) Propose mechanism of building structures eligible for future multidimensional analysis
    * (x/o) (code) Creating views defined for all declared metric types (static and dynamic)

  * (o) (research) Introduce methods of comparing and correlating two/many metrics (mainly in time dimension)

  * (o) (research) Research methods of aggregating data (reducing details, gaining read speed, reducing space) - data consolidation methods


## [Viewer](ModuleViewer.md) (`**`) ##
  1. Presentation and Front-end


## General (also allmon-common) ##

  * (C) (o) (code) Prepare build scripts creating allmon distribution.

  * (C) (o) (code) Create maven/ivy scripts for dependency management.

  * (C) (o) (code) Create notification mechanism in case of fatal errors, wrong configuration, lack of vital allmon components, etc. (logging, sending emails).

  * (C) (o) (code) Create a new eclipse project for purely common code (+ common test project with load test framework) - sources should be jarred and referenced to allmon-client and allmon-server sides.
    * (C) (o) (code) Split allmon-client to allmon-server configurations and constants. Common constants should be declared in the common project.

  * (C) (o) (code) Review and clean up allmon logging code.

  * (W) (o) (design) Create allmon logo.