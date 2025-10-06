--liquibase formatted sql
--changeset amonopoli:202301311250 runOnChange:true
create or replace function f_ctr_word_civ
(a_tipo_atto          	IN  	number,
 a_ufficio		IN	number,
 a_anno			IN	number,
 a_atto			IN	number,
 a_parte		IN	number,
 a_serie		IN	varchar2,
 a_formula		IN	varchar2,
 a_testo		IN      varchar2)

return varchar

IS

w_messaggio	varchar2(32000);

begin

  w_messaggio := '';

  return w_messaggiO;

end;
/
