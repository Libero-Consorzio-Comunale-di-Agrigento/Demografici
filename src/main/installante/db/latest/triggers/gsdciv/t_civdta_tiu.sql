--liquibase formatted sql
--changeset amonopoli:202307241200_1 runOnChange:true stripComments:false
create or replace trigger CIVDTA_TIU
before INSERT
    or UPDATE
on CIVDTA
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id := F_CIVDTA_NR(:new.id);
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
     if :new.cod_mi is not null and :new.id_civcta is not null then
        begin 
          update civdmi
             set id_civcta = :new.id_civcta
           where tipo_atto = :new.tipo_atto
             and cod_mi    = :new.cod_mi
          ;
        exception
          when others then
               null;
        end;
     end if;
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
