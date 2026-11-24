--liquibase formatted sql
--changeset amonopoli:202603120935_2 runOnChange:true stripComments:false
create or replace trigger ELETIM_TIU
before INSERT
    or UPDATE
on ELETIM
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
      :new.id             := f_ELETIM_nr(:new.id);
      :new.d_data_ult_agg := sysdate;
   end;
end;
/
