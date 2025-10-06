--liquibase formatted sql
--changeset amonopoli:202311081250_2 runOnChange:true stripComments:false
create or replace function f_ANSC_get_nome_sog
(a_id_soggetto_ansc		IN	number
)

return varchar2

IS

w_nome		varchar2(255);

begin
  begin
    select v.nome
      into w_nome
      from anssog_v v
     where id_soggetto_ansc = a_id_soggetto_ansc
    ;
  exception
    when others then 
         w_nome := '';
  end;

  return w_nome;
end;
/
