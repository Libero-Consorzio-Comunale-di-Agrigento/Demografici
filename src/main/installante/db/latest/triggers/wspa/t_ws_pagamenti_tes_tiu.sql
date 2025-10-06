--liquibase formatted sql
--changeset amonopoli:202501141155_2 runOnChange:true stripComments:false
create or replace trigger WS_PAGAMENTI_TES_TIU
before INSERT or UPDATE
on WS_PAGAMENTI_TES
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
--dbms_output.put_line('dentro il trigger');
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.id := F_WS_PAGAMENTI_TES_NR(:new.id);

   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
     if UPDATING then
        if :old.flag_invio_ws||:old.data_invio_ws||:old.note_ws != :new.flag_invio_ws||:new.data_invio_ws||:new.note_ws then
           begin
             update ws_pagamenti
                set flag_invio_ws   = :new.flag_invio_ws,
                    data_invio_ws   = :new.data_invio_ws,
                    note_ws         = :new.note_ws,
                    d_data_invio_ws = :new.d_data_invio_ws
              where id_ws_pagamenti_tes = :new.id
             ;
           exception
             when others then
                  null;
           end;
        end if;
     end if;

     if :new.data_reg is not null and :new.d_data_reg is null then
        :new.d_data_reg := to_date(:new.data_reg,'j');
     elsif :new.d_data_reg is not null and :new.data_reg is null then
        :new.data_reg := to_char(:new.d_data_reg,'j');
     end if;

     if :new.data_invio_ws is not null and :new.d_data_invio_ws is null then
        :new.d_data_invio_ws := to_date(:new.data_invio_ws,'j');
     elsif :new.d_data_invio_ws is not null and :new.data_invio_ws is null then
        :new.data_invio_ws := to_char(:new.d_data_invio_ws,'j');
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
