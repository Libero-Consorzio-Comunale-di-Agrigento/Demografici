--liquibase formatted sql
--changeset amonopoli:202501090915_2 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'CERDDC';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');

     w_sql := 'create or replace view cerddc_v_orizzontale
as
select ddc.cod_certificato cod_certificato,
       dce.descrizione descrizione_dce,
       dce.id_cerctc id_cerctc,
       ctc.descrizione des_cerctc,
       lpad(nvl(ddc_1.cod_diritto,0),2,''0'')||lpad(nvl(ddc_1.fascia_tariffaria,0),''2'',''0'')||
         lpad(nvl(ddc_2.cod_diritto,0),2,''0'')||lpad(nvl(ddc_2.fascia_tariffaria,0),''2'',''0'')||
         lpad(nvl(ddc_3.cod_diritto,0),2,''0'')||lpad(nvl(ddc_3.fascia_tariffaria,0),''2'',''0'')||
         lpad(nvl(ddc_4.cod_diritto,0),2,''0'')||lpad(nvl(ddc_4.fascia_tariffaria,0),''2'',''0'') stringa_ddc
  from cerctc ctc, cerdce dce, cerddc ddc_1, cerddc ddc_2, cerddc ddc_3, cerddc ddc_4, cerddc ddc
 where ctc.id (+)                = dce.id_cerctc
   and dce.cod_certificato       = ddc.cod_certificato
   and ddc_1.cod_certificato (+) = ddc.cod_certificato
   and ddc_1.cod_diritto     (+) = 1
   and ddc_2.cod_certificato (+) = ddc.cod_certificato
   and ddc_2.cod_diritto     (+) = 2
   and ddc_3.cod_certificato (+) = ddc.cod_certificato
   and ddc_3.cod_diritto     (+) = 3
   and ddc_4.cod_certificato (+) = ddc.cod_certificato
   and ddc_4.cod_diritto     (+) = 4';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto cerddc_v_orizzontale creato');
     exception
       when others then
dbms_output.put_line('oggetto cerddc_v_orizzontale non creato ('||SQLERRM||')');
     end;

  elsif w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' NON esistente');
  end if;
end;
/
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'CERDDC_DCE';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');

     w_sql := 'create or replace view cerddc_v_orizzontale
as
select ddc.cod_certificato cod_certificato,
       dce.descrizione descrizione_dce,
       dce.id_cerctc id_cerctc,
       ctc.descrizione des_cerctc,
       lpad(nvl(ddc_1.cod_diritto,0),2,''0'')||lpad(nvl(ddc_1.fascia_tariffaria,0),''2'',''0'')||
         lpad(nvl(ddc_2.cod_diritto,0),2,''0'')||lpad(nvl(ddc_2.fascia_tariffaria,0),''2'',''0'')||
         lpad(nvl(ddc_3.cod_diritto,0),2,''0'')||lpad(nvl(ddc_3.fascia_tariffaria,0),''2'',''0'')||
         lpad(nvl(ddc_4.cod_diritto,0),2,''0'')||lpad(nvl(ddc_4.fascia_tariffaria,0),''2'',''0'') stringa_ddc
  from cerctc ctc, cerdce dce, cerddc_dce ddc_1, cerddc_dce ddc_2, cerddc_dce ddc_3, cerddc_dce ddc_4, cerddc_dce ddc
 where ctc.id (+)                = dce.id_cerctc
   and dce.cod_certificato       = ddc.cod_certificato
   and ddc_1.cod_certificato (+) = ddc.cod_certificato
   and ddc_1.cod_diritto     (+) = 1
   and ddc_2.cod_certificato (+) = ddc.cod_certificato
   and ddc_2.cod_diritto     (+) = 2
   and ddc_3.cod_certificato (+) = ddc.cod_certificato
   and ddc_3.cod_diritto     (+) = 3
   and ddc_4.cod_certificato (+) = ddc.cod_certificato
   and ddc_4.cod_diritto     (+) = 4';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto cerddc_v_orizzontale creato');
     exception
       when others then
dbms_output.put_line('oggetto cerddc_v_orizzontale non creato ('||SQLERRM||')');
     end;

  elsif w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' NON esistente');
  end if;
end;
/
declare
cursor sel_ctc is
select v.id_cerctc id_cerctc,
       min(v.des_cerctc) des_cerctc,
       count(*) count_ddc,
       min(v.cod_certificato) cod_certificato,
       min(v.descrizione_dce) descrizione_dce,
       v.stringa_ddc
  from cerddc_v_orizzontale v
 group by v.id_cerctc, v.stringa_ddc
 order by 1, 3 desc, 4
;

w_id_cerctc_prec	varchar2(255) := 0;

w_tipo_ogg	varchar2(255);
w_nome_ogg	varchar2(255);
w_nome_col      varchar2(255);

w_check_db	number;

w_sql		varchar2(32000);
w_result	varchar2(32000);

begin
  for rec_ctc in sel_ctc loop
--
-- CERCTC
-- 1 - ANA
-- 2 - CIV
-- 3 - ELE
-- 4 - LEV
-- 5 - DIC
-- 6 - VARIE-ANA
-- 7 - VARIE-CIV
-- 8 - CDI-CIE
--
      if rec_ctc.id_cerctc != w_id_cerctc_prec then
         if rec_ctc.id_cerctc in (1,5,8) then -- solo ANA, DIC e CDI-CIE
            w_tipo_ogg := 'TAB';
            w_nome_ogg := 'CERDDC';
            w_check_db := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

            if w_check_db = 1 then
               w_sql := 'insert into cerddc_ctc (ID_CERCTC, ID_CERDTD, VERSION)
                         select '||rec_ctc.ID_CERCTC||', dtd.ID, 0
                           from cerdtd dtd, cerddc ddc
                          where dtd.cod_diritto       = ddc.cod_diritto
                            and dtd.fascia_tariffaria = ddc.fascia_tariffaria
                            and cod_certificato       = '''||rec_ctc.cod_certificato||'''
                            and not exists (select 1 from cerddc_ctc b
                                             where b.id_cerctc = '||rec_ctc.id_cerctc||')';

               begin
                 execute immediate w_sql;
dbms_output.put_line('insert into cerddc_ctc eseguita');
               exception
                 when others then
dbms_output.put_line('insert into cerddc_ctc NON eseguita ('||SQLERRM||')');
               end;

            else
               w_sql := 'insert into cerddc_ctc (ID_CERCTC, ID_CERDTD, VERSION)
                         select '||rec_ctc.ID_CERCTC||', dtd.ID, 0
                           from cerdtd dtd, cerddc_dce ddc
                          where dtd.cod_diritto       = ddc.cod_diritto
                            and dtd.fascia_tariffaria = ddc.fascia_tariffaria
                            and cod_certificato       = '''||rec_ctc.cod_certificato||'''
                            and not exists (select 1 from cerddc_ctc b
                                             where b.id_cerctc = '||rec_ctc.id_cerctc||')';

               begin
                 execute immediate w_sql;
dbms_output.put_line('insert into cerddc_ctc eseguita');
               exception
                 when others then
dbms_output.put_line('insert into cerddc_ctc NON eseguita ('||SQLERRM||')');
               end;

            end if;
         else
            null;
         end if;
      else
         null;
      end if;

      w_id_cerctc_prec := rec_ctc.id_cerctc;
  end loop;
end;
/
