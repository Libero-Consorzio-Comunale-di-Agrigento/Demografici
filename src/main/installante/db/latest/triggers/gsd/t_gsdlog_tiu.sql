--liquibase formatted sql
--changeset amonopoli:202506111230_2 runOnChange:true stripComments:false
create or replace trigger GSDLOG_TIU
before INSERT
    or UPDATE
on GSDLOG
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.log_id     := F_GSDLOG_NR(:new.log_id);
     :new.data_reg   := nvl(:new.data_reg,to_char(sysdate,'j'));
     :new.ora_reg    := nvl(:new.ora_reg,to_char(sysdate,'hh24'));
     :new.minuti_reg := nvl(:new.minuti_reg,to_char(sysdate,'mi'));
     :new.d_data_reg := nvl(:new.d_data_reg,sysdate);
     :new.operazione := nvl(:new.operazione,f_GSD_operazione_log(:new.fase));
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
/* End Trigger: GSDLOG_TIU */
/
