--liquibase formatted sql
--changeset amonopoli:202503050935 runOnChange:true stripComments:false
create or replace function f_get_campo_ANA
(a_matricola		IN	number
,a_campo		IN	varchar2
)

return varchar2

IS

w_campo		varchar2(255) := upper(a_campo);
w_valore	varchar2(255);

begin
  begin
    select decode(w_campo,
             'SESSO', ana.sesso,
             'COGNOME_NOME', ana.cognome_nome,
             'COGNOME_NOME_PD', ana.paternita,
             'COGNOME_NOME_MD', ana.maternita,
             'COGNOME_NOME_CN', ana.cognome_nome_cn
           )
      into w_valore
      from anaana ana
     where ana.matricola = a_matricola
    ;
  exception 
    when others then
         w_valore := '';
  end;

  return w_valore;

end;
/
