--liquibase formatted sql
--changeset amonopoli:202503260908_1 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE object_data IS
type objtype is record (
nome_oggetto varchar2(128),
tipo_oggetto varchar2(18),
stato_oggetto varchar2(7),
tabella_oggetto varchar2(30),
stato_trigger varchar2(8)
);
type objcurtyp is REF CURSOR return objtype;
procedure open_obj_cv( obj_cv in out objcurtyp);
END;
/
