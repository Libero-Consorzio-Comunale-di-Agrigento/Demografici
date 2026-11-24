--liquibase formatted sql
--changeset amonopoli:202310131455 runOnChange:true stripComments:false
create or replace function f_flag_ANSC

return varchar2

IS

w_integrazione_ansc 	varchar2(1) := upper(f_valore_inp('ANSC',1,1,'X','S'));
w_ambiente_ansc		varchar2(255);
w_ambiente_anpr		varchar2(255);
w_codice_cliente	varchar2(255);

w_return		varchar2(4000);

begin
  w_return := '';

  if nvl(w_integrazione_ansc,'N') = 'S' then
     begin
       select valore
         into w_ambiente_ansc
         from ansinp
        where parametro = 'AMBIENTE'
       ;
     exception
       when others then
            w_ambiente_ansc := 'XXX';
     end;

     if nvl(w_ambiente_ansc,'PROD') = 'PRE' then
        w_ambiente_anpr  := f_ANPR_valore_inp('TIPO_INVIO',1,10,'X','S');
        w_codice_cliente := f_get_comune_cliente('COD_COMUNE');
        if w_ambiente_ANPR = 'TEST' and w_codice_cliente in ('039010','025006') then	-- ambienti SVI e TST
           w_return := 'S';
        end if;

     elsif nvl(w_ambiente_ansc,'PROD') = 'PROD' then
        w_return := 'S';
     end if;
           
  end if;

  return w_return;
end;
/
