-- created by Oraschemadoc Fri Jun 13 14:05:54 2008
-- visit http://www.yarpen.cz/oraschemadoc/ for more info

  CREATE TABLE "RHNSAT"."RHNPUSHCLIENT" 
   (	"ID" NUMBER CONSTRAINT "RHN_PCLIENT_ID_NN" NOT NULL ENABLE, 
	"NAME" VARCHAR2(64) CONSTRAINT "RHN_PCLIENT_NAME_NN" NOT NULL ENABLE, 
	"SERVER_ID" NUMBER CONSTRAINT "RHN_PCLIENT_SID_NN" NOT NULL ENABLE, 
	"JABBER_ID" VARCHAR2(128), 
	"SHARED_KEY" VARCHAR2(64) CONSTRAINT "RHN_PCLIENT_SKEY_NN" NOT NULL ENABLE, 
	"STATE_ID" NUMBER CONSTRAINT "RHN_PCLIENT_STID_NN" NOT NULL ENABLE, 
	"NEXT_ACTION_TIME" DATE, 
	"LAST_MESSAGE_TIME" DATE, 
	"LAST_PING_TIME" DATE, 
	"CREATED" DATE DEFAULT sysdate CONSTRAINT "RHN_PCLIENT_CREATED_NN" NOT NULL ENABLE, 
	"MODIFIED" DATE DEFAULT sysdate CONSTRAINT "RHN_PCLIENT_MODIFIED_NN" NOT NULL ENABLE, 
	 CONSTRAINT "RHN_PCLIENT_ID_PK" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS"  ENABLE, 
	 FOREIGN KEY ("STATE_ID")
	  REFERENCES "RHNSAT"."RHNPUSHCLIENTSTATE" ("ID") ENABLE
   ) PCTFREE 10 PCTUSED 40 INITRANS 32 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 16 FREELIST GROUPS 1 BUFFER_POOL DEFAULT)
  TABLESPACE "DATA_TBS" 
 
/
