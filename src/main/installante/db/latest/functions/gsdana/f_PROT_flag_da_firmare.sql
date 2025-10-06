--liquibase formatted sql
--changeset amonopoli:202303101050_1 runOnChange:true stripComments:false
create or replace function f_PROT_flag_da_firmare
(a_archivio_rif		IN	varchar2
,a_nome_allegato	IN	varchar2	default NULL
)

return varchar2

IS

w_firma_url                varchar2(255);

w_flag                     varchar2(255);

errore                     exception;
w_errore                   varchar2(4000);

w_operazione_log		varchar2(255) := 'f_PROT_flag_da_firmare';

begin
  if a_archivio_rif is null then
     goto fine;
  end if;

  w_firma_url := nvl(rtrim(f_valore_inp('FIRMA_URL',1,1,'X','S')),'N');

  if w_firma_url = 'N' then
     goto fine;
  end if;

  if a_archivio_rif = 'CIVCOM' then
     if upper(a_nome_allegato) like '%.P7M' then
        goto fine;
     else
        w_flag := 'S';
     end if;
  else
     w_errore := 'Archivio di riferimento '||a_archivio_rif||' non gestito';
     raise errore;
  end if;          

<< fine>>
null; 

  return w_flag;
        
exception
  when errore then
--       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);  
       return null;      
  when others then
       w_errore := 'errore ('||sqlerrm||')';
--       DOCAREA_PKG.ins_log(w_operazione_log, w_errore);        
       return null;      
end;
/
