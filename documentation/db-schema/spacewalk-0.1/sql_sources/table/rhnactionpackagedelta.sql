-- created by Oraschemadoc Fri Jun 13 14:05:49 2008
-- visit http://www.yarpen.cz/oraschemadoc/ for more info

  CREATE TABLE "RHNSAT"."RHNACTIONPACKAGEDELTA" 
   (	"ACTION_ID" NUMBER CONSTRAINT "RHN_ACT_PD_AID_NN" NOT NULL ENABLE, 
	"PACKAGE_DELTA_ID" NUMBER CONSTRAINT "RHN_ACT_PD_PDID_NN" NOT NULL ENABLE, 
	 CONSTRAINT "RHN_ACT_PD_AID_FK" FOREIGN KEY ("ACTION_ID")
	  REFERENCES "RHNSAT"."RHNACTION" ("ID") ON DELETE CASCADE ENABLE, 
	 CONSTRAINT "RHN_ACT_PD_PDID_FK" FOREIGN KEY ("PACKAGE_DELTA_ID")
	  REFERENCES "RHNSAT"."RHNPACKAGEDELTA" ("ID") ON DELETE CASCADE ENABLE
   ) PCTFREE 10 PCTUSED 40 INITRANS 32 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS" 
 
/
