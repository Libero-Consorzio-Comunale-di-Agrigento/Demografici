--liquibase formatted sql
--changeset amonopoli:202605081300_2 runOnChange:true stripComments:false
create or replace procedure p_SCAW_riga_dati_viw
(a_anno_progr_mov	IN	number
,a_numero_progr_mov	IN	number
,a_matricola		IN	number
,a_anno_pratica		IN	number
,a_pratica		IN	number
,a_cod_mov		IN	number
,a_cod_eve		IN	number
,a_data_reg		IN	number
,a_ente_lp		IN	number
,a_modello		IN	varchar2
,a_stampa_terminalista	IN	varchar2
,a_nome_terminalista	IN	varchar2
,a_separatore		IN	varchar2
,w_anno_pratica_eve	IN OUT	number
,w_pratica_eve		IN OUT	number
)

IS

w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_separatore   varchar2(255) := nvl(a_separatore,chr(9));

w_riga_dati      	clob;
w_errore         	varchar2(4000);

w_return         	number;

w_stringa         clob;
w_campo           varchar2(32000);

w_conta           number;

w_session_id      varchar2(255) := f_tabrep_terminale();
w_sql_clob        clob;
w_sql             varchar2(32000);

w_result          clob;

w_operazione_log  varchar2(255) := 'p_SCAW_riga_dati_viw';
w_note_log        varchar2(4000);
w_campo_log       clob;
w_modulo_rif_log  varchar2(255) := 'ANA';
w_id_rif_log      varchar2(255) := a_anno_pratica||lpad(a_pratica,6,'0'); -- := f_ANA_get_id_pratica(a_anagrafe,a_tipo_evento,a_anno_pratica,a_pratica);
w_return_log      number;

begin

--dbms_output.put_line('prima di p_SCAW_riga_dati');
  p_SCAW_riga_dati(a_anno_progr_mov, a_numero_progr_mov, a_matricola,
                   a_anno_pratica, a_pratica, a_cod_mov, a_cod_eve, a_data_reg, 
                   a_ente_lp, a_modello, a_stampa_terminalista, a_nome_terminalista, w_separatore,
                   w_riga_dati, w_anno_pratica_eve, w_pratica_eve, w_errore);
--dbms_output.put_line('dopo p_SCAW_riga_dati');

  w_campo_log   := 'a_anno_progr_mov: '||a_anno_progr_mov||' - '||
                   'a_numero_progr_mov: '||a_numero_progr_mov||' - '|| 
                   'a_matricola: '||a_matricola||' - '||
                   'a_anno_pratica: '||a_anno_pratica||' - '||
                   'a_pratica: '||a_pratica||' - '||
                   'a_cod_mov: '||a_cod_mov||' - '||
                   'a_cod_eve: '||a_cod_eve||' - '||
                   'a_data_reg: '||a_data_reg||' - '||
                   'a_ente_lp: '||a_ente_lp||' - '||
                   'a_modello: '||a_modello||' - '||
                   'a_stampa_terminalista: '||a_stampa_terminalista||' - '||
                   'a_nome_terminalista: '||a_nome_terminalista;

  w_note_log    := 'w_riga_dati - parametri';
  w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_campo_log, w_modulo_rif_log, w_id_rif_log);

  w_note_log    := 'w_riga_dati';
  w_return_log  := f_GTE_inserisci_log(w_operazione_log, w_note_log, w_riga_dati, w_modulo_rif_log, w_id_rif_log);

  w_conta := 0;
  w_stringa := w_riga_dati;
--dbms_output.put_line('prima di while');
  while instr(w_stringa,w_separatore) > 0 loop
--dbms_output.put_line('w_stringa '||substr(w_stringa,1,200));
      if w_conta = 0 then
         w_sql_clob := 'create or replace view SCAW_'||w_session_id||'_val'||chr(10);
         w_sql_clob := w_sql_clob||'AS'||chr(10);
         w_sql_clob := w_sql_clob||'select';
      end if;
--dbms_output.put_line('prima di w_conta');
      w_conta   := w_conta + 1;
--dbms_output.put_line('prima di w_campo');
      w_campo   := substr(w_stringa,1,instr(w_stringa,w_separatore)-1);
--dbms_output.put_line('prima di w_stringa');
      w_stringa := substr(w_stringa,instr(w_stringa,w_separatore)+1);
--dbms_output.put_line('prima di w_sql_clob');
      w_sql_clob     := w_sql_clob||' '''||replace(w_campo,'''','''''')||''' val_'||to_char(w_conta)||','||chr(10);
  end loop;
--dbms_output.put_line('dopo while');

  if w_sql_clob is not null and w_stringa is not null then
     w_conta := w_conta + 1;
     w_campo := w_stringa;
     w_sql_clob := w_sql_clob||' '''||w_campo||''' val_'||w_conta||chr(10);
     w_sql_clob := w_sql_clob||'from dual';
  end if;

--dbms_output.put_line('prima di execute');
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

<< fine >>
null;
    
end;
/
