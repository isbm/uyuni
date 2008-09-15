-- created by Oraschemadoc Fri Jun 13 14:06:03 2008
-- visit http://www.yarpen.cz/oraschemadoc/ for more info

  CREATE INDEX "RHNSAT"."RHN_KSSCRIPT_KSID_POS_IDX" ON "RHNSAT"."RHNKICKSTARTSCRIPT" ("KICKSTART_ID", "POSITION") 
  PCTFREE 10 INITRANS 32 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS" 
 
/
