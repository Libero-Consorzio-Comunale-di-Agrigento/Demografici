--liquibase formatted sql
--changeset amonopoli:202312211005_4 runOnChange:true stripComments:false
create or replace view gsdana_v_civ_con_cf
AS
select 'CIV_CON_CF_'||v.cod_fiscale ID, v.*
  from (select nas.cognome, nas.nome, nas.sesso, nas.d_data_nas, nas.cod_pro_nas, nas.cod_com_nas,
               f_comune_al(nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas) des_com_nas,
               f_provincia_stato_al(nas.cod_pro_nas,nas.cod_com_nas,'','S','',nas.data_nas) sigla_pro_nas,
               nas.cod_fiscale, nas.data_nas, nas.cognome_nome, nas.cognome_ric, nas.nome_ric,
               nas.cod_rec
          from civnas nas
         where nas.cod_fiscale is not null
           and nas.cod_rec in (0,3,5)
        UNION
        select mor.cognome, mor.nome, mor.sesso, mor.d_data_nas, mor.cod_pro_nas, mor.cod_com_nas,
               f_comune_al(mor.cod_pro_nas,mor.cod_com_nas,mor.data_nas) des_com_nas,
               f_provincia_stato_al(mor.cod_pro_nas,mor.cod_com_nas,'','S','',mor.data_nas) sigla_pro_nas,
               mor.cod_fiscale, mor.data_nas, mor.cognome_nome, mor.cognome_ric, mor.nome_ric,
               mor.cod_rec
          from civmor mor
         where mor.cod_fiscale is not null
           and mor.cod_rec in (0,3,5)
        UNION
        select mat.cognome_m, mat.nome_m, 'M' sesso, mat.d_data_nas_m, mat.cod_pro_nas_m, mat.cod_com_nas_m,
               f_comune_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.data_nas_m) des_com_nas_m,
               f_provincia_stato_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,'','S','',mat.data_nas_m) sigla_pro_nas_m,
               mat.cod_fiscale_m, mat.data_nas_m, mat.cognome_nome_m, mat.cognome_m_ric, mat.nome_m_ric,
               mat.cod_rec
          from civmat mat
         where mat.cod_fiscale_m is not null
           and mat.cod_rec in (0,3,5)
        UNION
        select mat.cognome_f, mat.nome_f, 'F' sesso, mat.d_data_nas_f, mat.cod_pro_nas_f, mat.cod_com_nas_f,
               f_comune_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.data_nas_f) des_com_nas_f,
               f_provincia_stato_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,'','S','',mat.data_nas_f) sigla_pro_nas_f,
               mat.cod_fiscale_f, mat.data_nas_f, mat.cognome_nome_f, mat.cognome_f_ric, mat.nome_f_ric,
               mat.cod_rec
          from civmat mat
         where mat.cod_fiscale_f is not null
           and mat.cod_rec in (0,3,5)
        UNION
        select uci.cognome_m, uci.nome_m, uci.sesso_m, uci.d_data_nas_m, uci.cod_pro_nas_m, uci.cod_com_nas_m,
               f_comune_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.data_nas_m) des_com_nas_m,
               f_provincia_stato_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,'','S','',uci.data_nas_m) sigla_pro_nas_m,
               uci.cod_fiscale_m, uci.data_nas_m, uci.cognome_nome_m, uci.cognome_m_ric, uci.nome_m_ric,
               uci.cod_rec
          from civuci uci
         where uci.cod_fiscale_m is not null
           and uci.cod_rec in (0,3,5)
        UNION
        select uci.cognome_f, uci.nome_f, uci.sesso_f, uci.d_data_nas_f, uci.cod_pro_nas_f, uci.cod_com_nas_f,
               f_comune_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.data_nas_f) des_com_nas_f,
               f_provincia_stato_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,'','S','',uci.data_nas_f) sigla_pro_nas_f,
               uci.cod_fiscale_f, uci.data_nas_f, uci.cognome_nome_f, uci.cognome_f_ric, uci.nome_f_ric,
               uci.cod_rec
          from civuci uci
         where uci.cod_fiscale_f is not null
           and uci.cod_rec in (0,3,5)
        UNION
        select cit.cognome, cit.nome, cit.sesso, cit.d_data_nas, cit.cod_pro_nas, cit.cod_com_nas,
               f_comune_al(cit.cod_pro_nas,cit.cod_com_nas,cit.data_nas) des_com_nas,
               f_provincia_stato_al(cit.cod_pro_nas,cit.cod_com_nas,'','S','',cit.data_nas) sigla_pro_nas,
               cit.cod_fiscale, cit.data_nas, cit.cognome_nome, cit.cognome_ric, cit.nome_ric,
               cit.cod_rec
          from civcit cit
         where cit.cod_fiscale is not null
           and cit.cod_rec in (0,3,5)) v
