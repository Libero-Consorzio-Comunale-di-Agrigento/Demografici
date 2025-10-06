--liquibase formatted sql
--changeset amonopoli:202411141655 runOnChange:true stripComments:false
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
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');

     w_sql := 'rename CERDDC to CERDDC_DCE';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' rinominato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non rinominato ('||SQLERRM||')');
     end;
  end if;
end;
/
create or replace view cerddc
       (COD_CERTIFICATO, COD_DIRITTO, FASCIA_TARIFFARIA, ID_CERDTD)
AS
select ddc.cod_certificato, ddc.cod_diritto, ddc.fascia_tariffaria, dtd.id
  from cerdtd dtd, cerdce dce, cerddc_dce ddc
 where dce.cod_certificato   = ddc.cod_certificato
   and dtd.cod_diritto       = ddc.cod_diritto
   and dtd.fascia_tariffaria = ddc.fascia_tariffaria
   and nvl(f_valore_inp('CERDDC_CTC',1,1,'X','S'),'N') = 'N'
UNION
select ddc.cod_certificato, ddc.cod_diritto, ddc.fascia_tariffaria, dtd.id
  from cerdtd dtd, cerdce dce, cerddc_dce ddc
 where (dce.id_cerctc is null or dce.flag_dismesso is not null)
   and dce.cod_certificato   = ddc.cod_certificato
   and dtd.cod_diritto       = ddc.cod_diritto
   and dtd.fascia_tariffaria = ddc.fascia_tariffaria
   and nvl(f_valore_inp('CERDDC_CTC',1,1,'X','S'),'N') = 'S'
UNION
select dce.cod_certificato, dtd.cod_diritto, dtd.fascia_tariffaria, dtd.id
  from cerdtd dtd, cerdce dce, cerddc_ctc ddc
 where dce.flag_dismesso is null
   and dtd.id            = ddc.id_cerdtd
   and dce.id_cerctc     = ddc.id_cerctc
   and nvl(f_valore_inp('CERDDC_CTC',1,1,'X','S'),'N') = 'S'
/
COMMENT ON TABLE CERDDC IS 'Certificazione - Dizionario Diritti per Certificato (view)'
/
