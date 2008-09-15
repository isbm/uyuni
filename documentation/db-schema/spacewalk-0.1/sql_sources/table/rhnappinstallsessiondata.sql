-- created by Oraschemadoc Fri Jun 13 14:05:50 2008
-- visit http://www.yarpen.cz/oraschemadoc/ for more info

  CREATE TABLE "RHNSAT"."RHNAPPINSTALLSESSIONDATA" 
   (	"ID" NUMBER CONSTRAINT "RHN_APPINST_SDATA_ID_NN" NOT NULL ENABLE, 
	"SESSION_ID" NUMBER CONSTRAINT "RHN_APPINST_SDATA_SID_NN" NOT NULL ENABLE, 
	"KEY" VARCHAR2(64) CONSTRAINT "RHN_APPINST_SDATA_K_NN" NOT NULL ENABLE, 
	"VALUE" VARCHAR2(2048), 
	"EXTRA_DATA" BLOB, 
	"CREATED" DATE DEFAULT (sysdate) CONSTRAINT "RHN_APPINST_SDATA_CREAT_NN" NOT NULL ENABLE, 
	"MODIFIED" DATE DEFAULT (sysdate) CONSTRAINT "RHN_APPINST_SDATA_MOD_NN" NOT NULL ENABLE, 
	 CONSTRAINT "RHN_APPINST_SDATA_ID_PK" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 32 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS"  ENABLE, 
	 CONSTRAINT "RHN_APPINST_SDATA_SID_K_UQ" UNIQUE ("SESSION_ID", "KEY")
  USING INDEX PCTFREE 10 INITRANS 32 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS"  ENABLE, 
	 CONSTRAINT "RHN_APPINST_SDATA_SID_FK" FOREIGN KEY ("SESSION_ID")
	  REFERENCES "RHNSAT"."RHNAPPINSTALLSESSION" ("ID") ON DELETE CASCADE ENABLE
   ) PCTFREE 10 PCTUSED 40 INITRANS 32 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS" 
 LOB ("EXTRA_DATA") STORE AS (
  TABLESPACE "DATA_TBS" ENABLE STORAGE IN ROW CHUNK 8192 PCTVERSION 10
  NOCACHE LOGGING 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)) 
 
/
