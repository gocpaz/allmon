call set-variables.bat

java -Xmx512m -cp %CLASS_PATH% %JVM_PROPERTIES% org.allmon.client.aggregator.AgentAggregatorMain
