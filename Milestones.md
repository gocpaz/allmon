We would like to introduce milestones so that we have a clear idea where the project is progressing and where we would like to see it in the future.

While it is a statement of intent, it does not necessarily tie down the scope or creativity of the solution. This is a very broad idea based on what we plan to do.

### 0.3.0-PA (around mid Dec 2010) ###
  * restructuring projects - splitting client project to smaller more specifically isolated maven projects - Action TS
  * merging trunk code with allmon-mvn branch - Action TS
  * solving problem of correlating entry/exit metrics (potential: one metric record per entry/exit?) - Action TS
  * adding RMI method of sending metrics data from agents to aggregator (optional to jms)

### 0.4.0-PA (around mid Jan 2011) ###
  * introducing server-side front-end - a set simple views to collected (raw/stored) metrics
  * implement first phase of aggregation functions (avg, count etc) - Action VN
  * re-think and research client-side buffers - Action VN

### 0.5.0-PA (around mid Mar 2011) ###
  * research apache-cassandra as a metrics storage
  * introducing first analyses views
  * finalise aggregation functions (avg, count etc) for the metrics
  * re-designing acquisition strategies and client-side buffers
  * implementing thread management strategies