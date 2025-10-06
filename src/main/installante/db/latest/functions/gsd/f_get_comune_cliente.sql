--liquibase formatted sql
--changeset amonopoli:202008071405 runOnChange:true stripComments:false
create or replace function f_get_comune_cliente
(a_campo	varchar2
)

return varchar2

IS

w_campo			varchar2(255) := nvl(upper(a_campo),'DES_COM');

w_cod_provincia		number;
w_cod_comune		number;
w_descrizione		varchar2(255);
w_sigla_provincia	varchar2(255);
w_codice_catasto	varchar2(255);

w_return		varchar2(255);

begin

  begin
    select cod_provincia, cod_comune, descrizione, sigla_provincia, codice_catasto
      into w_cod_provincia, w_cod_comune, w_descrizione, w_sigla_provincia, w_codice_catasto
      from arccom
     where (cod_provincia,cod_comune) = (select pro_cliente,com_cliente
                                           from menuditta)
    ;
  end;

  if w_campo = 'COD_PRO' then
     w_return := lpad(w_cod_provincia,3,'0');
  elsif w_campo = 'COD_COM' then
     w_return := lpad(w_cod_comune,3,'0');
  elsif w_campo = 'COD_COMUNE' then
     w_return := lpad(w_cod_provincia,3,'0')||lpad(w_cod_comune,3,'0');
  elsif w_campo = 'DES_COM' then
     w_return := w_descrizione;
  elsif w_campo = 'SIGLA_PRO' then
     w_return := w_sigla_provincia;
  elsif w_campo = 'DES_COMUNE' then
     w_return := w_descrizione||' ('||w_sigla_provincia||')';
  else
     w_return := '';
  end if;

  return w_return;
end;
/
