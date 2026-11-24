--liquibase formatted sql
--changeset amonopoli:202606101455_2 runOnChange:true stripComments:false
alter table anaeve disable all triggers
/
declare
cursor sel_eve is
select eve.rowid rowid_eve
  from anaeve eve
 where id is null
 order by nvl(data_reg,1111111), cod_mov, cod_eve desc, matricola
;

begin
  for rec in sel_eve loop
      begin
        update anaeve
           set id             = ANAEVE_SQ.nextval
         where id    is null
           and rowid = rec.rowid_eve
        ;
      exception 
        when others then 
             null;
      end;
  end loop;
end;
/
alter table anaeve enable all triggers
/
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'IDX';
w_nome_ogg	varchar2(255) := 'ANAEVE_PK';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create unique index anaeve_pk on anaeve (id)';

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
