--liquibase formatted sql
--changeset amonopoli:202307171705_2 runOnChange:true stripComments:false
create or replace function f_ANSC_rilasciato_da
(a_ente_documento		IN	varchar2
,a_tipo_documento 		IN	varchar2
)

return varchar2

IS

w_codice			varchar2(10);

begin
-- 1 - ministero interno
-- 2 - comune

  if a_ente_documento||a_tipo_documento is null then
     goto fine;
  end if;

  if a_ente_documento is not null then
     begin
       select t20.id
         into w_codice
         from anst20 t20
        where ente_documento_ads = a_ente_documento
       ;
     exception
       when others then
            w_codice := '';
     end;
  end if;

  if w_codice is null and a_tipo_documento is not null then
     if a_tipo_documento in ('PT','PP','CE') then
        w_codice := '1';
     elsif a_tipo_documento in ('CI','DI') then
        w_codice := '2';
     else
        w_codice := '2';
     end if;
  end if;

<< fine >>

  return w_codice;
end;
/
