--liquibase formatted sql
--changeset amonopoli:202312211005_2 runOnChange:true stripComments:false
create or replace view isteddv_int (cod_modello, riga)
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
UNION
select 'DDV_2024',
       'PROGRESSIVO_QUEST'||';'||'TIPO_PROCEDURA'||';'||
       'N_ATTO'||';'||'P_ATTO'||';'||'S_ATTO'||';'||
       'DATA_STIP'||';'||'DATA_REG'||';'||
       'TIPO_ACCORDO_EXTRA'||';'||
       'COD_TRIBUNALE'||';'||'COD_CORTE'||';'||'DATA_PROC'||';'||'DATA_PROVV'||';'||'DATA_TRASCR'||';'||'TIPO_PROVV_TRIB'||';'||
       'CAUSA_SCIOGLIMENTO'||';'||'DATA_SEPARAZIONE'||';'||
       'DATA_MATRIM_U'||';'||'PROV_MATRIM_U'||';'||'COM_MATRIM_U'||';'||'STATO_MATRIM_U'||';'||
       'REGIME_PATRIMONIALE'||';'||'RITO'||';'||
       'NOME_MARITO_P1'||';'||'COGNOME_MARITO_P1'||';'||'SESSO_P1'||';'||
       'DATA_NASC_MARITO_P1'||';'||'PROVNASC_MARITO_P1'||';'||'COMNASC_MARITO_P1'||';'||'STATONASC_MARITO_P1'||';'||
       'CODFISC_MARITO_P1'||';'||
       'PROVRES_MARITO_P1'||';'||'COMRES_MARITO_P1'||';'||'STATORES_MARITO_P1'||';'||
       'CITT_MARITO_P1'||';'||'DATA_CITT_MARITO_P1'||';'||'STATOCITT_MARITO_P1'||';'||
       'STATOCIV_MARITO_P1'||';'||
       'NOME_MOGLIE_P2'||';'||'COGNOME_MOGLIE_P2'||';'||'SESSO_P2'||';'||
       'DATA_NASC_MOGLIE_P2'||';'||'PROVNASC_MOGLIE_P2'||';'||'COMNASC_MOGLIE_P2'||';'||'STATONASC_MOGLIE_P2'||';'||
       'CODFISC_MOGLIE_P2'||';'||
       'PROVRES_MOGLIE_P2'||';'||'COMRES_MOGLIE_P2'||';'||
       'STATORES_MOGLIE_P2'||';'||
       'CITT_MOGLIE_P2'||';'||'DATA_CITT_MOGLIE_P2'||';'||'STATOCITT_MOGLIE_P2'||';'||
       'STATOCIV_MOGLIE_P2'
  from dual
/
comment on table isteddv_int is 'ISTAT - Modello SC - Intestazione'
/
