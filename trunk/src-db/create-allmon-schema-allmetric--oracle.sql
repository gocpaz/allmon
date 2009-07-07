-- allmon allmetric schema (by Tomasz Sikora)

-- TODO :
-- * Add parameters table - associated with metrics data
-- * Add output table - associated with metrics data (ex: output code for report server)

/*
Example of stored metrics data in denormalized fashion (1NF).

(meta-data) 			(meta-data) 	(dynamic-dim) 	(dynamic-dim) 			
Artifact 	Host 	Instance 	Metric Type 	Resource 	Source 	Metric 	Time Stamp 	Time
OS 	Host1 	- 	CPU 	CPUn 	- 	NV 	TS 	T
OS 	Host1 	- 	Mem 	Usr 	- 	NV 	TS 	T
OS 	Host1 	- 	Mem 	Sys 	- 	NV 	TS 	T
OS 	Host1 	- 	IO 	- 	? 	NV 	TS 	T
OS 	Host1 	- 	Page 	- 	- 	NV 	TS 	T
OS 	Host1 	- 	Net 	- 	? 	NV 	TS 	T
AppMet 	Host1 	AppInst1 	Action 	ActionClass1 	User 	ExecTime 	TS 	T -- ! problem with WebSession
AppMet 	Host1 	AppInst1 	POJO 	Class1.method 	Class.method 	ExecTime 	TS 	T
AppMet 	Host1 	AppInst1 	EJB 	EJB1.method 	? 	ExecTime 	TS 	T
AppMet 	Host1 	AppInst1 	MDBExec 	MDB1 	? 	ExecTime 	TS 	T
AppMet 	Host1 	AppInst1 	MDBWait 	MDB1 	? 	ExecTime 	TS 	T
AppMet 	Host1 	AppInst1 	SLC ServStatus - NV TS T   
Rep 	Host1 	RepServ1 	QueueLength 	Rep1 	? 	NV 	TS 	T
Rep 	Host1 	RepServ1 	RepExec 	Rep1 	? 	ExecTime 	TS 	T
Rep 	Host1 	RepServ1 	RepWait 	Rep1 	? 	ExecTime 	TS 	T
JVM 	Host1 	JVMInst1 	Mem 	Heap 	- 	NV 	TS 	T
JVM 	Host1 	JVMInst1 	Mem 	Tenured 	- 	NV 	TS 	T
JVM 	Host1 	JVMInst1 	Mem 	Eden 	- 	NV 	TS 	T
JVM 	Host1 	JVMInst1 	Threads 	- 	- 	NV 	TS 	T
DB 	Host1 	DBInst1 	Sessions 	- 	- 	NV 	TS 	T
HW 	Machine1 	- 	Temp 	CPUTemp1 	- 	NV 	TS 	T 


  Artifact	     -- a part of infrastructure under monitoring: OS, AppMet, Rep, JVM, DB, HW, etc.
  Instance	     -- related to Artifact: CPU, MEM, IO, AppInstance, RepServInst, JVMInst
  Metric Type	   -- related to Artifact - represents type of collected metric: CPU1, CPU2, Mem Usr, ...
  Host	
  Resource	     -- related to Metric Type - represents resource under monitoring
  Source	       -- related to Metric Type - source of a call to monitored resource 
  Metric	       -- 
  Time Stamp	   -- Time Stamp and Calendar references
  
*/

-------------------------------------------------------------------------------------------------------------------------
-- drop schema
DROP SEQUENCE am_cal_seq;
DROP SEQUENCE am_tim_seq;
DROP SEQUENCE am_arf_seq;
DROP SEQUENCE am_mty_seq;
DROP SEQUENCE am_hst_seq;
DROP SEQUENCE am_ins_seq;
DROP SEQUENCE am_met_seq;
DROP SEQUENCE am_rsc_seq;
DROP SEQUENCE am_src_seq;

-- drop fact table
DROP TABLE am_metricsdata;

-- drop dimensions
DROP TABLE am_calendar;
DROP TABLE am_time;
DROP TABLE am_instance;
DROP TABLE am_host;
DROP TABLE am_resource;
DROP TABLE am_source;
DROP TABLE am_metrictype;
DROP TABLE am_artifact;

