--liquibase formatted sql
--changeset amonopoli:202412051405 runOnChange:true stripComments:false
create or replace function f_DOC_numero
(a_tipo_documento	IN	varchar2
)

return varchar2

IS

w_tipo_documento	varchar2(10) := upper(a_tipo_documento);

w_numero		varchar2(255);

begin
  if w_tipo_documento is not null then
     begin
       select max(to_number(numero)) + 1
         INTO w_numero
         from anadoc
        where tipo_documento = w_tipo_documento
          and (cod_pro_ente,cod_com_ente) = (select pro_cliente,com_cliente from menuditta)
          and translate(numero,'1234567890','9999999999') in ( '9','99','999','9999','99999','999999','9999999',
                                                               '99999999','999999999','9999999999','99999999999',
                                                               '999999999999' )
       ;
     exception
       when others then
            w_numero := '';
     end;
  end if;

  return w_numero;

end;
/
