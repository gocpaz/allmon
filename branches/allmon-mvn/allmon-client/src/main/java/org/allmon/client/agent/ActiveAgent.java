/**
 * 
 */
package org.allmon.client.agent;

import org.allmon.common.MetricMessage;
import org.allmon.common.MetricMessageWrapper;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.scheduling.quartz.QuartzJobBean;

/**
 * Active agents are used in active monitoring, where metric 
 * collection process is triggered by agent scheduler mechanism.<br><br>
 * 
 * This technique basis on created scripts to simulate an action which 
 * end-user or other functionality would take in the system. Those scripts 
 * continuously monitor at specified intervals for performance and availability 
 * reasons various system metrics.<br>
 * - Active monitoring test calls add (artificial - additional) load to monitored 
 * system.<br>
 * - Applying this approach we can have almost constant knowledge about service 
 * level in our system (if something happen we might know about it even before 
 * end-users notice a problem).<br>
 * 
 * TODO add timeout mechanism preventing creating/leaking too many threads
 * 
 */
abstract class ActiveAgent implements AgentTaskable {

    private static final Log logger = LogFactory.getLog(ActiveAgent.class);
    
    final AgentContext agentContext;
    
    ActiveAgent(AgentContext agentContext) {
		this.agentContext = agentContext;
	}
	
    public final AgentMetricBuffer getMetricBuffer() {
        return agentContext.getMetricBuffer();
    }
	
    String getAgentContextName() {
        return agentContext.getName();
    }
    
	private ActiveAgentMetricMessageSender messageSender = new ActiveAgentMetricMessageSender(this);
    
    /**
     * This method force all active agents to contain specific collectMetrics implementations
     * designed to meet different requirements of agents.
     * 
     * @return MetricMessage
     */
    abstract MetricMessageWrapper collectMetrics();
    
    /**
     * This method is used by AgentCallerMain to execute process of:
     * (1) collecting metrics and 
     * (2) sending metrics messages. 
     * This method is final, so no other concrete Agent implementation can override it.
     */
    public final void execute() {
//        try {
//            validateAgentTaskableParameters(); // FIXME Add implementation
//        } catch (Exception e) {
//            throw new RuntimeException("Parameters weren't initialized properly: " + e.toString());
//        }
    	System.out.println("ActiveAgent is executing collecting metrics..."); // TODO clean logger
        MetricMessageWrapper metricMessageWrapper = collectMetrics();
        if (metricMessageWrapper == null || metricMessageWrapper.size() == 0) {
        	//TODO create named exception! Necessary to handle metrics collection process exceptions
            throw new RuntimeException("MetricMessages haven't been initialized properly");
        }
        sendMessage(metricMessageWrapper);
    }
    
    private void sendMessage(MetricMessageWrapper metricMessageWrapper) {
        if (logger.isDebugEnabled()) {
            logger.debug("Sending acquired metrics: " + metricMessageWrapper.toString());
        }
        // TODO review creating different explicitly specified MetricMessageSender
        for (MetricMessage metricMessage : metricMessageWrapper) {
            messageSender.insertPoint(metricMessage);
        }
    }
    
    // TODO move this implementation to Agent
    void addMetricMessage(MetricMessage metricMessage) {
        getMetricBuffer().add(metricMessage); // TODO review for multiton
    }
    
//    // TODO review this property - it is forcing to use decodeAgentTaskableParams implementation for all active agents 
//    // XXX create a new interface only for those Active agents which should have parameters
//    // XXX in future allmon releases parameters for active agents can be specified in XML, so String[] can be not enough
//    private String[] paramsString;
//
//    final String getParamsString(int i) {
//        if (paramsString != null && paramsString.length > i) {
//            return paramsString[i];
//        }
//        return null; // TODO review is null result is better than throwing an exception
//    }
//    
//    /**
//     * Forced by AgentTaskable - in the future can by forced only for specific active agents.
//     */
//    public final void setParameters(String[] paramsString) {
//        //if (paramsString == null) // TODO decide what to do with null paramsString
//        this.paramsString = paramsString;
//    }
    
    //abstract void validateAgentTaskableParameters() throws Exception; // FIXME Add implementations
    
    private String agentSchedulerName;
    
    public final void setAgentSchedulerName(String agentSchedulerName) {
        this.agentSchedulerName = agentSchedulerName;
    }
    
    public final String getAgentSchedulerName() {
        return agentSchedulerName;
    }
        
}
