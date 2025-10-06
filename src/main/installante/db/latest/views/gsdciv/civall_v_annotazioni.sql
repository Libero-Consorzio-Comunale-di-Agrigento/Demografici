--liquibase formatted sql
--changeset amonopoli:202405221445 runOnChange:true stripComments:false
create or replace view civall_v_annotazioni
       (tipo_comune, tipo_atto, tipo_atto_rif, tipo_formula,
        ufficio, anno, atto, parte, serie, 
        cognome, nome, sesso, d_data_nas, 
        cognome_2, nome_2, sesso_2, d_data_nas_2, 
        d_data_eve, id, id_atto,
        natura, id_civdta, tipo_atto_ann, id_civann,
        id_atto_ansc)
AS
-- atti del COMUNE UTENTE (tipo_comune = 1)
select 1   tipo_comune
     , 1   tipo_atto
     , 1   tipo_atto_rif
     , '1' tipo_formula
     , cit.ufficio
     , cit.anno
     , cit.atto
     , to_number(null)
     , to_char(null)
     , nvl(cit.cognome,f_cognome(cit.cognome_nome))
     , nvl(cit.nome,f_nome(cit.cognome_nome))
     , to_char(null)
     , cit.d_data_nas
     , to_char(null)
     , to_char(null)
     , to_char(null)
     , to_date(null)
     , cit.d_data_cit
     , 'CIT.'||lpad(cit.id,10,'0') 
     , cit.id_atto
     , cit.natura
     , cit.id_civdta
     , 1   tipo_atto_ann
     , to_number(null) 	id_civann
     , cit.id_atto_ansc
  from civcit cit
 WHERE cit.cod_rec in (0,3)
   and cit.natura   != 'D'
UNION
select 1   tipo_comune
     , 2   tipo_atto
     , 2   tipo_atto_rif
     , '1' tipo_formula
     , nas.ufficio
     , nas.anno
     , nas.atto
     , nas.parte
     , nas.serie
     , nvl(nas.cognome, f_cognome(nas.cognome_nome))
     , nvl(nas.nome, f_nome(nas.cognome_nome))
     , nas.sesso
     , nas.d_data_nas
     , to_char(null)
     , to_char(null)
     , to_char(null)
     , to_date(null)
     , nas.d_data_nas
     , 'NAS.'||lpad(nas.id,10,'0')
     , nas.id_atto
     , nas.natura
     , nas.id_civdta
     , 2   tipo_atto_ann
     , to_number(null) 	id_civann
     , nas.id_atto_ansc
  from civnas nas
 WHERE nas.cod_rec  in (0,3)
   and nas.natura   in ('O','T')
UNION
select 1   tipo_comune
     , 4   tipo_atto
     , 4   tipo_atto_rif
     , '1' tipo_formula
     , mat.ufficio
     , mat.anno
     , mat.atto
     , mat.parte
     , mat.serie
     , nvl(mat.cognome_m,f_cognome(mat.cognome_nome_m))
     , nvl(mat.nome_m,f_nome(mat.cognome_nome_m))
     , 'M'
     , mat.d_data_nas_m
     , nvl(mat.cognome_f,f_cognome(mat.cognome_nome_f))
     , nvl(mat.nome_f,f_nome(mat.cognome_nome_f))
     , 'F'
     , mat.d_data_nas_f
     , mat.d_data_mat
     , 'MAT.'||lpad(mat.id,10,'0') 
     , mat.id_atto
     , mat.natura
     , mat.id_civdta
     , 4   tipo_atto_ann
     , to_number(null) 	id_civann
     , mat.id_atto_ansc
  from civmat mat
 WHERE mat.cod_rec in (0,3)
   and mat.natura   in ('O','T')
UNION
select 1   tipo_comune
     , -4  tipo_atto
     , -4  tipo_atto_rif
     , '1' tipo_formula
     , uci.ufficio
     , uci.anno
     , uci.atto
     , uci.parte
     , uci.serie
     , nvl(uci.cognome_m,f_cognome(uci.cognome_nome_m))
     , nvl(uci.nome_m,f_nome(uci.cognome_nome_m))
     , uci.sesso_m
     , uci.d_data_nas_m
     , nvl(uci.cognome_f,f_cognome(uci.cognome_nome_f))
     , nvl(uci.nome_f,f_nome(uci.cognome_nome_f))
     , uci.sesso_f
     , uci.d_data_nas_f
     , uci.d_data_mat
     , 'UCI.'||lpad(uci.id,10,'0') 
     , uci.id_atto
     , uci.natura
     , uci.id_civdta
     , -4   tipo_atto_ann
     , to_number(null) 	id_civann
     , uci.id_atto_ansc
  from civuci uci
 WHERE uci.cod_rec in (0,3)
   and uci.natura   in ('O','T')
