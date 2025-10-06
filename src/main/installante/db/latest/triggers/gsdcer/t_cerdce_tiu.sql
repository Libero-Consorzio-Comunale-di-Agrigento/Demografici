--liquibase formatted sql
--changeset amonopoli:202412161445 runOnChange:true stripComments:false
create or replace trigger CERDCE_TIU
before INSERT
    or UPDATE
on CERDCE
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   if INSERTING or UPDATING then
      if :new.id_cerctc is not null then
         begin
           select competenza_an_sc
             into :new.competenza 
             from cerctc
            where id = :new.id_cerctc
           ;
         exception
           when others then
                null;
         end;
      end if;
   end if;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/

