--liquibase formatted sql
--changeset amonopoli:202606081640_2 runOnChange:true stripComments:false
alter table anatpr disable all triggers
/
update anatpr tpr
   set iniziativa = (select tipo_richiesta from anaap4 ap4 where anno_pratica = tpr.anno_pratica and pratica = tpr.pratica and rownum = 1)
 where anagrafe    = 'RES'
   and tipo_evento = 'I'
   and iniziativa  is null
/
update anatpr
   set iniziativa = decode(cod_variazione,'',1,'W',1,'Y',1,2)
 where anagrafe    = 'RES'
   and tipo_evento = 'E'
   and iniziativa  is null
/
update anatpr
   set id             = ANATPR_SQ.nextval,
       id_pratica     = f_ANA_get_id_pratica(anagrafe,tipo_evento,anno_pratica,pratica),
       d_data_pratica = to_date(data_pratica,'j'),
       cognome_dic    = f_cognome(cognome_nome_dic),
       nome_dic       = f_nome(cognome_nome_dic)
 where id is null
/
update anatpr tpr
   set d_data_decorrenza = (select to_date(nvl(ap4.data_decorrenza,tpr.data_pratica),'j')
                              from anaap4 ap4
                             where anno_pratica = tpr.anno_pratica
                               and pratica      = tpr.pratica
                               and rownum = 1)
 where d_data_decorrenza is null
   and anagrafe          = 'RES'
   and tipo_evento       = 'I'
/
update anatpr tpr
   set d_data_decorrenza = (select to_date(nvl(cp4.data_decorrenza,tpr.data_pratica),'j')
                              from anacp4 cp4
                             where anno_pratica = tpr.anno_pratica
                               and pratica      = tpr.pratica
                               and rownum = 1)
 where d_data_decorrenza is null
   and anagrafe          = 'RES'
   and tipo_evento       = 'C'
/
update anatpr tpr
   set d_data_decorrenza = (select to_date(nvl(cre.data_decorrenza,tpr.data_pratica),'j')
                              from anacre cre
                             where anno_pratica = tpr.anno_pratica
                               and pratica      = tpr.pratica
                               and rownum = 1)
 where d_data_decorrenza is null
   and anagrafe          = 'RES'
   and tipo_evento       = 'E'
/
update anatpr tpr
   set d_data_decorrenza = (select to_date(nvl(a01.data_decorrenza,tpr.data_pratica),'j')
                              from anaa01 a01
                             where anno_protocollo_aire = tpr.anno_pratica
                               and protocollo_aire      = tpr.pratica
                               and rownum = 1)
 where d_data_decorrenza is null
   and anagrafe          = 'AIR'
   and tipo_evento       = 'I'
/
update anatpr tpr
   set d_data_decorrenza = (select to_date(nvl(c01.data_decorrenza,tpr.data_pratica),'j')
                              from anac01 c01
                             where anno_protocollo_aire = tpr.anno_pratica
                               and protocollo_aire      = tpr.pratica
                               and rownum = 1)
 where d_data_decorrenza is null
   and anagrafe          = 'AIR'
   and tipo_evento       = 'C'
/
--update anatpr tpr
--   set d_data_decorrenza = (select to_date(nvl(caa.data_decorrenza,tpr.data_pratica),'j')
--                              from anacaa caa
--                             where anno_protocollo_aire = tpr.anno_pratica
--                               and protocollo_aire      = tpr.pratica
--                               and rownum = 1)
-- where d_data_decorrenza is null
--   and anagrafe          = 'AIR'
--   and tipo_evento       = 'E'
--/
update anatpr 
   set d_data_decorrenza = to_date(data_pratica,'j')
 where d_data_decorrenza is null
/
alter table anatpr enable all triggers
/
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'IDX';
w_nome_ogg	varchar2(255) := 'ANATPR_PK1';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create unique index anatpr_pk1 on anatpr (id)';

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
w_nome_ogg	varchar2(255) := 'ANATPR_PK2';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create unique index anatpr_pk2 on anatpr (id_pratica)';

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
