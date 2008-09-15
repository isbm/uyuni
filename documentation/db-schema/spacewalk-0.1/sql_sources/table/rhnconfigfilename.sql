-- created by Oraschemadoc Fri Jun 13 14:05:51 2008
-- visit http://www.yarpen.cz/oraschemadoc/ for more info

  CREATE TABLE "RHNSAT"."RHNCONFIGFILENAME" 
   (	"ID" NUMBER CONSTRAINT "RHN_CFNAME_ID_NN" NOT NULL ENABLE, 
	"PATH" VARCHAR2(1024) CONSTRAINT "RHN_CFNAME_PATH_NN" NOT NULL ENABLE, 
	"CREATED" DATE DEFAULT (sysdate) CONSTRAINT "RHN_CFNAME_CREATED_NN" NOT NULL ENABLE, 
	"MODIFIED" DATE DEFAULT (sysdate) CONSTRAINT "RHN_CFNAME_MODIFIED_NN" NOT NULL ENABLE, 
	 CONSTRAINT "RHN_CFNAME_ID_PK" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 32 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS"  ENABLE
   ) PCTFREE 10 PCTUSED 40 INITRANS 32 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS" 
 
/
