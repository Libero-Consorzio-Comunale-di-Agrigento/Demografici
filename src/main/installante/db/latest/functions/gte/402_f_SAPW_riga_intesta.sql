--liquibase formatted sql
--changeset amonopoli:202203221240_2 runOnChange:true stripComments:false
CREATE OR REPLACE function f_SAPW_riga_intesta
(a_separatore		IN	varchar2)

return varchar2

IS

w_sep			varchar2(255) := nvl(a_separatore,chr(9));
w_riga_intesta		varchar2(4000);

begin
  w_riga_intesta := 'ANNO_PRATICA'||w_sep||'PRATICA'||w_sep||'DATA_PRATICA'||w_sep||'TIPO_PRATICA'||w_sep||
                    'COGNOME_NOME_DICHIARANTE'||w_sep||'COD_FISCALE_DICHIARANTE'||w_sep||
                    'RIGA_TRASFERIMENTO_1'||w_sep||'RIGA_TRASFERIMENTO_2'||w_sep||
                    'RIGA_TRASFERIMENTO_3'||w_sep||'RIGA_TRASFERIMENTO_4'||w_sep||
                    'COGNOME_NOME'||w_sep||'COGNOME'||w_sep||'NOME'||w_sep||'SESSO'||w_sep||
                    'PATERNITA'||w_sep||'MATERNITA'||w_sep||
                    'NAT_OA'||w_sep||'DATA_NASCITA'||w_sep||'COMUNE_NASCITA'||w_sep||
                    'COMUNE_ATTO_NASCITA'||w_sep||'ATTO_NASCITA'||w_sep||
                    'STATO_CIVILE'||w_sep||'CONIUGAT_OA'||w_sep||'COGNOME_NOME_CONIUGE'||w_sep||
                    'CITTADINANZA'||w_sep||'COD_FISCALE'||w_sep||'RAPPORTO_PARENTELA'||w_sep||
                    'SEQUENZA_PAR'||w_sep||'RESIDENZA_FAM'||w_sep||'INDIRIZZO_FAM'||w_sep||
                    'RESIDENZA'||w_sep||'INDIRIZZO'||w_sep||'CAP_COMUNE_RESIDENZA'||w_sep||
                    'INDIRIZZO_DICHIARATO'||w_sep||'COMUNE_DICHIARATO'||w_sep||
                    'NUMERO_CARTA_DICHIARANTE'||w_sep||'DATA_CARTA_DICHIARANTE'||w_sep||
                    'COMUNE_DATA'||w_sep||'COMUNE'||w_sep||'DATA'||w_sep||
                    'DATA_ULTIMO_ACCERTAMENTO'||w_sep||'NOTE_ULTIMO_ACCERTAMENTO'||w_sep||
                    'MATRICOLA'||w_sep||'MATRICOLA_DICHIARANTE'||w_sep||'DESCRIZIONE_EVENTO'||w_sep||
                    'PROFESSIONE_DICHIARANTE'||w_sep||'TITOLO_STUDIO_DICHIARANTE'||w_sep||
                    'IL_SIG_DICH'||w_sep||'SIG_DICH'||w_sep||'COMUNE_PROVENIENZA'||w_sep||'DATA_DECORRENZA'||w_sep||
                    'FAM_DCA_1'||w_sep||'FAM_DCA_2'||w_sep||'FAM_DCA_3'||w_sep||'FAM_VAA'||w_sep||
                    'DOC_PT_1'||w_sep||'DOC_CC_1'||w_sep||'DOC_PT_2'||w_sep||'DOC_CC_2'||w_sep||
                    'CDF_1'||w_sep||'CDF_2'||w_sep||'CDF_3'||w_sep||'CDF_4'||w_sep||'CDF_5'||w_sep||
                    'TERMINALISTA'||w_sep||'FIRMA_OMESSA'||w_sep||
                    'NUMERO_TEL_TERMINALISTA'||w_sep||'INDIRIZZO_MAIL_TERMINALISTA'||w_sep||
                    'LOGO_ANA';

  w_riga_intesta := w_riga_intesta||w_sep||
                    f_SER_riga_intesta(w_sep,'ANA')||w_sep||
                    f_SER_riga_intesta(w_sep,'COM')||w_sep||
                    f_SER_riga_intesta(w_sep,'URP');

  return w_riga_intesta;

end;
/
