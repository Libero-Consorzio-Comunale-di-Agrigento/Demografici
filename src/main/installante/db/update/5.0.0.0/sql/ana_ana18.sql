--liquibase formatted sql
--changeset amonopoli:202502201620_1 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'COL';
w_nome_ogg	varchar2(255) := 'ANAANA';
w_nome_col      varchar2(255) := 'D_DATA_MAT';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'alter table anaana
add 
(d_DATA_ULT_EVE         date 
,d_DATA_INIZIO_FAM      date
,d_DATA_INIZIO_RES      date
,d_DATA_MAT             date
,d_DATA_MOR		date
,d_DATA_VED             date
,d_DATA_DIV             date
,d_DATA_DIV_GIU         date
,d_DATA_DIV_ANN         date
,d_DATA_VAL_ESPATRIO    date
,d_DATA_INIZIO_NAZ      date
,d_DATA_REG             date
)';

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

w_tipo_ogg	varchar2(255) := 'COL';
w_nome_ogg	varchar2(255) := 'ANAANA';
w_nome_col      varchar2(255) := 'COGNOME_PD';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'alter table anaana
add 
(cognome_pd	varchar2(100)
,nome_pd	varchar2(100)
,cognome_md	varchar2(100)
,nome_md	varchar2(100)
,cognome_cn	varchar2(100)
,nome_cn	varchar2(100)
)';

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

w_tipo_ogg	varchar2(255) := 'COL';
w_nome_ogg	varchar2(255) := 'ANAANA';
w_nome_col      varchar2(255) := 'COD_FAM_UNIQUE';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'alter table anaana
add 
(cod_fam_unique	varchar2(20)
)';

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
w_nome_ogg	varchar2(255) := 'IDX13ANAANA';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create index idx13anaana on anaana (cod_fam_unique)';

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
alter table anaana disable all triggers
/
update anaana
   set d_data_ult_eve = to_date(data_ult_eve,'j')
 where d_data_ult_eve is null
/
update anaana
   set d_data_inizio_fam = to_date(data_inizio_fam,'j')
 where d_data_inizio_fam is null
/
update anaana
   set d_data_inizio_res = to_date(data_inizio_res,'j')
 where d_data_inizio_res is null
/
update anaana
   set d_data_mat = to_date(data_mat,'j')
 where d_data_mat is null
/
update anaana
   set d_data_mor = to_date(data_mor,'j')
 where d_data_mor is null
/
update anaana
   set d_data_ved = to_date(data_ved,'j')
 where d_data_ved is null
/
update anaana
   set d_data_div = to_date(data_div,'j')
 where d_data_div is null
/
update anaana
   set d_data_div_giu = to_date(data_div_giu,'j')
 where d_data_div_giu is null
/
update anaana
   set d_data_div_ann = to_date(data_div_ann,'j')
 where d_data_div_ann is null
/
update anaana
   set d_data_val_espatrio = to_date(data_val_espatrio,'j')
 where d_data_val_espatrio is null
/
update anaana
   set d_data_inizio_naz = to_date(data_inizio_naz,'j')
 where d_data_inizio_naz is null
/
update anaana
   set d_data_reg = to_date(data_reg,'j')
 where d_data_reg is null
/
update anaana
   set cognome_pd = f_cognome_pd(matricola_pd,paternita,cognome_nome),
       nome_pd    = f_nome_pd(matricola_pd,paternita,cognome_nome)
 where cognome_pd||nome_pd is null
/
update anaana
   set cognome_md = f_cognome_md(matricola_md,maternita),
       nome_md    = f_nome_md(matricola_md,maternita)
 where cognome_md||nome_md is null
/
update anaana
   set cognome_cn = f_cognome(cognome_nome_cn),
       nome_cn    = f_nome(cognome_nome_cn)
 where cognome_cn||nome_cn is null
/
update anaana
   set cod_fam_unique = f_ANA_get_cod_fam_unique(fascia,cod_fam)
 where cod_fam_unique is null
/
alter table anaana enable all triggers
/

