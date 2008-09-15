-- created by Oraschemadoc Fri Jun 13 14:05:56 2008
-- visit http://www.yarpen.cz/oraschemadoc/ for more info

  CREATE TABLE "RHNSAT"."RHNUSERRESERVED" 
   (	"LOGIN" VARCHAR2(64) CONSTRAINT "RHN_USER_RES_LOGIN_NN" NOT NULL ENABLE, 
	"LOGIN_UC" VARCHAR2(64) CONSTRAINT "RHN_USER_RES_LOGIN_UC_NN" NOT NULL ENABLE, 
	"PASSWORD" VARCHAR2(38) CONSTRAINT "RHN_USER_RES_PWD_NN" NOT NULL ENABLE, 
	"CREATED" DATE DEFAULT (sysdate) CONSTRAINT "RHN_USER_RES_CREATED_NN" NOT NULL ENABLE, 
	"MODIFIED" DATE DEFAULT (sysdate) CONSTRAINT "RHN_USER_RES_MODIFIED_NN" NOT NULL ENABLE
   ) PCTFREE 10 PCTUSED 40 INITRANS 32 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS" 
 
/
