--liquibase formatted sql
--changeset amonopoli:202606101120_2 runOnChange:true stripComments:false
alter table anaa01 disable all triggers
/
update anaa01
   set id                    = ANAA01_SQ.nextval,
       id_pratica            = f_ANA_get_id_pratica('RES','C',anno_pratica,pratica),
       id_protocollo_aire    = f_ANA_get_id_pratica('AIR','I',anno_protocollo_aire,protocollo_aire),
       d_data_pratica        = to_date(data_pratica,'j'),
       d_data_definizione    = to_date(data_definizione,'j'),
       d_data_arrivo         = to_date(data_arrivo,'j'),
       d_data_reg            = to_date(data_reg,'j')
 where id is null
/
update anaa01
   set cognome_presso = f_cognome(presso),
       nome_presso    = f_nome(presso)
 where cognome_presso||nome_presso is null
   and presso is not null
/
update anaa01 a01
   set id_arccon = (select con.id from arccon con
                     where con.cod_consolato  = a01.cod_consolato
                       and con.tipo_consolato = a01.tipo_consolato
                       and con.stato          = a01.cod_territorio)
 where cod_consolato  is not null
   and tipo_consolato is not null
   and cod_territorio is not null
/
update anaa01 a01
   set id_anatpr = (select tpr.id from anatpr tpr
                     where tpr.anagrafe     = 'RES'
                       and tpr.tipo_evento  = 'C'
                       and tpr.anno_pratica = a01.anno_pratica
                       and tpr.pratica      = a01.pratica
                       and rownum = 1)
 where anno_pratica is not null
   and pratica      is not null
   and id_anatpr    is null
/
update anaa01 a01
   set id_anatpr = (select tpr.id from anatpr tpr
                     where tpr.anagrafe     = 'AIR'
                       and tpr.tipo_evento  = 'I'
                       and tpr.anno_pratica = a01.anno_protocollo_aire
                       and tpr.pratica      = a01.protocollo_aire
                       and rownum = 1)
 where anno_pratica         is null
   and pratica              is null
   and anno_protocollo_aire is not null
   and protocollo_aire      is not null
   and id_anatpr            is null
/
update anaa01
   set cod_fam_unique = f_ANA_get_cod_fam_unique(3,cod_fam)
 where cod_fam_unique is null
   and cod_fam is not null 
/
update anaa01
   set cod_fam_prov_unique = f_ANA_get_cod_fam_unique(1,cod_fam_prov)
 where cod_fam_prov_unique is null
   and cod_fam_prov is not null 
/
alter table anaa01 enable all triggers
/
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'IDX';
w_nome_ogg	varchar2(255) := 'ANAA01_PK1';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create unique index anaa01_pk1 on anaa01 (id)';

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
w_nome_ogg	varchar2(255) := 'ANAA01_PK2';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create index anaa01_pk2 on anaa01 (id_pratica)';

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
w_nome_ogg	varchar2(255) := 'ANAA01_PK3';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create index anaa01_pk3 on anaa01 (id_protocollo_aire)';

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
w_nome_ogg	varchar2(255) := 'ANAA01_PK4';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create index anaa01_pk4 on anaa01 (id_anatpr)';

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
