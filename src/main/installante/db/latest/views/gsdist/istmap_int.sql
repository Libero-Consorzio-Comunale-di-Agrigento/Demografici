--liquibase formatted sql
--changeset amonopoli:202503211248_2 runOnChange:true stripComments:false
create or replace view istmap_int (cod_modello, riga)
AS
select 'APR4_TESTATA',
       'PROGRESSIVO_QUEST'||';'||
         'MESE_DI_RIFERIMENTO'||';'||
         'ANNO_DI_RIFERIMENTO'||';'||
         'NUMERO_PERSONE'||';'||
         'TIPO_PRATICA'||';'||
         'NUM_PRATICA_ISCRIZIONE'||';'||
         'ISCRIZIONE_CONTEGGIO'||';'||
         'NUM_PRATICA_CANCELLAZIONE'||';'||
         'CANCELLAZIONE_CONTEGGIO'||';'||
         'COD_PROVINCIA_CANCELLAZIONE'||';'||
         'CODICE_COMUNE_CANCELLAZIONE'||';'||
         'PROVVEDIMENTO_ISCRIZIONE'||';'||
         'COD_STATO_ESTERO_PROV'||';'||
         'PROVV_CANCELLAZIONE'||';'||
         'COD_STATO_ESTERO_DEST'||';'||
         'DATA_COMUNIC_PRATICA'||';'||
         'FAMIGLIA_CONVIVENZA'||';'||
         'DATA_DECORR_ISCRIZIONE'||';'||
         'DATA_DECORR_CANCELL'||';'||
         'NUOVO_INDIRIZZO_RES'
  from dual
UNION
select 'APR4_PERSONE',
       'PROGRESSIVO_QUEST'||';'||
         'ID_MODULO'||';'||
         'CODICE_FISCALE'||';'||
         'DATA_NASCITA'||';'||
         'COD_PROV_NASCITA'||';'||
         'COD_COMUNE_NASCITA'||';'||
         'COD_STATO_ESTERO_NASCITA'||';'||
         'SESSO'||';'||
         'STATO_CIVILE'||';'||
         'CITTADINANZA_ITALIANA'||';'||
         'CITTADINANZA_STRANIERA'||';'||
         'PROFESSIONE_SE_OCCUPATO'||';'||
         'CONDIZIONE_NON_PROFESSIONALE'||';'||
         'TITOLO_STUDIO'||';'||
         'RELAZIONE_PARENTELA'
  from dual
/
comment on table ISTMAP_INT is 'ISTAT - Dati per Compilazione Modello APR/4 - Intestazioni (view)'
/