UNION
select 1   tipo_comune
     , 5   tipo_atto
     , 5   tipo_atto_rif
     , '1' tipo_formula
     , mor.ufficio
     , mor.anno
     , mor.atto
     , mor.parte
     , mor.serie
     , nvl(mor.cognome,f_cognome(mor.cognome_nome))
     , nvl(mor.nome,f_nome(mor.cognome_nome))
     , mor.sesso
     , mor.d_data_nas
     , to_char(null)
     , to_char(null)
     , to_char(null)
     , to_date(null)
     , mor.d_data_mor
     , 'MOR'||lpad(mor.id,10,'0') 
     , mor.id_atto
     , mor.natura
     , mor.id_civdta
     , 5   tipo_atto_ann
     , to_number(null) 	id_civann
     , mor.id_atto_ansc
  from civmor mor
 WHERE mor.cod_rec in (0,3)
   and mor.natura   in ('O','T')
UNION
-- atti di ALTRO COMUNE (tipo_comune = 0)
-- dati del richiedente da atto di cittadinanza (tipo_atto '6' - tipo_formula '1')
select 0   tipo_comune
     , 6   tipo_atto
     , 1   tipo_atto_rif
     , '1' tipo_formula
     , cit.ufficio
     , cit.anno
     , cit.atto
     , to_number(null)
     , to_char(null)
     , nvl(cit.cognome,f_cognome(cit.cognome_nome))
     , nvl(cit.nome,f_nome(cit.cognome_nome))
     , to_char(null)
     , cit.d_data_nas
     , to_char(null)
     , to_char(null)
     , to_char(null)
     , to_date(null)
     , cit.d_data_cit
     , 'CIT.'||lpad(cit.id,10,'0')||'.nas'
     , f_CIV_get_id_atto(6,cit.ufficio,cit.anno,'','',cit.atto)
     , cit.natura
     , cit.id_civdta
     , 2   tipo_atto_ann
     , ann.id   id_civann
     , cit.id_atto_ansc
  from civann ann, civcit cit
 WHERE ann.id_atto  = cit.id_atto||'.nas'
   and cit.natura   != 'D'
   and cit.cod_rec  in (0,3)
UNION
-- dati dello sposo da atto di matrimonio (tipo_atto '7' - tipo_formula '1')
SELECT 0   tipo_comune
     , 7   tipo_atto
     , 4   tipo_atto_rif
     , '1' tipo_formula
     , mat.ufficio
     , mat.anno
     , mat.atto
     , mat.parte
     , mat.serie
     , nvl(mat.cognome_m,f_cognome(mat.cognome_nome_m))
     , nvl(mat.nome_m,f_nome(mat.cognome_nome_m))
     , 'M'
     , mat.d_data_nas_m
     , to_char(null) --nvl(mat.cognome_f,f_cognome(mat.cognome_nome_f))
     , to_char(null) --nvl(mat.nome_f,f_nome(mat.cognome_nome_f))
     , to_char(null) --'F'
     , to_date(null) --mat.d_data_nas_f
     , mat.d_data_mat
     , 'MAT.'||lpad(mat.id,10,'0')||'.nas.1'
     , f_CIV_get_id_atto(7,mat.ufficio,mat.anno,mat.parte,mat.serie,mat.atto)
     , mat.natura
     , mat.id_civdta
     , 2   tipo_atto_ann
     , ann.id   id_civann
     , mat.id_atto_ansc
  FROM civann ann, civmat mat
 WHERE decode(ann.formula,'','', substr(ann.formula,1,1)) = '1'
   and ann.id_atto  = mat.id_atto||'.nas'
   and mat.natura   in ('O','T','D')
   and mat.cod_rec  in (0,3)
