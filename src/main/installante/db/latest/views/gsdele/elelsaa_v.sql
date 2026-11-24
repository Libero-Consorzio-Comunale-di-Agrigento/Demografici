--liquibase formatted sql
--changeset amonopoli:202602130945_2 runOnChange:true stripComments:false
create or replace function f_LSAA_flag_fuori_sede
(a_matricola		IN	number
,a_anno_elezioni	IN	number
,a_progr_elezioni	IN	number
)

return varchar2

IS

w_flag		varchar2(255);

begin
  if a_matricola is not null and a_anno_elezioni is not null and a_progr_elezioni is not null then
     begin
       select 'S'
         into w_flag
         from eleefs efs
        where matricola      = a_matricola
          and anno_elezioni  = a_anno_elezioni
          and progr_elezioni = a_progr_elezioni
          and rownum = 1
       ;
     exception
       when others then
            w_flag := '';
     end;
  end if;

  return w_flag;

end;
/
create or replace view elelsaa_v_flag
       (matricola, flag_depennato_art_33, flag_voto_estero, flag_opzione_voto_italia, flag_fuori_sede)
AS
select 
-- matricola
       ele.matricola,
-- flag_depennato_art_33
       decode(ele.stato,'E',
         decode(par_v.w_data_elezioni_j,'','',
           decode(sign(add_months(to_date(ana.data_nas,'j'),216) - to_date(par_v.w_data_elezioni_j,'j')),1,'S'))),
-- flag_voto_estero
       to_char(null),
-- flag_opzione_voto_italia
       to_char(null),
-- flag_fuori_sede
       f_LSAA_flag_fuori_sede(ele.matricola,par_v.w_anno_elezioni,par_v.w_progr_elezioni)
  from tabrep_lsaa par_v, anaana ana, eleela ele
 where par_v.w_ai_seggi = 'S'
   and par_v.terminale  = 'ELESAA3'
   and par_v.w_sesso    = 'X'
   and ana.matricola    = ele.matricola
   and ele.stato        = 'E'
/
comment on table elelsaa_v_flag is 'Elettorale - Flag per gestione Stampa Lista Sezionale - Aggiunte (view)'
/
create or replace view elelsaa_v
      (TIPO_LISTA, SESSO, 
       PROGR_LISTA_GEN, PROGR_LISTA_SEZ, ANNO, FASCICOLO, SEZIONE,
       MATRICOLA, COGNOME_NOME, LUOGO_DATA_NAS, ATTO, TRIBUNALE,
       INDIRIZZO, PROFESSIONE, TITOLO_STUDIO,
       EMIGRATO, 
       MOTIVO_1, MOTIVO_2, VERBALE_1, VERBALE_2, 
       STATO, ARCHIVIO_RIF, 
       COGNOME_ORD, NOME_ORD, DATA_NAS_ORD,
       FLAG_DEPENNATO_ART_33, FLAG_VOTO_ESTERO, FLAG_OPZIONE_VOTO_ITALIA, FLAG_FUORI_SEDE)
AS
select 
-- tipo_lista
       ele.tipo_lista,
-- sesso
       ele.sesso,
-- progr_lista_gen
       ele.progr_lista_gen,
-- progr_lista_sez
       ele.progr_lista_sez, 
-- anno
       ele.anno,
-- fascicolo
       ele.fascicolo,
-- sezione
       ele.sezione,
-- matricola
       ele.matricola, 
-- cognome_nome
       translate(ele.cognome_nome,'/',' '), 
-- luogo_data_nas
       d.descrizione||
         decode(d.sigla_provincia,'','',' ('||d.sigla_provincia||')')||
         ' il '||to_char(to_date(data_nas,'j'),'dd/mm/yyyy'), 
-- atto
       decode(ana.atto_nas_digitale,'',
         atto_nas||' '||parte_nas||serie_nas||' '||ufficio_nas,
         ana.atto_nas_digitale)||
        decode(ana.cod_com_atto_nas||ana.cod_pro_atto_nas,ana.cod_com_nas||ana.cod_pro_nas,'',
        decode(n.descrizione,'','',' - '||n.descrizione||decode(n.sigla_provincia,'','',' ('||n.sigla_provincia||')'))), 
-- tribunale
       c.descrizione||decode(c.sigla_provincia,'','',' ('||c.sigla_provincia||')'), 
-- indirizzo
       decode(ele.cod_via_ele,'',
         ele.via_aire_ele||' '||b.descrizione||decode(b.sigla_provincia, '','',' ('||b.sigla_provincia||')'), 
         bvie.denom_uff||civico_esterno_ele||decode(f_valore_inp('INTERNO_E',1,1,'X','S'),'N','',civico_interno_ele)), 
