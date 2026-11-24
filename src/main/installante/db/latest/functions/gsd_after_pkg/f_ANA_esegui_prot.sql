--liquibase formatted sql
--changeset amonopoli:202512101225 runOnChange:true stripComments:false
create or replace function f_ANA_esegui_prot
(a_id_com		IN 	number
,a_terminalista		IN	varchar2 	default null
)

return CLOB

IS

w_archivio_rif        	varchar2(255) := 'ANACOM';
w_id_com              	varchar2(255) := a_id_com;

w_return_prot		varchar2(2000);
w_return_mail		varchar2(2000);
w_return		clob;

w_errore		varchar2(4000);
errore			exception;

cursor sel_prot is
select com_p.oggetto
     , com_p.FLAG_WS_PROT
     , f_PROT_flag_destinatari('ANACOM',com_p.id) flag_destinatari
  from anacom_prot com_p
 where id = w_id_com
;

begin
  for rec in sel_prot loop
     if rec.flag_ws_prot is not null then
        w_return := 'Operazione non eseguita: comunicazione già protocollata';
     else
        if rec.flag_destinatari is null then
           w_return := 'Impossibile eseguire la protocollazione: destinatari non presenti';
           goto fine;
        elsif rec.oggetto is null then
           w_return := 'Impossibile eseguire la protocollazione: oggetto non indicato';
           goto fine;
        else
           if a_terminalista is not null then
              w_return_prot := docarea_pkg.PROTOCOLLA_UTENTE(w_archivio_rif,w_id_com,a_terminalista);
           else 
              w_return_prot := docarea_pkg.PROTOCOLLA(w_archivio_rif,w_id_com);
           end if;
           if w_return_prot is not null then
              if nvl(w_return_prot,'N') = 'S' then
                 begin
                   update anacom
                      set stampa_eseguita = 'SI'
                    where id = w_id_com
                      and stampa_eseguita = 'NO'
                   ;
                 exception
                   when others then 
                        null;
                 end;
                 w_return := '';
              else
                 w_return := 'errore Protocollo - id_com '||a_id_com||' ('||w_return_prot||')';
                 goto fine;
              end if;
           else -- if w_return_prot is not null then
              w_return := 'anomalia in fase di protocollazione (id_com '||a_id_com||')';
           end if;
        end if;
     end if;

     if rec.flag_destinatari is not null then
        w_return_mail := docarea_pkg.INVIA_MAIL(w_archivio_rif,w_id_com,'');
        if w_return_mail is not null then
           if nvl(w_return_mail,'N') = 'S' then
              w_return := '';
           else
              w_return := 'errore Invio PEC - id_com '||a_id_com||' ('||w_return_mail||')';
              goto fine;
           end if;
        end if;
     end if;
  end loop;
<< fine >>
null;
  
  return w_return;
exception
  when others then
       w_errore := 'errore - id_com '||a_id_com||' ('||sqlerrm||')';
       return w_errore;  
end;
/
