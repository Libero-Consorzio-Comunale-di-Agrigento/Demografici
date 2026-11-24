--liquibase formatted sql
--changeset amonopoli:202209201030_1 runOnChange:true stripComments:false
create or replace procedure p_SCSW_riga_intesta_VIW
(a_tipo_atto      IN       number
,a_separatore     IN       varchar2
)

IS

w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_separatore      varchar2(255) := nvl(a_separatore,chr(9));
w_riga_intesta    clob;

w_stringa         clob;
w_campo           varchar2(255);

w_conta           number;

w_session_id      varchar2(255) := f_tabrep_terminale();
w_sql_clob        clob;
w_sql             varchar2(32000);

w_result          varchar2(32000);

begin
  w_riga_intesta := f_SCSW_riga_intesta(a_tipo_atto,a_separatore);
  
  w_conta := 0;
  w_stringa := w_riga_intesta;
  while instr(w_stringa,w_separatore) > 0 loop
      if w_conta = 0 then
         w_sql_clob := 'create or replace view SCSW_'||w_session_id||'_int'||chr(10);
         w_sql_clob := w_sql_clob||'AS'||chr(10);
         w_sql_clob := w_sql_clob||'select';
      end if;
      w_conta   := w_conta + 1;
      w_campo   := substr(w_stringa,1,instr(w_stringa,w_separatore)-1);
      w_stringa := substr(w_stringa,instr(w_stringa,w_separatore)+1);
      w_sql_clob     := w_sql_clob||' '''||w_campo||''' int_'||to_char(w_conta)||','||chr(10);
  end loop;

  if w_sql_clob is not null and w_stringa is not null then
     w_conta   := w_conta + 1;
     w_campo   := w_stringa;
     w_sql_clob := w_sql_clob||' '''||w_campo||''' int_'||w_conta||chr(10);
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
    
end;
/
