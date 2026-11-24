--liquibase formatted sql
--changeset amonopoli:202604211235_2 runOnChange:true stripComments:false
create or replace function f_ANPR_annulla_comunicazione
(a_id_operazione	IN	number
,a_servizio		IN	varchar2
,a_utente		IN	varchar2
)

return number

IS

w_id_operazione			number;
w_servizio_ann			varchar2(255);
w_tipo_operazione_ann		varchar2(255);

errore		exception;
w_errore	varchar2(4000);

w_return	number;

begin
  w_servizio_ann := f_ANPR_codice_servizio_ann(a_servizio);

  if w_servizio_ann is null then
     w_errore := 'Problema nella definizione del servizio di annullamento';
     w_return := -1;
 
  elsif w_servizio_ann is not null then  
     w_tipo_operazione_ann := nvl(f_ANPR_tipo_operazione_ann(w_servizio_ann),'V');
     w_id_operazione       := f_ANPCIU_nr('',a_servizio);
     if w_id_operazione is null then
        w_errore := 'Problema nell''assegnazione dell''ID Operazione';
        w_return := -1;
        raise errore;

     elsif w_id_operazione is not null then
        begin
          insert into anpciu
                 (id_operazione, servizio, tipo_operazione, 
                  archivio_rif, anno_rif, numero_rif, 
                  matricola, fascia_fam, cod_fam, 
                  id_anadoc, id_anamsi,
                  terminalista, data_reg)
          select w_id_operazione, w_servizio_ann, 'V',
                 ciu.archivio_rif, ciu.anno_rif, ciu.numero_rif,
                 ciu.matricola, ciu.fascia_fam, ciu.cod_fam, 
                 ciu.id_anadoc, ciu.id_anamsi,
                 a_utente, to_char(sysdate,'j')
            from anpciu ciu
            where id_operazione = a_id_operazione
          ;
          insert into anpciu_rif
                 (id_operazione, 
                  id_operazione_rif, servizio_rif, id_operazione_anpr_rif,
                  flag_annullamento)
          select w_id_operazione, 
                 ciu.id_operazione, ciu.servizio, ciu.id_operazione_anpr,
                 'S'
            from anpciu ciu
           where id_operazione = a_id_operazione
          ;
        exception
          when others then
               w_errore := 'Problema nella creazione della comunicazione di annullamento'||' ('||SQLERRM||')';
               w_return := 1;
               raise errore;
        end;

        begin
          update anpciu
             set id_operazione = w_id_operazione
           where id_operazione = w_id_operazione
          ;
          if sql%found then
             commit;
             w_return := 1;
          else
             w_return := 0;
          end if;
        exception
          when others then
               w_errore := 'Errore in aggiornamento ANPCIU ('||sqlerrm||')';
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