call set-variables.bat

"%_JAVACMD%" -Xmx512m -cp %CLASS_PATH% %JVM_PROPERTIES% org.allmon.client.aggregator.AgentAggregatorMain
