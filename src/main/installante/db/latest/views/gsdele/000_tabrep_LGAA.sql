--liquibase formatted sql
--changeset amonopoli:202603061510_1 runOnChange:true stripComments:false
create or replace view tabrep_LGAA
as
select terminale,
       ltrim(substr(parametri,1,1),'0') w_TIPO_LISTA,
       ltrim(substr(parametri,2,1),'0') w_SESSO,
       ltrim(substr(parametri,3,6),'0') w_DA_PROGR,
       ltrim(substr(parametri,9,6),'0') w_A_PROGR,
       substr(parametri,15,1) w_STAMPA_CHIUSURA,
       rtrim(substr(parametri,16,10),' ') w_VERBALE,
       ltrim(substr(parametri,26,7),'0') w_DATA_VERBALE_j,
       to_char(to_date(ltrim(substr(parametri,26,7),'0'),'j'),'dd/mm/yyyy') w_DATA_VERBALE,
       ltrim(substr(parametri,33,4),'0') w_ANNO_ELEZIONI,
       ltrim(substr(parametri,37,2),'0') w_PROGR_ELEZIONI,
       ltrim(substr(parametri,39,7),'0') w_DATA_ELEZIONI_j,
       to_char(to_date(ltrim(substr(parametri,39,7),'0'),'j'),'dd/mm/yyyy') w_DATA_ELEZIONI,
       nvl(rtrim(substr(parametri,46,1)),'N') w_TIMBRO1_1,
       nvl(rtrim(substr(parametri,47,1)),'N') w_TIMBRO1_2,
       nvl(rtrim(substr(parametri,48,1)),'N') w_TIMBRO1_3,
       nvl(rtrim(substr(parametri,49,1)),'N') w_TIMBRO2_1,
       nvl(rtrim(substr(parametri,50,1)),'N') w_TIMBRO2_2,
       nvl(rtrim(substr(parametri,51,1)),'N') w_TIMBRO2_3,
       nvl(rtrim(substr(parametri,52,1)),'N') w_SALTO_P,
       rtrim(substr(parametri,53,10),' ') w_VERBALE2_1,
       ltrim(substr(parametri,63,7),'0') w_DATA_VERBALE2_1_j,
       to_char(to_date(ltrim(substr(parametri,63,7),'0'),'j'),'dd/mm/yyyy') w_DATA_VERBALE2_1,
       rtrim(substr(parametri,70,10),' ') w_VERBALE2_2,
       ltrim(substr(parametri,80,7),'0') w_DATA_VERBALE2_2_j,
       to_char(to_date(ltrim(substr(parametri,80,7),'0'),'j'),'dd/mm/yyyy') w_DATA_VERBALE2_2,
       nvl(rtrim(substr(parametri,87,1)),'R') w_TIPO_FIRMA,
       ltrim(substr(parametri,88,7),'0') w_DATA_VERBALE2_3_j,
       to_char(to_date(ltrim(substr(parametri,88,7),'0'),'j'),'dd/mm/yyyy') w_DATA_VERBALE2_3,
       rtrim(substr(parametri,95,10),' ') w_VERBALE1_3,
       ltrim(substr(parametri,105,7),'0') w_DATA_VERBALE1_3_j,
       to_char(to_date(ltrim(substr(parametri,105,7),'0'),'j'),'dd/mm/yyyy') w_DATA_VERBALE1_3,
--
       decode(dur.progr_semestrale,1,'20 Giugno',2,'20 Dicembre') w_data_rif_semestrale,
       decode(dcc.sottocommissione,'S','Sottocommissione','Commissione') w_commissione,
       dtl.descrizione w_DES_TIPO_LISTA
  from eledcc dcc, eledur dur, eledtl dtl, tabrep
 where dtl.cod_tl = substr(parametri,1,1)
   and chiave     = 'LGAA'
/
comment on table tabrep_LGAA is 'Elettorale - Parametri per elaborazione Lista Generale Aggiunta (view)'
/
