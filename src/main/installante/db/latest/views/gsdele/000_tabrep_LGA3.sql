--liquibase formatted sql
--changeset amonopoli:202603061505_1 runOnChange:true stripComments:false
create or replace view tabrep_LGA3
AS
select par.terminale 
     , substr(par.parametri,1,1) w_sesso
     , ltrim(substr(par.parametri,2,6),'0') w_da_progr
     , ltrim(substr(par.parametri,8,6),'0') w_a_progr
     , substr(par.parametri,14,1) w_stampa_chiusura
     , rtrim(substr(par.parametri,15,10)) w_verbale
     , ltrim(substr(par.parametri,25,7),'0') w_data_verbale_j
     , to_char(to_date(ltrim(substr(par.parametri,25,7),'0'),'j'),'dd/mm/yyyy') w_data_verbale
     , ltrim(substr(par.parametri,32,4),'0') w_anno_elezioni
     , ltrim(substr(par.parametri,36,2),'0') w_progr_elezioni
     , ltrim(substr(par.parametri,38,7),'0') w_data_elezioni_j
     , to_char(to_date(ltrim(substr(par.parametri,38,7),'0'),'j'),'dd/mm/yyyy') w_data_elezioni
     , substr(par.parametri,45,1) w_timbro1_1
     , substr(par.parametri,46,1) w_timbro1_2
     , substr(par.parametri,47,1) w_timbro1_3
     , substr(par.parametri,48,1) w_timbro2_1
     , substr(par.parametri,49,1) w_timbro2_2
     , substr(par.parametri,50,1) w_timbro2_3
     , substr(par.parametri,51,1) w_salto_p
     , rtrim(substr(par.parametri,52,10)) w_verbale2_1
     , ltrim(substr(par.parametri,62,7),'0') w_data_verbale2_1_j
     , to_char(to_date(ltrim(substr(par.parametri,62,7),'0'),'j'),'dd/mm/yyyy') w_data_verbale2_1
     , rtrim(substr(par.parametri,69,10)) w_verbale2_2
     , ltrim(substr(par.parametri,79,7),'0') w_data_verbale2_2_j
     , to_char(to_date(ltrim(substr(par.parametri,79,7),'0'),'j'),'dd/mm/yyyy') w_data_verbale2_2
     , substr(par.parametri,86,1) w_tipo_firma
     , ltrim(substr(par.parametri,87,7),'0') w_data_verbale2_3_j
     , to_char(to_date(ltrim(substr(par.parametri,87,7),'0'),'j'),'dd/mm/yyyy') w_data_verbale2_3
     , rtrim(substr(par.parametri,94,10)) w_verbale1_3
     , ltrim(substr(par.parametri,104,7),'0') w_data_verbale1_3_j
     , to_char(to_date(ltrim(substr(par.parametri,104,7),'0'),'j'),'dd/mm/yyyy') w_data_verbale1_3
     , decode(dur.progr_semestrale,1,'20 Giugno',2,'20 Dicembre') w_data_rif_semestrale
     , decode(dcc.sottocommissione,'S','Sottocommissione','Commissione') w_commissione
  from eledcc dcc, eledur dur, TABREP par
 where par.chiave = 'LGA3'      
/
comment on table tabrep_LGA3 is 'Elettorale - Parametri per elaborazione Lista Generale (view)'
/
