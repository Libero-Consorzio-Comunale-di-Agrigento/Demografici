--liquibase formatted sql
--changeset snocca:202310300935 runAlways:true runOnChange:true stripComments:false
create or replace view ansall_v
AS
select nas.id_atto as id, nas.id as id_rif, 'NAS' as archivio_rif, anno, id_atto_ansc, numero_unico, id_evento_ansc,
       nas.id_usecase_ansc, cu2.descrizione,
       nas.id_soggetto_ansc as id_soggetto_ansc_1, cognome as cognome_1, nome as nome_1, d_data_nas as d_data_nas_1, sesso as sesso_1,
       to_number(null) as id_soggetto_ansc_2, to_char(null) as cognome_2, to_char(null) as nome_2, to_date(null) as d_data_nas_2, to_char(null) as sesso_2,
       2 as tipo_atto_ads, nas.d_data_reg, nas.cod_rec,
       -- flag_divorzio
       to_char(null) as flag_divorzio,
       -- flag_pren_parto_plurimo
       to_char(null) as flag_pren_parto_plurimo
  from civnas nas, anscu2 cu2
 where numero_unico is not null
   and nas.id_usecase_ansc = cu2.id (+)
   and nas.cod_rec in (0,3)
UNION
select mor.id_atto, mor.id, 'MOR', anno, id_atto_ansc, numero_unico, id_evento_ansc,
       mor.id_usecase_ansc, cu5.descrizione,
       mor.id_soggetto_ansc, cognome, nome, d_data_nas, sesso,
       to_number(null), to_char(null), to_char(null), to_date(null), to_char(null),
       5, mor.d_data_reg, mor.cod_rec,
       -- flag_divorzio
       to_char(null),
       -- flag_pren_parto_plurimo
       to_char(null)
  from civmor mor, anscu5 cu5
 where numero_unico is not null
   and mor.id_usecase_ansc = cu5.id (+)
   and mor.cod_rec in (0,3)
UNION
select mat.id_atto, mat.id, 'MAT', anno, id_atto_ansc, numero_unico, id_evento_ansc,
       mat.id_usecase_ansc, cu4.descrizione,
       mat.id_soggetto_ansc_m, cognome_m, nome_m, d_data_nas_m, 'M',
       mat.id_soggetto_ansc_f, cognome_f, nome_f, d_data_nas_f, 'F',
       4, mat.d_data_reg, mat.cod_rec,
       -- flag_divorzio
       decode(cta.id, '', decode(mat.parte||mat.serie||mat.natura,'2CD','S'), cta.flag_divorzio) flag_divorzio,
       -- flag_pren_parto_plurimo
       to_char(null)
  from civmat mat, anscu4 cu4, civcta cta, civdta dta
 where numero_unico is not null
   and mat.id_usecase_ansc = cu4.id (+)
   and mat.cod_rec in (0,3)
   and cta.id (+)          = dta.id_civcta
   and dta.id (+)          = mat.id_civdta
UNION
select uci.id_atto, uci.id, 'UCI', anno, id_atto_ansc, numero_unico, id_evento_ansc,
       uci.id_usecase_ansc, cuu.descrizione,
       uci.id_soggetto_ansc_m, cognome_m as cognome_1, nome_m as nome_1, d_data_nas_m, sesso_m,
       uci.id_soggetto_ansc_f, cognome_f as cognome_2, nome_f as nome_2, d_data_nas_f, sesso_f,
       -4, uci.d_data_reg, uci.cod_rec,
       -- flag_divorzio
       decode(cta.id, '', decode(uci.parte||uci.serie||uci.natura,'2D','S'), cta.flag_divorzio) flag_divorzio,
       -- flag_pren_parto_plurimo
       to_char(null)
  from civuci uci, anscuu cuu, civcta cta, civdta dta
 where numero_unico is not null
   and uci.id_usecase_ansc = cuu.id (+)
   and uci.cod_rec in (0,3)
   and cta.id (+)          = dta.id_civcta
   and dta.id (+)          = uci.id_civdta
