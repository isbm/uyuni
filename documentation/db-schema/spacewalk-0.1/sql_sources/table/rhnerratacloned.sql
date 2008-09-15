-- created by Oraschemadoc Fri Jun 13 14:05:51 2008
-- visit http://www.yarpen.cz/oraschemadoc/ for more info

  CREATE TABLE "RHNSAT"."RHNERRATACLONED" 
   (	"ORIGINAL_ID" NUMBER CONSTRAINT "RHN_ERRATACLONE_FEID_NN" NOT NULL ENABLE, 
	"ID" NUMBER CONSTRAINT "RHN_ERRATACLONE_TEID_NN" NOT NULL ENABLE, 
	"CREATED" DATE DEFAULT (sysdate) CONSTRAINT "RHN_ERRATACLONE_CREATED_NN" NOT NULL ENABLE, 
	"MODIFIED" DATE DEFAULT (sysdate) CONSTRAINT "RHN_ERRATACLONE_MODIFIED_NN" NOT NULL ENABLE, 
	 CONSTRAINT "RHN_ERRATACLONE_FEID_TEID_UQ" UNIQUE ("ORIGINAL_ID", "ID")
  USING INDEX PCTFREE 10 INITRANS 32 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS"  ENABLE, 
	 CONSTRAINT "RHN_ERRATACLONE_ID_PK" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS"  ENABLE, 
	 CONSTRAINT "RHN_ERRATACLONE_FEID_FK" FOREIGN KEY ("ORIGINAL_ID")
	  REFERENCES "RHNSAT"."RHNERRATA" ("ID") ON DELETE CASCADE ENABLE, 
	 CONSTRAINT "RHN_ERRATACLONE_TEID_FK" FOREIGN KEY ("ID")
	  REFERENCES "RHNSAT"."RHNERRATA" ("ID") ON DELETE CASCADE ENABLE
   ) PCTFREE 10 PCTUSED 40 INITRANS 32 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS" 
 
/
