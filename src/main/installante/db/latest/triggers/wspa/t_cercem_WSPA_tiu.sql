--liquibase formatted sql
--changeset amonopoli:202501141145 runOnChange:true stripComments:false
create or replace trigger CERCEM_WSPA_TIU
before INSERT
    or UPDATE
on CERCEM
for each row
declare

w_integrazione_ws	varchar2(255);
w_flag_wspa             varchar2(255);

w_operazione_log	varchar2(255) := 'cercem_wspa_tiu';

w_errore	  	varchar2(4000);
errore			exception;

begin
  w_integrazione_ws := f_WSPA_get_flag_ws(); 
  if nvl(w_integrazione_ws,'N') = 'S' then
     :new.id := F_CERCEM_NR(:new.id);
     if INSERTING then
        if nvl(:new.SEGRETERIA,0) + nvl(:new.STATO_CIVILE,0) + nvl(:new.CARTA_IDENTITA,0) + nvl(:new.RIMBORSO_ST,0) + nvl(:new.BOLLO,0) > 0 then
           begin
             select flag_wspa
               into w_flag_wspa
               from cerdtp
              where cod_tp = nvl(:new.tipo_pagamento,1)
                and rownum = 1
             ;
           exception
             when others then
                  w_flag_wspa := '';
           end;

           if nvl(w_flag_wspa,'N') = 'S' then
              begin 
                insert into ws_pagamenti
                       (TABELLA_RIF, ANNO_RIF, PROGR_RIF, TERMINALISTA, ID_TABELLA_RIF)
                values ('CERCEM', :new.anno_emissione, :new.progr_emissione, :new.TERMINALISTA, :new.ID)
                ;
              exception
                when others then
                     w_errore := 'errore in ins_ws_pagamenti ('||sqlerrm||')';
                     raise errore;
              end;
           end if;
        end if;

     elsif UPDATING then
        if :old.annullamento is null and :new.annullamento is not null then
           begin
             delete ws_pagamenti
              where tabella_rif = 'CERCEM'
                and anno_rif    = :new.anno_emissione
                and progr_rif   = :new.progr_emissione
                and flag_invio_ws is null
             ;
           exception
             when others then
                  w_errore := 'errore in del_ws_pagamenti ('||sqlerrm||')';
           end;
           begin
             update ws_pagamenti
                set flag_da_annullare = 'S'
              where tabella_rif = 'CERCEM'
                and anno_rif    = :new.anno_emissione
                and progr_rif   = :new.progr_emissione
                and flag_invio_ws is not null
             ;
           exception
            when others then
                  w_errore := 'errore in upd_ws_pagamenti ('||sqlerrm||')';
           end;
        end if;
     end if;
  end if;

exception
  when errore then
       ws_pagamenti_pkg.INS_LOG(w_operazione_log,'errore',w_errore);
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       ws_pagamenti_pkg.INS_LOG(w_operazione_log,'errore',w_errore);
end;
/