UNION
select cit.id_atto, cit.id, 'CIT', anno, id_atto_ansc, numero_unico, id_evento_ansc,
       cit.id_usecase_ansc, cu1.descrizione,
       cit.id_soggetto_ansc, cognome, nome, d_data_nas, sesso,
       to_number(null), to_char(null), to_char(null), to_date(null), to_char(null),
       1, cit.d_data_reg, cit.cod_rec,
       -- flag_divorzio
       to_char(null),
       -- flag_pren_parto_plurimo
       to_char(null)
  from civcit cit, anscu1 cu1
 where numero_unico is not null
   and cit.id_usecase_ansc = cu1.id (+)
   and cit.cod_rec in (0,3)
UNION
select 'ANN_'||to_char(ann.id), ann.id, 'ANN', ann.anno_annotazione, ann.id_atto_ansc, ann.numero_unico, ann.id_evento_ansc,
       ann.id_usecase_ansc, t03.descrizione,
       -- soggetto 1
       decode(ann.tipo_atto, 1, cit.id_soggetto_ansc, 2, nas.id_soggetto_ansc, 4, mat.id_soggetto_ansc_m, -4, uci.id_soggetto_ansc_m, 5, mor.id_soggetto_ansc),
       decode(ann.tipo_atto, 1, cit.cognome, 2, nas.cognome, 4, mat.cognome_m, -4, uci.cognome_m, 5, mor.cognome), 
       decode(ann.tipo_atto, 1, cit.nome, 2, nas.nome, 4, mat.nome_m, -4, uci.nome_m, 5, mor.nome), 
       decode(ann.tipo_atto, 1, cit.d_data_nas, 2, nas.d_data_nas, 4, mat.d_data_nas_m, -4, uci.d_data_nas_m, 5, mor.d_data_nas), 
       decode(ann.tipo_atto, 1, cit.sesso, 2, nas.sesso, 4, 'M', -4, uci.sesso_m, 5, mor.sesso),
       -- soggetto 2
       decode(ann.tipo_atto, 4, mat.id_soggetto_ansc_f, -4, uci.id_soggetto_ansc_f, to_number(null)),
       decode(ann.tipo_atto, 4, mat.cognome_f, -4, uci.cognome_f), 
       decode(ann.tipo_atto, 4, mat.nome_f, -4, uci.nome_f), 
       decode(ann.tipo_atto, 4, mat.d_data_nas_f, -4, uci.d_data_nas_f), 
       decode(ann.tipo_atto, 4, 'F', -4, uci.sesso_f), 
       ann.tipo_atto, ann.d_data_reg, to_number(null),
       -- flag_divorzio
       to_char(null),
       -- flag_pren_parto_plurimo
       to_char(null)
  from civcit cit, civnas nas, civmat mat, civuci uci, civmor mor,
       civann ann, anst03 t03
 where cit.id_atto (+) = ann.id_atto
   and nas.id_atto (+) = ann.id_atto
   and mat.id_atto (+) = ann.id_atto
   and uci.id_atto (+) = ann.id_atto
   and mor.id_atto (+) = ann.id_atto
   and ann.numero_unico is not null
   and ann.id_usecase_ansc = t03.id (+)
UNION
select nas_p.id_atto as id, nas_p.id, 'NAS', nas_p.anno, to_char(null), nas_p.numero_unico, to_number(null),
       to_number(null) id_usecase_ansc, to_char(null) descrizione,
       to_number(null), to_char(null) as cognome_1, to_char(null) as nome_1, to_date(null), to_char(null),
       to_number(null), to_char(null) as cognome_2, to_char(null) as nome_2, to_date(null), to_char(null),
       2, to_date(null), to_number(null),
       -- flag_divorzio
       to_char(null),
       -- flag_pren_parto_plurimo
       'S'
  from civnas_plurimo nas_p
 where numero_unico is not null
   and not exists (select 1 from civnas where id_atto = nas_p.id_atto)
/