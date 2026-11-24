--liquibase formatted sql
--changeset amonopoli:202603171705 runOnChange:true stripComments:false
create or replace view ansana_v_civ_con_cf
AS
select 'CIV_CON_CF_'||v.cod_fiscale ID, v.*
  from (select nas.cognome, nas.nome, nas.sesso, nas.d_data_nas, nas.cod_pro_nas, nas.cod_com_nas,
               f_comune_al(nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas) des_com_nas,
               f_provincia_stato_al(nas.cod_pro_nas,nas.cod_com_nas,'','S','',nas.data_nas) sigla_pro_nas,
               nas.cod_fiscale, nas.data_nas, nas.cognome_nome, nas.cognome_ric, nas.nome_ric,
               nas.cod_rec
          from civnas nas
         where nas.cod_fiscale is not null
           and nas.cod_rec in (5)
        UNION
        select mor.cognome, mor.nome, mor.sesso, mor.d_data_nas, mor.cod_pro_nas, mor.cod_com_nas,
               f_comune_al(mor.cod_pro_nas,mor.cod_com_nas,mor.data_nas) des_com_nas,
               f_provincia_stato_al(mor.cod_pro_nas,mor.cod_com_nas,'','S','',mor.data_nas) sigla_pro_nas,
               mor.cod_fiscale, mor.data_nas, mor.cognome_nome, mor.cognome_ric, mor.nome_ric,
               mor.cod_rec
          from civmor mor
         where mor.cod_fiscale is not null
           and mor.cod_rec in (5)
        UNION
        select mat.cognome_m, mat.nome_m, 'M' sesso, mat.d_data_nas_m, mat.cod_pro_nas_m, mat.cod_com_nas_m,
               f_comune_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.data_nas_m) des_com_nas_m,
               f_provincia_stato_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,'','S','',mat.data_nas_m) sigla_pro_nas_m,
               mat.cod_fiscale_m, mat.data_nas_m, mat.cognome_nome_m, mat.cognome_m_ric, mat.nome_m_ric,
               mat.cod_rec
          from civmat mat
         where mat.cod_fiscale_m is not null
           and mat.cod_rec in (5)
        UNION
        select mat.cognome_f, mat.nome_f, 'F' sesso, mat.d_data_nas_f, mat.cod_pro_nas_f, mat.cod_com_nas_f,
               f_comune_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.data_nas_f) des_com_nas_f,
               f_provincia_stato_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,'','S','',mat.data_nas_f) sigla_pro_nas_f,
               mat.cod_fiscale_f, mat.data_nas_f, mat.cognome_nome_f, mat.cognome_f_ric, mat.nome_f_ric,
               mat.cod_rec
          from civmat mat
         where mat.cod_fiscale_f is not null
           and mat.cod_rec in (5)
        UNION
        select uci.cognome_m, uci.nome_m, uci.sesso_m, uci.d_data_nas_m, uci.cod_pro_nas_m, uci.cod_com_nas_m,
               f_comune_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.data_nas_m) des_com_nas_m,
               f_provincia_stato_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,'','S','',uci.data_nas_m) sigla_pro_nas_m,
               uci.cod_fiscale_m, uci.data_nas_m, uci.cognome_nome_m, uci.cognome_m_ric, uci.nome_m_ric,
               uci.cod_rec
          from civuci uci
         where uci.cod_fiscale_m is not null
           and uci.cod_rec in (5)
        UNION
        select uci.cognome_f, uci.nome_f, uci.sesso_f, uci.d_data_nas_f, uci.cod_pro_nas_f, uci.cod_com_nas_f,
               f_comune_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.data_nas_f) des_com_nas_f,
               f_provincia_stato_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,'','S','',uci.data_nas_f) sigla_pro_nas_f,
               uci.cod_fiscale_f, uci.data_nas_f, uci.cognome_nome_f, uci.cognome_f_ric, uci.nome_f_ric,
               uci.cod_rec
          from civuci uci
         where uci.cod_fiscale_f is not null
           and uci.cod_rec in (5)
        UNION
        select cit.cognome, cit.nome, cit.sesso, cit.d_data_nas, cit.cod_pro_nas, cit.cod_com_nas,
               f_comune_al(cit.cod_pro_nas,cit.cod_com_nas,cit.data_nas) des_com_nas,
               f_provincia_stato_al(cit.cod_pro_nas,cit.cod_com_nas,'','S','',cit.data_nas) sigla_pro_nas,
               cit.cod_fiscale, cit.data_nas, cit.cognome_nome, cit.cognome_ric, cit.nome_ric,
               cit.cod_rec
          from civcit cit
         where cit.cod_fiscale is not null
           and cit.cod_rec in (5)) v
