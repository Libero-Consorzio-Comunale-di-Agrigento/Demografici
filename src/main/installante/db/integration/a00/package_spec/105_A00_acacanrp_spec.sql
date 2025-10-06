--liquibase formatted sql
--changeset amonopoli:202503261005_1 runOnChange:false stripComments:false
CREATE OR REPLACE package acacanrp is
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO        IN NUMBER);
end;
/
