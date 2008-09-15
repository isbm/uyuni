-- created by Oraschemadoc Fri Jun 13 14:05:54 2008
-- visit http://www.yarpen.cz/oraschemadoc/ for more info

  CREATE TABLE "RHNSAT"."RHNSERVERDMI" 
   (	"ID" NUMBER CONSTRAINT "RHN_SERVER_DMI_ID_NN" NOT NULL ENABLE, 
	"SERVER_ID" NUMBER CONSTRAINT "RHN_SERVER_DMI_SID_NN" NOT NULL ENABLE, 
	"VENDOR" VARCHAR2(256), 
	"SYSTEM" VARCHAR2(256), 
	"PRODUCT" VARCHAR2(256), 
	"BIOS_VENDOR" VARCHAR2(256), 
	"BIOS_VERSION" VARCHAR2(256), 
	"BIOS_RELEASE" VARCHAR2(256), 
	"ASSET" VARCHAR2(256), 
	"BOARD" VARCHAR2(256), 
	"CREATED" DATE DEFAULT (sysdate) CONSTRAINT "RHN_SERVER_DMI_CREATED_NN" NOT NULL ENABLE, 
	"MODIFIED" DATE DEFAULT (sysdate) CONSTRAINT "RHN_SERVER_DMI_MODIFIED_NN" NOT NULL ENABLE, 
	 CONSTRAINT "RHN_SERVER_DMI_PK" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS"  ENABLE, 
	 CONSTRAINT "RHN_SERVER_DMI_SID_FK" FOREIGN KEY ("SERVER_ID")
	  REFERENCES "RHNSAT"."RHNSERVER" ("ID") ENABLE
   ) PCTFREE 10 PCTUSED 40 INITRANS 32 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS" 
 
/
