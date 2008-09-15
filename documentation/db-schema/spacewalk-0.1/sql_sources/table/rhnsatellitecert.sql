-- created by Oraschemadoc Fri Jun 13 14:05:54 2008
-- visit http://www.yarpen.cz/oraschemadoc/ for more info

  CREATE TABLE "RHNSAT"."RHNSATELLITECERT" 
   (	"LABEL" VARCHAR2(64) CONSTRAINT "RHN_SATCERT_LABEL_NN" NOT NULL ENABLE, 
	"VERSION" NUMBER, 
	"CERT" BLOB CONSTRAINT "RHN_SATCERT_CERT_NN" NOT NULL ENABLE, 
	"ISSUED" DATE DEFAULT (sysdate), 
	"EXPIRES" DATE DEFAULT (sysdate), 
	"CREATED" DATE DEFAULT (sysdate) CONSTRAINT "RHN_SATCERT_CREATED_NN" NOT NULL ENABLE, 
	"MODIFIED" DATE DEFAULT (sysdate) CONSTRAINT "RHN_SATCERT_MODIFIED_NN" NOT NULL ENABLE
   ) PCTFREE 10 PCTUSED 40 INITRANS 32 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS" 
 LOB ("CERT") STORE AS (
  TABLESPACE "DATA_TBS" ENABLE STORAGE IN ROW CHUNK 8192 PCTVERSION 10
  NOCACHE LOGGING 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)) 
 
/
