--liquibase formatted sql
--changeset amonopoli:2023061414735 runAlwasy:true runOnChange:true stripComments:false
create or replace view anssog_v
AS
select id_soggetto_ansc
     , cognome
     , nome
     , sesso
     , d_data_nas
     , cod_pro_nas
     , cod_com_nas
     , f_ANSC_id_comune_al(cod_pro_nas,cod_com_nas,d_data_nas) id_Comune_Nascita
     , f_ANSC_comune_al(cod_pro_nas,cod_com_nas,d_data_nas) nome_Comune_Nascita
     , f_ANSC_id_provincia_al(cod_pro_nas,cod_com_nas,d_data_nas) id_Provincia_Nascita
     , f_ANSC_provincia_al(cod_pro_nas,cod_com_nas,d_data_nas) sigla_Provincia_Nascita
     , f_ANSC_id_stato_al(cod_pro_nas,cod_com_nas,d_data_nas) id_Stato_Nascita
     , f_ANSC_stato_al(cod_pro_nas,cod_com_nas,d_data_nas) nome_Stato_Nascita
  from civnas
 where id_soggetto_ansc is not null
UNION
select id_soggetto_ansc
     , cognome
     , nome
     , sesso
     , d_data_nas
     , cod_pro_nas
     , cod_com_nas
     , f_ANSC_id_comune_al(cod_pro_nas,cod_com_nas,d_data_nas) id_Comune_Nascita
     , f_ANSC_comune_al(cod_pro_nas,cod_com_nas,d_data_nas) nome_Comune_Nascita
     , f_ANSC_id_provincia_al(cod_pro_nas,cod_com_nas,d_data_nas) id_Provincia_Nascita
     , f_ANSC_provincia_al(cod_pro_nas,cod_com_nas,d_data_nas) sigla_Provincia_Nascita
     , f_ANSC_id_stato_al(cod_pro_nas,cod_com_nas,d_data_nas) id_Stato_Nascita
     , f_ANSC_stato_al(cod_pro_nas,cod_com_nas,d_data_nas) nome_Stato_Nascita
  from civmor
 where id_soggetto_ansc is not null
UNION
select id_soggetto_ansc_m
     , cognome_m
     , nome_m
     , 'M'
     , d_data_nas_m
     , cod_pro_nas_m
     , cod_com_nas_m
     , f_ANSC_id_comune_al(cod_pro_nas_m,cod_com_nas_m,d_data_nas_m) id_Comune_Nascita
     , f_ANSC_comune_al(cod_pro_nas_m,cod_com_nas_m,d_data_nas_m) nome_Comune_Nascita
     , f_ANSC_id_provincia_al(cod_pro_nas_m,cod_com_nas_m,d_data_nas_m) id_Provincia_Nascita
     , f_ANSC_provincia_al(cod_pro_nas_m,cod_com_nas_m,d_data_nas_m) sigla_Provincia_Nascita
     , f_ANSC_id_stato_al(cod_pro_nas_m,cod_com_nas_m,d_data_nas_m) id_Stato_Nascita
     , f_ANSC_stato_al(cod_pro_nas_m,cod_com_nas_m,d_data_nas_m) nome_Stato_Nascita
  from civmat
 where id_soggetto_ansc_m is not null
UNION
select id_soggetto_ansc_f
     , cognome_f
     , nome_f
     , 'F'
     , d_data_nas_f
     , cod_pro_nas_f
     , cod_com_nas_f
     , f_ANSC_id_comune_al(cod_pro_nas_f,cod_com_nas_f,d_data_nas_f) id_Comune_Nascita
     , f_ANSC_comune_al(cod_pro_nas_f,cod_com_nas_f,d_data_nas_f) nome_Comune_Nascita
     , f_ANSC_id_provincia_al(cod_pro_nas_f,cod_com_nas_f,d_data_nas_f) id_Provincia_Nascita
     , f_ANSC_provincia_al(cod_pro_nas_f,cod_com_nas_f,d_data_nas_f) sigla_Provincia_Nascita
     , f_ANSC_id_stato_al(cod_pro_nas_f,cod_com_nas_f,d_data_nas_f) id_Stato_Nascita
     , f_ANSC_stato_al(cod_pro_nas_f,cod_com_nas_f,d_data_nas_f) nome_Stato_Nascita
  from civmat
 where id_soggetto_ansc_f is not null
UNION
select id_soggetto_ansc_m
     , cognome_m
     , nome_m
     , sesso_m
     , d_data_nas_m
     , cod_pro_nas_m
     , cod_com_nas_m
     , f_ANSC_id_comune_al(cod_pro_nas_m,cod_com_nas_m,d_data_nas_m) id_Comune_Nascita
     , f_ANSC_comune_al(cod_pro_nas_m,cod_com_nas_m,d_data_nas_m) nome_Comune_Nascita
     , f_ANSC_id_provincia_al(cod_pro_nas_m,cod_com_nas_m,d_data_nas_m) id_Provincia_Nascita
     , f_ANSC_provincia_al(cod_pro_nas_m,cod_com_nas_m,d_data_nas_m) sigla_Provincia_Nascita
     , f_ANSC_id_stato_al(cod_pro_nas_m,cod_com_nas_m,d_data_nas_m) id_Stato_Nascita
     , f_ANSC_stato_al(cod_pro_nas_m,cod_com_nas_m,d_data_nas_m) nome_Stato_Nascita
  from civuci
 where id_soggetto_ansc_m is not null
UNION
select id_soggetto_ansc_f
     , cognome_f
     , nome_f
     , sesso_f
     , d_data_nas_f
     , cod_pro_nas_f
     , cod_com_nas_f
     , f_ANSC_id_comune_al(cod_pro_nas_f,cod_com_nas_f,d_data_nas_f) id_Comune_Nascita
     , f_ANSC_comune_al(cod_pro_nas_f,cod_com_nas_f,d_data_nas_f) nome_Comune_Nascita
     , f_ANSC_id_provincia_al(cod_pro_nas_f,cod_com_nas_f,d_data_nas_f) id_Provincia_Nascita
     , f_ANSC_provincia_al(cod_pro_nas_f,cod_com_nas_f,d_data_nas_f) sigla_Provincia_Nascita
     , f_ANSC_id_stato_al(cod_pro_nas_f,cod_com_nas_f,d_data_nas_f) id_Stato_Nascita
     , f_ANSC_stato_al(cod_pro_nas_f,cod_com_nas_f,d_data_nas_f) nome_Stato_Nascita
  from civuci
 where id_soggetto_ansc_f is not null
UNION
select id_soggetto_ansc
     , cognome
     , nome
     , sesso
     , d_data_nas
     , cod_pro_nas
     , cod_com_nas
     , f_ANSC_id_comune_al(cod_pro_nas,cod_com_nas,d_data_nas) id_Comune_Nascita
     , f_ANSC_comune_al(cod_pro_nas,cod_com_nas,d_data_nas) nome_Comune_Nascita
     , f_ANSC_id_provincia_al(cod_pro_nas,cod_com_nas,d_data_nas) id_Provincia_Nascita
     , f_ANSC_provincia_al(cod_pro_nas,cod_com_nas,d_data_nas) sigla_Provincia_Nascita
     , f_ANSC_id_stato_al(cod_pro_nas,cod_com_nas,d_data_nas) id_Stato_Nascita
     , f_ANSC_stato_al(cod_pro_nas,cod_com_nas,d_data_nas) nome_Stato_Nascita
  from civcit
 where id_soggetto_ansc is not null
/
comment on table anssog_v is 'ANSC - Soggetti ANSC (view)'
/

