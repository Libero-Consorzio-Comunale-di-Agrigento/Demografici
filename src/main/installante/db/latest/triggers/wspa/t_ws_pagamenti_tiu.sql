--liquibase formatted sql
--changeset amonopoli:202501141225_1 runOnChange:true stripComments:false
create or replace trigger WS_PAGAMENTI_TIU
before INSERT
    or UPDATE
on ws_pagamenti
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     if INSERTING then
        if :new.id is null then
           begin
             select ws_pagamenti_sq.nextval
               into :new.id
               from dual
             ;
           exception
             when others then
                  :new.id := '';
           end;
        end if;
        :new.data_reg       := to_char(sysdate,'j');
        :new.d_data_reg     := sysdate;
     end if;

     if UPDATING then
        if :new.data_reg is not null and :new.d_data_reg is null then
           :new.d_data_reg := to_date(:new.data_reg,'j');
        elsif :new.d_data_reg is not null and :new.data_reg is null then
           :new.data_reg   := to_char(:new.d_data_reg,'j');
        end if;

        if :new.data_invio_ws is not null and :new.d_data_invio_ws is null then
           :new.d_data_invio_ws := to_date(:new.data_invio_ws,'j');
        elsif :new.d_data_invio_ws is not null and :new.data_invio_ws is null then
           :new.data_invio_ws   := to_char(:new.d_data_invio_ws,'j');
        end if;
    end if;
   end;

   begin  -- Check REFERENTIAL Integrity on INSERT or UPDATE
     if UPDATING then
        if :old.anno_pagamento||:old.progr_pagamento is null and :new.anno_pagamento||:new.progr_pagamento is not null then
           begin
             insert into ws_pagamenti_tes 
                    (id, anno_pagamento, progr_pagamento, 
                     flag_invio_ws, data_invio_ws, note_ws, 
                     terminalista, data_reg, chiave_provider, url_provider,
                     d_data_reg)
             select ws_pagamenti_tes_sq.nextVal, :new.anno_pagamento, :new.progr_pagamento,
                    :new.flag_invio_ws, :new.data_invio_ws, :new.note_ws, 
                    :new.terminalista, :new.data_reg, :new.chiave_provider, :new.url_provider,
                    :new.d_data_reg
               from dual
              where not exists (select 1 from ws_pagamenti_tes b
                                 where b.anno_pagamento = :new.anno_pagamento
                                   and b.progr_pagamento = :new.progr_pagamento)
             ;
             select id
               into :new.id_ws_pagamenti_tes
               from ws_pagamenti_tes
              where anno_pagamento  = :new.anno_pagamento
                and progr_pagamento = :new.progr_pagamento
                and rownum = 1
             ;
           exception
             when others then
                  null;
           end;
        end if;
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
/* End Trigger: WS_PAGAMENTI_TIU */
/
