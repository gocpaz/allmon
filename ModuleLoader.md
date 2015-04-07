# Loader #

  * Provides all mechanisms for metrics storage and metadata persistence.
  * Loads data to the database.
  * Aggregates data.

# Loading metrics data to database #

Process is spit to two isolated phases (two specialized processes):
  * loading raw metrics data to database (am\_raw\_metricsdata)
  * loading stored data in raw metrics storage to allmetrics schema

# Aggregation #

Data stored in allmetrics schema can be aggregated and stored in a separate space. This gives two main advantages:
  * aggregated data are easier to query (amount of metrics rows is limited),
  * aggregated data use much less space, thus high detail metrics data can be deleted, if certain level of granularity is not needed any more.

## Aggregation process parameters ##

  * Aggregation function
    * Aggregate metrics name (result of the aggregation process)

  * Filters
    * Instance
    * Host
    * StartTime/EndTime metrics which are taken by the process

  * Grouping
    * Instance
    * Host
    * Resource (can contain part of resources names - reg exp)
    * Source  (can contain part of resources names - reg exp)
    * Time group (i.e. day, hour, quarter, minute)


## Aggregates ##

Allmon aggregates processes diagram:
![http://allmon.googlecode.com/svn/wiki/allmon-deployment-diagram-logical-overview-v1.03e.png](http://allmon.googlecode.com/svn/wiki/allmon-deployment-diagram-logical-overview-v1.03e.png)

  * Scalar metrics
    * In-time
      * For boolean values - point to point change aggregation (very effective if changes are not often)
      * **1minute**, 15m, 30m, **1h**, 2h, 3h, 6h, 12h, **1d**, 2d, 1w, 1month, ...
    * ...
  * Vector metrics
    * In-time aggregation (day, hour, etc.)
      * Aggregated servlet calls in days/hours
    * In resource/source hierarchy level aggregation
      * Aggregated servlet calls in hours for classes (resource) - users (source) and session is lost
    * Aggregated calls by count of concurrent calls (in second grain)
    * ...

  * Aggregate functions
    * Min/Max - very good to describe spread
    * Avg - base aggregation for most scalar metrics
    * Sum - basis for execution times metrics
    * Median - can be useful because median is a central point which minimizes the average of the absolute deviations
    * First/Last - together with Min/Max can be used to give candlestick analysis over time (http://en.wikipedia.org/wiki/Candlestick_chart)
    * Stddev - especially good for metrics describing activity with gausian (normal) distribution
    * Poison k, m
    * Distribution - storing histogram or bitmap function of metrics values - very effective way of aggregating for coarse grained aggregates
    * Derivative - first, second, third, etc.

  * Aggregate procedures can be set for specific time period, i.e.:
    * servlet calls contain resource: class, source: user - for 500k calls per day in a system with 100 servlet classes used by 1000 users with constant distribution on 24x7 basis, gives 500k rows per day -> 3.5M rows per week -> 15M rows per month
      * _hour_ aggregation of servlet calls per user (class name is not taken into account) _for last three months_ only - 24 hours x 500 users = 12k rows per day - 360k rows per month and 1M rows overall
      * _day_ aggregates of servlet calls per user _for last year_ - 1 day x 500 users = 500 rows per day - 15k rows per month - 180k per year

  * All aggregation procedures contain estimation algorithm which helps decide about parameters to balance usability of aggregated data and space needed for their storage
    * taking above example, all figures can be estimated using the same distribution as already stored in not aggregated (detailed) data