/
create or replace view ansana_v_civ_senza_cf
AS
select 'CIV_SENZA_CF_'||v.cognome||'-'||v.nome||'-'||v.sesso||'-'||v.d_data_nas||'-'||v.cod_pro_nas||'-'||v.cod_com_nas ID, v.*
  from (select nas.cognome, nas.nome, nas.sesso, nas.d_data_nas, nas.cod_pro_nas, nas.cod_com_nas,
               f_comune_al(nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas) des_com_nas,
               f_provincia_stato_al(nas.cod_pro_nas,nas.cod_com_nas,'','S','',nas.data_nas) sigla_pro_nas,
               nas.cod_fiscale, nas.data_nas, nas.cognome_nome, nas.cognome_ric, nas.nome_ric,
               nas.cod_rec
          from civnas nas
         where nas.cod_fiscale is null
           and nas.cod_rec in (5)
        UNION
        select mor.cognome, mor.nome, mor.sesso, mor.d_data_nas, mor.cod_pro_nas, mor.cod_com_nas,
               f_comune_al(mor.cod_pro_nas,mor.cod_com_nas,mor.data_nas) des_com_nas,
               f_provincia_stato_al(mor.cod_pro_nas,mor.cod_com_nas,'','S','',mor.data_nas) sigla_pro_nas,
               mor.cod_fiscale, mor.data_nas, mor.cognome_nome, mor.cognome_ric, mor.nome_ric,
               mor.cod_rec
          from civmor mor
         where mor.cod_fiscale is null
           and mor.cod_rec in (5)
        UNION
        select mat.cognome_m, mat.nome_m, 'M' sesso, mat.d_data_nas_m, mat.cod_pro_nas_m, mat.cod_com_nas_m,
               f_comune_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.data_nas_m) des_com_nas_m,
               f_provincia_stato_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,'','S','',mat.data_nas_m) sigla_pro_nas_m,
               mat.cod_fiscale_m, mat.data_nas_m, mat.cognome_nome_m, mat.cognome_m_ric, mat.nome_m_ric,
               mat.cod_rec
          from civmat mat
         where mat.cod_fiscale_m is null
           and mat.cod_rec in (5)
        UNION
        select mat.cognome_f, mat.nome_f, 'F' sesso, mat.d_data_nas_f, mat.cod_pro_nas_f, mat.cod_com_nas_f,
               f_comune_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.data_nas_f) des_com_nas_f,
               f_provincia_stato_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,'','S','',mat.data_nas_f) sigla_pro_nas_f,
               mat.cod_fiscale_f, mat.data_nas_f, mat.cognome_nome_f, mat.cognome_f_ric, mat.nome_f_ric,
               mat.cod_rec
          from civmat mat
         where mat.cod_fiscale_f is null
           and mat.cod_rec in (5)
        UNION
        select uci.cognome_m, uci.nome_m, uci.sesso_m, uci.d_data_nas_m, uci.cod_pro_nas_m, uci.cod_com_nas_m,
               f_comune_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.data_nas_m) des_com_nas_m,
               f_provincia_stato_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,'','S','',uci.data_nas_m) sigla_pro_nas_m,
               uci.cod_fiscale_m, uci.data_nas_m, uci.cognome_nome_m, uci.cognome_m_ric, uci.nome_m_ric,
               uci.cod_rec
          from civuci uci
         where uci.cod_fiscale_m is null
           and uci.cod_rec in (5)
        UNION
        select uci.cognome_f, uci.nome_f, uci.sesso_f, uci.d_data_nas_f, uci.cod_pro_nas_f, uci.cod_com_nas_f,
               f_comune_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.data_nas_f) des_com_nas_f,
               f_provincia_stato_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,'','S','',uci.data_nas_f) sigla_pro_nas_f,
               uci.cod_fiscale_f, uci.data_nas_f, uci.cognome_nome_f, uci.cognome_f_ric, uci.nome_f_ric,
               uci.cod_rec
          from civuci uci
         where uci.cod_fiscale_f is null
           and uci.cod_rec in (5)
        UNION
        select cit.cognome, cit.nome, cit.sesso, cit.d_data_nas, cit.cod_pro_nas, cit.cod_com_nas,
               f_comune_al(cit.cod_pro_nas,cit.cod_com_nas,cit.data_nas) des_com_nas,
               f_provincia_stato_al(cit.cod_pro_nas,cit.cod_com_nas,'','S','',cit.data_nas) sigla_pro_nas,
               cit.cod_fiscale, cit.data_nas, cit.cognome_nome, cit.cognome_ric, cit.nome_ric,
               cit.cod_rec
          from civcit cit
         where cit.cod_fiscale is null
           and cit.cod_rec in (5)) v
