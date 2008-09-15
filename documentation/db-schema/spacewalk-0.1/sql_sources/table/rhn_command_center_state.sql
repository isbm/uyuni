-- created by Oraschemadoc Fri Jun 13 14:05:56 2008
-- visit http://www.yarpen.cz/oraschemadoc/ for more info

  CREATE TABLE "RHNSAT"."RHN_COMMAND_CENTER_STATE" 
   (	"CUST_ADMIN_ACCESS_ALLOWED" CHAR(1) CONSTRAINT "RHN_CMDCS_ALLOWED_NN" NOT NULL ENABLE, 
	"REASON" VARCHAR2(2000) CONSTRAINT "RHN_CMDCS_REASON_NN" NOT NULL ENABLE, 
	"LAST_UPDATE_USER" VARCHAR2(40) CONSTRAINT "RHN_CMDCS_LAST_USER_NN" NOT NULL ENABLE, 
	"LAST_UPDATE_DATE" DATE CONSTRAINT "RHN_CMDCS_LAST_DATE_NN" NOT NULL ENABLE
   ) PCTFREE 10 PCTUSED 40 INITRANS 32 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS" 
 
/