DROP TABLE am_pivot;

-------------------------------------------------------------------------------------------------------------------------
-- creating schema
-- -- create dimension tables
CREATE TABLE am_artifact (
  am_arf_id NUMBER(10) NOT NULL,
  artifactname VARCHAR(50) NOT NULL,
  artifactcode VARCHAR(6) NOT NULL,
  CONSTRAINT am_arf_pk PRIMARY KEY (am_arf_id) USING INDEX
);
CREATE SEQUENCE am_arf_seq MINVALUE 1 MAXVALUE 999999999999999 INCREMENT BY 1;
CREATE UNIQUE INDEX am_arf_uk1 ON am_artifact(artifactcode);

CREATE TABLE am_metrictype (
  am_mty_id NUMBER(10) NOT NULL,
  am_arf_id NUMBER(10) NOT NULL,
  metricname VARCHAR(50) NOT NULL,
  metriccode VARCHAR(6) NOT NULL,
  unit VARCHAR(6) DEFAULT '-' NOT NULL,
  CONSTRAINT am_mty_pk PRIMARY KEY (am_mty_id) USING INDEX,
  CONSTRAINT am_mty_am_arf_fk1 FOREIGN KEY (am_arf_id) REFERENCES am_artifact(am_arf_id)
);
CREATE SEQUENCE am_mty_seq MINVALUE 1 MAXVALUE 999999999999999 INCREMENT BY 1;

CREATE TABLE am_instance (
  am_ins_id NUMBER(10) NOT NULL,
  am_arf_id NUMBER(10) NOT NULL,
  instancename VARCHAR(50) NOT NULL,
  instancecode VARCHAR(6) NOT NULL,
  url VARCHAR(100),
  CONSTRAINT am_ins_pk PRIMARY KEY (am_ins_id) USING INDEX,
  CONSTRAINT am_ins_am_arf_fk1 FOREIGN KEY (am_arf_id) REFERENCES am_artifact(am_arf_id)
);
CREATE SEQUENCE am_ins_seq MINVALUE 1 MAXVALUE 999999999999999 INCREMENT BY 1;

CREATE TABLE am_host (
  am_hst_id NUMBER(10) NOT NULL,
  hostname VARCHAR(50) NOT NULL,
  hostcode VARCHAR(6) NOT NULL,
  hostip VARCHAR(15) NOT NULL,
  CONSTRAINT am_hst_pk PRIMARY KEY (am_hst_id) USING INDEX
);
CREATE SEQUENCE am_hst_seq MINVALUE 1 MAXVALUE 999999999999999 INCREMENT BY 1;

CREATE TABLE am_resource (
  am_rsc_id NUMBER(10) NOT NULL,
  am_mty_id NUMBER(10) NOT NULL,
  resourcename VARCHAR(200) NOT NULL,
  resourcecode VARCHAR(10),
  unit VARCHAR(6) DEFAULT '-' NOT NULL,
  CONSTRAINT am_rsc_pk PRIMARY KEY (am_rsc_id) USING INDEX,
  CONSTRAINT am_rsc_am_mty_fk1 FOREIGN KEY (am_mty_id) REFERENCES am_metrictype(am_mty_id)
);
CREATE SEQUENCE am_rsc_seq MINVALUE 1 MAXVALUE 999999999999999 INCREMENT BY 1;
CREATE UNIQUE INDEX am_rsc_uk1 ON am_resource(am_mty_id, resourcename);
CREATE UNIQUE INDEX am_rsc_uk2 ON am_resource(resourcecode);

CREATE TABLE am_source (
  am_src_id NUMBER(10) NOT NULL,
  am_mty_id NUMBER(10) NOT NULL,
  sourcename VARCHAR(200) NOT NULL,
  sourcecode VARCHAR(10),
  CONSTRAINT am_src_pk PRIMARY KEY (am_src_id) USING INDEX,
  CONSTRAINT am_src_am_mty_fk1 FOREIGN KEY (am_mty_id) REFERENCES am_metrictype(am_mty_id)
);
CREATE SEQUENCE am_src_seq MINVALUE 1 MAXVALUE 999999999999999 INCREMENT BY 1;
CREATE UNIQUE INDEX am_src_uk1 ON am_source(am_mty_id, sourcename);
CREATE UNIQUE INDEX am_src_uk2 ON am_source(sourcecode);

