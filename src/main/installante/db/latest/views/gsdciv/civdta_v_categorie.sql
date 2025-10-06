--liquibase formatted sql
--changeset snocca:202309271630_3 runOnChange:true stripComments:false
CREATE OR REPLACE VIEW CIVDTA_V_CATEGORIE
(id, tipo_atto, parte, serie, id_categoria, categoria, descrizione_voce, tipo, sequenza, flag_pregresso, flag_divorzio, flag_verbale, flag_ansc)
AS
select distinct decode(v.count_dta,1,dta.ID)
     , dta.TIPO_ATTO
     , dta.PARTE
     , dta.SERIE
     , v.ID_CIVCTA AS ID_CATEGORIA
     , v.CATEGORIA AS CATEGORIA
     , rtrim(
       decode(dta.tipo_atto,
         3, decode(v.count_dta,1, dta.DESCRIZIONE,v.DES_CATEGORIA),
            decode(dta.PARTE,'','','Parte '||dta.parte||' - ')||
              decode(dta.SERIE, '','','Serie '||dta.serie||' - ')||
                decode(v.flag_pregresso,'S','',
                  decode(v.count_dta,1, dta.DESCRIZIONE,v.DES_CATEGORIA))
       ),' - ') AS DESCRIZIONE_VOCE
     , decode(v.count_dta,1,'T','C') AS TIPO
     , decode(v.count_dta,1,v.min_sequenza,100 + v.min_sequenza) AS SEQUENZA
     , v.flag_pregresso AS FLAG_PREGRESSO
     , v.flag_divorzio  AS FLAG_DIVORZIO
     , v.flag_verbale   AS FLAG_VERBALE
     , dta.flag_ansc    AS FLAG_ANSC
  from (SELECT dta.tipo_atto, dta.parte, dta.serie, dta.id_civcta, cta.sigla categoria, cta.descrizione des_categoria,
               cta.flag_pregresso, cta.flag_divorzio, cta.flag_verbale, dta.flag_ansc,
               min(dta.sequenza) min_sequenza,
               COUNT(*) count_dta
          FROM CIVCTA cta, CIVDTA dta
         WHERE cta.id            = dta.id_civcta
           AND dta.flag_pregresso is null
           AND dta.flag_dismesso is null
         group by dta.tipo_atto, dta.parte, dta.serie, dta.id_civcta, cta.sigla, cta.descrizione, cta.flag_pregresso, cta.flag_divorzio, cta.flag_verbale, dta.flag_ansc) v
     , CIVDTA dta
 where v.TIPO_ATTO            = dta.TIPO_ATTO
   and COALESCE(v.PARTE, 0)   = COALESCE(dta.PARTE, 0)
   and COALESCE(v.SERIE, ' ') = COALESCE(dta.SERIE, ' ')
   and v.ID_CIVCTA            = dta.ID_CIVCTA
   and nvl(v.flag_ansc,'N')   = nvl(dta.flag_ansc,'N')
   and dta.flag_dismesso  is null
   and dta.flag_pregresso is null
UNION
--
-- tipi di atto associati a categoria, duplicati in versione "pregresso"
-- (per i soli tipi di atto che non hanno il flag attivo)
--
select v.id
     , v.TIPO_ATTO
     , v.PARTE
     , v.SERIE
     , v.ID_CIVCTA AS ID_CATEGORIA
     , v.SIGLA AS CATEGORIA
     , rtrim(
       decode(v.PARTE,'','','Parte '||v.parte||' - ')||
         decode(v.SERIE, '','','Serie '||v.serie||' - ')||
         decode(v.tipo_atto, 1, decode(v.natura, 'A', 'ACQUISTO', 'P', 'PERDITA', 'D', decode(v.sigla, 'ATL', 'ALTRO', 'GIURAMENTO') ),
           decode(v.sigla,
             'ATL',decode(v.NATURA, 'O','ORIGINALE', 'T', 'TRASCRITTO', 'D', 'ALTRO', 'A','ACQUISTO', 'P','PERDITA'),
             'T2','TRASCRITTO')),' - ') AS DESCRIZIONE_VOCE
     , 'T' AS TIPO
     , v.sequenza AS SEQUENZA
     , 'S' AS FLAG_PREGRESSO
     , TO_CHAR(NULL) AS FLAG_DIVORZIO
     , TO_CHAR(NULL) AS FLAG_VERBALE
     , v.flag_ansc   AS FLAG_ANSC
from (select d.tipo_atto,
             d.id,
             d.parte,
             d.serie,
             d.natura,
             d.id_civcta,
             c.sigla,
             d.sequenza,
             d.flag_ansc
          from civdta d, civcta c
         where d.id_civcta = c.id
           and c.flag_pregresso is null
           and ((d.tipo_atto = 2 and d.parte||d.serie != '2B')
                OR (d.tipo_atto in (4, 5) and d.parte||d.serie != '2C')
                OR (d.tipo_atto = -4 and c.sigla in ('O1')))
           and d.flag_dismesso is null
        UNION
      select d.tipo_atto,
             d.id,
             d.parte,
             d.serie,
             d.natura,
             d.id_civcta,
             c.sigla,
             d.sequenza,
             d.flag_ansc
          from civdta d, civcta c
         where d.id_civcta = c.id
           and d.flag_pregresso = 'S'
           and d.flag_dismesso is null
        ) v
UNION
--
-- inserimento del livello '0' per gli atti pregressi
--
select distinct to_number(null)
     , dta.TIPO_ATTO
     , to_number(null)
     , to_char(null)
     , 0 AS ID_CATEGORIA
     , 'PRE' AS CATEGORIA
     , 'ATTO PREGRESSO' AS DESCRIZIONE_VOCE
     , 'P' AS TIPO
     , 999
     , TO_CHAR(NULL) AS FLAG_PREGRESSO
     , TO_CHAR(NULL) AS FLAG_DIVORZIO
     , TO_CHAR(NULL) AS FLAG_VERBALE
     , dta.flag_ansc AS FLAG_ANSC
  from civdta dta
 where tipo_atto != 3
/
comment on table civdta_v_categorie is 'Stato Civile - Tipi di Atto raggruppati per Categoria'
/
