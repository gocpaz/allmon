package org.allmon.server.receiver;

import org.allmon.common.AllmonCommonConstants;
import org.allmon.common.MetricMessageWrapper;
import org.allmon.server.loader.LoadRawMetric;
import org.apache.camel.Exchange;
import org.apache.camel.Processor;
import org.apache.camel.builder.RouteBuilder;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class LoaderReceiverRouteBuilder extends RouteBuilder {

    private static final Log logger = LogFactory.getLog(LoaderReceiverRouteBuilder.class);
    
    public void configure() {

        // receiving data from server-side queue
        from(AllmonCommonConstants.ALLMON_SERVER_CAMEL_QUEUE_READYFORLOADING).process(new Processor() {
            public void process(Exchange e) {
                logger.debug(">>>>> Received exchange: " + e.getIn());
                logger.debug(">>>>> Received exchange body: " + e.getIn().getBody());
                
                MetricMessageWrapper metricMessageWrapper = (MetricMessageWrapper)e.getIn().getBody();
                if (metricMessageWrapper != null) {
                    try {
                        // Store metric
                        LoadRawMetric loadRawMetric = new LoadRawMetric();
                        //loadRawMetric.storeMetric(metricMessageWrapper.toString()); // TODO change String(metricMessageWrapper.toString) to MetricMessage
                        loadRawMetric.storeMetric(metricMessageWrapper); // TODO change String(metricMessageWrapper.toString) to MetricMessage
                    } catch (Throwable t) {
                        logger.error(t.getMessage(), t);
                    }
                } else {
                    logger.debug(">>>>> Received exchange: MetricMessageWrapper is null");
                }
                
                logger.debug(">>>>> Received exchange: End.");
            }
        });
        
        //from(q2).to("jpa:org.apache.camel.example.jmstofile.PersMessage");

        /*
        from("file:src/data?noop=true").convertBodyTo(PersonDocument.class)
            .to("jpa:org.apache.camel.example.etl.CustomerEntity");
        // the following will dump the database to files
        from("jpa:org.apache.camel.example.etl.CustomerEntity?consumeDelete=false&consumer.delay=3000&consumeLockEntity=false")
            .setHeader(Exchange.FILE_NAME, el("${in.body.userName}.xml"))
            .to("file:target/customers?append=false");
        */
           
    }
    
}
