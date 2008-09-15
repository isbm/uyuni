-- created by Oraschemadoc Fri Jun 13 14:06:12 2008
-- visit http://www.yarpen.cz/oraschemadoc/ for more info

  CREATE OR REPLACE FUNCTION "RHNSAT"."LOOKUP_PACKAGE_CAPABILITY" (name_in IN VARCHAR2,
    version_in IN VARCHAR2 DEFAULT NULL)
RETURN NUMBER
DETERMINISTIC
IS
	PRAGMA AUTONOMOUS_TRANSACTION;
	name_id		NUMBER;
BEGIN
	IF version_in IS NULL THEN
		SELECT id
		  INTO name_id
		  FROM rhnPackageCapability
		 WHERE name = name_in
		   AND version IS NULL;
	ELSE
		SELECT id
		  INTO name_id
		  FROM rhnPackageCapability
		 WHERE name = name_in
		   AND version = version_in;
	END IF;
	RETURN name_id;
EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO rhnPackageCapability (id, name, version)
                VALUES (rhn_pkg_capability_id_seq.nextval, name_in, version_in)
                RETURNING id INTO name_id;
            COMMIT;
	RETURN name_id;
END;
 
/
