The main goal of the project is to create a distributed generic system collecting and storing various runtime metrics collections used for system performance, application responses, health, quality and availability monitoring purposes. The system also provides a set of data-mining algorithms useful for further performance analysis. Allmon is [Apache licensed open source](http://www.apache.org/licenses/LICENSE-2.0) attempt to create an [Application Service Management (ASM)](http://en.wikipedia.org/wiki/Application_service_management) system.

_"Measure what is measurable, and make measurable what is not so." - Galileo Galilei (1564–1642)_

**To read more about main goals and project requirements go to the project site**<a href='http://sites.google.com/site/allmonzone/'>AllmonZone</a>.

Remote Allmon [collector](ModuleCollector.md) agents are designed to harvest a range of metrics values coming from many areas of monitored infrastructure (i.e. application instrumentation, internal and generic application metrics accessible via JMX, HTTP service checks, database metrics, SNMP stats). Metrics are sent to the server and [stored](GoalsAndRequirements.md). The collected data are base for quantitative and qualitative performance and availability analysis. Allmon collaborates with other analytical tools for OLAP multidimensional analysis and Data Mining processing. The tool can be used for continuous production monitoring/auditing as well as for development (profiling) and QA (load testing) purposes to meet real [APM](http://en.wikipedia.org/wiki/Application_performance_management) needs.

_"If you can not measure it, you can not improve it." - William Thomson (1824–1907)_

Allmon schema is design to store hundreds of millions of raw metrics data rows. Allmon database can hold hundreds GB of data. Later on data can be aggregated by very flexible generic processes which can limit amount of allocated data and provide better prepared data for analysis.

**Following slideshare presentation**<a href='http://www.slideshare.net/tomaszsikora/introduction-to-allmon-010'>introduction to allmon</a> can be helpful to understand how allmon works and how can be used.

If you have any question, suggestions or any other ideas, please go to allmon users' group (Homepage: http://groups.google.com/group/allmon, Group email: allmon@googlegroups.com).

<a href='Hidden comment: 
<i><font face="Times" size="1">(Tomasz Sikora, London 18th February 2009)

Unknown end tag for &lt;/font&gt;



Unknown end tag for &lt;/i&gt;


'></a>


---


**Help Wanted!**

Allmon is a fairly new project, and it needs a lot of development effort. If you know (or want to learn) any of Apache Camel, Active MQ, OLAP technologies, Statistics etc. then you are qualified to help.

As with most open source projects under Apache license, Allmon is a [meritocracy](http://en.wikipedia.org/wiki/Meritocracy): "the more you put in, the more you get to define the project's future".


---


| &lt;wiki:gadget url="http://www.ohloh.net/p/319899/widgets/project\_basic\_stats.xml" height="220" width="320" border="0" /&gt; | &lt;wiki:gadget url="http://www.ohloh.net/p/319899/widgets/project\_languages.xml" height="220" width="320" border="0" /&gt; |
|:--------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------|

<a href='http://www3.clustrmaps.com/user/93ab9438'><img src='http://www3.clustrmaps.com/stats/maps-no_clusters/code.google.com-p-allmon--thumb.jpg' alt='Locations of visitors to this page' />
</a>

<a href='http://www.myworldmaps.net/mapstats.aspx?mapid=958ff55d-b640-43bd-b281-303a1117c531'><img src='http://www.myworldmaps.net/map.ashx/958ff55d-b640-43bd-b281-303a1117c531/thumb' border='0' />
</a>

![http://code.google.com/images/code_sm.png](http://code.google.com/images/code_sm.png)