--liquibase formatted sql
--changeset amonopoli:202606091210_2 runOnChange:true stripComments:false
alter table anaap4 disable all triggers
/
update anaap4
   set id                    = ANAAP4_SQ.nextval,
       id_pratica            = f_ANA_get_id_pratica('RES','I',anno_pratica,pratica),
       id_dichiarazione      = f_ANA_get_id_pratica('RES','I',anno_dic,numero_dic),
       d_data_pratica        = to_date(data_pratica,'j'),
       d_data_decorrenza     = to_date(data_decorrenza,'j'),
       d_data_irreperibilita = to_date(data_irreperibilita,'j'),
       d_data_definizione    = to_date(data_definizione,'j'),
       d_data_reg            = to_date(data_reg,'j')
 where id is null
/
update anaap4
   set cod_fam_unique_prov = f_ANA_get_cod_fam_unique(3,cod_fam_prov)
 where cod_fam_prov is not null
   and cod_fam_unique_prov is null
/
update anaap4
   set cod_fam_dest = ''
 where cod_fam_dest is not null
   and not exists (select 1 from anafam
                    where cod_fam = anaap4.cod_fam_dest
                      and fascia  in (1,2))
/
update anaap4
   set cod_fam_unique_dest = f_ANA_get_cod_fam_unique(1,cod_fam_dest)
 where cod_fam_dest is not null
   and cod_fam_unique_dest is null
/
update anaap4
   set cognome_presso = f_cognome(presso),
       nome_presso    = f_nome(presso)
 where cognome_presso||nome_presso is null
   and presso is not null
/
update anaap4 ap4
   set id_anatpr = (select tpr.id from anatpr tpr
                     where tpr.anagrafe     = 'RES'
                       and tpr.tipo_evento  = 'I'
                       and tpr.anno_pratica = ap4.anno_pratica
                       and tpr.pratica      = ap4.pratica
                       and rownum = 1)
 where id_anatpr is null
/
alter table anaap4 enable all triggers
/
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'IDX';
w_nome_ogg	varchar2(255) := 'anaap4_pk1';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create unique index anaap4_pk1 on anaap4 (id)';

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
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'IDX';
w_nome_ogg	varchar2(255) := 'anaap4_pk2';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create index anaap4_pk2 on anaap4 (id_pratica)';

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
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'IDX';
w_nome_ogg	varchar2(255) := 'anaap4_pk3';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create unique index anaap4_pk3 on anaap4 (id_dichiarazione)';

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
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'IDX';
w_nome_ogg	varchar2(255) := 'anaap4_pk4';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create index anaap4_pk4 on anaap4 (id_anatpr)';

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
