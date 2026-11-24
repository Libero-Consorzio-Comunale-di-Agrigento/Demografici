--liquibase formatted sql
--changeset amonopoli:202510211050 runOnChange:true stripComments:false
create or replace trigger ANADTS_TIU
before INSERT
    or UPDATE
on ANADTS
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
      :new.data_ult_agg   := to_char(sysdate,'j');
      :new.d_data_ult_agg := sysdate;
      :new.version        := nvl(:new.version,0);
   end;
end;
/
