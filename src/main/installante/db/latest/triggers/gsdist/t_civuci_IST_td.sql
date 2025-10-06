--liquibase formatted sql
--changeset amonopoli:202312221150_2 runOnChange:true stripComments:false
create or replace trigger CIVUCI_IST_TD
before DELETE
on CIVUCI
for each row
declare
  w_errore	varchar2(4000);
  errore	exception;

w_integrazione_istat	varchar2(1) := f_valore_inp('ISTATEL',1,1,'X','S');

begin
--
-- 18/01/2024 (AM): gestito UPDATE di comune matrimonio (rif. CIVUCI_IST_FI)
--

 if nvl(w_integrazione_istat,'N') = 'S' then
  ISTAT_PKG.ins_log('civuci_ist_td',:old.id_atto||' - delete');
  CIVUCI_IST_FI(:old.cod_rec,:old.natura,:old.ufficio,:old.anno,:old.atto,:old.parte,:old.serie,
 		null,null,
		null,null,null,null,null,null,
		null,null,null,null,null,null,
		null,null,:old.id_atto,
                null,null	--a_cod_pro_mat_old,a_cod_com_mat_old
               );
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
