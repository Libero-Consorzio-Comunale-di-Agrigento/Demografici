--liquibase formatted sql
--changeset amonopoli:202401081200_2 runOnChange:true stripComments:false
create or replace package body ISTAT_PKG
is

function versione

return varchar2

IS

w_versione 		varchar2(255);

begin
--
-- Versione   Data         Autore   Note
-- V1.0   del 01/12/2021   AM       .prima emissione
--

  w_versione := 'V1.0   del 02/12/2021';

  return w_versione;
end;

procedure dati_cliente
is

w_operazione_log	varchar2(255) := 'dati_cliente';

w_errore		varchar2(4000);
errore			exception;

begin

  begin
    select m.cod_provincia
         , m.cod_Comune
         , lpad(m.cod_provincia,3,'0')||lpad(m.cod_Comune,3,'0')
         , m.descrizione
         , m.sigla_provincia
      into w_cod_pro_cliente
         , w_cod_com_cliente
         , w_codice_cliente
         , w_des_com_cliente
         , w_sigla_pro_cliente
      from arccom m
     where (m.cod_provincia, m.cod_comune) = (select pro_cliente, com_cliente from menuditta)
    ;
  exception
    when others then
         w_errore := 'errore in dati_cliente ('||SQLERRM||')';
         raise errore;
  end;

exception
  when errore then
       ISTAT_PKG.ins_log(w_operazione_log, w_errore);
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       ISTAT_PKG.ins_log(w_operazione_log, w_errore);
end dati_cliente;

procedure ins_log
(a_operazione   varchar2
,a_note 	varchar2
,a_campo_clob 	clob	default null
)

is

w_id			number;

w_operazione_log	varchar2(255) := 'ins_log';

w_errore		varchar2(4000);
errore			exception;

begin
  begin
    select ISTAT_LOG_SQ.nextval
      into w_id
      from dual
    ;
  end;

  begin
    insert into istat_log (id, data_ora, operazione, note, campo_clob)
    values (w_id, sysdate, a_operazione, a_note, a_campo_clob)
    ;
--COMMIT;
  exception
    when others then
         raise errore;
  end;
<< fine >>
null;

exception
  when others then
       w_errore := 'errore ('||SQLERRM||')';
       begin
         insert into istat_log (id, data_ora, operazione, note, campo_clob)
         values (w_id, sysdate, w_operazione_log, a_note, a_campo_clob)
         ;
       end;
end ins_log;

end;
/