-- professione
       to_char(null),
-- titolo_studio
       to_char(null),
-- emigrato
       decode(ana.fascia,3,'RESIDENTE ALL''ESTERO', 4,'RESIDENTE ALL''ESTERO',
         decode(flag_v.flag_fuori_sede,'','','ELETTORE FUORI SEDE')), 
-- motivo_1
       decode(ele.stato,'E',
         decode(flag_v.flag_depennato_art_33, 'S', 'DEPENNATO AI SENSI',
           decode(flag_v.flag_fuori_sede,'S','VOTA IN ALTRO COMUNE',
             decode(par_v.w_f_vota_solo_per,'S','VOTA SOLO'))),
         'CANCELLAZIONE PER'),
-- motivo_2
       decode(ele.stato,'E',
         decode(flag_v.flag_depennato_art_33, 'S', 'DELL''ART.33 DEL T.U.',
           decode(flag_v.flag_fuori_sede,'S','',
             decode(par_v.w_f_vota_solo_per,'S','PER LE ELEZIONI'))),
         substr(dmo.descrizione,1,25)), 
-- verbale_1
       decode(ele.stato,'E',
         decode(flag_v.flag_depennato_art_33, 'S', '20/03/1967, N. 223',
           decode(flag_v.flag_fuori_sede,'S','',
             decode(par_v.w_f_vota_solo_per,'S',nvl(rtrim(par_v.w_vota_solo_per),'AMMINISTRATIVE')))),
         'Verbale N.'||dsr.verbale), 
-- verbale_2
       decode(ele.stato,'E','',
         'del '||to_char(to_date(dsr.data_verbale,'j'),'dd/mm/yyyy')), 
-- stato
       ele.stato,
--
-- archivio_rif
       'ANA' archivio_rif, 
