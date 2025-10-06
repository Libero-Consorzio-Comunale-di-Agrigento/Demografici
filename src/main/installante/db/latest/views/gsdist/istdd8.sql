--liquibase formatted sql
--changeset amonopoli:202503211243_1 runOnChange:true stripComments:false
create or replace view istdd8
      (anno, ufficio, atto, natura, des_tipo_atto, cognome_nome, sesso, data_nas, id_atto, data_eve, data_reg, flag_ansc, des_atto)
AS      
select cit.anno, cit.ufficio, cit.atto, cit.natura,
       dta.descrizione,
       cit.cognome_nome, cit.sesso, cit.data_nas,
       cit.id_atto, cit.data_cit, cit.data_reg,
       'N',
       cit.atto||' '||cit.ufficio||'/'||cit.anno
  from civdta dta, civcit cit
 where dta.id = cit.id_civdta
   and cit.id_usecase_ansc is null       
   and cit.natura in ('A','D')
   and cit.cod_rec = 0
UNION
select cit.anno, cit.ufficio, cit.atto, cit.natura,
       t03.descrizione,
       cit.cognome_nome, cit.sesso, cit.data_nas,
       cit.id_atto, cit.data_cit, cit.data_reg,
       'S',
       decode(cit.id_atto_ansc, '', 
         cit.atto||' '||cit.ufficio||'/'||cit.anno,
         cit.id_atto_ansc)
  from anst03 t03, civcit cit
 where t03.id = cit.id_usecase_ansc
   and cit.numero_unico is not null       
   and cit.natura in ('A','D')
   and cit.cod_rec = 0
/
comment on table istdd8 is 'ISTAT - Dati Modello D.8 - Atti di Cittadinanza (view)'
/
 
