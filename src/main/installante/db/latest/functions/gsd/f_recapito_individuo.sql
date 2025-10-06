--liquibase formatted sql
--changeset amonopoli:202411191605_1 runOnChange:true stripComments:false
create or replace function f_recapito_individuo
(a_matricola      number
,a_tipo_comunicazione      varchar2)

return varchar2

IS

w_recapito                 varchar2(255);

begin
  if a_tipo_comunicazione in ('S','F') then
     begin
       select ari.numero_telefonico
         into w_recapito
         from anadtr dtr, anaari ari
        where dtr.tipo_comunicazione = a_tipo_comunicazione
          and dtr.cod_tr             = ari.tipo_recapito
          and ari.matricola          = a_matricola
          and rownum                 = 1
       ;
     exception
       when others then
            w_recapito := '';
     end;
  elsif a_tipo_comunicazione in ('E') then
     begin
       select ari.indirizzo_rec
         into w_recapito
         from anadtr dtr, anaari ari
        where dtr.tipo_comunicazione = a_tipo_comunicazione
          and dtr.cod_tr             = ari.tipo_recapito
          and ari.matricola          = a_matricola
          and rownum                 = 1
       ;
     exception
       when others then
            w_recapito := '';
     end;
  end if;

  return w_recapito;
end;
/
