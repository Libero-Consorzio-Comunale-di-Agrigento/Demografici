--liquibase formatted sql
--changeset amonopoli:202503211245_2 runOnChange:true stripComments:false
create or replace view isteddu_int (cod_modello, riga)
AS
select 'D3U',
       'PROGRESSIVO_QUEST'||';'||
       'MESE_RIF_RISPONDENTE'||';'||
       'ANNO_RIF_RISPONDENTE'||';'||
       'N_ATTO'||';'||
       'P_ATTO_UNIONE'||';'||
       'S_ATTO_UNIONE'||';'||
       'DATA_COSTITUZIONE'||';'||
       'U_REGIME_PATR'||';'||
       'NOME_PARTNER1'||';'||
       'COGNOME_PARTNER1'||';'||
       'U_SESSO_PARTNER1'||';'||
       'FLAG_LUOGO_RESIDENZA_PARTNER1'||';'||
       'PROV_RESIDENZA_PARTNER1'||';'||
       'COMUME_RESIDENZA_PARTNER1'||';'||
       'STATO_ESTERO_RES_PARTNER1'||';'||
       'FLAG_LUOGO_NASCITA_PARTNER1'||';'||
       'PROV_NASC_PARTNER1'||';'||
       'COM_NASC_PARTNER1'||';'||
       'STATO_ESTERO_NASC_PARTNER1'||';'||
       'DATA_NASC_PARTNER1'||';'||
       'STATOCIV_PARTNER1'||';'||
       'TITOLO_STUDIO_PARTNER1'||';'||
       'POS_PROF_PARTNER1'||';'||
       'COND_PROF_PARTNER1'||';'||
       'FLAG_CITT_PARTNER1'||';'||
       'DATA_CITT_PARTNER1'||';'||
       'STATO_CITT_PARTNER1'||';'||
       'CODFISC_PARTNER1'||';'||
       'NOME_PARTNER2'||';'||
       'COGNOME_PARTNER2'||';'||
       'SESSO_PARTNER2'||';'||
       'FLAG_LUOGO_RESIDENZA_PARTNER2'||';'||
       'PROV_RESIDENZA_PARTNER2'||';'||
       'COMUNE_RESIDENZA_PARTNER2'||';'||
       'STATO_ESTERO_RES_PARTNER2'||';'||
       'FLAG_LUOGO_NASCITA_PARTNER2'||';'||
       'PROV_NASC_PARTNER2'||';'||
       'COM_NASC_PARTNER2'||';'||
       'STATO_ESTERO_NASC_PARTNER2'||';'||
       'DATA_NASC_PARTNER2'||';'||
       'STATOCIV_PARTNER2'||';'||
       'TITOLO_STUDIO_PARTNER2'||';'||
       'POS_PROF_PARTNER2'||';'||
       'COND_PROF_PARTNER2'||';'||
       'FLAG_CITT_PARTNER2'||';'||
       'DATA_CITT_PARTNER2'||';'||
       'STATO_CITT_PARTNER2'||';'||
       'CODFISC_PARTNER2'
  from dual
/
comment on table isteddu_int is 'ISTAT - Modello D.3.U - Intestazione'
/
