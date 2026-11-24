--liquibase formatted sql
--changeset amonopoli:202509021405_2 runOnChange:true stripComments:false
create or replace function f_DOC_d_data_scadenza
(a_tipo_documento	IN	varchar2
,a_d_data_emissione	IN	date
,a_matricola		IN	number
)

return date

IS

w_data_emissione	number;

w_data_sca		number;
w_d_data_sca		date;

begin
  w_data_emissione := to_char(a_d_data_emissione,'j');

  w_data_sca       := f_DOC_data_scadenza(a_tipo_documento,w_data_emissione,a_matricola);

  w_d_data_sca     := to_date(w_data_sca,'j');

  return w_d_data_sca;

end;
/
