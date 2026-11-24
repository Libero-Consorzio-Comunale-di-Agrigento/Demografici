--liquibase formatted sql
--changeset amonopoli:202510270910_2 runOnChange:true stripComments:false
create or replace trigger ansana_tiu
before insert
on ansana
for each row

declare
w_id_comune_inp                varchar2(255);

w_atto                    number := '';
w_ufficio                 number := '';
w_natura                  varchar2(255) := 'O';
w_cognome_nome            varchar2(255);
w_cognome_nome_ric        varchar2(255);
w_data_nas_j              number;
w_cod_pro_nas		  number;
w_cod_com_nas		  number;

w_note_civ                varchar2(4000);

w_servizio_log            varchar2(255) := 'R005';
w_operazione_log          varchar2(255) := 'ansana_tiu';
w_campo_clob_log          varchar2(255);

begin
  w_campo_clob_log := 'idComuneRegistrazione: '||:new.idComuneRegistrazione||' - '||
                      'idTipoContenuto: '||:new.idTipoContenuto||' - '||
                      'idAttoAnsc: '||:new.idAnsc||' - '||
                      'idSoggettoAnsc: '||:new.INT_id;
  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'inizio', w_campo_clob_log);                
  
  w_atto := substr(:new.numeroAtto,1,4);

  if :new.idTipoContenuto in ('1','3') then
     w_id_comune_inp := rtrim(f_ANSC_valore_inp('ID_COMUNE',1,10,'9',''));

     if :new.idComuneRegistrazione != w_id_comune_inp or :new.idComuneRegistrazione = w_id_comune_inp then
        w_note_civ := to_char(sysdate,'dd/mm/yyyy')||': dati acquisiti da ANSC';
        w_note_civ := w_note_civ||' ('||:new.nomeComuneRegistrazione||')';
        
        if :new.INT_cognome||:new.INT_nome is not null then
           w_cognome_nome     := :new.INT_cognome||'/'||:new.INT_nome;
           w_cognome_nome_ric := upper(:new.INT_cognome||'/'||:new.INT_nome);
        end if;
           
        w_data_nas_j := f_ADS_data(:new.INT_dataNascita);

        if :new.INT_idStatoNascita is not null and :new.INT_idStatoNascita != '90' then
           begin
             select codice, 0 
               into w_cod_pro_nas, w_cod_com_nas
               from anpt02
              where id = :new.INT_idStatoNascita
                and rownum = 1
             ;
             ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'sel_anpt02 - ok');                
           exception
             when others then
                  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'sel_anpt02 - KO', sqlerrm);                
                  w_cod_pro_nas := '';
                  w_cod_com_nas := '';
           end;
        
        elsif :new.INT_idComuneNascita is not null then
           begin
             select ltrim(substr(codIstat,1,3),'0'), ltrim(substr(codIstat,4,3),'0')
               into w_cod_pro_nas, w_cod_com_nas
               from anpt03
              where codice = :new.INT_idComuneNascita
                and rownum = 1
             ;
             ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'sel_anpt03 - ok');                
           exception
             when others then
                  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'sel_anpt03 - KO', sqlerrm);                
                  w_cod_pro_nas := '';
                  w_cod_com_nas := '';
           end;
        end if;

        if :new.idTipoEvento = '1' then
            begin
              delete civnas
               where cod_rec = 5
                 and id_soggetto_ansc = :new.INT_id
                 and id_atto_ansc     = :new.idAnsc
              ;
              if sql%found then
                 ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'del_civnas', w_campo_clob_log);                
              end if;
              insert into civnas
                     (cod_rec, anno, atto, ufficio, natura,
                      cognome, nome, sesso, data_nas, cod_fiscale, cod_pro_nas, cod_com_nas,
                      terminalista,
                      id_atto_ansc, id_evento_ansc, id_usecase_ansc, id_soggetto_ansc,
                      cognome_nome, cognome_nome_ric, note)
              values (5, :new.annoAtto, w_atto, w_ufficio, w_natura,
                      :new.INT_cognome, :new.INT_nome, :new.INT_sesso,
                      w_data_nas_j, :new.INT_codiceFiscale, w_cod_pro_nas, w_cod_com_nas,
                      'ANSC',
                      :new.idAnsc, :new.id, :new.idUseCase, :new.INT_id,
                      w_cognome_nome, w_cognome_nome_ric, w_note_civ)
              ;
              if sql%found then
                 ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'ins_civnas', w_campo_clob_log);                
              end if;
            exception
              when others then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'ins_civnas - errore', sqlerrm);                
            end;

         elsif :new.idTipoEvento = '2' then
            begin
              delete civmor
               where cod_rec = 5
                 and id_soggetto_ansc = :new.INT_id
                 and id_atto_ansc     = :new.idAnsc
              ;
              if sql%found then
                 ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'del_civmor', w_campo_clob_log);                
              end if;
              insert into civmor
                     (cod_rec, anno, atto, ufficio, natura,
                      cognome, nome, sesso, data_nas, cod_fiscale, cod_pro_nas, cod_com_nas,
                      terminalista,
                      id_atto_ansc, id_evento_ansc, id_usecase_ansc, id_soggetto_ansc,
                      cognome_nome, cognome_nome_ric, note)
              values (5, :new.annoAtto, w_atto, w_ufficio, w_natura,
                      :new.INT_cognome, :new.INT_nome, :new.INT_sesso,
                      w_data_nas_j, :new.INT_codiceFiscale, w_cod_pro_nas, w_cod_com_nas,
                      'ANSC',
                      :new.idAnsc, :new.id, :new.idUseCase, :new.INT_id,
                      w_cognome_nome, w_cognome_nome_ric, w_note_civ)
              ;
              if sql%found then
                 ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'ins_civmor', w_campo_clob_log);                
              end if;
            exception
              when others then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'ins_civmor - errore', sqlerrm);                
            end;

         elsif :new.idTipoEvento = '3' then
            if :new.INT_sesso = 'M' then
               begin
                 delete civmat
                  where cod_rec = 5
                    and id_soggetto_ansc_m = :new.INT_id
                    and id_atto_ansc       = :new.idAnsc
                 ;
                 if sql%found then
                    ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'del_civmat', w_campo_clob_log);                
                 end if;
                 insert into civmat
                        (cod_rec, anno, atto, ufficio, natura,
                         cognome_m, nome_m, data_nas_m, cod_fiscale_m, cod_pro_nas_m, cod_com_nas_m,
                         terminalista,
                         id_atto_ansc, id_evento_ansc, id_usecase_ansc, id_soggetto_ansc_m,
                         cognome_nome_m, cognome_nome_m_ric, note)
                 values (5, :new.annoAtto, w_atto, w_ufficio, w_natura,
                         :new.INT_cognome, :new.INT_nome, 
                         w_data_nas_j, :new.INT_codiceFiscale, w_cod_pro_nas, w_cod_com_nas,
                         'ANSC',
                         :new.idAnsc, :new.id, :new.idUseCase, :new.INT_id,
                         w_cognome_nome, w_cognome_nome_ric, w_note_civ)
                 ;
                 if sql%found then
                    ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'ins_civmat', w_campo_clob_log);                
                 end if;
               exception
                 when others then
                      ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'ins_civmat - errore', sqlerrm);                
               end;

            elsif :new.INT_sesso = 'F' then
               begin
                 update civmat
                    set cognome_f          = :new.INT_cognome,
                        nome_f             = :new.INT_nome,
                        data_nas_f         = w_data_nas_j,
                        cod_pro_nas_f      = w_cod_pro_nas,
                        cod_com_nas_f      = w_cod_com_nas,
                        cod_fiscale_f      = :new.INT_codiceFiscale,
                        id_soggetto_ansc_f = :new.INT_id,
                        cognome_nome_f     = w_cognome_nome, 
                        cognome_nome_f_ric = w_cognome_nome_ric
                  where cod_rec      = 5
                    and id_atto_ansc = :new.idAnsc
                 ;
                 if sql%found then
                    ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmat', w_campo_clob_log);                
                 end if;
               exception
                 when others then
                      ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civmat - errore', sqlerrm);                
               end;
            end if;

         elsif :new.idTipoEvento = '4' then
            begin
              delete civuci
               where cod_rec = 5
                 and id_soggetto_ansc_m = :new.INT_id
                 and id_atto_ansc       = :new.idAnsc
              ;
              if sql%found then
                 ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'del_civuci', w_campo_clob_log);                
              end if;
              insert into civuci
                     (cod_rec, anno, atto, ufficio, natura,
                      cognome_m, nome_m, sesso_m, data_nas_m, cod_fiscale_m, cod_pro_nas_m, cod_com_nas_m,
                      terminalista,
                      id_atto_ansc, id_evento_ansc, id_usecase_ansc, id_soggetto_ansc_m,
                      cognome_nome_m, cognome_nome_m_ric, note)
              values (5, :new.annoAtto, w_atto, w_ufficio, w_natura,
                      :new.INT_cognome, :new.INT_nome, :new.INT_sesso,
                      w_data_nas_j, :new.INT_codiceFiscale, w_cod_pro_nas, w_cod_com_nas,
                      'ANSC',
                      :new.idAnsc, :new.id, :new.idUseCase, :new.INT_id,
                      w_cognome_nome, w_cognome_nome_ric, w_note_civ)
              ;
              if sql%found then
                 ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'ins_civuci', w_campo_clob_log);                
              end if;
           exception
             when others then
                  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'ins_civuci - errore', sqlerrm);                
           end;
           begin              
              update civuci
                 set cognome_f          = :new.INT_cognome,
                     nome_f             = :new.INT_nome,
                     sesso_f            = :new.INT_sesso,
                     data_nas_f         = w_data_nas_j,
                     cod_pro_nas_f      = w_cod_pro_nas,
                     cod_com_nas_f      = w_cod_com_nas,
                     cod_fiscale_f      = :new.INT_codiceFiscale,
                     id_soggetto_ansc_f = :new.INT_id,
                     cognome_nome_f     = w_cognome_nome, 
                     cognome_nome_f_ric = w_cognome_nome_ric
               where cod_rec      = 5
                 and id_atto_ansc = :new.idAnsc
                 and nvl(id_soggetto_ansc_f,:new.INT_id) = :new.INT_id
                 and id_soggetto_ansc_m != :new.INT_id
              ;
              if sql%found then
                 ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civuci', w_campo_clob_log);                
              end if;
            exception
              when others then
                  ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'upd_civuci - errore', sqlerrm);                
            end;

         elsif :new.idTipoEvento = '5' then
            begin
              delete civcit
               where cod_rec = 5
                 and id_soggetto_ansc = :new.INT_id
                 and id_atto_ansc     = :new.idAnsc
              ;
              if sql%found then
                 ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'del_civcit', w_campo_clob_log);                
              end if;
              insert into civcit
                     (cod_rec, anno, atto, ufficio, natura,
                      cognome, nome, sesso, data_nas, cod_fiscale, cod_pro_nas, cod_com_nas,
                      terminalista,
                      id_atto_ansc, id_evento_ansc, id_usecase_ansc, id_soggetto_ansc,
                      cognome_nome, cognome_nome_ric, note)
              values (5, :new.annoAtto, w_atto, w_ufficio, w_natura,
                      :new.INT_cognome, :new.INT_nome, :new.INT_sesso,
                      w_data_nas_j, :new.INT_codiceFiscale, w_cod_pro_nas, w_cod_com_nas,
                      'ANSC',
                      :new.idAnsc, :new.id, :new.idUseCase, :new.INT_id,
                      w_cognome_nome, w_cognome_nome_ric, w_note_civ)
              ;
              if sql%found then
                 ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'ins_civcit', w_campo_clob_log);                
              end if;
            exception
              when others then
                   ANSC_pkg.ins_log(w_servizio_log, w_operazione_log, 'ins_civcit - errore', sqlerrm);                
            end;
         end if;
     end if; --if :new.idComuneRegistrazione != w_id_comune_inp then
  end if;
end;
/
