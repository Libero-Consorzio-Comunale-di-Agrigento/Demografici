--liquibase formatted sql
--changeset amonopoli:202503211243_2 runOnChange:true stripComments:false
create or replace view istdd8_nas
      (anno, ufficio, atto, parte, serie, natura, des_tipo_atto, cognome_nome, sesso, data_nas, id_atto, data_reg, flag_ansc, des_atto,
       des_com_nas, sigla_pro_nas, des_com_res, sigla_pro_res)
AS      
select nas.anno, nas.ufficio, nas.atto, nas.parte, nas.serie, nas.natura,
       dta.descrizione,
       nas.cognome_nome, nas.sesso, nas.data_nas,
       nas.id_atto, nas.data_reg,
       'N',
       nas.atto||' '||nas.parte||nas.serie||' '||nas.ufficio||'/'||nas.anno,
       nas.des_com_nas, nas.sigla_pro_nas, nas.des_com_res, nas.sigla_pro_res
  from civcta cta, civdta dta, civnas_v nas
 where cta.sigla in ('TEA','TEP')
   and cta.id = dta.id_civcta
   and dta.id = nas.id_civdta
   and nas.id_usecase_ansc is null       
   and nas.cod_pro_nas > 200 
   and nas.cod_pro_res > 200
   and nas.natura  = 'O'
   and nas.cod_rec = 0
UNION
select nas.anno, nas.ufficio, nas.atto, nas.parte, nas.serie, nas.natura,
       t03.descrizione,
       nas.cognome_nome, nas.sesso, nas.data_nas,
       nas.id_atto, nas.data_reg,
       'S',
       decode(nas.id_atto_ansc, '', 
         nas.atto||' '||nas.parte||nas.serie||' '||nas.ufficio||'/'||nas.anno,
         nas.id_atto_ansc),
       nas.des_com_nas, nas.sigla_pro_nas, nas.des_com_res, nas.sigla_pro_res
  from civcta cta, civdta dta, anst03 t03, civnas_v nas
 where cta.sigla in ('TEA','TEP')
   and cta.id = dta.id_civcta
   and dta.id = nas.id_civdta
   and t03.id = nas.id_usecase_ansc
   and nas.numero_unico is not null       
   and nas.cod_pro_nas > 200 
   and nas.cod_pro_res > 200
   and nas.natura  = 'O'
   and nas.cod_rec = 0
/
comment on table istdd8_nas is 'ISTAT - Dati Modello D.8 - Atti di Nascita (view)'
/
