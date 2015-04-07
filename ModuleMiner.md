# Miner #

This component is responsible for mining knowledge from collected in allmon database data.

Provides:
  * Statistical analysis procedures
    * Correlation across set up dimensions
  * Storing events history log
  * Data mining algorithms
    * Clusterization
    * ...


## Statistical analysis ##

  * Correlation
    * Detecting related events in metrics of many layers of monitored systems infrastructure
    * Autocorrelation - http://web.science.mq.edu.au/~cassidy/comp449/html/ch05s02.html
    * Finding pseudo-related events (before/after) health check value change
  * Filtration
    * Detecting and removing outliners or noise - i.e. before aggregation to minimize round-off errors
  * Trend detection
    * Extrapolation
    * Forecasting
    * "aberrant behavior detection"
  * Simple statistics
    * Up time (in log)
  * Analysis in frequency domain (after Fourier transform)
    * http://en.wikipedia.org/wiki/Frequency_domain
    * http://web.science.mq.edu.au/~cassidy/comp449/html/ch06.html
  * ...

## Data mining ##

  * Clusterization - hierarchical and mean-based - identifying similarities in users/methods behaviour
  * Graphs of interconnections between resources and sources (who/what is using what)
  * ...