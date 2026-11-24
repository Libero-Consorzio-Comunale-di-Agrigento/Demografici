--liquibase formatted sql
--changeset amonopoli:202606110930_10 runOnChange:true stripComments:false
create or replace function f_ANPR_id_scheda
(a_matricola	IN	number
,a_cod_fiscale  IN	varchar2
,a_fascia_fam 	IN	number
,a_cod_fam	IN	number
,a_tipo_fam	IN	number
,a_tipo_scheda	IN	varchar2 	default NULL
)

return number

IS

w_id_scheda	number;

begin
 if a_tipo_scheda is not null then
     begin
       select id_scheda_anpr
         into w_id_scheda
         from anpads
        where matricola_ads    = a_matricola
          and tipo_scheda_anpr = a_tipo_scheda
          and rownum = 1
       ; 
     exception
       when others then
            w_id_scheda := '';
     end;

 else 

  if a_matricola is not null then
     begin
       select id_scheda_anpr
         into w_id_scheda
         from anpads
        where matricola_ads    = a_matricola
          and tipo_scheda_anpr in ('Individuale','Aire')
          and rownum = 1
       ; 
     exception
       when others then
            w_id_scheda := '';
     end;

  elsif a_cod_fiscale is not null then
     begin
       select id_scheda_anpr
         into w_id_scheda
         from anpads anp, anaana ana
        where anp.tipo_scheda_anpr in ('Individuale','Aire')
          and anp.matricola_ads    = ana.matricola
          and ana.cod_fiscale      = a_cod_fiscale
          and rownum = 1
       ; 
     exception
       when others then
            w_id_scheda := '';
     end;

  else
     if a_tipo_fam is null then
        begin
          select id_scheda_anpr
            into w_id_scheda
            from anpads
           where fascia_ads       = a_fascia_fam
             and cod_fam_ads      = a_cod_fam 
             and tipo_scheda_anpr in ('Famiglia','Famiglia AIRE')
             and id_scheda_anpr   is not null
             and rownum = 1
          ; 
        exception
          when others then
               w_id_scheda := '';
        end;
     elsif a_tipo_fam is not null then
        begin
          select id_scheda_anpr
            into w_id_scheda
            from anpads
           where fascia_ads       = a_fascia_fam
             and cod_fam_ads      = a_cod_fam 
             and tipo_scheda_anpr = 'Convivenza'
             and id_scheda_anpr   is not null
             and rownum = 1
          ; 
        exception
          when others then
               w_id_scheda := '';
        end;
     end if;
  end if;
 end if;

 return w_id_scheda;

end;
/
