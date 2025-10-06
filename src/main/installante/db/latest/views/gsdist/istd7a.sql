--liquibase formatted sql
--changeset amonopoli:202302081511 runOnChange:true stripComments:false
create or replace view ISTD7A
	(archivio, punto, 
         ufficio, anno, atto, parte, serie,
	 cognome_nome_1, cognome_nome_2, sesso, data_eve,
	 data_reg)
AS
-- nati vivi - dichiarati all'ufficiale di stato civile (1.1)
select 'NAS','1.1',
	nas.ufficio, nas.anno, nas.atto, nas.parte, nas.serie,
	nas.cognome_nome, to_char(null), nas.sesso, nas.data_nas, 
	nas.data_reg
  from civnas nas
 where nas.nato_morto 	is null 
   and nas.cod_rec 	in (0,3)
   and nas.parte 	= 1
   and nas.serie	in ('A','B')
UNION
-- nati vivi - di cui nati nel territorio del comune (1.1.1)
select 'NAS','1.1.1',
	nas.ufficio, nas.anno, nas.atto, nas.parte, nas.serie,
	nas.cognome_nome, to_char(null), nas.sesso, nas.data_nas, 
	nas.data_reg
  from civnas nas
 where (nas.cod_pro_nas,nas.cod_com_nas) in (select pro_cliente, com_cliente 
                                               from menuditta
				             union
	 			             select f.cod_provincia, f.cod_comune
				               from arccom f, arccom m
				              where f.cod_pro_fusione = m.cod_provincia
                                                and f.cod_com_fusione = m.cod_comune
                                                and (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta))
   and nas.parte 	= 1
   and nas.serie	in ('A','B')   
   and nas.nato_morto 	is null 
   and nas.cod_rec 	in (0,3)
UNION
-- nati vivi - di cui nati in altro comune (1.1.2)
select 'NAS','1.1.2',
	nas.ufficio, nas.anno, nas.atto, nas.parte, nas.serie,
	nas.cognome_nome, to_char(null), nas.sesso, nas.data_nas, 
	nas.data_reg
  from civnas nas
 where (nas.cod_pro_nas,nas.cod_com_nas) not in (select pro_cliente, com_cliente 
                                               from menuditta
				             union
	 			             select f.cod_provincia, f.cod_comune
				               from arccom f, arccom m
				              where f.cod_pro_fusione = m.cod_provincia
                                                and f.cod_com_fusione = m.cod_comune
                                                and (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta))
   and nas.parte 	= 1
   and nas.serie	in ('A','B')
   and nas.nato_morto 	is null 
   and nas.cod_rec 	in (0,3)
UNION
-- nati vivi - dichiarati in un centro di nascita (1.2)
select 'NAS','1.2',
	nas.ufficio, nas.anno, nas.atto, nas.parte, nas.serie,
	nas.cognome_nome, to_char(null), nas.sesso, nas.data_nas, 
	nas.data_reg
  from civnas nas
 where nas.parte 	= 2 
   and nas.serie 	= 'B' 
   and nas.natura 	in ('O') 
   and nas.cod_pro_nas 	< 199
   and nas.nato_morto 	is null 
   and nas.cod_rec 	in (0,3)
UNION
-- nati vivi - da stranieri
select 'NAS','1.3.1',
	nas.ufficio, nas.anno, nas.atto, nas.parte, nas.serie,
	nas.cognome_nome, to_char(null), nas.sesso, nas.data_nas, 
	nas.data_reg
  from civnas nas
 where (f_nati_stranieri(nas.ufficio,nas.anno,nas.atto,nas.parte,nas.serie,'MAT') != 'I' or
	f_nati_stranieri(nas.ufficio,nas.anno,nas.atto,nas.parte,nas.serie,'PAT') != 'I')
   and ((nas.parte = 1 and nas.serie in ('A','B')) 
	or
	(nas.parte = 2 and nas.serie = 'B' and nas.natura in ('O') and 
	 nas.cod_pro_nas < 199)) 
   and nas.nato_morto 	is null 
   and nas.cod_rec 	in (0,3)
