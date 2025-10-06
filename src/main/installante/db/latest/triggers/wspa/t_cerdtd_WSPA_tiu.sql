--liquibase formatted sql
--changeset amonopoli:202502040835_1 runOnChange:true stripComments:false
create or replace trigger CERDTD_WSPA_TIU
before INSERT
    or UPDATE
on CERDTD
for each row
declare

w_integrazione_ws	varchar2(255);

w_operazione_log	varchar2(255) := 'CERDTD_wspa_tiu';

w_errore	  	varchar2(4000);
errore			exception;

begin
  w_integrazione_ws := f_WSPA_get_flag_ws(); 
  if nvl(w_integrazione_ws,'N') = 'S' then
     if INSERTING then
        begin 
          insert into ws_pagamenti_VDC
                 (TABELLA_RIF, COD_DIRITTO_RIF, FASCIA_TARIFFARIA_RIF)
          select 'CERCEM', :new.cod_diritto, :new.fascia_tariffaria
            from dual
           where not exists (select 1 from ws_pagamenti_vdc b
                              where b.tabella_rif           = 'CERCEM'
                                and b.cod_diritto_rif       = :new.cod_diritto
                                and b.fascia_tariffaria_rif = :new.fascia_tariffaria)
          ;
        exception
          when others then
               w_errore := 'errore in ins_ws_pagamenti ('||sqlerrm||')';
               raise errore;
        end;
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
