--liquibase formatted sql
--changeset amonopoli:202606110930_20    runOnChange:true stripComments:false
create or replace function f_ANPR_id_unico
(a_matricola	IN	number
,a_cod_fiscale  IN	varchar2
)

return varchar2

IS

w_id_unico	varchar2(255);

begin
  if a_matricola is not null then
     begin
       select id_unico_anpr
         into w_id_unico
         from anpads
        where matricola_ads    = a_matricola
          and tipo_scheda_anpr in ('Individuale','Aire')
          and rownum = 1
       ; 
     exception
       when others then
            w_id_unico := '';
     end;

  elsif a_cod_fiscale is not null then
     begin
       select id_unico_anpr
         into w_id_unico
         from anpads anp, anaana ana
        where anp.tipo_scheda_anpr in ('Individuale','Aire')
          and anp.matricola_ads    = ana.matricola
          and ana.cod_fiscale      = a_cod_fiscale
          and rownum = 1
       ; 
     exception
       when others then
            w_id_unico := '';
     end;

 end if;

 return w_id_unico;

end;
/