UNION
-- nati morti - legittimi
select 'NAS','2.1',
	nas.ufficio, nas.anno, nas.atto, nas.parte, nas.serie,
	nas.cognome_nome, to_char(null), nas.sesso, nas.data_nas, 
	nas.data_reg
  from civnas nas
 where nvl(nas.tipo_filiazione,' ') = 'L'
   and ((nas.parte = 1 and nas.serie in ('A','B')) 
	or
	(nas.parte = 2 and nas.serie = 'B' and nas.natura in ('O') and nas.cod_pro_nas < 199)) 
   and nas.nato_morto 	is not null
   and nas.cod_rec 	in (0,3)
UNION
-- nati morti - naturali
select 'NAS','2.2',
	nas.ufficio, nas.anno, nas.atto, nas.parte, nas.serie,
	nas.cognome_nome, to_char(null), nas.sesso, nas.data_nas, 
	nas.data_reg
  from civnas nas
 where nvl(nas.tipo_filiazione,' ') in ('C','S',' ')
   and ((nas.parte = 1 and nas.serie = 'A') 
	or
	(nas.parte = 2 and nas.serie = 'B' and nas.natura in ('O') and 
	 nas.cod_pro_nas < 199)) 
   and nas.nato_morto 	is not null
   and nas.cod_rec 	in (0,3)
UNION
-- nati morti - da stranieri
select 'NAS','2.3.1',
	nas.ufficio, nas.anno, nas.atto, nas.parte, nas.serie,
	nas.cognome_nome, to_char(null), nas.sesso, nas.data_nas, 
	nas.data_reg
  from civnas nas
 where (f_nati_stranieri(nas.ufficio,nas.anno,nas.atto,nas.parte,nas.serie,'MAT') != 'I' or
	f_nati_stranieri(nas.ufficio,nas.anno,nas.atto,nas.parte,nas.serie,'PAT') != 'I')
   and ((nas.parte = 1 and nas.serie in ('A','B')) 
	or
	(nas.parte = 2 and nas.serie = 'B' and nas.natura in ('O') and nas.cod_pro_nas < 199)) 
   and nas.nato_morto 	is not null
   and nas.cod_rec 	in (0,3)
UNION
-- nati vivi legittimi
select 'NAS','3.1',
	nas.ufficio, nas.anno, nas.atto, nas.parte, nas.serie,
	nas.cognome_nome, to_char(null), nas.sesso, nas.data_nas, 
	nas.data_reg
  from civnas nas
 where nvl(nas.tipo_filiazione,' ') = 'L'
   and ((nas.parte = 1 and nas.serie in ('A','B')) 
	or
	(nas.parte = 2 and nas.serie = 'B' and nas.natura in ('O') and nas.cod_pro_nas < 199)) 
   and nas.nato_morto 	is null
   and nas.cod_rec 	in (0,3)
UNION
-- nati vivi naturali 
select 'NAS','3.2',
	nas.ufficio, nas.anno, nas.atto, nas.parte, nas.serie,
	nas.cognome_nome, to_char(null), nas.sesso, nas.data_nas, 
	nas.data_reg
  from civnas nas
 where nvl(nas.tipo_filiazione,' ') in ('C','S',' ')
   and ((nas.parte = 1 and nas.serie in ('A','B')) 
	or
	(nas.parte = 2 and nas.serie = 'B' and nas.natura in ('O') and nas.cod_pro_nas < 199)) 
   and nas.nato_morto 	is null
   and nas.cod_rec 	in (0,3)
UNION
-- nati vivi e morti - da parti plurimi
select 'NAS','3.3',
	nas.ufficio, nas.anno, nas.atto, nas.parte, nas.serie,
	nas.cognome_nome, to_char(null), nas.sesso, nas.data_nas, 
	nas.data_reg
  from civnas nas
 where nas.parto_plurimo = 'SI'
   and ((nas.parte = 1 and nas.serie in ('A','B')) 
	or
	(nas.parte = 2 and nas.serie = 'B' and nas.natura in ('O') and nas.cod_pro_nas < 199)) 
   and nas.cod_rec 	in (0,3)
UNION
-- morti nel 1 anno
select 'MOR','4.1',
	mor.ufficio, mor.anno, mor.atto, mor.parte, mor.serie,
	mor.cognome_nome, to_char(null), mor.sesso, nvl(mor.data_mor,mor.data_reg),
	mor.data_reg 
  from civmor mor
 where nvl(mor.data_mor,mor.data_reg) - to_number(to_char(add_months(to_date(mor.data_nas,'j'),12),'j')) < 0
   and mor.natura	= 'O'
   and (mor.cod_pro_mor, cod_com_mor) in (select pro_cliente, com_cliente 
                                               from menuditta
				             union
	 			             select f.cod_provincia, f.cod_comune
				               from arccom f, arccom m
				              where f.cod_pro_fusione = m.cod_provincia
                                                and f.cod_com_fusione = m.cod_comune
                                                and (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta))
   and mor.cod_rec	in (0,3)