/
create or replace view ansana_v 
AS
select 'CIV' archivio
     , 'Stato Civile'||decode(civ.cod_rec,5,' (ANSC)') des_archivio
     , civ.id
     , civ.cognome
     , civ.nome
     , civ.sesso
     , civ.d_data_nas
     , civ.cod_pro_nas
     , civ.cod_com_nas
     , civ.des_com_nas
     , civ.sigla_pro_nas
     , civ.cod_fiscale
     , to_char(null) cf_calcolato
     , to_char(null) stato_civile
     , to_char(null) des_stato_civile
     , to_char(null) nazionalita
     , to_number(null) cod_pro_res
     , to_number(null) cod_com_res
     , to_char(null) des_com_res
     , to_char(null) sigla_pro_res
     , to_char(null) indirizzo_res
     , to_char(null) cap_res
     , decode(civ.cod_rec, 5, 'Provenienza: ANSC',
         f_GSD_des_stato_ana_x_civ(civ.cognome,civ.nome,civ.sesso,civ.d_data_nas,civ.cod_pro_nas,civ.cod_com_nas)) des_stato_ana
     , to_number(null) fascia_ana
     , to_number(null) matricola_ana
     , to_number(null) id_soggetto_anpr
     , to_char(null) id_unico_anpr
     , civ.cognome_ric cognome_ric
     , civ.nome_ric nome_ric
  from ansana_v_civ_con_cf civ
UNION
select /*+ RULE*/ 'CIV' archivio
     , 'Stato Civile'||decode(civ.cod_rec,5,' (ANSC)') des_archivio
     , civ.id
     , civ.cognome
     , civ.nome
     , civ.sesso
     , civ.d_data_nas
     , civ.cod_pro_nas
     , civ.cod_com_nas
     , civ.des_com_nas
     , civ.sigla_pro_nas
     , civ.cod_fiscale
     , to_char(null) cf_calcolato
     , to_char(null) stato_civile
     , to_char(null) des_stato_civile
     , to_char(null) nazionalita
     , to_number(null) cod_pro_res
     , to_number(null) cod_com_res
     , to_char(null) des_com_res
     , to_char(null) sigla_pro_res
     , to_char(null) indirizzo_res
     , to_char(null) cap_res
     , decode(civ.cod_rec, 5, 'Provenienza: ANSC',
         f_GSD_des_stato_ana_x_civ(civ.cognome,civ.nome,civ.sesso,civ.d_data_nas,civ.cod_pro_nas,civ.cod_com_nas)) des_stato_ana
     , to_number(null) fascia_ana
     , to_number(null) matricola_ana
     , to_number(null) id_soggetto_anpr
     , to_char(null) id_unico_anpr
     , civ.cognome_ric cognome_ric
     , civ.nome_ric nome_ric
  from ansana_v_civ_senza_cf civ
 where not exists (select 1 from ansana_v_civ_con_cf b
                    where b.cognome     = civ.cognome
                      and b.nome        = civ.nome
                      and b.sesso       = civ.sesso
                      and b.data_nas    = civ.data_nas
                      and b.cod_pro_nas = civ.cod_pro_nas
                      and b.cod_com_nas = civ.cod_com_nas)
/
comment on table ANSANA_V is 'Servizi Demografici - Soggetti da Atti ANSC (view)'
/
