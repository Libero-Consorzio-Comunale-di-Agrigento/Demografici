--liquibase formatted sql
--changeset amonopoli:202403041055_2 runOnChange:true stripComments:false
create or replace trigger CERCEM_TIU
before INSERT
    or UPDATE
on CERCEM
for each row
declare
   integrity_error       exception;
   errno                 integer;
   errmsg                char(200);
   dummy                 integer;
   found                 boolean;

   w_fascia_bollo        number;
   w_esenzione_diritti   varchar2(255);
begin
  :new.id      := F_CERCEM_NR(:new.id);
  :new.version := nvl(:new.version,0);

  if INSERTING then
     begin  -- Check DATA Integrity on INSERT or UPDATE
       if :new.d_data_emissione is null then
          :new.d_data_emissione := sysdate;
       end if;
       if :new.data is null and :new.d_data_emissione is not null then
          :new.data := to_number(to_char(trunc(:new.d_data_emissione),'j'));
       end if; 

       if :new.data_nas_richiedente is null and :new.d_data_nas_richiedente is not null then
          :new.data_nas_richiedente := to_number(to_char(trunc(:new.d_data_nas_richiedente),'j'));
       end if;
       if :new.data_nas_richiedente is not null and :new.d_data_nas_richiedente is null then
          :new.d_data_nas_richiedente := to_date(:new.data_nas_richiedente,'j');
       end if;

       if :new.data_storico is null and :new.d_data_storico is not null then
          :new.data_storico := to_number(to_char(trunc(:new.d_data_storico),'j'));
       end if;
       if :new.data_storico is not null and :new.d_data_storico is null then
          :new.d_data_storico := to_date(:new.data_storico,'j');
       end if;

       if :new.cod_certificato is not null and :new.anno_emissione is not null and :new.progr_emissione is not null then
          begin
            insert into cercdc
                   (anno_emissione, progr_emissione, cod_diritto, fascia_tariffaria)
            select :new.anno_emissione, :new.progr_emissione, ddc.cod_diritto, ddc.fascia_tariffaria
              from cerddc ddc
             where ddc.cod_certificato = :new.cod_certificato
            ;
          exception
            when others then
                 null;
          end;
       end if;

       :new.cognome_richiedente         := nvl(:new.cognome_richiedente,f_cognome(:new.richiedente));
       :new.nome_richiedente            := nvl(:new.nome_richiedente,f_nome(:new.richiedente));
       :new.cognome_beneficiario        := nvl(:new.cognome_beneficiario,f_cognome(:new.cognome_nome));
       :new.nome_beneficiario           := nvl(:new.nome_beneficiario,f_nome(:new.cognome_nome));

       if :new.modalita_rilascio is not null and
          :new.SEGRETERIA||:new.STATO_CIVILE||:new.CARTA_IDENTITA||:new.RIMBORSO_ST||:new.BOLLO is null
       then  
          begin
            select decode(dri.esenzione_diritti,'SI',to_number(null), 
                   decode(:new.terminalista,'ON_LINE',dtd.importo_1_on_line,dtd.importo_1)), 
                   dri.fascia_tariffaria, dri.esenzione_diritti
              into :new.bollo, w_fascia_bollo, w_esenzione_diritti
              from cerdtd dtd, cerdri dri
             where dtd.cod_diritto       (+) = 9
               and dtd.fascia_tariffaria (+) = dri.fascia_tariffaria
               and dri.cod_ri                = :new.modalita_rilascio
            ;
          exception
            when no_data_found then
                  w_fascia_bollo := '';
            when others then
                 raise_application_error (-20999, 'Errore in ricerca importo Bollo ('||SQLERRM||')');
          end;

          if nvl(w_esenzione_diritti,'NO') != 'SI' then
             if :new.terminalista = 'ON_LINE' then
                begin
                  select max(decode(dtd.cod_diritto,1,
                           decode(w_fascia_bollo,'',importo_1_on_line,importo_2_on_line),'')),
                         max(decode(dtd.cod_diritto,2,   
                           decode(w_fascia_bollo,'',importo_1_on_line,importo_2_on_line),'')),   
                         max(decode(dtd.cod_diritto,3,importo_1_on_line,'')),
                         max(decode(dtd.cod_diritto,4,
                           decode(w_fascia_bollo,'',importo_1_on_line,nvl(importo_2_on_line,importo_1_on_line)),''))
                    into :new.SEGRETERIA, :new.STATO_CIVILE, :new.CARTA_IDENTITA, :new.RIMBORSO_ST
                    from cerdtd dtd, cerddc ddc
                   where dtd.cod_diritto       = ddc.cod_diritto
                     and dtd.fascia_tariffaria = ddc.fascia_tariffaria
                     and ddc.cod_certificato   = :new.cod_certificato
                  ;
                exception
                  when no_data_found then   
                       null;
                  when others then
                       raise_application_error (-20999, 'Errore in ricerca importo Diritti on-line ('||SQLERRM||')');
                end;
             else
                begin
                  select max(decode(dtd.cod_diritto,1,
                           decode(w_fascia_bollo,'',importo_1,importo_2),'')),
                         max(decode(dtd.cod_diritto,2,   
                           decode(w_fascia_bollo,'',importo_1,importo_2),'')),   
                         max(decode(dtd.cod_diritto,3,importo_1,'')),
                         max(decode(dtd.cod_diritto,4,
                           decode(w_fascia_bollo,'',importo_1,nvl(importo_2,importo_1)),''))
                    into :new.SEGRETERIA, :new.STATO_CIVILE, :new.CARTA_IDENTITA, :new.RIMBORSO_ST
                    from cerdtd dtd, cerddc ddc
                   where dtd.cod_diritto       = ddc.cod_diritto
                     and dtd.fascia_tariffaria = ddc.fascia_tariffaria
                     and ddc.cod_certificato   = :new.cod_certificato
                  ;
                exception
                  when no_data_found then   
                       null;
                  when others then
                       raise_application_error (-20999, 'Errore in ricerca importo Diritti ('||SQLERRM||')');
                end;
             end if;  
          end if;
       end if;
     end;
  end if;
end;
/