UNION
-- dati della sposa da atto di matrimonio (tipo_atto '7' - tipo_formula '5')
SELECT 0   tipo_comune
     , 7   tipo_atto
     , 4   tipo_atto_rif
     , '5' tipo_formula
     , mat.ufficio
     , mat.anno
     , mat.atto
     , mat.parte
     , mat.serie
     , nvl(mat.cognome_f,f_cognome(mat.cognome_nome_f))
     , nvl(mat.nome_f,f_nome(mat.cognome_nome_f))
     , 'F'
     , mat.d_data_nas_f
     , to_char(null) --nvl(mat.cognome_m,f_cognome(mat.cognome_nome_m))
     , to_char(null) --nvl(mat.nome_m,f_nome(mat.cognome_nome_m))
     , to_char(null) --'M'
     , to_date(null) --mat.d_data_nas_m
     , mat.d_data_mat
     , 'MAT.'||lpad(mat.id,10,'0')||'.nas.5'
     , f_CIV_get_id_atto(7,mat.ufficio,mat.anno,mat.parte,mat.serie,mat.atto)
     , mat.natura
     , mat.id_civdta
     , 2   tipo_atto_ann
     , ann.id   id_civann
     , mat.id_atto_ansc
  FROM civann ann, civmat mat
 WHERE decode(ann.formula,'','', substr(ann.formula,1,1)) = '5'
   and ann.id_atto  = mat.id_atto||'.nas'
   and mat.natura   in ('O','T','D')
   and mat.cod_rec  in (0,3)
UNION
-- dati di altro soggetto da atto di matrimonio (tipo_atto '7' - tipo_formula 'X')
SELECT 0   tipo_comune
     , 7   tipo_atto
     , 4   tipo_atto_rif
     , 'X' tipo_formula
     , mat.ufficio
     , mat.anno
     , mat.atto
     , mat.parte
     , mat.serie
     , 'ALTRO'
     , 'SOGGETTO'
     , to_char(null)
     , to_date(null)
     , to_char(null)
     , to_char(null)
     , to_char(null)
     , to_date(null)
     , mat.d_data_mat
     , 'MAT.'||lpad(mat.id,10,'0')||'.nas.X'
     , f_CIV_get_id_atto(7,mat.ufficio,mat.anno,mat.parte,mat.serie,mat.atto)
     , mat.natura
     , mat.id_civdta
     , 2   tipo_atto_ann
     , ann.id   id_civann
     , mat.id_atto_ansc
  FROM civann ann, civmat mat
 WHERE decode(ann.formula,'','', substr(ann.formula,1,1)) = 'X'
   and ann.id_atto  = mat.id_atto||'.nas'
   and mat.natura   in ('O','T')
   and mat.cod_rec  in (0,3)
UNION
-- dati del contraente '1' da atto di unione civile (tipo_atto '-7' - tipo_formula '1')
SELECT 0   tipo_comune
     , -7  tipo_atto
     , -4  tipo_atto_rif
     , '1' tipo_formula
     , uci.ufficio
     , uci.anno
     , uci.atto
     , uci.parte
     , uci.serie
     , nvl(uci.cognome_m,f_cognome(uci.cognome_nome_m))
     , nvl(uci.nome_m,f_nome(uci.cognome_nome_m))
     , uci.sesso_m
     , uci.d_data_nas_m
     , to_char(null) --nvl(uci.cognome_f,f_cognome(uci.cognome_nome_f))
     , to_char(null) --nvl(uci.nome_f,f_nome(uci.cognome_nome_f))
     , to_char(null) --uci.sesso_f
     , to_date(null) --uci.d_data_nas_f
     , uci.d_data_mat
     , 'UCI.'||lpad(uci.id,10,'0')||'.nas.1'
     , f_CIV_get_id_atto(-7,uci.ufficio,uci.anno,uci.parte,uci.serie,uci.atto)
     , uci.natura
     , uci.id_civdta
     , 2   tipo_atto_ann
     , ann.id   id_civann
     , uci.id_atto_ansc
  FROM civuci uci, civann ann
 WHERE decode(ann.formula,'','', substr(ann.formula,1,1)) = '1'
   and ann.id_atto  = uci.id_atto||'.nas'
   and uci.natura   in ('O','T','D')
   and uci.cod_rec  in (0,3)
UNION
-- dati del contraente '2' da atto di unione civile (tipo_atto '-7' - tipo_formula '5')
SELECT 0   tipo_comune
     , -7  tipo_atto
     , -4  tipo_atto_rif
     , '5' tipo_formula
     , uci.ufficio
     , uci.anno
     , uci.atto
     , uci.parte
     , uci.serie
     , nvl(uci.cognome_f,f_cognome(uci.cognome_nome_f))
     , nvl(uci.nome_f,f_nome(uci.cognome_nome_f))
     , uci.sesso_f
     , uci.d_data_nas_f
     , to_char(null) --nvl(uci.cognome_m,f_cognome(uci.cognome_nome_m))
     , to_char(null) --nvl(uci.nome_m,f_nome(uci.cognome_nome_m))
     , to_char(null) --uci.sesso_m
     , to_date(null) --uci.d_data_nas_m
     , uci.d_data_mat
     , 'UCI.'||lpad(uci.id,10,'0')||'.nas.5'
     , f_CIV_get_id_atto(-7,uci.ufficio,uci.anno,uci.parte,uci.serie,uci.atto)
     , uci.natura
     , uci.id_civdta
     , 2   tipo_atto_ann
     , ann.id   id_civann
     , uci.id_atto_ansc
  FROM civann ann, civuci uci
 WHERE decode(ann.formula,'','', substr(ann.formula,1,1)) = '5'
   and ann.id_atto  = uci.id_atto||'.nas'
   and uci.natura   in ('O','T','D')
   and uci.cod_rec  in (0,3)