CREATE TABLE am_calendar (
  am_cal_id NUMBER(10) NOT NULL,
  caldate DATE NOT NULL,
  year NUMBER(4) NOT NULL,
  month NUMBER(2) NOT NULL, 
  day NUMBER(2) NOT NULL, 
  week_day NUMBER(1) NOT NULL,
  year_day NUMBER(3) NOT NULL,
  quarter NUMBER(1) NOT NULL,
  week_of_year NUMBER(2) NOT NULL,
  CONSTRAINT am_cal_pk PRIMARY KEY (am_cal_id) USING INDEX
);
CREATE SEQUENCE am_cal_seq MINVALUE 1 MAXVALUE 999999999999999 INCREMENT BY 1;
CREATE UNIQUE INDEX am_cal_uk1 ON am_calendar(year, month, day);
CREATE UNIQUE INDEX am_cal_uk2 ON am_calendar(caldate);
CREATE INDEX am_cal_idx1 ON am_calendar(week_day, year_day, quarter, week_of_year);

CREATE TABLE am_time(
  am_tim_id NUMBER(10) NOT NULL,
  t DATE NOT NULL, 
  hour NUMBER(2) NOT NULL,
  minute NUMBER(2) NOT NULL,
  CONSTRAINT am_tim_pk PRIMARY KEY (am_tim_id) USING INDEX
);
CREATE SEQUENCE am_tim_seq MINVALUE 1 MAXVALUE 999999999999999 INCREMENT BY 1;
CREATE UNIQUE INDEX am_tim_uk1 ON am_time(hour, minute);

-- create fact table 
CREATE TABLE am_metricsdata (
  am_met_id NUMBER(10) NOT NULL,
  --am_arf_id NUMBER(10) NOT NULL, -- Artifact
  --am_mty_id NUMBER(10) NOT NULL, -- Metric Type
  am_ins_id NUMBER(10) NOT NULL, -- Instance	
  am_hst_id NUMBER(10) NOT NULL, -- Host
  am_rsc_id NUMBER(10) NOT NULL, -- Resource	
  am_src_id NUMBER(10), -- Source	
  am_cal_id NUMBER(10) NOT NULL, -- Calendar
  am_tim_id NUMBER(10) NOT NULL, -- Time
  metricvalue NUMBER(13,3) NOT NULL, -- Metric	
  ts DATE NOT NULL, -- Time Stamp -- TODO review to delete
  loadts DATE DEFAULT SYSDATE NOT NULL, -- Loading to the fact table Time Stamp
  CONSTRAINT am_met_pk PRIMARY KEY (am_met_id) USING INDEX,
  --CONSTRAINT am_met_am_mty_fk1 FOREIGN KEY (am_mty_id) REFERENCES am_metrictype(am_mty_id),
  CONSTRAINT am_met_am_ins_fk1 FOREIGN KEY (am_ins_id) REFERENCES am_instance(am_ins_id),
  CONSTRAINT am_met_am_hst_fk1 FOREIGN KEY (am_hst_id) REFERENCES am_host(am_hst_id),
  CONSTRAINT am_met_am_rsc_fk1 FOREIGN KEY (am_rsc_id) REFERENCES am_resource(am_rsc_id),
  CONSTRAINT am_met_am_src_fk1 FOREIGN KEY (am_src_id) REFERENCES am_source(am_src_id),
  CONSTRAINT am_met_am_cal_fk1 FOREIGN KEY (am_cal_id) REFERENCES am_calendar(am_cal_id),
  CONSTRAINT am_met_am_tim_fk1 FOREIGN KEY (am_tim_id) REFERENCES am_time(am_tim_id)
);
CREATE SEQUENCE am_met_seq MINVALUE 1 MAXVALUE 999999999999999 INCREMENT BY 1 CACHE 100;
--CREATE INDEX am_met_am_mty_idx1 ON am_metricsdata(am_mty_id);
CREATE INDEX am_met_am_ins_idx1 ON am_metricsdata(am_ins_id);
CREATE INDEX am_met_am_hst_idx1 ON am_metricsdata(am_hst_id);
CREATE INDEX am_met_am_rsc_idx1 ON am_metricsdata(am_rsc_id);
CREATE INDEX am_met_am_src_idx1 ON am_metricsdata(am_src_id);
CREATE INDEX am_met_am_cal_idx1 ON am_metricsdata(am_cal_id);
CREATE INDEX am_met_am_tim_idx1 ON am_metricsdata(am_tim_id);


