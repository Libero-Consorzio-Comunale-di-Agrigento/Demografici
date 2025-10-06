--liquibase formatted sql
--changeset amonopoli:202305251500_2 runOnChange:true stripComments:false
CREATE OR REPLACE FUNCTION f_CIV_cambia_testo_formula
(testo         		IN	clob
,p_tipo_atto   		IN	number
,p_anno        		IN	number
,p_ufficio     		IN	number
,p_atto        		IN	number
,p_parte       		IN	number
,p_serie       		IN	varchar2
,p_formula		IN	varchar2	default NULL
,p_richiamo		IN	number		default NULL
,p_flag_richiamo	IN	varchar2	default NULL
,p_tabella_rif   	IN	varchar2	default NULL
,p_id_rif		IN	varchar2	default NULL
)

RETURN clob

IS

w_testo			clob := null;
w_testo_1		clob := null;
w_testo_2		clob := null;
w_testo_1_finale	clob := null;
w_testo_finale		clob := null;
variabile      		varchar2(32000) := null;

w_sql			varchar2(32000);

BEGIN

  if p_tabella_rif is null or p_id_rif is null then
     w_testo := testo;
  else
     if p_tabella_rif = 'CIVTFA' then
        begin
          select f_CIV_testo_formula(tfa.testo_4000,tfa.testo_a3)
            into w_testo
            from civtfa tfa
           where formula = p_id_rif
             and rownum = 1
          ;
        exception
          when others then
               w_testo := testo;
        end;

     elsif p_tabella_rif = 'CIVISM' then
        begin
          select ism.riga_clob
            into w_testo
            from civism ism
           where id = p_id_rif
             and rownum = 1
          ;
        exception
          when others then
               w_testo := testo;
        end;

     else
         w_testo := testo;
     end if;
  end if;

  if w_testo like '%'||chr(10)  then
     w_testo_2 := w_testo;
  else
     w_testo_2 := w_testo||chr(10);
  end if;
  
  while instr(w_testo_2,chr(10)) > 0 loop
        w_testo_1 := substr(w_testo_2,1,instr(w_testo_2,chr(10)));
        w_testo_2 := substr(w_testo_2,instr(w_testo_2,chr(10))+1);
  
        if instr(w_testo_1,'<') > 0 and instr(w_testo_1,'>') > 0 then
           w_testo_1 := replace(w_testo_1,'''','''''');
           w_testo_1 := replace(w_testo_1, '<', '''||v.');
           w_testo_1 := replace(w_testo_1, '>', '||''');
           
           
           w_sql := 'select '''||w_testo_1||'''';

           if p_tipo_atto = 1 then
              w_sql := w_sql||' from civwci_totale';
           elsif p_tipo_atto = 2 then
              w_sql := w_sql||' from civwna_totale';
           elsif p_tipo_atto = 3 then
              w_sql := w_sql||' from civwpu_totale';
           elsif p_tipo_atto = 4 then
              w_sql := w_sql||' from civwma_totale';
           elsif p_tipo_atto = -4 then
              w_sql := w_sql||' from civwuc_totale';
           elsif p_tipo_atto = 5 then
              w_sql := w_sql||' from civwmo_totale';
           end if;

           w_sql := w_sql||' v';
           w_sql := w_sql||' where ufficio = '||p_ufficio;
           w_sql := w_sql||' and anno = '||p_anno;
           w_sql := w_sql||' and atto = '||p_atto;
           if p_tipo_atto != 1 then
              if p_parte is null then
                 w_sql := w_sql||' and parte is null';
              else
                 w_sql := w_sql||' and parte = '||p_parte;
              end if;
              if p_serie is null then
                 w_sql := w_sql||' and serie is null';
              else
                 w_sql := w_sql||' and serie = '''||p_serie||'''';
              end if;
          end if;

--dbms_output.put_line(substr(w_sql,1,250));
--dbms_output.put_line(substr(w_sql,251,250));
--dbms_output.put_line(substr(w_sql,501,250));
--dbms_output.put_line(substr(w_sql,751,250));
--dbms_output.put_line(substr(w_sql,1001,250));
--dbms_output.put_line(substr(w_sql,1251,250));
--dbms_output.put_line(substr(w_sql,1501,250));
--dbms_output.put_line(substr(w_sql,1751,250));
--dbms_output.put_line(substr(w_sql,2001,250));
--dbms_output.put_line(substr(w_sql,2251,250));
--dbms_output.put_line(substr(w_sql,2501,250));
--dbms_output.put_line(substr(w_sql,2751,250));

           if w_sql is not null then
              begin
                execute immediate w_sql into w_testo_1_finale;
              exception
                when others then
         --            w_testo_finale := '';
                     w_testo_1_finale := sqlerrm;
              end;
           else
              w_testo_1_finale := w_testo_1;
           end if;
        else
           w_testo_1_finale := w_testo_1;
        end if;
      w_testo_finale := w_testo_finale || w_testo_1_finale;  
  end loop;
  w_testo_finale := rtrim(w_testo_finale,chr(10));
  
--ORA-00904: "V"."CITTADINANZA": identificativo non valido
  if w_testo_finale like 'ORA-00904:%' then
     w_testo_finale := substr(w_testo_finale,instr(w_testo_finale,'"V"."')+5);
     w_testo_finale := substr(w_testo_finale,1,instr(w_testo_finale,'":')-1);
     w_testo_finale := 'ATTENZIONE! Variabile "<'||w_testo_finale||'>" errata all''interno della formula / minuta';
     goto fine;
  elsif w_testo_finale like 'ORA-%' then
--     w_testo_finale := w_sql;
     w_testo_finale := null;
  end if;

  if w_testo_finale is null then
     w_testo_finale := w_testo;
  end if;

  if p_flag_richiamo is not null and p_richiamo is not null then
     w_testo_finale := '('||p_richiamo||') '||w_testo_finale;
  end if;

<< fine >>
--  return w_sql;
  return(w_testo_finale);

END;
/
