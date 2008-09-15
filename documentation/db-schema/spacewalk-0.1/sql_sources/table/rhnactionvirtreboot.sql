-- created by Oraschemadoc Fri Jun 13 14:05:50 2008
-- visit http://www.yarpen.cz/oraschemadoc/ for more info

  CREATE TABLE "RHNSAT"."RHNACTIONVIRTREBOOT" 
   (	"ACTION_ID" NUMBER CONSTRAINT "RHN_AVREBOOT_AID_NN" NOT NULL ENABLE, 
	"UUID" VARCHAR2(128) CONSTRAINT "RHN_AVREBOOT_UUID_NN" NOT NULL ENABLE, 
	"CREATED" DATE DEFAULT (sysdate) CONSTRAINT "RHN_AVREBOOT_CREAT_NN" NOT NULL ENABLE, 
	"MODIFIED" DATE DEFAULT (sysdate) CONSTRAINT "RHN_AVREBOOT_MOD_NN" NOT NULL ENABLE, 
	 CONSTRAINT "RHN_AVREBOOT_AID_PK" PRIMARY KEY ("ACTION_ID")
  USING INDEX PCTFREE 10 INITRANS 32 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS"  ENABLE, 
	 CONSTRAINT "RHN_AVREBOOT_AID_FK" FOREIGN KEY ("ACTION_ID")
	  REFERENCES "RHNSAT"."RHNACTION" ("ID") ON DELETE CASCADE ENABLE
   ) PCTFREE 10 PCTUSED 40 INITRANS 32 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS" 
 
/
