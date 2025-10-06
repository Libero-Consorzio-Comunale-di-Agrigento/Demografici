--liquibase formatted sql
--changeset amonopoli:202307311155 runOnChange:true stripComments:false
create or replace function f_WDI_get_id_anadoc
(a_matricola      number)

return number

IS

cursor sel_doc is
select doc.id
  from anaddo ddo, anadoc doc
 where ddo.flag_identita     = 'S'
   and ddo.cod_do           = doc.tipo_documento
   and doc.natura_documento != 'A'
   and doc.progr_documento  = 1
   and doc.matricola        = a_matricola
 order by doc.data_emissione desc,
          nvl(doc.data_scadenza,9999999) desc,
          nvl(doc.flag_scadenza_illimitata,'N') desc,
          nvl(doc.data_reg,0000000) desc,
          doc.rowid desc
;

w_id                number;

begin
  open sel_doc;
  fetch sel_doc into w_id;
  close sel_doc;

  return w_id;
end;
/
