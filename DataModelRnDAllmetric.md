# Introduction #

Allmetric data model research. More details and the schema creation script is under: http://code.google.com/p/allmon/source/browse/trunk/allmon-db/create-allmon-schema-allmetric--oracle.sql.

Why we wanted to have so generic schema?
We have two answers:
  * We wanted to avoid creation of new structures if we want to add a new metric, metric group or even new area (layer) of monitoring.
  * ... 3 tier architecture of a datawarehouse - middle tier contains schema in nice and generic 3NF.

# Details #

Example of stored metrics data in denormalized fashion (1NF).

| (static meta-data) | (dynamic-dim)  | (dynamic-dim)  | (static meta-data) | (dynamic-dim) | (dynamic-dim) | (values) | | |
|:-------------------|:---------------|:---------------|:-------------------|:--------------|:--------------|:---------|:|:|
| **Artifact** | **Host** (AgentHost) | **Instance** | **Metric Type** | **Resource** | **Source** | **Metric Values** | **Time Stamp** | **Comment** |
| OS | Host1 | - | CPU | CPUn | - | NV | TS |  |
| OS | Host1 | - | Mem | Usr | - | NV | TS |  |
| OS | Host1 | - | Mem | Sys | - | NV | TS |  |
| OS | Host1 | ProcessName1 | Process | Allocated Memory | - | NV | TS | Review ??? |
| OS | Host1 | - | Average disk reads in time | Disc1 | - | NV | TS | Review ??? |
| OS | Host1 | - | IO | - | ? | NV | TS |  |
| OS | Host1 | - | Page | - | - | NV | TS |  |
| OS | Host1 | - | Net | - | ? | NV | TS |  |
| AppMet | Host1 | AppInst1 | Action/Servlet | ActionClass1 | User | ExecTime | TS |  |
| AppMet | Host1 | AppInst1 | POJO | Class1.method | Class.method | ExecTime | TS |  |
| AppMet | Host1 | AppInst1 | EJB | EJB1.method | ? | ExecTime | TS |  |
| AppMet | Host1 | AppInst1 | MDBExec | MDB1 | ? | ExecTime | TS |  |
| AppMet | Host1 | AppInst1 | MDBWait | MDB1 | ? | ExecTime | TS |  |
| AppMet | ClientHost1 | AppInst1 | ClientSideRender | JSP1 | ? | ExecTime | TS |  |
| AppMet | ClientHost1 | AppInst1 | ClientSideReqWait | JSP1 | ? | ExecTime | TS |  |
| AppMet | ClientHost1 | AppInst1 | ClientSideRespWait | JSP1 | ? | ExecTime | TS |  |
| AppMet | AgentHost1 | AppInst1 | HTTPServiceHealthCheck | CheckName1 | CheckedHost | Up/Down (Boolean) | TS |  |
| AppMet | AgentHost1 | AppInst1 | HTTPServiceHealthCheck | CheckName2 | CheckedHost | ExecTime | TS |  |
| Rep | Host1 | RepServ1 | QueueLength | Rep1 | ? | NV | TS |  |
| Rep | Host1 | RepServ1 | RepExec | Rep1 | ? | ExecTime | TS |  |
| Rep | Host1 | RepServ1 | RepWait | Rep1 | ? | ExecTime | TS |  |
| JVM | Host1 | JVMInst1 | JMX | Directory:MBeanName:AttributeName | - | NV | TS | Proposition to review ??? |
| JVM | Host1 | JVMInst1 | JMX | java.lang:sun.management.MemoryPool | Eden Space | NV | TS | Review ??? |
| JVM | Host1 | JVMInst1 | JMX | java.lang:sun.management.MemoryImpl | Tenured Gen | NV | TS | Review ??? |
| JVM | Host1 | JVMInst1 | JMX | java.lang:sun.management.GarbageCollectorImpl | CollectionCount | NV | TS | Review ??? |
| JVM | Host1 | JVMInst1 | JMX | java.lang:sun.management.GarbageCollectorImpl | CollectionTime | NV | TS | Review ??? |
| JVM | Host1 | JVMInst1 | JMX | java.lang:sun.management.ThreadImpl | ThreadCount | NV | TS | T |
| JVM | Host1 | JVMInst1 | JMX | java.lang:sun.management.ThreadImpl | CurrentThreadCpuTime | NV | TS | Review ???  |
| JVM | Host1 | JVMInst1 | JMX | org.apache.activemq:org.apache.activemq.broker.jmx.QueueView | ProducerCount | NV | TS | Review ???  |
| DB | Host1 | DBInst1 | Sessions | - | - | NV | TS |  |
| HW | Machine1 | - | Temp | CPUTemp1 | - | NV | TS |  |
| HW | SwitchIP1 | - | Bandwidth | -| - | kBit | TS |  |

Fields Description;

  * Artifact -- (static) a part of infrastructure under monitoring: OS, AppMet, Rep, JVM, DB, HW, etc.
  * Instance -- (dynamic) related to Artifact - concrete instance of an artifact: AppInstance, RepServInst, JVMInst
  * Metric Type	-- (static) related to Artifact - represents type of collected metric: CPU, MEM, IO, Mem Usr, ...
  * Host -- (dynamic) - always host of a machine where agents run
  * Resource -- (dynamic) related to Metric Type - represents resource under monitoring: CPU1, CPU2, Mem usr, Action class, POJO Class, Count of connections to database ...
  * Source -- (dynamic) related to Metric Type - source of a call to monitored resource
  * Metric -- (values)
  * Time Stamp -- Time Stamp and Calendar references

  * (static)  - all values have to be configured explicitly, those values are referencing to allmon constants, any loading process cannot add new values
  * (dynamic) - loading processes addnew values dynamically, base on what data are comming from allmon-client



---

Legend:
  * NV - numerical value
  * TS - time stamp
  * dT - delta time


# Allmetric Schema #

```

                      +-------------+
            +---------|  Artifact   |--------+
            |         +-------------+        |
            A                                A
+-------------+                            +-------------+
|  Instance   |-------+                    |  MetricType |-------+    
+-------------+       |                    +-------------+----+  |
                      A                                       |  |
                    +-------------+        +-------------+    |  |
                    | MetricsData |>-------|  Resource   |>---+  |
                    +-------------+        +-------------+       |
                      V         V                                |
+-------------+       |         |          +-------------+       |
|  Host       |-------+         + - - - - -|  Source     |>------+
+-------------+                            +-------------+


```