-------------------------------------------------------------------------------------------------------------------------
-- miscelaneous
CREATE TABLE am_pivot AS
WITH ones AS
   (SELECT 0 x FROM dual
    UNION SELECT 1 FROM dual
    UNION SELECT 2 FROM dual
    UNION SELECT 3 FROM dual
    UNION SELECT 4 FROM dual
    UNION SELECT 5 FROM dual
    UNION SELECT 6 FROM dual
    UNION SELECT 7 FROM dual
    UNION SELECT 8 FROM dual
    UNION SELECT 9 FROM dual)
    SELECT 100000*o100000.x + 10000*o10000.x + 1000*o1000.x + 100*o100.x + 10*o10.x + o1.x x
    FROM ones o1, ones o10, ones o100, ones o1000, ones o10000, ones o100000;


-------------------------------------------------------------------------------------------------------------------------
-- create views

CREATE OR REPLACE VIEW vam_metricsdata AS
SELECT ama.am_arf_id, ama.artifactname, ama.artifactcode, 
       amt.am_mty_id, amt.metricname, amt.metriccode, amt.unit,
       ami.am_ins_id, ami.instancename, ami.instancecode, ami.url,
       amh.am_hst_id, amh.hostname, amh.hostcode, amh.hostip,
       amr.am_rsc_id, amr.resourcename, amr.resourcecode,
       ams.am_src_id, ams.sourcename, ams.sourcecode,
       amm.metricvalue, amm.ts, amm.loadts
FROM  am_metricsdata amm, 
      am_metrictype amt, am_instance ami, am_host amh, am_resource amr, am_source ams, 
      am_artifact ama
WHERE amm.am_ins_id = ami.am_ins_id
AND   amm.am_hst_id = amh.am_hst_id
AND   amm.am_rsc_id = amr.am_rsc_id
AND   amm.am_src_id = ams.am_src_id
--
AND   amt.am_arf_id = ama.am_arf_id
AND   ami.am_arf_id = ama.am_arf_id
AND   amr.am_mty_id = amt.am_mty_id
AND   ams.am_mty_id = amt.am_mty_id;

CREATE OR REPLACE VIEW vam_metricsdata_cal AS
SELECT ama.am_arf_id, ama.artifactname, ama.artifactcode, 
       amt.am_mty_id, amt.metricname, amt.metriccode, amt.unit,
       ami.am_ins_id, ami.instancename, ami.instancecode, ami.url,
       amh.am_hst_id, amh.hostname, amh.hostcode, amh.hostip,
       amr.am_rsc_id, amr.resourcename, amr.resourcecode,
       ams.am_src_id, ams.sourcename, ams.sourcecode,
       amm.metricvalue, amm.ts, amm.loadts,
       amc.year, amc.month, amc.day, amc.week_day, amc.year_day, amc.quarter, amc.week_of_year, amti.hour, amti.minute
FROM  am_metricsdata amm, 
      am_metrictype amt, am_instance ami, am_host amh, am_resource amr, am_source ams, 
      am_artifact ama,
      am_calendar amc, am_time amti
WHERE amm.am_ins_id = ami.am_ins_id
AND   amm.am_hst_id = amh.am_hst_id
AND   amm.am_rsc_id = amr.am_rsc_id
AND   amm.am_src_id = ams.am_src_id
--
AND   amt.am_arf_id = ama.am_arf_id
AND   ami.am_arf_id = ama.am_arf_id
AND   amr.am_mty_id = amt.am_mty_id
AND   ams.am_mty_id = amt.am_mty_id
-- 
AND   amm.am_cal_id = amc.am_cal_id
AND   amm.am_tim_id = amti.am_tim_id;

