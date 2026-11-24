--liquibase formatted sql
--changeset amonopoli:202512021505 runOnChange:true stripComments:false
create or replace function f_PAR_fase_ana
(a_fase		IN	varchar2
,a_funzione	IN	varchar2
,a_campo	IN	varchar2
)

return varchar2

IS

w_campo			varchar2(255) := upper(a_campo);
w_fase			varchar2(255);

begin
  if a_fase||a_funzione is not null then
     if w_campo = 'COD' then
        w_fase := a_fase;

     elsif w_campo = 'DES' then
        if a_fase = 'SCAW' then
           w_fase := 'Stampa Comunicazioni';

        elsif a_fase = 'SAPW' then
           w_fase := 'Stampa Adempimenti Pratiche';

        elsif a_fase = 'IAPR' then
           w_fase := 'Iscrizione APR';
   
        elsif a_fase = 'CABI' then
           w_fase := 'Cambio Abitazione APR';
   
        elsif a_fase = 'CAPR' then
           w_fase := 'Cancellazione APR';
   
        elsif a_fase = 'IAIR' then
           w_fase := 'Iscrizione AIRE';
   
        elsif a_fase = 'CABA' then
           w_fase := 'Cambio Abitazione AIRE';
   
        elsif a_fase = 'KAIR' then
           w_fase := 'Cancellazione AIRE';
   
        end if;
     end if;
  end if;
 
  return w_fase;

end;
/
