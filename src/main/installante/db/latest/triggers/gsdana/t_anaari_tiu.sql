--liquibase formatted sql
--changeset amonopoli:202509101145_2 runOnChange:true stripComments:false
create or replace trigger ANAARI_TIU
before INSERT
    or UPDATE
on ANAARI
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id           := F_ANAARI_NR(:new.id);
     :new.version      := nvl(:new.version,0);
     :new.data_reg     := nvl(:new.data_reg,to_char(sysdate,'j'));
     :new.d_data_reg   := nvl(:new.d_data_reg,sysdate);
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ANAARI_TIU */
/