/
create or replace view gsdana_v_civ_senza_cf
AS
select 'CIV_SENZA_CF_'||v.cognome||'-'||v.nome||'-'||v.sesso||'-'||v.d_data_nas||'-'||v.cod_pro_nas||'-'||v.cod_com_nas ID, v.*
  from (select nas.cognome, nas.nome, nas.sesso, nas.d_data_nas, nas.cod_pro_nas, nas.cod_com_nas,
               f_comune_al(nas.cod_pro_nas,nas.cod_com_nas,nas.data_nas) des_com_nas,
               f_provincia_stato_al(nas.cod_pro_nas,nas.cod_com_nas,'','S','',nas.data_nas) sigla_pro_nas,
               nas.cod_fiscale, nas.data_nas, nas.cognome_nome, nas.cognome_ric, nas.nome_ric,
               nas.cod_rec
          from civnas nas
         where nas.cod_fiscale is null
           and nas.cod_rec in (0,3,5)
        UNION
        select mor.cognome, mor.nome, mor.sesso, mor.d_data_nas, mor.cod_pro_nas, mor.cod_com_nas,
               f_comune_al(mor.cod_pro_nas,mor.cod_com_nas,mor.data_nas) des_com_nas,
               f_provincia_stato_al(mor.cod_pro_nas,mor.cod_com_nas,'','S','',mor.data_nas) sigla_pro_nas,
               mor.cod_fiscale, mor.data_nas, mor.cognome_nome, mor.cognome_ric, mor.nome_ric,
               mor.cod_rec
          from civmor mor
         where mor.cod_fiscale is null
           and mor.cod_rec in (0,3,5)
        UNION
        select mat.cognome_m, mat.nome_m, 'M' sesso, mat.d_data_nas_m, mat.cod_pro_nas_m, mat.cod_com_nas_m,
               f_comune_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,mat.data_nas_m) des_com_nas_m,
               f_provincia_stato_al(mat.cod_pro_nas_m,mat.cod_com_nas_m,'','S','',mat.data_nas_m) sigla_pro_nas_m,
               mat.cod_fiscale_m, mat.data_nas_m, mat.cognome_nome_m, mat.cognome_m_ric, mat.nome_m_ric,
               mat.cod_rec
          from civmat mat
         where mat.cod_fiscale_m is null
           and mat.cod_rec in (0,3,5)
        UNION
        select mat.cognome_f, mat.nome_f, 'F' sesso, mat.d_data_nas_f, mat.cod_pro_nas_f, mat.cod_com_nas_f,
               f_comune_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,mat.data_nas_f) des_com_nas_f,
               f_provincia_stato_al(mat.cod_pro_nas_f,mat.cod_com_nas_f,'','S','',mat.data_nas_f) sigla_pro_nas_f,
               mat.cod_fiscale_f, mat.data_nas_f, mat.cognome_nome_f, mat.cognome_f_ric, mat.nome_f_ric,
               mat.cod_rec
          from civmat mat
         where mat.cod_fiscale_f is null
           and mat.cod_rec in (0,3,5)
        UNION
        select uci.cognome_m, uci.nome_m, uci.sesso_m, uci.d_data_nas_m, uci.cod_pro_nas_m, uci.cod_com_nas_m,
               f_comune_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,uci.data_nas_m) des_com_nas_m,
               f_provincia_stato_al(uci.cod_pro_nas_m,uci.cod_com_nas_m,'','S','',uci.data_nas_m) sigla_pro_nas_m,
               uci.cod_fiscale_m, uci.data_nas_m, uci.cognome_nome_m, uci.cognome_m_ric, uci.nome_m_ric,
               uci.cod_rec
          from civuci uci
         where uci.cod_fiscale_m is null
           and uci.cod_rec in (0,3,5)
        UNION
        select uci.cognome_f, uci.nome_f, uci.sesso_f, uci.d_data_nas_f, uci.cod_pro_nas_f, uci.cod_com_nas_f,
               f_comune_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,uci.data_nas_f) des_com_nas_f,
               f_provincia_stato_al(uci.cod_pro_nas_f,uci.cod_com_nas_f,'','S','',uci.data_nas_f) sigla_pro_nas_f,
               uci.cod_fiscale_f, uci.data_nas_f, uci.cognome_nome_f, uci.cognome_f_ric, uci.nome_f_ric,
               uci.cod_rec
          from civuci uci
         where uci.cod_fiscale_f is null
           and uci.cod_rec in (0,3,5)
        UNION
        select cit.cognome, cit.nome, cit.sesso, cit.d_data_nas, cit.cod_pro_nas, cit.cod_com_nas,
               f_comune_al(cit.cod_pro_nas,cit.cod_com_nas,cit.data_nas) des_com_nas,
               f_provincia_stato_al(cit.cod_pro_nas,cit.cod_com_nas,'','S','',cit.data_nas) sigla_pro_nas,
               cit.cod_fiscale, cit.data_nas, cit.cognome_nome, cit.cognome_ric, cit.nome_ric,
               cit.cod_rec
          from civcit cit
         where cit.cod_fiscale is null
           and cit.cod_rec in (0,3,5)) v
