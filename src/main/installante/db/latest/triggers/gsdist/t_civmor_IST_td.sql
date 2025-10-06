--liquibase formatted sql
--changeset amonopoli:202302131300_2 runOnChange:true stripComments:false
create or replace trigger CIVMOR_IST_TD
before DELETE
on CIVMOR
for each row
declare
  w_errore	varchar2(4000);
  errore	exception;

w_integrazione_istat	varchar2(1) := f_valore_inp('ISTATEL',1,1,'X','S');

begin
 if nvl(w_integrazione_istat,'N') = 'S' then
  ISTAT_PKG.ins_log('civmor_ist_td',:old.id_atto||' - delete');
  CIVMOR_IST_FI(:old.cod_rec, null,
		:old.ufficio, :old.anno, :old.atto, :old.parte, :old.serie,
		null, null, null, null, null,
		null, null, null,
		null, null,
		null, null,
		null,
                null,
                null);
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