-------------------------------------------------------------------------------------------------------------------------
-- fill the static dimension - up to 2020
INSERT INTO am_calendar(am_cal_id, caldate, YEAR, MONTH, DAY, week_day, year_day, quarter, week_of_year)
  SELECT am_cal_seq.NEXTVAL,
         caldate,
         to_char(caldate, 'YYYY'),
         to_char(caldate, 'MM'),
         to_char(caldate, 'DD'),
         to_char(caldate, 'D'),
         to_char(caldate, 'DDD'),
         to_char(caldate, 'Q'),
         to_char(caldate, 'WW') --to_char(caldate, 'IW')
  FROM   (SELECT to_date('2007-01-01', 'YYYY-MM-DD') + x AS caldate
          FROM   pivot p
          WHERE  p.x < 13 * 365.25 -- 0.25 - 1 day for every forth year
          ORDER  BY 1);
INSERT INTO am_time(am_tim_id, t, hour, minute)
  SELECT am_tim_seq.NEXTVAL,
         t,
         to_char(t, 'HH24'),
         to_char(t, 'MI')
  FROM   (SELECT to_date('1970-01-01', 'YYYY-MM-DD') + x / (24*60)  AS t
          FROM   pivot p
          WHERE  p.x < 24*60
          ORDER  BY 1);
COMMIT;

-- fill up default data for not dynamic dimensions
-- OS, AppMet, Rep, JVM, DB, HW
INSERT INTO am_artifact(am_arf_id, artifactname, artifactcode) VALUES(am_arf_seq.NEXTVAL, 'Operating System', 'OS'); 
INSERT INTO am_artifact(am_arf_id, artifactname, artifactcode) VALUES(am_arf_seq.NEXTVAL, 'Application', 'APP'); 
INSERT INTO am_artifact(am_arf_id, artifactname, artifactcode) VALUES(am_arf_seq.NEXTVAL, 'Report', 'REP'); 
INSERT INTO am_artifact(am_arf_id, artifactname, artifactcode) VALUES(am_arf_seq.NEXTVAL, 'Java Virtual Machine', 'JVM'); 
INSERT INTO am_artifact(am_arf_id, artifactname, artifactcode) VALUES(am_arf_seq.NEXTVAL, 'Database', 'DB'); 
INSERT INTO am_artifact(am_arf_id, artifactname, artifactcode) VALUES(am_arf_seq.NEXTVAL, 'Hardware', 'HW'); 
COMMIT;

INSERT INTO am_metrictype(am_mty_id, am_arf_id, metricname, metriccode, unit) VALUES(am_mty_seq.NEXTVAL, (SELECT aa.am_arf_id FROM am_artifact aa WHERE aa.artifactcode = 'APP'), 'Struts Action Class', 'ACTCLS', 'ms'); 
INSERT INTO am_metrictype(am_mty_id, am_arf_id, metricname, metriccode) VALUES(am_mty_seq.NEXTVAL, (SELECT aa.am_arf_id FROM am_artifact aa WHERE aa.artifactcode = 'APP'), 'Service Level Check', 'APPSLC'); 
INSERT INTO am_metrictype(am_mty_id, am_arf_id, metricname, metriccode) VALUES(am_mty_seq.NEXTVAL, (SELECT aa.am_arf_id FROM am_artifact aa WHERE aa.artifactcode = 'REP'), 'Report Jobs Execs', 'REPEXE'); 
COMMIT;

INSERT INTO am_instance(am_ins_id, am_arf_id, instancename, instancecode) VALUES(am_ins_seq.NEXTVAL, (SELECT aa.am_arf_id FROM am_artifact aa WHERE aa.artifactcode = 'APP'), 'Petstore', 'PETSTR'); 
INSERT INTO am_instance(am_ins_id, am_arf_id, instancename, instancecode) VALUES(am_ins_seq.NEXTVAL, (SELECT aa.am_arf_id FROM am_artifact aa WHERE aa.artifactcode = 'REP'), 'Petstore Reports', 'PETREP'); 
COMMIT;

INSERT INTO am_host(am_hst_id, hostname, hostcode, hostip) VALUES(am_hst_seq.NEXTVAL, 'Example Host', 'EXPHST', '123.123.123.123'); 
COMMIT;

-------------------------------------------------------------------------------------------------------------------------
-- check data

