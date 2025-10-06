--liquibase formatted sql
--changeset amonopoli:202503211130_2 runOnChange:true stripComments:false
create or replace trigger CIVNAS_IST_TD
before DELETE
on CIVNAS
for each row
declare
  w_errore	varchar2(4000);
  errore	exception;

w_integrazione_istat	varchar2(1) := f_valore_inp('ISTATEL',1,1,'X','S');

begin
 if nvl(w_integrazione_istat,'N') = 'S' then
  ISTAT_PKG.ins_log('civnas_ist_td',:old.id_atto||' - delete');
  CIVNAS_IST_FI(:old.cod_rec,'',
   	        :old.ufficio,:old.anno,:old.atto,:old.parte,:old.serie,
	        '','','','','','','','');
 end if; --if nvl(w_integrazione_istat,'N') = 'S' then

exception
  when errore then
       rollback;
       raise_application_error(-20999, w_errore);
  when others then
       rollback;
       w_errore := 'errore ('||SQLERRM||')';
       raise_application_error(-20999, w_errore);
end;
/
