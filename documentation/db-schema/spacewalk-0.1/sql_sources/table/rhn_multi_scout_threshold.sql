-- created by Oraschemadoc Fri Jun 13 14:05:57 2008
-- visit http://www.yarpen.cz/oraschemadoc/ for more info

  CREATE TABLE "RHNSAT"."RHN_MULTI_SCOUT_THRESHOLD" 
   (	"PROBE_ID" NUMBER(12,0) CONSTRAINT "RHN_MSTHR_PROBE_ID_NN" NOT NULL ENABLE, 
	"SCOUT_WARNING_THRESHOLD_IS_ALL" CHAR(1) DEFAULT '1' CONSTRAINT "RHN_MSTHR_WARN_THRES_NN" NOT NULL ENABLE, 
	"SCOUT_CRIT_THRESHOLD_IS_ALL" CHAR(1) DEFAULT '1' CONSTRAINT "RHN_MSTHR_CRIT_THRES_NN" NOT NULL ENABLE, 
	"SCOUT_WARNING_THRESHOLD" NUMBER(12,0), 
	"SCOUT_CRITICAL_THRESHOLD" NUMBER(12,0), 
	 CONSTRAINT "RHN_MSTHR_PROBE_ID_PK" PRIMARY KEY ("PROBE_ID")
  USING INDEX PCTFREE 10 INITRANS 32 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS"  ENABLE
   ) PCTFREE 10 PCTUSED 40 INITRANS 32 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS" 
 
/
