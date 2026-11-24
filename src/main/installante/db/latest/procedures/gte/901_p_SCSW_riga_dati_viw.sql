--liquibase formatted sql
--changeset amonopoli:202209201030_2 runOnChange:true stripComments:false
create or replace procedure p_SCSW_riga_dati_viw
(a_terminalista   IN      varchar2
,a_comune_data    IN      varchar2
,a_comune         IN      varchar2
,a_data           IN      varchar2
,a_tipo_atto_nb   IN      number
,a_tipo_atto      IN      number
,a_w_tipo_atto    IN      number
,a_formula        IN      varchar2
,a_codice_co      IN      number
,a_ufficio        IN      number
,a_anno           IN      number
,a_atto           IN      number
,a_parte          IN      number
,a_serie          IN      varchar2
,a_data_reg       IN      number
,a_sequenza       IN      number
,a_separatore     IN      varchar2
)

IS

w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_separatore   varchar2(255) := nvl(a_separatore,chr(9));

w_errore         	varchar2(4000);
w_return         	number;
w_riga_dati      	clob;

w_stringa         clob;
w_campo           varchar2(32000);

w_conta           number;

w_session_id      varchar2(255) := f_tabrep_terminale();
w_sql_clob        clob;
w_sql             varchar2(32000);

w_result          clob;

begin
--dbms_output.put_line('prima di p_scsw_riga_dati');
  p_SCSW_riga_dati(a_terminalista,a_comune_data,a_comune,a_data,
                   a_tipo_atto_nb,a_tipo_atto,a_w_tipo_atto,a_formula,
                   a_codice_co,a_ufficio,a_anno,a_atto,a_parte,a_serie,
                   a_data_reg,a_sequenza,a_separatore,
                   w_errore,w_return,w_riga_dati);
--dbms_output.put_line('dopo p_scsw_riga_dati');


  w_conta := 0;
  w_stringa := w_riga_dati;
--dbms_output.put_line('prima di while');
  while instr(w_stringa,w_separatore) > 0 loop
--dbms_output.put_line('w_stringa '||substr(w_stringa,1,200));
      if w_conta = 0 then
         w_sql_clob := 'create or replace view SCSW_'||w_session_id||'_val'||chr(10);
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
    
end;
/
