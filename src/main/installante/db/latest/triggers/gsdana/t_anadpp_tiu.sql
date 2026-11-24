--liquibase formatted sql
--changeset amonopoli:202511180931_3 runOnChange:true stripComments:false
create or replace trigger ANADPP_TIU
before INSERT
    or UPDATE
on ANADPP
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
      :new.d_data_ult_agg := sysdate;
      :new.version        := nvl(:new.version,0);
   end;
end;
/
