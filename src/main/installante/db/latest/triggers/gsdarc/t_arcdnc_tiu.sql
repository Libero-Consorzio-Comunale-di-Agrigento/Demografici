--liquibase formatted sql
--changeset amonopoli:202603231555_2 runOnChange:true stripComments:false
create or replace trigger ARCDNC_TIU
before INSERT
    or UPDATE
on ARCDNC
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
      :new.id             := F_ARCDNC_NR(:new.id);
      :new.d_data_ult_agg := sysdate;
      :new.version        := nvl(:new.version,0);
   end;
end;
/