UNION
select 0   tipo_comune
     , 8   tipo_atto
     , 5   tipo_atto_rif
     , '1' tipo_formula
     , mor.ufficio
     , mor.anno
     , mor.atto
     , mor.parte
     , mor.serie
     , nvl(mor.cognome,f_cognome(mor.cognome_nome))
     , nvl(mor.nome,f_nome(mor.cognome_nome))
     , mor.sesso
     , mor.d_data_nas
     , to_char(null)
     , to_char(null)
     , to_char(null)
     , to_date(null)
     , mor.d_data_mor
     , 'MOR.'||lpad(mor.id,10,'0')||'.nas'
     , f_CIV_get_id_atto(8,mor.ufficio,mor.anno,mor.parte,mor.serie,mor.atto)
     , mor.natura
     , mor.id_civdta
     , 2   tipo_atto_ann
     , ann.id   id_civann
     , mor.id_atto_ansc
  from civann ann, civmor mor
 WHERE ann.id_atto  = mor.id_atto||'.nas'
   and mor.natura   in ('O','T')
   and mor.cod_rec  in (0,3)
UNION
-- dati del matrimonio da atto di divorzio (tipo_atto '9' - tipo_formula '1')
select 0   tipo_comune
     , 9   tipo_atto
     , 4   tipo_atto_rif
     , '1' tipo_formula
     , mat.ufficio
     , mat.anno
     , mat.atto
     , mat.parte
     , mat.serie
     , nvl(mat.cognome_m,f_cognome(mat.cognome_nome_m))
     , nvl(mat.nome_m,f_nome(mat.cognome_nome_m))
     , 'M'
     , mat.d_data_nas_m
     , nvl(mat.cognome_f,f_cognome(mat.cognome_nome_f))
     , nvl(mat.nome_f,f_nome(mat.cognome_nome_f))
     , 'F'
     , mat.d_data_nas_f
     , mat.d_data_mat
     , 'MAT.'||lpad(mat.id,10,'0')||'.mat' 
     , f_CIV_get_id_atto(9,mat.ufficio,mat.anno,mat.parte,mat.serie,mat.atto)
     , mat.natura
     , mat.id_civdta
     , 4   tipo_atto_ann
     , ann.id   id_civann
     , mat.id_atto_ansc
  from civann ann, civmat mat
 WHERE ann.id_atto  = mat.id_atto||'.mat'
   and mat.natura   = 'D'
   and mat.cod_rec  in (0,3)
UNION
-- dati dell'unione civile da atto di scioglimento (tipo_atto '-9' - tipo_formula '1')
select 0   tipo_comune
     , -9  tipo_atto
     , -4  tipo_atto_rif
     , '1' tipo_formula
     , uci.ufficio
     , uci.anno
     , uci.atto
     , uci.parte
     , uci.serie
     , nvl(uci.cognome_m,f_cognome(uci.cognome_nome_m))
     , nvl(uci.nome_m,f_nome(uci.cognome_nome_m))
     , uci.sesso_m
     , uci.d_data_nas_m
     , nvl(uci.cognome_f,f_cognome(uci.cognome_nome_f))
     , nvl(uci.nome_f,f_nome(uci.cognome_nome_f))
     , uci.sesso_f
     , uci.d_data_nas_f
     , uci.d_data_mat
     , 'UCI.'||lpad(uci.id,10,'0')||'.uci'
     , f_CIV_get_id_atto(-9,uci.ufficio,uci.anno,uci.parte,uci.serie,uci.atto)
     , uci.natura
     , uci.id_civdta
     , -4   tipo_atto_ann
     , ann.id   id_civann
     , uci.id_atto_ansc
  from civann ann, civuci uci
 WHERE ann.id_atto  = uci.id_atto||'.uci'
   and uci.natura   = 'D'
   and uci.cod_rec  in (0,3)
/
comment on table civall_v_annotazioni is 'Stato Civile - Tabella unica di tutti gli atti per gestione annotazioni'
/
comment on column civall_v_annotazioni.tipo_comune is 'Stato Civile - 1 = comune utente / 0 = altro comune'
/
