--liquibase formatted sql
--changeset amonopoli:202502040835_2 runOnChange:true stripComments:false
create or replace trigger CERDTD_WSPA_TD
before DELETE
on CERDTD
for each row
declare

w_integrazione_ws	varchar2(255);

w_operazione_log	varchar2(255) := 'CERDTD_wspa_td';

w_errore	  	varchar2(4000);
errore			exception;

begin
  w_integrazione_ws := f_WSPA_get_flag_ws(); 
  if nvl(w_integrazione_ws,'N') = 'S' then
     begin 
       delete ws_pagamenti_VDC
        where tabella_rif           = 'CERCEM'
          and cod_diritto_rif       = :old.cod_diritto
          and fascia_tariffaria_rif = :old.fascia_tariffaria
       ;
     exception
       when others then
            w_errore := 'errore in del_ws_pagamenti ('||sqlerrm||')';
            raise errore;
     end;
  end if;

exception
  when errore then
       ws_pagamenti_pkg.INS_LOG(w_operazione_log,'errore',w_errore);
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       ws_pagamenti_pkg.INS_LOG(w_operazione_log,'errore',w_errore);
end;
/
