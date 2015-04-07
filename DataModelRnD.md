# Allmon Database Transformation Tiers #

http://www.rittmanmead.com/2009/07/16/drilling-down-in-the-oracle-next-generation-reference-dw-architecture/

  * Staging tier
    * Loading structures (am\_raw\_metrics table)
  * Foundation tier - 3rd NF model (highly normalized data)
    * **Allmon core schema (allgeneric/allmetric) with metadata**
  * Access tier (extra structures for better efficiency)
    * Denormalized data (views, materialized views, tables)
    * Aggregate tables

# Allmon core data model RnD #

Issues and Challenges:
  * No need for transactions!
  * Flexibility!
  * Partitioning?
  * Scalability?

  * RRD tool limitations
    * Only scalar metrics can be stored
    * Lack of fine grained stats over a period of time
    * No SQL support
    * ....but much more effective as a storage of scalar metrics!


## Scalar vs. Vector variables (metrics) ##

A scalar is a variable that only has magnitude, e.g. a speed of 40 km/h. Vector quantities have two characteristics, a magnitude and a direction, e.g. a velocity of 40km/h north. Vectors allow us to look at complex, multi-dimensional problems as a simpler group of one-dimensional problems. When you compare vector quantities of the same type, you have to compare both the magnitude and the direction. For scalars, you only compare the magnitude.

**Both allgeneric and allmetric schemas support scalar and vector metrics.**

## Very generic data model **[allgeneric](DataModelRnDAllgeneric.md)** ##

All data (meta-data and collected metrics, aggregates etc.) are stored in fixed generic relational schema. Allgeneric schema can store data of constellation of many star and snowflake schemas. It is very generic and flexible form. You can add a new dimension or a fact table without redefining your schema.

  * Very easy adding new facts, dimensions and measures
  * All meta-data connected to data on relational level
  * Can cause performance problems

## More relational data model **[allmetric](DataModelRnDAllmetric.md)** ##

Allmetric schema is more solid that allgeneric. It also basis on idea of datawarehouse concepts, but it is less generic and more fitting metrics collecting requirements. After early load tests allmetric schema turned out as much more efficient than allgeneric (especially for bigger datasets, more than 10M rows).

  * Very similar to other data warehouse methods
  * Much better performance

# Data volumes calculations #

## Actions ##

  * dimension
    * datatime (one month hours) - 31 `*` 24 = 744
    * action class - 2000
    * system user - 1000
  * measure
    * execution time

  * fact table space size: 744 `*` 2000 `*` 1000 = 1'488'000'000 ~ 1500M points
  * fact space usage - weak

## CPU ##

  * dimension
    * datatime (one month minutes) - 31 `*` 24 `*` 60 = 44640
    * Host - 10 hosts
    * CPU - 2 CPUs
  * measure
    * Utilization (Types: User% Sys% Wait% Idle% Sum%)

  * whole fact table space size: 44640 `*` 10 `*` 2 `*` 5 = 4'464'000 ~ 4.5M points
  * fact space usage - full