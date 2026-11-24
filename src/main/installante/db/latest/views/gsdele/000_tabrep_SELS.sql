--liquibase formatted sql
--changeset amonopoli:202603061505_3 runOnChange:true stripComments:false
create or replace view tabrep_SELS
AS
select terminale 
     , substr(parametri,1,1) w_sesso
     , ltrim(substr(parametri,2,4),'0') w_da_sezione
     , ltrim(substr(parametri,6,4),'0') w_a_sezione
     , substr(parametri,10,1) w_stampa_chiusura
     , rtrim(substr(parametri,11,10)) w_verbale
     , ltrim(substr(parametri,21,7),'0') w_data_verbale_j
     , to_char(to_date(ltrim(substr(parametri,21,7),'0'),'j'),'dd/mm/yyyy') w_data_verbale
     , substr(parametri,28,1) w_ai_seggi
     , ltrim(substr(parametri,29,7),'0') w_data_elezioni_j
     , to_char(to_date(ltrim(substr(parametri,29,7),'0'),'j'),'dd/mm/yyyy') w_data_elezioni
     , substr(parametri,36,1) w_doppio_timbro
     , substr(parametri,37,1) w_flag_politiche
     , substr(parametri,38,1) w_stampa_visto
     , substr(parametri,39,1) w_alfabetico
     , substr(parametri,40,1) w_storico
     , ltrim(substr(parametri,41,4),'0') w_da_progr
     , ltrim(substr(parametri,45,4),'0') w_a_progr
     , ltrim(substr(parametri,49,4),'0') w_anno_elezioni
     , ltrim(substr(parametri,53,2),'0') w_progr_elezioni
     , substr(parametri,55,1) w_flag_referendum
     , substr(parametri,56,1) w_timbro1_1
     , substr(parametri,57,1) w_timbro1_2
     , substr(parametri,58,1) w_timbro1_3
     , substr(parametri,59,1) w_timbro2_1
     , substr(parametri,60,1) w_timbro2_2
     , substr(parametri,61,1) w_timbro2_3
     , substr(parametri,62,1) w_timbro2_4
     , substr(parametri,63,1) w_salto_p
     , rtrim(substr(parametri,64,10)) w_verbale2_1
     , ltrim(substr(parametri,74,7),'0') w_data_verbale2_1_j
     , to_char(to_date(ltrim(substr(parametri,74,7),'0'),'j'),'dd/mm/yyyy') w_data_verbale2_1
     , rtrim(substr(parametri,81,10)) w_verbale2_2
     , ltrim(substr(parametri,91,7),'0') w_data_verbale2_2_j
     , to_char(to_date(ltrim(substr(parametri,91,7),'0'),'j'),'dd/mm/yyyy') w_data_verbale2_2
     , substr(parametri,98,1) w_tipo_firma
     , substr(parametri,99,1) w_flag_amministrative
     , rtrim(substr(parametri,100,20)) w_vota_solo_per
     , ltrim(substr(parametri,120,7),'0') w_data_verbale2_3_j
     , to_char(to_date(ltrim(substr(parametri,120,7),'0'),'j'),'dd/mm/yyyy') w_data_verbale2_3
     , ltrim(substr(parametri,127,7),'0') w_data_verbale2_4_j
     , to_char(to_date(ltrim(substr(parametri,127,7),'0'),'j'),'dd/mm/yyyy') w_data_verbale2_4
     , rtrim(substr(parametri,134,10)) w_verbale1_3
     , ltrim(substr(parametri,144,7),'0') w_data_verbale1_3_j
     , to_char(to_date(ltrim(substr(parametri,144,7),'0'),'j'),'dd/mm/yyyy') w_data_verbale1_3
     , decode(dur.progr_semestrale,1,'20 Giugno',2,'20 Dicembre') w_data_rif_semestrale
     , decode(dcc.sottocommissione,'S','Sottocommissione','Commissione') w_commissione
  from eledcc dcc, eledur dur, TABREP
 where chiave = 'SELS'      
/
comment on table tabrep_SELS is 'Elettorale - Parametri per elaborazione Estratto Lista Sezionale (view)'
/
