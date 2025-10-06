--liquibase formatted sql
--changeset amonopoli:202305231225 runOnChange:true stripComments:false
create or replace function f_ANSC_tipo_file
(a_estensione_file		IN	varchar2
)

return varchar2

IS

w_estensione_file	varchar2(255) := upper(a_estensione_file);

w_tipo_file		varchar2(255);

begin
  if a_estensione_file is not null then
     begin
       select t10.id
         into w_tipo_file
         from anst10 t10
        where descrizione = w_estensione_file
          ;
      exception 
        when others then
             w_tipo_file := '';
     end;
  end if; -- if a_archivio_rif is not null and a_id_rif is not null then

  return w_tipo_file;
end;
/
