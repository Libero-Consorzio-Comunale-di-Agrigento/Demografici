--liquibase formatted sql
--changeset amonopoli:202503211244_2 runOnChange:true stripComments:false
create or replace view istddv_int (cod_modello, riga)
AS
select 'DDV',
       'PROGRESSIVO_QUEST'||';'||'ART6_ART12'||';'||
       'DATA_STIP'||';'||'DATA_REG'||';'||'N_ATTO'||';'||'P_ATTO'||';'||'S_ATTO'||';'||'TIPO_ACCORDO'||';'||
       'CAUSA_SCIOGLIMENTO'||';'||'DATA_SEPARAZIONE'||';'||
       'PROV_MATRIM_COD'||';'||'COM_MATRIM'||';'||'STATO_MATRIM'||';'||'RITO'||';'||'REGIME_PATRIMONIALE'||';'||
       'DATA_MATRIMONIO'||';'||
       'NOME_MARITO'||';'||'COGNOME_MARITO'||';'||'DATA_NASC_MARITO'||';'||'PROVNASC_MARITO'||';'||'COMNASC_MARITO'||';'||'STATONASC_MARITO'||';'||'CODFISC_MARITO'||';'||
       'PROVRES_MARITO'||';'||'COMRES_MARITO'||';'||'STATORES_MARITO'||';'||
       'CITT_MARITO'||';'||'DATA_CITT_MARITO'||';'||'STATOCITT_MARITO'||';'||'STATOCIV_MARITO'||';'||'TITSTUD_MARITO'||';'||'CONDPROF_MARITO'||';'||'POSPROF_MARITO'||';'||
       'NOME_MOGLIE'||';'||'COGNOME_MOGLIE'||';'||'DATA_NASC_MOGLIE'||';'||'PROVNASC_MOGLIE'||';'||'COMNASC_MOGLIE'||';'||'STATONASC_MOGLIE'||';'||'CODFISC_MOGLIE'||';'||
       'PROVRES_MOGLIE'||';'||'COMRES_MOGLIE'||';'||'STATORES_MOGLIE'||';'||
       'CITT_MOGLIE'||';'||'DATA_CITT_MOGLIE'||';'||'STATOCITT_MOGLIE'||';'||'STATOCIV_MOGLIE'||';'||'TITSTUD_MOGLIE'||';'||'CONDPROF_MOGLIE'||';'||'POSPROF_MOGLIE'||';'||
       'NOME_AVV_MAR'||';'||'COGNOME_AVV_MAR'||';'||'CODFISC_AVV_MAR'||';'||'ALBO_MAR'||';'||
       'NOME_AVV_MOG'||';'||'COGNOME_AVV_MOG'||';'||'CODFISC_AVV_MOG'||';'||'ALBO_MOG'||';'||
       'SOSTCON'||';'||'FLAG_IMPCON'||';'||'IMPCON_MENS'||';'||'IMPCON_UNICO'||';'||'CHI_SOSTCON'||';'||'ASS_ABITAZ'||';'||
       'FIGLI'||';'||'NR_FIGLI'||';'||
       'FIGLI_MIN'||';'||'NFIGLI_MIN'||';'||'FIGLI_A_CARICO'||';'||'NFIGLI_A_CARICO'||';'||
       'NOME1'||';'||'COGNOME1'||';'||'SESSO1'||';'||'DATANAS1'||';'||'ETA1'||';'||'CODFISC1'||';'||'AFFID1'||';'||'N_PERNOTTAMENTI1'||';'||
       'NOME2'||';'||'COGNOME2'||';'||'SESSO2'||';'||'DATANAS2'||';'||'ETA2'||';'||'CODFISC2'||';'||'AFFID2'||';'||'N_PERNOTTAMENTI2'||';'||
       'NOME3'||';'||'COGNOME3'||';'||'SESSO3'||';'||'DATANAS3'||';'||'ETA3'||';'||'CODFISC3'||';'||'AFFID3'||';'||'N_PERNOTTAMENTI3'||';'||
       'NOME4'||';'||'COGNOME4'||';'||'SESSO4'||';'||'DATANAS4'||';'||'ETA4'||';'||'CODFISC4'||';'||'AFFID4'||';'||'N_PERNOTTAMENTI4'||';'||
       'SOSTFIG'||';'||'CAPITOLI_SPESA1'||';'||'CAPITOLI_SPESA2'||';'||'CAPITOLI_SPESA3'||';'||'CAPITOLI_SPESA4'||';'||'CAPITOLI_SPESA5'||';'||
       'CHI_SOSTFIG'||';'||'IMPFIG'||';'||'SOST_FIGLI_MAGG'
  from dual
/
comment on table ISTDDV_INT is 'ISTAT - Dati per Compilazione Modello SC - Intestazioni (view)'
/
