--liquibase formatted sql
--changeset amonopoli:202311151255 runOnChange:true stripComments:false
create or replace function f_ANSC_lista_not_RTE
(a_id_atto_ansc         IN 	varchar2
)

return clob

IS

w_id_atto_ansc       varchar2(255);

w_clob               clob;

cursor sel_not is
select n.*
  from ansnot_rte n
 where substr(id_ansc,1,instr(id_ansc,'-',1,2)) = substr(a_id_atto_ansc,1,instr(a_id_atto_ansc,'-',1,2))
 order by id
;

begin
  for rec in sel_not loop
      w_clob := w_clob||
                'idNotifica '||rec.id||
                  ' - idAttoAnsc '||rec.id_ansc||
                  ' - genere '||rec.genere||
                  ' - stato '||rec.stato||chr(10);
  end loop;

  return w_clob;

end;
/
