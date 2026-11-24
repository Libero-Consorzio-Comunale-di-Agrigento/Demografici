--liquibase formatted sql
--changeset amonopoli:202410281245_1 runOnChange:true stripComments:false
create or replace function f_PAR_fase
(a_fase		IN	varchar2
,a_campo	IN	varchar2
,a_funzione	IN	varchar2	default NULL
)

return varchar2

IS
w_campo		varchar2(255) := upper(a_campo);
w_fase		varchar2(255);

begin
  if a_fase is not null then
     if a_fase in ('ACIT','ANAS','AVPB','AMAT','ADIV','AUCI','AMOR') then
        if w_campo = 'COD' then
           w_fase := 'A';
        elsif w_campo = 'DES' then
           w_fase := 'Stampa Atti';
        end if;

     elsif a_fase in ('SCPW') then
        if a_funzione like '%00' then
           w_fase := '';
        else 
           if w_campo = 'COD' then
              w_fase := 'W';
           elsif w_campo = 'DES' then
              w_fase := 'Stampa Comunicazioni';
           end if;
        end if;

     elsif a_fase in ('CERW') then
        if w_campo = 'COD' then
           w_fase := 'W';
        elsif w_campo = 'DES' then
           w_fase := 'Stampa Certificati';
        end if;

     elsif a_fase in ('SCAW') then
        if w_campo = 'COD' then
           w_fase := 'C';
        elsif w_campo = 'DES' then
           w_fase := 'Stampa Comunicazioni';
        end if;

     elsif a_fase in ('SAPW','IAPR','CABI','CAPR','IAIR','CABA','KAIR') then
        if a_funzione in ('APR4','SDDR') then
           w_fase := '';
        else
           if w_campo = 'COD' then
              w_fase := 'P';
           elsif w_campo = 'DES' then
              w_fase := 'Stampa Adempimenti';
           end if;
--              if a_fase = 'SAPW' then
--                 w_fase := 'Stampa Adempimenti Pratiche';
--              elsif a_fase = 'IAPR' then
--                 w_fase := 'Iscrizione APR';
--              elsif a_fase = 'CABI' then
--                 w_fase := 'Cambio Abitazione APR';
--              elsif a_fase = 'CAPR' then
--                 w_fase := 'Cancellazione APR';
--              elsif a_fase = 'IAIR' then
--                 w_fase := 'Iscrizione AIRE';
--              elsif a_fase = 'CABA' then
--                 w_fase := 'Cambio Abitazione AIRE';
--              elsif a_fase = 'KAIR' then
--                 w_fase := 'Cancellazione AIRE';
--              end if;
--           end if;
        end if;

     elsif a_fase in ('SCEW') then
        if w_campo = 'COD' then
           w_fase := 'W';
        elsif w_campo = 'DES' then
           w_fase := 'Stampa Comunicazioni';
        end if;

     elsif a_fase in ('SCLW') then
        if w_campo = 'COD' then
           w_fase := 'W';
        elsif w_campo = 'DES' then
           w_fase := 'Stampa Comunicazioni';
        end if;
     end if;
  end if;
 
  return w_fase;

end;

/
