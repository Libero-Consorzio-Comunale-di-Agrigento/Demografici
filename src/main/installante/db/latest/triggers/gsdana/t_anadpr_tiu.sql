--liquibase formatted sql
--changeset amonopoli:202510211050 runOnChange:true stripComments:false
create or replace trigger ANADPR_TIU
before INSERT
    or UPDATE
on ANADPR
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
      :new.id             := :new.sesso||lpad(:new.cod_pr,5,'0');
      :new.data_ult_agg   := to_char(sysdate,'j');
      :new.d_data_ult_agg := sysdate;
      :new.version        := nvl(:new.version,0);
   end;
end;
/
