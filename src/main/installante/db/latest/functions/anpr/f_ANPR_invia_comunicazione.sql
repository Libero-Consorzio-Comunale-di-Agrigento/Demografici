--liquibase formatted sql
--changeset amonopoli:202604211235_1 runOnChange:true stripComments:false
create or replace function f_ANPR_invia_comunicazione
(a_id_operazione	IN	number
,a_servizio		IN	varchar2
,a_flag_ripetizione	IN	varchar2
)

return number

IS

w_id_operazione			number;

w_id_operazione_rif		number;
w_servizio_rif			varchar2(255);
w_id_operazione_anpr_rif	number;

errore				exception;
w_errore			varchar2(4000);

w_return			number;

begin
  w_return := 0;

  if a_flag_ripetizione is null then
     begin
       update anpciu
          set id_operazione = a_id_operazione,
              servizio      = a_servizio
        where id_operazione = a_id_operazione
       ;
       if sql%found then
          commit;
          w_return := 1;
       else
          w_return := 0;
       end if;
     exception
       when others then
            w_errore := 'Errore in aggiornamento ANPCIU - Invio ('||sqlerrm||')';
            w_return := -1;
            raise errore;
     end;

  elsif a_flag_ripetizione is not null then
     w_id_operazione := f_ANPCIU_nr('');

     if w_id_operazione is null then
        w_return := -1;
        raise errore;

     elsif w_id_operazione is not null then
        begin
          select id_operazione_rif, servizio_rif, id_operazione_anpr_rif
            into w_id_operazione_rif, w_servizio_rif, w_id_operazione_anpr_rif
            from anpciu_rif 
           where id_operazione     = a_id_operazione
             and flag_annullamento = 'S'
          ;
        exception
          when others then
               w_id_operazione_rif      := '';
               w_servizio_rif           := '';
               w_id_operazione_anpr_rif := '';
        end;

        if w_id_operazione_rif is not null then
           begin
             insert into anpciu_rif
                    (id_operazione, id_operazione_rif, servizio_rif, id_operazione_anpr_rif, flag_annullamento)
             values (w_id_operazione, w_id_operazione_rif, w_servizio_rif, w_id_operazione_anpr_rif, 'S')
             ;
           exception
             when others then
		  w_errore := 'Errore in inserimento ANPCIU_RIF ('||SQLERRM||')';
                  w_return := -1;
                  raise errore;
           end;
        end if;
		
        begin
          update anpciu
             set flag_invio_ws = ''
           where id_operazione = a_id_operazione
          ;
          update anpciu
             set id_operazione = w_id_operazione,
                 servizio      = a_servizio
           where id_operazione = a_id_operazione
          ;
          if sql%found then
             commit;
             w_return := 1;
          else
             w_return := 0;
          end if;
        exception
          when others then
               w_errore := 'Errore in aggiornamento ANPCIU - Ripetizione ('||sqlerrm||')';
               w_return := -1;
               raise errore;
        end;
     end if;
  end if;

  return w_id_operazione;

exception
  when errore then
       return w_return;
  when others then
       w_return := -1;
       return w_return;
end;
/
