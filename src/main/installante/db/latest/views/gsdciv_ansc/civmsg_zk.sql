--liquibase formatted sql
--changeset amonopoli:202412171625 runOnChange:true stripComments:false
create or replace view civmsg_zk
  (tipo_atto, id, ufficio, anno, parte, serie, atto, id_atto,
         sequenza, messaggio, dettaglio, 
         flag_avviso, flag_cer, flag_civ)
as
select 2, nas.id, nas.ufficio, nas.anno, nas.parte, nas.serie, nas.atto, nas.id_atto,
       9, 
       'Atto con Note compilate', 
       f_varchar2nvarchar(nas.note),
       'S', 'S', 'S'
  from civnas nas
 where nas.note is not null
UNION
select 2, nas.id, nas.ufficio, nas.anno, nas.parte, nas.serie, nas.atto, nas.id_atto,
       0, 
       decode(nas.id_atto_ansc, '', 'A.N.S.C. - Atto NON validato ', 'A.N.S.C. - Atto digitale'), 
       f_varchar2nvarchar('id Ansc: '||nas.id_atto_ansc||' - Numero Comunale: '||nas.numero_unico),
       'S', 'S', 'S'
  from civnas nas
 where nas.numero_unico is not null
   and nas.id_atto_ansc is null
   and f_flag_ANSC = 'S'
UNION
select 4, mat.id, mat.ufficio, mat.anno, mat.parte, mat.serie, mat.atto, mat.id_atto,
       9, 
       'Atto con Note compilate', 
       f_varchar2nvarchar(mat.note),
       'S', 'S', 'S'
  from civmat mat
 where mat.note is not null
UNION
select 4, mat.id, mat.ufficio, mat.anno, mat.parte, mat.serie, mat.atto, mat.id_atto,
       0, 
       decode(mat.id_atto_ansc, '', 'A.N.S.C. - Atto NON validato ', 'A.N.S.C. - Atto digitale'), 
       f_varchar2nvarchar('id Ansc: '||mat.id_atto_ansc||' - Numero Comunale: '||mat.numero_unico),
       'S', 'S', 'S'
  from civmat mat
 where mat.numero_unico is not null
   and mat.id_atto_ansc is null
   and f_flag_ANSC = 'S'
UNION
select 5, mor.id, mor.ufficio, mor.anno, mor.parte, mor.serie, mor.atto, mor.id_atto,
       9, 
       'Atto con Note compilate', 
       f_varchar2nvarchar(mor.note),
       'S', 'S', 'S'
  from civmor mor
 where mor.note is not null
UNION
select 5, mor.id, mor.ufficio, mor.anno, mor.parte, mor.serie, mor.atto, mor.id_atto,
       0, 
       decode(mor.id_atto_ansc, '', 'A.N.S.C. - Atto NON validato ', 'A.N.S.C. - Atto digitale'), 
       f_varchar2nvarchar('id Ansc: '||mor.id_atto_ansc||' - Numero Comunale: '||mor.numero_unico),
       'S', 'S', 'S'
  from civmor mor
 where mor.numero_unico is not null
   and mor.id_atto_ansc is null
   and f_flag_ANSC = 'S'
UNION
select -4, uci.id, uci.ufficio, uci.anno, uci.parte, uci.serie, uci.atto, uci.id_atto,
       9, 
       'Atto con Note compilate', 
       f_varchar2nvarchar(uci.note),
       'S', 'S', 'S'
  from civuci uci
 where uci.note is not null
UNION
select -4, uci.id, uci.ufficio, uci.anno, uci.parte, uci.serie, uci.atto, uci.id_atto,
       0, 
       decode(uci.id_atto_ansc, '', 'A.N.S.C. - Atto NON validato ', 'A.N.S.C. - Atto digitale'), 
       f_varchar2nvarchar('id Ansc: '||uci.id_atto_ansc||' - Numero Comunale: '||uci.numero_unico),
       'S', 'S', 'S'
  from civuci uci
 where uci.numero_unico is not null
   and uci.id_atto_ansc is null
   and f_flag_ANSC = 'S'
UNION
select 2, nas.id, nas.ufficio, nas.anno, nas.parte, nas.serie, nas.atto, nas.id_atto,
       diz.id, 
       'Atto con caratteri speciali', 
       diz.descrizione||': '||uni.cognome_nome,
       'S', 'S', 'S'
  from gsdana_unicode_diz diz
     , civnas nas
     , gsdana_unicode uni
 where diz.codice       = uni.campo_rif
   and diz.modulo_rif   in ('CIV','GSD')
   and nas.id           = to_number(uni.id_rif)
   and uni.tabella_rif  = 'CIVNAS'
UNION
select 4, mat.id, mat.ufficio, mat.anno, mat.parte, mat.serie, mat.atto, mat.id_atto,
       diz.id, 
       'Atto con caratteri speciali', 
       diz.descrizione||': '||uni.cognome_nome,
       'S', 'S', 'S'
  from gsdana_unicode_diz diz
     , civmat mat
     , gsdana_unicode uni
 where diz.codice       = uni.campo_rif
   and diz.modulo_rif   in ('CIV','GSD')
   and mat.id           = to_number(uni.id_rif)
   and uni.tabella_rif  = 'CIVMAT'
UNION
select 5, mor.id, mor.ufficio, mor.anno, mor.parte, mor.serie, mor.atto, mor.id_atto,
       diz.id, 
       'Atto con caratteri speciali', 
       diz.descrizione||': '||uni.cognome_nome,
       'S', 'S', 'S'
  from gsdana_unicode_diz diz
     , civmor mor
     , gsdana_unicode uni
 where diz.codice       = uni.campo_rif
   and diz.modulo_rif   in ('CIV','GSD')
   and mor.id           = to_number(uni.id_rif)
   and uni.tabella_rif  = 'CIVMOR'
UNION
select -4, uci.id, uci.ufficio, uci.anno, uci.parte, uci.serie, uci.atto, uci.id_atto,
       diz.id, 
       'Atto con caratteri speciali', 
       diz.descrizione||': '||uni.cognome_nome,
       'S', 'S', 'S'
  from gsdana_unicode_diz diz
     , civuci uci
     , gsdana_unicode uni
 where diz.codice       = uni.campo_rif
   and diz.modulo_rif   in ('CIV','GSD')
   and uci.id           = to_number(uni.id_rif)
   and uni.tabella_rif  = 'CIVUCI'
/
comment on table CIVMSG_ZK is 'Stato Civile - Messaggi per Atti - ZK (view)'
/