UNION
-- morti oltre il 1 anno
select 'MOR','4.2',
	mor.ufficio, mor.anno, mor.atto, mor.parte, mor.serie,
	mor.cognome_nome, to_char(null), mor.sesso, nvl(mor.data_mor,mor.data_reg),
	mor.data_reg 
  from civmor mor
 where nvl(mor.data_mor,mor.data_reg) - to_number(to_char(add_months(to_date(mor.data_nas,'j'),12),'j')) >= 0
   and mor.natura	= 'O'
   and (mor.cod_pro_mor, cod_com_mor) in (select pro_cliente, com_cliente 
                                               from menuditta
				             union
	 			             select f.cod_provincia, f.cod_comune
				               from arccom f, arccom m
				              where f.cod_pro_fusione = m.cod_provincia
                                                and f.cod_com_fusione = m.cod_comune
                                                and (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta))
   and mor.cod_rec	in (0,3)
UNION
-- morti stranieri
select 'MOR','4.3.1',
	mor.ufficio, mor.anno, mor.atto, mor.parte, mor.serie,
	mor.cognome_nome, to_char(null), mor.sesso, nvl(mor.data_mor,mor.data_reg),
	mor.data_reg 
  from civdmo dmo, civmor mor
 where (nvl(upper(dmo.cittadinanza),'ITALIA') not like '%ITALIA%'
        or mor.nazionalita != 'I')
   and dmo.ufficio  (+)	     = mor.ufficio
   and dmo.anno	    (+)	     = mor.anno
   and dmo.atto	    (+)	     = mor.atto
   and dmo.parte    (+)	     = mor.parte
   and nvl(dmo.serie(+),' ') = nvl(mor.serie,' ')
   and mor.natura	= 'O'
   and (mor.cod_pro_mor, cod_com_mor) in (select pro_cliente, com_cliente 
                                               from menuditta
				             union
	 			             select f.cod_provincia, f.cod_comune
				               from arccom f, arccom m
				              where f.cod_pro_fusione = m.cod_provincia
                                                and f.cod_com_fusione = m.cod_comune
                                                and (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta))
   and mor.cod_rec 	in (0,3)
UNION
-- matrimoni religiosi
select 'MAT','5.1',
	mat.ufficio, mat.anno, mat.atto, mat.parte, mat.serie,
	mat.cognome_nome_m, mat.cognome_nome_f, to_char(null), mat.data_mat, 
	mat.data_reg 
  from civmat mat
 where mat.parte 	= 2
   and mat.serie 	= 'A'
   and mat.cod_rec	in (0,3)
UNION
-- matrimoni civili
select 'MAT','5.2',
	mat.ufficio, mat.anno, mat.atto, mat.parte, mat.serie,
	mat.cognome_nome_m, mat.cognome_nome_f, to_char(null), mat.data_mat, 
	mat.data_reg 
  from civmat mat
 where (mat.parte = 1 or (mat.parte = 2 and nvl(mat.serie,' ') = 'C'))
   and (mat.cod_pro_mat, mat.cod_com_mat) in (select pro_cliente, com_cliente 
                                               from menuditta
				             union
	 			             select f.cod_provincia, f.cod_comune
				               from arccom f, arccom m
				              where f.cod_pro_fusione = m.cod_provincia
                                                and f.cod_com_fusione = m.cod_comune
                                                and (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta))
   and mat.natura	= 'O'
   and mat.cod_rec	in (0,3)
UNION
-- matrimoni stranieri
select 'MAT','5.3.1',
	mat.ufficio, mat.anno, mat.atto, mat.parte, mat.serie,
	mat.cognome_nome_m, mat.cognome_nome_f, to_char(null), mat.data_mat, 
	mat.data_reg 
  from civmat mat
 where mat.natura	= 'O'
   and (mat.cod_pro_mat, mat.cod_com_mat) in (select pro_cliente, com_cliente 
                                               from menuditta
				             union
	 			             select f.cod_provincia, f.cod_comune
				               from arccom f, arccom m
				              where f.cod_pro_fusione = m.cod_provincia
                                                and f.cod_com_fusione = m.cod_comune
                                                and (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta))
   and mat.cod_rec	in (0,3)
   and (mat.nazionalita_m != 'I' or mat.nazionalita_f != 'I')
