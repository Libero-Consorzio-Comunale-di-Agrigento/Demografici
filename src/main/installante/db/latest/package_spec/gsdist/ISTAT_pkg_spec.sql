--liquibase formatted sql
--changeset amonopoli:202401081200_1 runOnChange:true stripComments:false
create or replace package ISTAT_PKG
is


w_cod_pro_cliente		number;
w_cod_com_cliente		number;
w_codice_cliente		varchar2(255);
w_des_com_cliente		varchar2(255);
w_sigla_pro_cliente		varchar2(255);

procedure dati_cliente;
function  versione                     return varchar2;

procedure ins_log                      (a_operazione varchar2,a_note varchar2,a_campo_clob clob default null);

end;
/
