--liquibase formatted sql
--changeset amonopoli:202410171155_2 runOnChange:true stripComments:false
create or replace procedure p_CERW_riga_dati_viw
(P_TIPO_ARCHIVIO                IN       NUMBER
,P_MATRICOLA                    IN       NUMBER
,P_UFFICIO                      IN       NUMBER
,P_ANNO                         IN       NUMBER
,P_ATTO                         IN       NUMBER
,P_PARTE                        IN       NUMBER
,P_SERIE                        IN       VARCHAR2
,P_STORICO                      IN       VARCHAR2
,P_DATA_CERT                    IN       VARCHAR2
,P_COD_CERTIFICATO              IN       VARCHAR2
,P_PROGR_EMISSIONE              IN       NUMBER
,P_ANNO_EMISSIONE               IN       NUMBER
,P_TERMINALE                    IN       VARCHAR2
,P_SEPARATORE                   IN       VARCHAR2
,P_FLAG_LOOP                    IN       VARCHAR2
)

IS

w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_separatore   varchar2(255) := nvl(p_separatore,chr(9));
w_riga_dati    clob;

--w_VALORI                     varchar2(32000);
--w_RIGA_CERINC                varchar2(32000);
--w_RIGA_LIBERA                varchar2(32000);
w_riga_dati_1                VARCHAR2(32000);
w_riga_dati_2                VARCHAR2(32000);
w_riga_dati_3                VARCHAR2(32000);
W_FASCIA                     number;
W_COD_FAM                    number;
W_FASCIA_EVE                 number;
W_COD_FAM_EVE                number;
w_CONVENZIONI                varchar2(32000);
W_MESSAGGIO_ERRORE           varchar2(32000);

w_stringa         clob;
w_campo           varchar2(32000);

w_conta           number;

w_session_id      varchar2(255) := f_tabrep_terminale();
w_sql_clob        clob;
w_sql             varchar2(32000);

w_result          varchar2(32000);

w_operazione_log    varchar2(255) := 'f_CERW_riga_dati_viw';
w_note_log      varchar2(4000);
w_modulo_rif_log      varchar2(255) := 'CER';
w_id_rif_log     varchar2(255);
w_return_log      number;


begin
  p_CERW_riga_dati(P_TIPO_ARCHIVIO,P_MATRICOLA,P_UFFICIO,P_ANNO,P_ATTO,P_PARTE,P_SERIE,
                   P_STORICO,P_DATA_CERT,P_COD_CERTIFICATO,P_PROGR_EMISSIONE,P_ANNO_EMISSIONE,
                   P_TERMINALE,P_SEPARATORE,P_FLAG_LOOP,
                   w_riga_dati_1,w_RIGA_DATI_2,w_RIGA_DATI_3,
                   W_FASCIA,W_COD_FAM,W_FASCIA_EVE,W_COD_FAM_EVE,
                   w_CONVENZIONI,W_MESSAGGIO_ERRORE);

--dbms_output.put_line('p_cerw_riga_dati_viw - prima di w_riga_dati');
  w_riga_dati := w_riga_dati_1||w_separatore||w_riga_dati_2||w_separatore||w_riga_dati_3;
--dbms_output.put_line('p_cerw_riga_dati_viw - dopo w_riga_dati');

  w_conta := 0;
  w_stringa := w_riga_dati;
  while instr(w_stringa,w_separatore) > 0 loop
      if w_conta = 0 then
         w_sql_clob := 'create or replace view CERW_'||w_session_id||'_val'||chr(10);
         w_sql_clob := w_sql_clob||'AS'||chr(10);
         w_sql_clob := w_sql_clob||'select';
      end if;
      w_conta   := w_conta + 1;
      w_campo   := substr(w_stringa,1,instr(w_stringa,w_separatore)-1);
      w_stringa := substr(w_stringa,instr(w_stringa,w_separatore)+1);
      w_sql_clob     := w_sql_clob||' '''||replace(w_campo,'''','''''')||''' val_'||to_char(w_conta)||','||chr(10);
  end loop;

  if w_sql_clob is not null and w_stringa is not null then
     w_conta := w_conta + 1;
     w_campo := w_stringa;
     w_sql_clob := w_sql_clob||' '''||w_campo||''' val_'||w_conta||chr(10);
     w_sql_clob := w_sql_clob||'from dual';
  end if;

  if w_sql_clob is not null then
     if w_oracle_ver >= '11' then
        begin
          execute immediate w_sql_clob;
        end;
     else
        w_sql := substr(w_sql_clob,1,32000);
        begin
          execute immediate w_sql;
        end;
     end if;
  end if;

  w_id_rif_log := p_anno_emissione||lpad(p_progr_emissione,6,'0');  
--  w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_sql_clob, w_modulo_rif_log, w_id_rif_log);

end;
/
