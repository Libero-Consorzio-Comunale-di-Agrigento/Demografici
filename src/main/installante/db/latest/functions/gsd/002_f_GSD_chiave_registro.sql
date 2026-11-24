--liquibase formatted sql
--changeset amonopoli:202510311115_2 runOnChange:true stripComments:false
create or replace function f_GSD_chiave_registro
(a_tabella_rif	IN	varchar2
)

return varchar2

IS

w_ente    	varchar2(255) := f_GSD_codice_ente();
w_modulo	varchar2(255) := 'DE4GSD';
w_istanza	varchar2(255) := 'GSD';
w_tabella	varchar2(255) := upper(a_tabella_rif);

w_chiave	varchar2(255);

begin
--PRODUCTS/[CODICE_IPA_ENTE]/[CODICE_MODULO]/[CODICE_ISTANZA]{/[TABELLA_APPLICATIVA]...}
  if a_tabella_rif is not null then
     w_chiave := 'PRODUCTS/'||w_ente||'/'||w_modulo||'/'||w_istanza||'/'||w_tabella;
  end if;  

  return w_chiave;

end;
/
