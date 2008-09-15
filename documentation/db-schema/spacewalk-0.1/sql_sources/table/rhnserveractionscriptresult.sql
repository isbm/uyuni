-- created by Oraschemadoc Fri Jun 13 14:05:54 2008
-- visit http://www.yarpen.cz/oraschemadoc/ for more info

  CREATE TABLE "RHNSAT"."RHNSERVERACTIONSCRIPTRESULT" 
   (	"SERVER_ID" NUMBER CONSTRAINT "RHN_SERVERAS_RESULT_SID_NN" NOT NULL ENABLE, 
	"ACTION_SCRIPT_ID" NUMBER CONSTRAINT "RHN_SERVERAS_RESULT_ASID_NN" NOT NULL ENABLE, 
	"OUTPUT" BLOB, 
	"START_DATE" DATE CONSTRAINT "RHN_SERVERAS_RESULT_START_NN" NOT NULL ENABLE, 
	"STOP_DATE" DATE CONSTRAINT "RHN_SERVERAS_RESULT_STOP_NN" NOT NULL ENABLE, 
	"RETURN_CODE" NUMBER CONSTRAINT "RHN_SERVERAS_RESULT_RETURN_NN" NOT NULL ENABLE, 
	"CREATED" DATE DEFAULT (sysdate) CONSTRAINT "RHN_SERVERAS_RESULT_CREAT_NN" NOT NULL ENABLE, 
	"MODIFIED" DATE DEFAULT (sysdate) CONSTRAINT "RHN_SERVERAS_RESULT_MOD_NN" NOT NULL ENABLE, 
	 CONSTRAINT "RHN_SERVERAS_RESULT_SID_FK" FOREIGN KEY ("SERVER_ID")
	  REFERENCES "RHNSAT"."RHNSERVER" ("ID") ENABLE, 
	 CONSTRAINT "RHN_SERVERAS_RESULT_ASID_FK" FOREIGN KEY ("ACTION_SCRIPT_ID")
	  REFERENCES "RHNSAT"."RHNACTIONSCRIPT" ("ID") ON DELETE CASCADE ENABLE
   ) PCTFREE 10 PCTUSED 40 INITRANS 32 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS" 
 LOB ("OUTPUT") STORE AS (
  TABLESPACE "DATA_TBS" ENABLE STORAGE IN ROW CHUNK 8192 PCTVERSION 10
  NOCACHE LOGGING 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)) 
 
/
