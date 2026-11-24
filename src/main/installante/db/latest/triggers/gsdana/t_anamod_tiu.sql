--liquibase formatted sql
--changeset amonopoli:202511261130_2 runOnChange:true stripComments:false
create or replace trigger ANAMOD_TIU
before INSERT
    or UPDATE
on ANAMOD
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id             := F_ANAMOD_NR(:new.tipo_modello,:new.cod_modello);
     :new.d_data_ult_agg := nvl(:new.d_data_ult_agg,sysdate);
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
         null;
   end;

   begin  -- Set FUNCTIONAL Integrity on INSERT or UPDATE
         null;
   end;
exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/