UNION
-- 6.1 - accordi ex art.6 - separazioni
-- 6.2 - accordi ex art.6 - divorzi
-- 7.1 - accordi ex art.12 - separazioni
-- 7.2 - accordi ex art.12 - divorzi
select distinct 'DIV',
       decode(ist.cod_modello_ist,'6SD','6','12SD','7')||'.'||
       ist.tipo_accordo_ist,
       mat_dv.ufficio, mat_dv.anno, mat_dv.atto, mat_dv.parte, mat_dv.serie,
       mat_dv.cognome_nome_m, mat_dv.cognome_nome_f, to_char(null), mat_dv.data_mat, 
       nvl(mat_dv.data_reg,ann.data_reg)
  from civmat mat_dv
     , civann ann
     , civmat_natura ist
 where mat_dv.cod_rec        in (0,3)
   and mat_dv.ufficio        = ann.ufficio
   and mat_dv.anno           = ann.anno
   and mat_dv.atto           = ann.atto
   and mat_dv.parte          = ann.parte
   and nvl(mat_dv.serie,' ') = nvl(ann.serie,' ')
   and ann.tipo_atto         = 9
   and ann.formula           = ist.formula
   and ist.flag_ist          = 'S'
UNION
select distinct 'DIV',
       decode(ist.cod_modello_ist,'6SD','6','12SD','7')||'.'||
       ist.tipo_accordo_ist,
       mat_dv.ufficio, mat_dv.anno, mat_dv.atto, mat_dv.parte, mat_dv.serie,
       mat_dv.cognome_nome_m, mat_dv.cognome_nome_f, to_char(null),mat_dv.data_mat, 
       nvl(mat_dv.data_reg,ann.data_reg)
  from civmat mat_dv
     , civmat mat
     , civann ann
     , civmat_natura ist
 where mat_dv.id_civdta      is null
   and mat_dv.cod_rec        in (0,3)
   and mat_dv.cognome_nome_m = mat.cognome_nome_m
   and mat_dv.data_nas_m     = mat.data_nas_m
   and mat_dv.cognome_nome_f = mat.cognome_nome_f
   and mat_dv.data_nas_f     = mat.data_nas_f
   and mat_dv.natura         not in ('O','T')
   and mat_dv.data_reg   (+) = ann.data_reg
   and mat.cod_rec           in (0,3)
   and mat.ufficio           = ann.ufficio
   and mat.anno              = ann.anno
   and mat.atto              = ann.atto
   and mat.parte             = ann.parte
   and nvl(mat.serie,' ')    = nvl(ann.serie,' ')
   and ann.tipo_atto         = 4
   and ann.formula           = ist.formula
   and ist.flag_ist          = 'S'
UNION
select distinct 'DIV',
       decode(cta.cod_modello_istat,'6SD','6','12SD','7')||'.'||
       decode(dpa.tipo_divorzio,'X',1,2),
       mat_dv.ufficio, mat_dv.anno, mat_dv.atto, mat_dv.parte, mat_dv.serie,
       mat_dv.cognome_nome_m, mat_dv.cognome_nome_f, to_char(null),mat_dv.data_mat, 
       mat_dv.data_reg
  from civcta cta
     , civdta dta
     , civdpa dpa
     , civmat mat_dv
 where cta.flag_divorzio          = 'S'
   and cta.flag_istat             = 'S'
   and cta.id                     = dta.id_civcta
   and nvl(dpa.tipo_divorzio,'A') != 'A'
   and dta.id                     = mat_dv.id_civdta
   and dpa.id_atto                = mat_dv.id_atto
   and mat_dv.cod_rec             in (0,3)
