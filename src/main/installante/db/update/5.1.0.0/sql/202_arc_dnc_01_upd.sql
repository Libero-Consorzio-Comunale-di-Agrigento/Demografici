--liquibase formatted sql
--changeset amonopoli:202603191245_1 runOnChange:true stripComments:false
declare
cursor sel_dnc is
select t.* 
  from arcdnc t
 where elemento in ('NUM_CIV','SUFFISSO','SCALA','PIANO','INTERNO','SUB_INTERNO')
   and id is null
 order by decode(flag_esterno,'',2,1), sequenza
;

begin
  for rec in sel_dnc loop
      begin
        update arcdnc
           set sequenza      = sequenza * 10,
               id            = ARCDNC_SQ.nextVal,
               version       = 0,
               flag_visibile = 'S'
         where id is null
           and elemento = rec.elemento
        ;
      exception
        when others then
             null;
      end; 
  end loop;
end;
/
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'IDX';
w_nome_ogg	varchar2(255) := 'ARCDNC_PK';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create unique index ARCDNC_PK on ARCDNC (id)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');

  end if;
end;
/
