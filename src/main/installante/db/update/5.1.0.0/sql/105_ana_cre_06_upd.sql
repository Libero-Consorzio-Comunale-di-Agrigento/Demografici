--liquibase formatted sql
--changeset amonopoli:202606091505_2 runOnChange:true stripComments:false
alter table anacre disable all triggers
/
update anacre
   set id                = ANACRE_SQ.nextval,
       id_pratica        = f_ANA_get_id_pratica('RES','E',anno_pratica,pratica),
       d_data_decorrenza = to_date(data_decorrenza,'j')
 where id is null
/
update anacre
   set cod_fam_unique_prov = f_ANA_get_cod_fam_unique(1,cod_fam_prov)
 where cod_fam_prov is not null
   and cod_fam_unique_prov is null
/
update anacre
   set cod_fam_dest = ''
 where cod_fam_dest is not null
   and not exists (select 1 from anafam
                    where cod_fam = anacre.cod_fam_dest
                      and fascia  in (1,2))
/
update anacre
   set cod_fam_unique_dest = f_ANA_get_cod_fam_unique(1,cod_fam_dest)
 where cod_fam_dest is not null
   and cod_fam_unique_dest is null
/
update anacre
   set cognome_presso    = f_cognome(presso),
       nome_presso       = f_nome(presso)
 where cognome_presso||nome_presso is null
   and presso is not null
/
update anacre cre
   set id_anatpr = (select tpr.id from anatpr tpr
                     where tpr.anagrafe     = 'RES'
                       and tpr.tipo_evento  = 'E'
                       and tpr.anno_pratica = cre.anno_pratica
                       and tpr.pratica      = cre.pratica
                       and rownum = 1)
 where id_anatpr is null
/
alter table anacre enable all triggers
/
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'IDX';
w_nome_ogg	varchar2(255) := 'ANACRE_PK1';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create unique index anacre_pk1 on anacre (id)';

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
w_nome_ogg	varchar2(255) := 'ANACRE_PK2';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create index anacre_pk2 on anacre (id_pratica)';

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
w_nome_ogg	varchar2(255) := 'ANACRE_PK4';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create index anacre_pk4 on anacre (id_anatpr)';

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
