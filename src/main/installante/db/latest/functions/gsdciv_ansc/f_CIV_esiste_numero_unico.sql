--liquibase formatted sql
--changeset snocca:202311221340 runOnChange:true stripComments:false
create or replace function f_CIV_esiste_numero_unico
(a_archivio IN varchar2
,a_id	      IN	number
,a_anno  		IN 	number
,a_numero_unico	IN	number
)

return varchar2

IS            

w_esiste  number := 0;
w_errore	varchar2(4000);

begin
  w_errore := '';

  if a_numero_unico is not null and a_id is not null and a_anno is not null and a_archivio is not null then
     begin
       select 1
         into w_esiste
         from ansall_v v
        where v.numero_unico = a_numero_unico
          and v.anno = a_anno
          and ( (v.id_rif <> a_id) or (v.id_rif = a_id and v.archivio_rif <> a_archivio) )
       ;
       if w_esiste = 1 then
          w_errore := 'Numero comunale gia'' assegnato. La registrazione non puo'' essere inserita.';
       end if;
     exception
       when no_data_found then
            w_errore := '';
     end;
  end if;

  return w_errore;

exception
  when others then
       w_errore := 'Errore generico nel controllo del numero comunale dell''atto';
       return w_errore;
end;
/