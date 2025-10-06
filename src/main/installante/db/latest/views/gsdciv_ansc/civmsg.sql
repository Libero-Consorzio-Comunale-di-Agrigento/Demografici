--liquibase formatted sql
--changeset amonopoli:202310060825 runOnChange:true stripComments:false
create or replace view civmsg
	(tipo_atto, id, ufficio, anno, parte, serie, atto, id_atto,
         sequenza, messaggio, dettaglio, 
         flag_avviso, flag_cer, flag_civ)
as
select 2, nas.id, nas.ufficio, nas.anno, nas.parte, nas.serie, nas.atto, nas.id_atto,
       9, 'Atto con Note compilate', nas.note,
       'S', 'S', 'S'
  from civnas nas
 where nas.note is not null
UNION
select 2, nas.id, nas.ufficio, nas.anno, nas.parte, nas.serie, nas.atto, nas.id_atto,
       0, 
       decode(nas.id_atto_ansc, '', 'A.N.S.C. - Atto NON validato ', 'A.N.S.C. - Atto digitale'), 
       'id Ansc: '||nas.id_atto_ansc||' - Numero Comunale: '||nas.numero_unico,
       'S', 'S', 'S'
  from civnas nas
 where nas.numero_unico||nas.id_atto_ansc is not null
   and f_flag_ANSC = 'S'
UNION
select 4, mat.id, mat.ufficio, mat.anno, mat.parte, mat.serie, mat.atto, mat.id_atto,
       9, 'Atto con Note compilate', mat.note,
       'S', 'S', 'S'
  from civmat mat
 where mat.note is not null
UNION
select 4, mat.id, mat.ufficio, mat.anno, mat.parte, mat.serie, mat.atto, mat.id_atto,
       0, 
       decode(mat.id_atto_ansc, '', 'A.N.S.C. - Atto NON validato ', 'A.N.S.C. - Atto digitale'), 
       'id Ansc: '||mat.id_atto_ansc||' - Numero Comunale: '||mat.numero_unico,
       'S', 'S', 'S'
  from civmat mat
 where mat.numero_unico||mat.id_atto_ansc is not null
   and f_flag_ANSC = 'S'
UNION
select 5, mor.id, mor.ufficio, mor.anno, mor.parte, mor.serie, mor.atto, mor.id_atto,
       9, 'Atto con Note compilate', mor.note,
       'S', 'S', 'S'
  from civmor mor
 where mor.note is not null
UNION
select 5, mor.id, mor.ufficio, mor.anno, mor.parte, mor.serie, mor.atto, mor.id_atto,
       0, 
       decode(mor.id_atto_ansc, '', 'A.N.S.C. - Atto NON validato ', 'A.N.S.C. - Atto digitale'), 
       'id Ansc: '||mor.id_atto_ansc||' - Numero Comunale: '||mor.numero_unico,
       'S', 'S', 'S'
  from civmor mor
 where mor.numero_unico||mor.id_atto_ansc is not null
   and f_flag_ANSC = 'S'
UNION
select 5, mor.id, mor.ufficio, mor.anno, mor.parte, mor.serie, mor.atto, mor.id_atto,
       1, 
       'ATTENZIONE', 
       'Certificazione ANSC su Atto di Morte: il Richiedente deve essere diverso dal Beneficiario',
       'S', 'S', 'S'
  from civmor mor
 where mor.id_atto_ansc is not null
   and f_flag_ANSC = 'S'
UNION
select -4, uci.id, uci.ufficio, uci.anno, uci.parte, uci.serie, uci.atto, uci.id_atto,
       9, 'Atto con Note compilate', uci.note,
       'S', 'S', 'S'
  from civuci uci
 where uci.note is not null
UNION
select -4, uci.id, uci.ufficio, uci.anno, uci.parte, uci.serie, uci.atto, uci.id_atto,
       0, 
       decode(uci.id_atto_ansc, '', 'A.N.S.C. - Atto NON validato ', 'A.N.S.C. - Atto digitale'), 
       'id Ansc: '||uci.id_atto_ansc||' - Numero Comunale: '||uci.numero_unico,
       'S', 'S', 'S'
  from civuci uci
 where uci.numero_unico||uci.id_atto_ansc is not null
   and f_flag_ANSC = 'S'
/
comment on table CIVMSG	is 'Stato Civile - Messaggi per Atti (view)'
/
