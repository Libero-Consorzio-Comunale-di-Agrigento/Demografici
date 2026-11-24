--liquibase formatted sql
--changeset amonopoli:202604011425_1 runOnChange:true stripComments:false
create or replace function f_ANPR_id_rif_ciu
(a_archivio_rif		IN	varchar2
,a_anno_rif		IN	number
,a_numero_rif		IN	number
,a_id_anadoc		IN	number
,a_id_anamsi		IN	number
,a_matricola		IN	number
,a_fascia_fam		IN	number
,a_cod_fam		IN	number
)

return number

IS

w_archivio_rif		varchar2(255) := upper(a_archivio_rif);

w_id_rif 		number;

begin
  if w_archivio_rif like 'MOV%' then
     w_id_rif := a_anno_rif||lpad(a_numero_rif,6,'0');

  elsif w_archivio_rif like 'MSI%' then
     w_id_rif := a_id_anamsi;

  elsif w_archivio_rif like 'DOC%' then
     w_id_rif := a_id_anadoc;
  end if;

  return w_id_rif;
end;
/
