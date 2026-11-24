--liquibase formatted sql
--changeset amonopoli:202603061510_3 runOnChange:true stripComments:false
create or replace view tabrep_SELA
AS
select terminale,
       substr(parametri,1,1) w_TIPO_LISTA, 
       substr(parametri,2,1) w_SESSO, 
       ltrim(substr(parametri,3,4),'0') w_DA_SEZIONE, 
       ltrim(substr(parametri,7,4),'0') w_A_SEZIONE,
       substr(parametri,11,1) w_STAMPA_CHIUSURA, 
       rtrim(substr(parametri,12,10),' ') w_VERBALE, 
       ltrim(substr(parametri,22,7),'0') w_DATA_VERBALE_j,
       to_char(to_date(ltrim(substr(parametri,22,7),'0'),'j'),'dd/mm/yyyy') w_DATA_VERBALE,
       substr(parametri,29,1) w_AI_SEGGI, 
       ltrim(substr(parametri,30,7),'0') w_DATA_ELEZIONI_j, 
       to_char(to_date(ltrim(substr(parametri,30,7),'0'),'j'),'dd/mm/yyyy') w_DATA_ELEZIONI, 
       substr(parametri,37,1) w_DOPPIO_TIMBRO, 
       'N' w_FLAG_POLITICHE, 
       substr(parametri,39,1) w_stampa_visto, 
       substr(parametri,40,1) w_alfabetico, 
       substr(parametri,41,1) w_storico, 
       substr(parametri,42,4) w_da_progr, 
       substr(parametri,46,4) w_a_progr,
       nvl(substr(parametri,50,1),'N') w_TIMBRO1_1,
       nvl(substr(parametri,51,1),'N') w_TIMBRO1_2,
       nvl(substr(parametri,52,1),'N') w_TIMBRO1_3,
       nvl(substr(parametri,53,1),'N') w_TIMBRO2_1,
       nvl(substr(parametri,54,1),'N') w_TIMBRO2_2,
       nvl(substr(parametri,55,1),'N') w_TIMBRO2_3,
       nvl(substr(parametri,56,1),'N') w_TIMBRO2_4,
       nvl(substr(parametri,57,1),'N') w_SALTO_P,  
       rtrim(substr(parametri,58,10),' ') w_VERBALE2_1, 
       ltrim(substr(parametri,68,7),'0') w_DATA_VERBALE2_1_j, 
       to_char(to_date(ltrim(substr(parametri,68,7),'0'),'j'),'dd/mm/yyyy') w_DATA_VERBALE2_1, 
       rtrim(substr(parametri,75,10),' ') w_VERBALE2_2, 
       ltrim(substr(parametri,85,7),'0') w_DATA_VERBALE2_2_j,
       to_char(to_date(ltrim(substr(parametri,85,7),'0'),'j'),'dd/mm/yyyy') w_DATA_VERBALE2_2,
       nvl(rtrim(substr(parametri,92,1)),'R') w_TIPO_FIRMA,
       ltrim(substr(parametri,93,7),'0') w_DATA_VERBALE2_3_j, 
       to_char(to_date(ltrim(substr(parametri,93,7),'0'),'j'),'dd/mm/yyyy') w_DATA_VERBALE2_3, 
       ltrim(substr(parametri,100,7),'0') w_DATA_VERBALE2_4_j, 
       to_char(to_date(ltrim(substr(parametri,100,7),'0'),'j'),'dd/mm/yyyy') w_DATA_VERBALE2_4, 
       rtrim(substr(parametri,107,10),' ') w_verbale1_3, 
       ltrim(substr(parametri,117,7),'0') w_data_verbale1_3_j,
       to_char(to_date(ltrim(substr(parametri,117,7),'0'),'j'),'dd/mm/yyyy') w_data_verbale1_3,
       dtl.descrizione w_DES_TIPO_LISTA,
       nvl(substr(parametri,124,1),'N') w_f_vota_solo_per, 
       substr(parametri,125,20) w_vota_solo_per, 
       ltrim(substr(parametri,145,4),'0') w_anno_elezioni, 
       ltrim(substr(parametri,149,2),'0') w_progr_elezioni,
--
       to_char(null) w_flag_referendum,
       to_char(null) w_flag_amministrative,
       decode(dur.progr_semestrale,1,'20 Giugno',2,'20 Dicembre') w_data_rif_semestrale,
       decode(dcc.sottocommissione,'S','Sottocommissione','Commissione') w_commissione,
       dtl.descrizione des_tipo_lista
  from eledcc dcc, eledur dur, eledtl dtl, tabrep
 where dtl.cod_tl = substr(parametri,1,1)
   and chiave     = 'SELA'
/
comment on table tabrep_SELA is 'Elettorale - Parametri per elaborazione Estratto Lista Sezionale Aggiunta (view)'
/
