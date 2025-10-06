--liquibase formatted sql
--changeset amonopoli:202503270945_1 runOnChange:false stripComments:false
INSERT INTO si4_REGISTRO 
	( CHIAVE, STRINGA, COMMENTO, VALORE ) 
SELECT 'DB_USERS/'||istanza, 'Dislocazione Loader', NULL, dislocazione||'\ctl'
  from ad4_istanze
 where istanza like 'GSD%'
   and length(istanza) in (3,6)
   and not exists (select 'x' from si4_registro
		    where chiave 	like 'DB_USERS/'||istanza
		      and stringa 	= 'Dislocazione Loader')
/
