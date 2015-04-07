# Introduction #

The main project goal is to create a generic system storing various metrics collections used for performance and availability monitoring purposes. The system also provides a set of datamining algorithms useful for performance analysis.

# Modules #

  1. **[Collector](ModuleCollector.md)** (`*`) (allmon-client)
    * Agents - Extraction (metrics data acquisition),
    * Aggregator - Transformation (aggregating metrics to packets) and transport to Loader
  1. **[Loader](ModuleLoader.md)** (`*`) (allmon-server)
    * MetricReceiver - Loading data to the database
    * Loader - Transforming data to allmetrics allmon schema
  1. **[Miner](ModuleMiner.md)** (`**`)
    * Mining knowledge from collected in the database data,
    * Statistical analysis,
    * Correlation across set up dimensions
  1. **[Viewer](ModuleViewer.md)** (`**`)
    * Presentation and Front-end

(`*`) Core modules.
(`**`) Allmon gives a set of views to the internal storage which can be used by other OLAP/BI/Reporting tools.

Allmon component diagram:
![http://allmon.googlecode.com/svn/wiki/allmon-deployment-diagram-logical-overview-v1.03a.png](http://allmon.googlecode.com/svn/wiki/allmon-deployment-diagram-logical-overview-v1.03a.png)


# Deployment and data live-cycle #

Allmon server-side can work with many distributed (remote) [collectors](ModuleCollector.md). Every instance of Collector can use (configurable) many set up **agents**, providing constant system(s) **active and/or passive monitoring**. Collected data are being **aggregated** and sent to allmon server. On server side **metric receiver** instance is listening for coming metrics and persists them to the database in raw form (1NF). The raw metrics are being transformed and loaded to allmetric schema by **loader** process.

_For more detailed description search allmon wiki._

Allmon deployment diagram:
![http://allmon.googlecode.com/svn/wiki/allmon-deployment-diagram-logical-overview-v1.03b.png](http://allmon.googlecode.com/svn/wiki/allmon-deployment-diagram-logical-overview-v1.03b.png)

Stored metrics can be taken by [Miner](ModuleMiner.md) and [Viewer](ModuleViewer.md) for further performance and availability analysis.

Allmon aggregates processes diagram:
![http://allmon.googlecode.com/svn/wiki/allmon-deployment-diagram-logical-overview-v1.03e.png](http://allmon.googlecode.com/svn/wiki/allmon-deployment-diagram-logical-overview-v1.03e.png)

# Research #

  * [Allmon datamodel research](DataModelRnD.md)

Allmon schema is designed to store different metrics values coming from various areas of monitoring infrastructure. The collected data are base for vast range of performance and availability analysis.

  * [RnD Hub - Central point of the project research](RnDLinks.md)

Allmon collaborates with other analytical tools for OLAP multidimensional analysis and Data Mining processing.


  * [Bit of Performance Monitoring Theory](RnDTheoryPerformanceMonitoring.md)

The tool can be used for production as well as for development (profiling) and QA (load testing) purposes.



---

![http://code.google.com/images/code_sm.png](http://code.google.com/images/code_sm.png)