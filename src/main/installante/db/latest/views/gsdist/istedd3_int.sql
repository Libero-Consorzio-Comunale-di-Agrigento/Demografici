--liquibase formatted sql
--changeset amonopoli:202312211005_5 runOnChange:true stripComments:false
create or replace view ISTEDD3_INT (cod_modello, riga)
AS
select 'D3',
       'PROGRESSIVO_QUEST'||';'||
       'MESE_RIFERIMENTO_RISPONDENTE'||';'||
       'ANNO_RIFERIMENTO_RISPONDENTE'||';'||
       'N_ATTO'||';'||
       'P_ATTO_MATRIMONIO'||';'||
       'S_ATTO_MATRIMONIO'||';'||
       'DATA_CELEBRAZIONE'||';'||
       'RITO'||';'||
       'NOME_SPOSO'||';'||
       'COGNOME_SPOSO'||';'||
       'FLAG_LUOGO_RESIDENZA_SPOSO'||';'||
       'PROV_RESIDENZA_SPOSO'||';'||
       'COMUNE_RESIDENZA_SPOSO'||';'||
       'STATO_ESTERO_RES_SPOSO'||';'||
       'FLAG_LUOGO_NASCITA_SPOSO'||';'||
       'PROV_NASC_SPOSO'||';'||
       'COM_NASC_SPOSO'||';'||
       'STATO_ESTERO_NASC_SPOSO'||';'||
       'DATA_NASC_SPOSO'||';'||
       'STATOCIV_SPOSO'||';'||
       'DATA_CESS_MATR_PREC_SPOSO'||';'||
       'GRADO_ISTRUZIONE_SPOSO'||';'||
       'COND_PROF_SPOSO'||';'||
       'POS_PROF_SPOSO'||';'||
       'RAMO_ATT_ECON_SPOSO'||';'||
       'FLAG_CITT_SPOSO'||';'||
       'STATO_CITT_SPOSO'||';'||
       'CODFISC_SPOSO'||';'||
       'RES_DOPO_MATR_SPOSO'||';'||
       'PROVRES_SPOSO_DOPO_MATR'||';'||
       'COMRES_SPOSO_DOPO_MATR'||';'||
       'STATORES_SPOSO_DOPO_MATR'||';'||
       'NOME_SPOSA'||';'||
       'COGNOME_SPOSA'||';'||
       'FLAG_LUOGO_RES_SPOSA'||';'||
       'PROV_RESIDENZA_SPOSA'||';'||
       'COM_RESIDENZA_SPOSA'||';'||
       'STATO_ESTERO_RES_SPOSA'||';'||
       'FLAG_LUOGO_NASCITA_SPOSA'||';'||
       'PROV_NASC_SPOSA'||';'||
       'COM_NASC_SPOSA'||';'||
       'STATO_ESTERO_NASC_SPOSA'||';'||
       'DATA_NASC_SPOSA'||';'||
       'STATOCIV_SPOSA'||';'||
       'DATA_CESS_MATR_PREC_SPOSA'||';'||
       'GRADO_ISTRUZIONE_SPOSA'||';'||
       'COND_PROF_SPOSA'||';'||
       'POS_PROF_SPOSA'||';'||
       'RAMO_ATT_ECON_SPOSA'||';'||
       'FLAG_CITT_SPOSA'||';'||
       'STATO_CITT_SPOSA'||';'||
       'CODFISC_SPOSA'||';'||
       'RES_DOPO_MATR_SPOSA'||';'||
       'PROVRES_SPOSA_DOPO_MATR'||';'||
       'COMRES_SPOSA_DOPO_MATR'||';'||
       'STATORES_SPOSA_DOPO_MATR'||';'||
       'U_REGIME_PATR'
  from dual
/
comment on table ISTEDD3_INT is 'ISTAT - Modello D.3 - Intestazione'
/
