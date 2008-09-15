-- created by Oraschemadoc Fri Jun 13 14:05:57 2008
-- visit http://www.yarpen.cz/oraschemadoc/ for more info

  CREATE TABLE "RHNSAT"."RHN_COMMAND_QUEUE_EXECS" 
   (	"INSTANCE_ID" NUMBER(12,0) CONSTRAINT "RHN_CQEXE_INSTANCE_ID_NN" NOT NULL ENABLE, 
	"NETSAINT_ID" NUMBER(12,0) CONSTRAINT "RHN_CQEXE_NETSAINT_ID_NN" NOT NULL ENABLE, 
	"DATE_ACCEPTED" DATE, 
	"DATE_EXECUTED" DATE, 
	"EXIT_STATUS" NUMBER(5,0), 
	"EXECUTION_TIME" NUMBER(10,6), 
	"STDOUT" VARCHAR2(4000), 
	"STDERR" VARCHAR2(4000), 
	"LAST_UPDATE_DATE" DATE, 
	"TARGET_TYPE" VARCHAR2(10) CONSTRAINT "RHN_CQEXE_TARGET_TYPE_NN" NOT NULL ENABLE, 
	 CONSTRAINT "RHN_CQEXE_INST_ID_NSAINT_PK" PRIMARY KEY ("INSTANCE_ID", "NETSAINT_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS"  ENABLE, 
	 CONSTRAINT "RHN_CQEXE_CQINS_INST_ID_FK" FOREIGN KEY ("INSTANCE_ID")
	  REFERENCES "RHNSAT"."RHN_COMMAND_QUEUE_INSTANCES" ("RECID") ON DELETE CASCADE ENABLE, 
	 CONSTRAINT "RHN_CQEXE_SATCL_NSAINT_ID_FK" FOREIGN KEY ("NETSAINT_ID", "TARGET_TYPE")
	  REFERENCES "RHNSAT"."RHN_COMMAND_TARGET" ("RECID", "TARGET_TYPE") ON DELETE CASCADE ENABLE
   ) PCTFREE 10 PCTUSED 40 INITRANS 32 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS" 
 
/