UNION
-- 8.1 - unioni civili (atti registrati con forms11)
select distinct 'UCI',
       '8.1',
       uci.ufficio, uci.anno, uci.atto, uci.parte, uci.serie,
       uci.cognome_nome_m, uci.cognome_nome_f, uci.sesso_m, uci.data_mat, 
       uci.data_reg
  from civuci uci
     , civuci_natura ist
 where (uci.cod_pro_mat, uci.cod_com_mat) in (select pro_cliente, com_cliente 
                                               from menuditta
				             union
	 			             select f.cod_provincia, f.cod_comune
				               from arccom f, arccom m
				              where f.cod_pro_fusione = m.cod_provincia
                                                and f.cod_com_fusione = m.cod_comune
                                                and (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta))
   and uci.cod_rec        in (0,3)
   and uci.natura_uci     = ist.natura
--   and ist.natura_pr      in ('O','T')
   and ist.natura_pr      = 'O'
   and ist.flag_ist       = 'S'
UNION
-- 8.1 - unioni civili (atti registrati con ZK)
select distinct 'UCI',
       '8.1',
       uci.ufficio, uci.anno, uci.atto, uci.parte, uci.serie,
       uci.cognome_nome_m, uci.cognome_nome_f, uci.sesso_m, uci.data_mat, 
       uci.data_reg
  from civcta cta
     , civdta dta
     , civuci uci
 where (uci.cod_pro_mat, uci.cod_com_mat) in (select pro_cliente, com_cliente 
                                               from menuditta
				             union
	 			             select f.cod_provincia, f.cod_comune
				               from arccom f, arccom m
				              where f.cod_pro_fusione = m.cod_provincia
                                                and f.cod_com_fusione = m.cod_comune
                                                and (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta))
   and cta.flag_istat     = 'S'
   and cta.id             = dta.id_civcta
   and dta.id             = uci.id_civdta
   and uci.natura         = 'O'
   and uci.cod_rec        in (0,3)
UNION
-- 8.2 - cessazioni di unione di civile (x rilevazione annuale < 2024)
select distinct 'SCI_AN',
       '8.2',
       uci.ufficio, uci.anno, uci.atto, uci.parte, uci.serie,
       uci.cognome_nome_m, uci.cognome_nome_f, uci.sesso_m, uci.data_mat, 
       uci.data_reg
  from civcta cta
     , civdta dta
     , civuci uci
 where cta.flag_istat     = 'S'
   and cta.id             = dta.id_civcta
   and dta.id             = uci.id_civdta
   and uci.natura         = 'D'
   and uci.cod_rec        in (0,3)
UNION
-- 6.3 - accordi ex art.6 - scioglimenti UCI (zk)
-- 7.3 - accordi ex art.12 - scioglimenti UCI (zk)
select distinct 'SCI',
       decode(cta.cod_modello_istat,'6SU','6','12SU','7')||'.3',
       uci.ufficio, uci.anno, uci.atto, uci.parte, uci.serie,
       uci.cognome_nome_m, uci.cognome_nome_f, uci.sesso_m, uci.data_mat, 
       uci.data_reg
  from civcta cta
     , civdta dta
     , civuci uci
 where cta.flag_istat     = 'S'
   and cta.id             = dta.id_civcta
   and dta.id             = uci.id_civdta
   and uci.natura         = 'D'
   and uci.cod_rec        in (0,3)
UNION
-- 9.1 - provvedimenti (da annotazione) - separazioni
-- 9.2 - provvedimenti (da annotazione) - divorzi
select distinct 'DIV',
       '9.'||decode(ann.genere,'AMX','1','AMD','2','AMA','2'),
       mat.ufficio, mat.anno, mat.atto, mat.parte, mat.serie,
       mat.cognome_nome_m, mat.cognome_nome_f, 'M', ann.data_reg,
       ann.data_reg
  from civmat mat
     , civann ann
 where mat.cod_rec        in (0,3)
   and mat.id_atto        = ann.id_atto
   and ann.flag_istat     = 'S'
   and ann.tipo_atto      = 4
UNION
-- 9.3 - provvedimenti (da annotazione) - scioglimenti UCI
select distinct 'SCI',
       '9.3',
       uci.ufficio, uci.anno, uci.atto, uci.parte, uci.serie,
       uci.cognome_nome_m, uci.cognome_nome_f, uci.sesso_m, ann.data_reg,
       ann.data_reg
  from civuci uci
     , civann ann
 where uci.cod_rec        in (0,3)
   and uci.id_atto        = ann.id_atto
   and ann.flag_istat     = 'S'
   and ann.tipo_atto      = -4
/
comment on table ISTD7A is 'ISTAT - Dati per Compilazione Modello D7A (view)'
/