SELECT COUNT(*) FROM am_calendar;
SELECT COUNT(*) FROM am_time;
SELECT COUNT(*) FROM am_artifact;

SELECT COUNT(*) FROM am_metricsdata;

SELECT COUNT(*) FROM vam_metricsdata;


SELECT vm.artifactname, vm.metricname, vm.unit, vm.resourcename, COUNT(*), AVG(vm.metricvalue), COUNT(*) * SUM(vm.metricvalue) AS perfcoef
FROM vam_metricsdata vm 
GROUP BY vm.artifactname, vm.metricname, vm.unit, vm.resourcename
ORDER BY 1, 2, 3, 4;

SELECT vm.artifactname, vm.hostname, vm.metricname, COUNT(*), AVG(vm.metricvalue)
FROM vam_metricsdata vm 
GROUP BY vm.artifactname, vm.hostname, vm.metricname
ORDER BY 1, 2, 3;

SELECT vmc.artifactname, vmc.metricname, vmc.unit, vmc.year, vmc.month, vmc.day, vmc.hour, COUNT(*), AVG(vmc.metricvalue)
FROM vam_metricsdata_cal vmc
GROUP BY vmc.artifactname, vmc.metricname, vmc.unit, vmc.year, vmc.month, vmc.day, vmc.hour
ORDER BY 1, 2, 3, 4, 5, 6, 7;

SELECT vmc.artifactname, vmc.metricname, vmc.unit, vmc.hour, COUNT(*), AVG(vmc.metricvalue)
FROM vam_metricsdata_cal vmc
GROUP BY vmc.artifactname, vmc.metricname, vmc.unit, vmc.hour
ORDER BY 1, 2, 3, 4;

-------------------------------------------------------------------------------------------------------------------------
-- rebuild indexes - advisable after heavy loading

--SELECT 'ALTER INDEX '||ai.Index_Name||' REBUILD UNRECOVERABLE;' FROM All_Indexes ai WHERE ai.Index_Name LIKE 'AM_%'

ALTER INDEX AM_ARF_PK REBUILD UNRECOVERABLE;
ALTER INDEX AM_ARF_UK1 REBUILD UNRECOVERABLE;
ALTER INDEX AM_MTY_PK REBUILD UNRECOVERABLE;
ALTER INDEX AM_INS_PK REBUILD UNRECOVERABLE;
ALTER INDEX AM_HST_PK REBUILD UNRECOVERABLE;
ALTER INDEX AM_RSC_PK REBUILD UNRECOVERABLE;
ALTER INDEX AM_RSC_UK1 REBUILD UNRECOVERABLE;
ALTER INDEX AM_RSC_UK2 REBUILD UNRECOVERABLE;
ALTER INDEX AM_SRC_PK REBUILD UNRECOVERABLE;
ALTER INDEX AM_SRC_UK1 REBUILD UNRECOVERABLE;
ALTER INDEX AM_SRC_UK2 REBUILD UNRECOVERABLE;
ALTER INDEX AM_CAL_UK1 REBUILD UNRECOVERABLE;
ALTER INDEX AM_CAL_UK2 REBUILD UNRECOVERABLE;
ALTER INDEX AM_CAL_IDX1 REBUILD UNRECOVERABLE;
ALTER INDEX AM_TIM_PK REBUILD UNRECOVERABLE;
ALTER INDEX AM_TIM_UK1 REBUILD UNRECOVERABLE;
ALTER INDEX AM_MET_PK REBUILD UNRECOVERABLE;
ALTER INDEX AM_MET_AM_INS_IDX1 REBUILD UNRECOVERABLE;
ALTER INDEX AM_MET_AM_HST_IDX1 REBUILD UNRECOVERABLE;
ALTER INDEX AM_MET_AM_RSC_IDX1 REBUILD UNRECOVERABLE;
ALTER INDEX AM_MET_AM_SRC_IDX1 REBUILD UNRECOVERABLE;
ALTER INDEX AM_MET_AM_CAL_IDX1 REBUILD UNRECOVERABLE;
ALTER INDEX AM_MET_AM_TIM_IDX1 REBUILD UNRECOVERABLE;
ALTER INDEX AM_CAL_PK REBUILD UNRECOVERABLE;