/
create or replace view gsdana_v
AS
select 'ANA' archivio
     , 'Anagrafe' des_archivio
     , 'ANA_'||ana.matricola as id
     , ana.cognome
     , ana.nome
     , ana.sesso
     , ana.d_data_nas
     , ana.cod_pro_nas
     , ana.cod_com_nas
     , ana.des_com_nas
     , ana.sigla_pro_nas
     , ana.cod_fiscale
     , ana.cf_calcolato
     , ana.stato_civile
     , ana.des_stato_civile
     , ana.nazionalita
     , ana.cod_pro_res
     , ana.cod_com_res
     , ana.des_com_res
     , ana.sigla_pro_res
     , ana.indirizzo_res
     , ana.cap_res
     , ana.des_stato_ana
     , ana.fascia
     , ana.matricola matricola_ana
     , f_ANPR_id_scheda(ana.matricola,'','','','','') id_soggetto_anpr
     , f_ANPR_id_unico(ana.matricola,'') id_unico_anpr
     , ana.cognome_ric
     , ana.nome_ric
  from anaana_v ana
UNION
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
  from gsdana_v_civ_con_cf civ
 where not exists (select 1 from anaana ana
                    where ana.cognome     = civ.cognome
                      and ana.nome        = civ.nome
                      and ana.sesso       = civ.sesso
                      and ana.data_nas    = civ.data_nas
                      and ana.cod_pro_nas = civ.cod_pro_nas
                      and ana.cod_com_nas = civ.cod_com_nas)
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
  from gsdana_v_civ_senza_cf civ
 where not exists (select 1 from anaana ana
                    where ana.cognome     = civ.cognome
                      and ana.nome        = civ.nome
                      and ana.sesso       = civ.sesso
                      and ana.data_nas    = civ.data_nas
                      and ana.cod_pro_nas = civ.cod_pro_nas
                      and ana.cod_com_nas = civ.cod_com_nas)
   and not exists (select 1 from gsdana_v_civ_con_cf b
                    where b.cognome     = civ.cognome
                      and b.nome        = civ.nome
                      and b.sesso       = civ.sesso
                      and b.data_nas    = civ.data_nas
                      and b.cod_pro_nas = civ.cod_pro_nas
                      and b.cod_com_nas = civ.cod_com_nas)
UNION
select 'CIV' archivio --'RNA' archivio
     , 'Rubrica Nascite' des_archivio
     , 'RNA_'||rna.id
     , rna.cognome
     , rna.nome
     , rna.sesso
     , rna.d_data_nas
     , rna.cod_pro_nas
     , rna.cod_com_nas
     , f_comune_al(rna.cod_pro_nas,rna.cod_com_nas,rna.data_nas) des_com_nas
     , f_provincia_stato_al(rna.cod_pro_nas,rna.cod_com_nas,'','S','',rna.data_nas) sigla_pro_nas
     , to_char(null) cod_fiscale
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
     , 'Rubrica Nascite - Comune Atto: '||
          f_comune_al(rna.cod_pro_atto_nas,rna.cod_com_atto_nas,rna.data_nas)||' '||
          f_provincia_stato_al(rna.cod_pro_atto_nas,rna.cod_com_atto_nas,'','S','S',rna.data_nas) des_stato_ana
     , to_number(null) fascia_ana
     , to_number(null) matricola_ana
     , to_number(null) id_soggetto_anpr
     , to_char(null) id_unico_anpr
     , f_cognome(rna.cognome_nome_ric) cognome_ric
     , f_nome(rna.cognome_nome_ric) nome_ric
  from civrna rna
 where not exists (select 1 from anaana ana
                    where ana.cognome     = rna.cognome
                      and ana.nome        = rna.nome
                      and ana.sesso       = rna.sesso
                      and ana.data_nas    = rna.data_nas
                      and ana.cod_pro_nas = rna.cod_pro_nas
                      and ana.cod_com_nas = rna.cod_com_nas)
/
comment on table GSDANA_V is 'Servizi Demografici - Soggetti Esteso (view)'
/