-- cognome_ord
       replace(replace(upper(f_cognome(ele.cognome_nome)),' ',''),'''','') cognome_ord, 
-- nome_ord
       replace(replace(upper(f_nome(ele.cognome_nome)),' ',''),'''','') nome_ord, 
-- data_nas_ord
       ana.data_nas,
-- flag_depennato_art_33
       flag_v.flag_depennato_art_33,
-- flag_voto_estero
       flag_v.flag_voto_estero,
-- flag_opzione_voto_italia
       flag_v.flag_opzione_voto_italia,
-- flag_fuori_sede
       flag_v.flag_fuori_sede
  from tabrep_lsaa par_v, elelsaa_v_flag flag_v,
       arccom b,arcvie bvie,eledmo dmo,eledsr dsr,
       anaana ana,eleela ele,arccom d,arccom c,arccom n
 where par_v.terminale       = 'ELESAA3'
   and par_v.w_sesso         = 'X'
   and flag_v.matricola (+)  = ele.matricola
   and b.cod_comune    (+)   = ele.cod_com_aire_ele 
   and b.cod_provincia (+)   = ele.cod_pro_aire_ele 
   and bvie.cod_via    (+)   = ele.cod_via_ele 
   and ana.matricola         = ele.matricola 
   and dmo.cod_mo            = ele.motivo 
   and dsr.anno        (+)   = ele.anno 
   and dsr.revisione   (+)   = ele.revisione 
   and dsr.progr_revisione (+) = ele.progr_revisione 
   and d.cod_comune    (+)   = ana.cod_com_nas 
   and d.cod_provincia (+)   = ana.cod_pro_nas 
   and c.cod_comune    (+)   = substr(lpad(d.tribunale,6,0),4,3) 
   and c.cod_provincia (+)   = substr(lpad(d.tribunale,6,0),1,3) 
   and n.cod_comune    (+)   = ana.cod_com_atto_nas 
   and n.cod_provincia (+)   = ana.cod_pro_atto_nas
UNION 
select 
-- tipo_lista
       ans.tipo_lista,
-- sesso 
       ans.SESSO,
-- progr_lista_gen
       ans.progr_lista_gen,
-- progr_lista_sez
       ans.progr_lista_sez, 
-- anno
       ans.anno,
-- fascicolo
       ans.fascicolo,
-- sezione
       ans.sezione,
-- matricola
       ans.matricola, 
-- cognome_nome
       translate(ans.cognome_nome,'/',' '), 
-- luogo_data_nas
       d.descrizione||decode(d.sigla_provincia,'','',' ('||d.sigla_provincia||')')||
         ' il '||to_char(to_date(data_nas,'j'),'dd/mm/yyyy'), 
-- atto
       decode(ana.atto_nas_digitale,'',
         atto_nas||' '||parte_nas||serie_nas||' '||ufficio_nas,
         ana.atto_nas_digitale)||
        decode(ana.cod_com_atto_nas||ana.cod_pro_atto_nas,ana.cod_com_nas||ana.cod_pro_nas,'',
        decode(n.descrizione,'','',' - '||n.descrizione||decode(n.sigla_provincia,'','',' ('||n.sigla_provincia||')'))), 
-- tribunale
       c.descrizione||decode(c.sigla_provincia,'','',' ('||c.sigla_provincia||')'), 
-- indirizzo
       decode(ans.cod_via_ele,'',
         ans.via_aire_ele||' '||b.descrizione||decode(b.sigla_provincia,'','',' ('||b.sigla_provincia||')'), 
         bvie.denom_uff||' '||ans.civico_esterno_ele||decode(f_valore_inp('INTERNO_E',1,1,'X','S'),'N','',ans.civico_interno_ele)), 
-- professione
       to_char(null),
-- titolo_studio
       to_char(null),
-- emigrato
       decode(ana.fascia,3,'RESIDENTE ALL''ESTERO',4,'RESIDENTE ALL''ESTERO'), 
-- motivo_1
       decode(ans.stato,'E', 
         decode(ans.motivo_e,8,'CANCELLAZIONE PER', 'TRASFERIMENTO ALLA'), 
         'CANCELLAZIONE PER'), 
-- motivo_2
       decode(ans.stato,'E', 
         decode(ans.motivo_e,8,'CAMBIO GENERALITA''', 'SEZIONE N.'||ele.sezione), 
         substr(dmo.descrizione,1,20)), 
-- verbale_1
       decode(ans.stato,'E', 
         'Verbale N.'||adsr.verbale, 
         'Verbale N.'||bdsr.verbale), 
-- verbale_2
       decode(ans.stato,'E', 
         'del '||to_char(to_date(adsr.data_verbale,'j'),'dd/mm/yyyy'), 
         'del '||to_char(to_date(bdsr.data_verbale,'j'),'dd/mm/yyyy')), 
-- stato
--       ans.stato,
       'C',
--
-- archivio_rif
       'ANS', 
-- cognome_ord
       upper(f_cognome(ans.cognome_nome)), 
-- nome_ord
       upper(f_nome(ans.cognome_nome)), 
-- data_nas_ord
       ana.data_nas,
-- flag_depennato_art_33
       to_char(null),
-- flag_voto_estero
       to_char(null),
-- flag_opzione_voto_italia
       to_char(null),
-- flag_fuori_sede
       to_char(null)
  from arccom b,arcvie bvie,eledmo dmo,eledsr adsr,eledsr bdsr, 
               anaana ana,eleela ele,eleels ans,arccom d,arccom c,arccom n
 where dmo.cod_mo      = ans.motivo 
   and b.cod_comune    (+)   = ans.cod_com_aire_ele 
   and b.cod_provincia (+)   = ans.cod_pro_aire_ele 
   and bvie.cod_via    (+)   = ans.cod_via_ele 
   and ana.matricola         = ele.matricola 
   and (ele.sezione != ans.sezione or ele.progr_lista_sez != ans.progr_lista_sez) 
   and ele.matricola         = ans.matricola 
   and bdsr.anno        (+)   = ans.anno 
   and bdsr.revisione   (+)   = ans.revisione 
   and bdsr.progr_revisione (+)  = ans.progr_revisione 
   and adsr.anno        (+)   = ans.anno_e 
   and adsr.revisione   (+)   = ans.revisione_e 
   and adsr.progr_revisione (+)  = ans.progr_revisione_e 
   and (ans.anno_e||ans.revisione_e||lpad(ans.progr_revisione_e,2,'0')) = 
       (select max(anno_e||revisione_e||lpad(progr_revisione_e,2,'0'))
          from eleels b 
         where b.matricola        = ans.matricola 
           and b.sezione         = ans.sezione 
           and b.progr_lista_sez= ans.progr_lista_sez) 
   and d.cod_comune    (+)   = ana.cod_com_nas 
   and d.cod_provincia (+)   = ana.cod_pro_nas 
   and c.cod_comune    (+)   = substr(lpad(d.tribunale,6,0),4,3) 
   and c.cod_provincia (+)   = substr(lpad(d.tribunale,6,0),1,3) 
   and n.cod_comune    (+)   = ana.cod_com_atto_nas 
   and n.cod_provincia (+)   = ana.cod_pro_atto_nas 
/
comment on table elelsaa_v is 'Elettorale - Dati per Stampa Lista Sezionale - Aggiunte (view)'
/
