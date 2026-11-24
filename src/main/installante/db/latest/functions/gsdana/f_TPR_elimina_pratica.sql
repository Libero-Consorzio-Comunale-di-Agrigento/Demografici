--liquibase formatted sql
--changeset amonopoli:202607011405 runOnChange:true stripComments:false
create or replace function f_TPR_elimina_pratica
(a_anagrafe		IN	varchar2
,a_tipo_evento		IN	varchar
,a_anno_pratica		IN	number
,a_pratica		IN	number
,a_terminalista		IN	varchar2
)

return varchar2

IS

w_anagrafe			varchar2(255) := upper(a_anagrafe);
w_tipo_evento			varchar2(255) := upper(a_tipo_evento);

cursor sel_apm is
select apm.matricola
  from anaana ana, anaapm apm, anaap4 ap4
 where ana.matricola    = apm.matricola
   and ana.fascia       in (5,6)
   and apm.id_anaap4    = ap4.id
   and ap4.anno_pratica = a_anno_pratica
   and ap4.pratica      = a_pratica
 order by 1
;

w_flag_perfezionamento		varchar2(255);
w_flag_annullamento		varchar2(255);
w_flag_perfezionamento_p	varchar2(255);

w_ctr_anacom			number;
w_ctr_anamov			number;
w_ctr_anaeve			number;
w_ctr_anadoc			number;

w_fase_log			varchar2(255) := 'ZK';
w_parametri_log			varchar2(2000);
w_note_log			varchar2(2000);
w_terminalista_log		varchar2(255) := a_terminalista;
w_operazione_log		varchar2(255);
w_return_log			number;

w_errore			varchar2(32000);
errore				exception;

w_return			varchar2(32000);

begin
  w_return := '';

  w_operazione_log := 'Eliminazione Pratica (zk)';
  w_parametri_log  := 'anagrafe: '||a_anagrafe||' - '||
                      'tipo_evento: '||a_tipo_evento||' - '||
                      'anno_pratica: '||a_anno_pratica||' - '||
                      'pratica: '||a_pratica;

  if a_anagrafe       is not null and
     a_tipo_evento    is not null and
     a_anno_pratica   is not null and
     a_pratica        is not null
  then
     w_return_log     := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);
     begin
       select v.flag_perfezionamento, v.flag_annullamento, v.flag_perfezionamento_p
         into w_flag_perfezionamento, w_flag_annullamento, w_flag_perfezionamento_p
         from anatpr_v_zk v
        where anagrafe       = w_anagrafe
          and tipo_evento    = w_tipo_evento
          and anno_pratica   = a_anno_pratica
          and pratica        = a_pratica
       ;
     exception
       when no_data_found then
            w_errore := 'Impossibile procedere con l''eliminazione: pratica non trovata';
            raise errore;
       when too_many_rows then
            w_errore := 'Impossibile procedere con l''eliminazione: esistono piu'' pratiche con lo stesso numero';
            raise errore;
       when others then
            w_errore := 'Impossibile procedere con l''eliminazione: errore generico in ricerca pratica';
            raise errore;
     end;

<< test_errore_1 >>
null;

     w_errore := '';
     if w_errore is null then
        if w_flag_perfezionamento_p is not null then
           w_errore := 'Eliminazione non consentita: la pratica risulta in fase di perfezionamento preliminare';
           raise errore;
        elsif w_flag_perfezionamento is not null then
           w_errore := 'Eliminazione non consentita: la pratica risulta perfezionata';
           raise errore;
        elsif w_flag_annullamento is not null then
           w_errore := 'Eliminazione non consentita: la pratica risulta annullata';
           raise errore;
        end if;
     end if;

<< test_errore_1 >>
null;

     w_ctr_anacom := 0;
     if w_errore is null then
        begin
          select 1
            into w_ctr_anacom
            from anacom_v v
           where anagrafe       = w_anagrafe
             and tipo_evento    = w_tipo_evento
             and anno_pratica   = a_anno_pratica
             and pratica        = a_pratica
             and (nvl(flag_protocollo,' ') = 'P' or nvl(flag_albo_pretorio,' ') = 'I')
             and rownum = 1
          ;
          w_errore := 'Eliminazione non consentita: esistono comunicazioni / adempimenti protocollati';
        exception
          when no_data_found then
               w_ctr_anacom := 0;
          when others then
               w_errore := 'Impossibile procedere con l''eliminazione: errore in ricerca comunicazioni protocollate';
        end;

        if w_errore is not null then
           raise errore;
        end if;

        if w_ctr_anacom = 0 then
           if w_anagrafe = 'RES' and w_tipo_evento = 'I' then
              for rec_apm in sel_apm loop
                  begin
                    select count(*)
                      into w_ctr_anamov
                      from anamov
                     where matricola = rec_apm.matricola
                       and cod_mov   != 5
                    ;
                    select count(*)
                      into w_ctr_anaeve
                      from anaeve
                     where matricola = rec_apm.matricola
                    ;
                    select count(*)
                      into w_ctr_anadoc
                      from anadoc
                     where matricola = rec_apm.matricola
                       and (cod_pro_ente, cod_com_ente) in (select pro_cliente, com_cliente from menuditta)
                    ;
                  exception
                    when others then
                         w_ctr_anamov := -1;
                         w_ctr_anaeve := -1;
                         w_ctr_anadoc := -1;
                  end;

--                  w_operazione_log := 'w_ctr_anamov: '||w_ctr_anamov||' - w_ctr_anaeve: '||w_ctr_anaeve||' - w_ctr_anadoc: '||w_ctr_anadoc;
--                  w_return_log     := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);
                  if rtrim(w_ctr_anamov||w_ctr_anaeve||w_ctr_anadoc,0) is null then
                     begin
                       delete anamov
                        where matricola = rec_apm.matricola
                          and cod_mov   = 5
                       ;
                       if sql%found then
                          w_operazione_log := '[eliminato] movimenti (matr. '||rec_apm.matricola||')';
                       elsif sql%notFound then
                          w_operazione_log := '[NON trovato] movimenti (matr. '||rec_apm.matricola||')';
                       end if;
                       w_return_log     := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);
                     exception
                       when others then
                            w_errore := '[errore] movimenti (matr. '||rec_apm.matricola||')';
                            raise errore;
                     end;

                     begin
                       delete anadoc
                        where matricola = rec_apm.matricola
                       ;
                       if sql%found then
                          w_operazione_log := '[eliminato] documenti (matr. '||rec_apm.matricola||')';
                       elsif sql%notFound then
                          w_operazione_log := '[NON trovato] documenti (matr. '||rec_apm.matricola||')';
                       end if;
                       w_return_log     := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);
                     exception
                       when others then
                            w_errore := '[errore] documenti (matr. '||rec_apm.matricola||')';
                            raise errore;
                     end;

                     begin
                       delete anaari
                        where matricola = rec_apm.matricola
                       ;
                       if sql%found then
                          w_operazione_log := '[eliminato] recapiti (matr. '||rec_apm.matricola||')';
                       elsif sql%notFound then
                          w_operazione_log := '[NON trovato] recapiti (matr. '||rec_apm.matricola||')';
                       end if;
                       w_return_log     := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);
                     exception
                       when others then
                            w_errore := '[errore] recapiti (matr. '||rec_apm.matricola||')';
                            raise errore;
                     end;

                     begin
                       delete anaauc
                        where matricola = rec_apm.matricola
                       ;
                       if sql%found then
                          w_operazione_log := '[eliminato] urne cinerarie (matr. '||rec_apm.matricola||')';
                       elsif sql%notFound then
                          w_operazione_log := '[NON trovato] urne cinerarie (matr. '||rec_apm.matricola||')';
                       end if;
                       w_return_log     := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);
                     exception
                       when others then
                            w_errore := '[errore] urne cinerarie (matr. '||rec_apm.matricola||')';
                            raise errore;
                     end;

                     begin
                       delete anaana
                        where matricola = rec_apm.matricola
                          and fascia    in (5,6)
                       ;
                       if sql%found then
                          w_operazione_log := '[eliminato] individui (matr. '||rec_apm.matricola||')';
                       elsif sql%notFound then
                          w_operazione_log := '[NON trovato] individui (matr. '||rec_apm.matricola||')';
                       end if;
                       w_return_log     := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);
                     exception
                       when others then
                            w_errore := '[errore] individui (matr. '||rec_apm.matricola||')';
                            raise errore;
                     end;

                     begin
                       delete anpads
                        where matricola_ads = rec_apm.matricola
                       ;
                       if sql%found then
                          w_operazione_log := '[eliminato] relazione anpr / ads (matr. '||rec_apm.matricola||')';
                       elsif sql%notFound then
                          w_operazione_log := '[NON trovato] relazione anpr / ads (matr. '||rec_apm.matricola||')';
                       end if;
                       w_return_log     := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);
                     exception
                       when others then
                            w_errore := '[errore] relazione anpr / ads (matr. '||rec_apm.matricola||')';
                            raise errore;
                     end;

                  else
                     w_operazione_log := '[NON eliminato] individui (matr. '||rec_apm.matricola||') - esistono movimenti / eventi / documenti';
                     w_return_log     := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);

                  end if; -- if rtrim(w_ctr_anamov||w_ctr_anaeve||w_ctr_anadoc,0) is null then
              end loop;

              begin
                delete anaapm
                 where id_anaap4 in (select id from anaap4
                                      where anno_pratica = a_anno_pratica
                                        and pratica      = a_pratica)
                ;
                if sql%found then
                   w_operazione_log := '[eliminato] soggetti modello apr/4';
                elsif sql%notFound then
                   w_operazione_log := '[NON trovato] soggetti modello apr/4';
                end if;
                w_return_log     := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);
              exception
                when others then
                     w_errore := '[errore] soggetti modello apr/4';
                     raise errore;
              end;

              begin
                delete anaap4
                 where anno_pratica = a_anno_pratica
                   and pratica      = a_pratica
                ;
                if sql%found then
                   w_operazione_log := '[eliminato] modello apr/4';
                elsif sql%notFound then
                   w_operazione_log := '[NON trovato] modello apr/4';
                end if;
                w_return_log     := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);
              exception
                when others then
                     w_errore := '[errore] modello apr/4';
                     raise errore;
              end;

              begin
                delete anac01
                 where anno_pratica = a_anno_pratica
                   and pratica      = a_pratica
                ;
                if sql%found then
                   w_operazione_log := '[eliminato] soggetti modello aire/01';
                elsif sql%notFound then
                   w_operazione_log := '[NON trovato] soggetti modello aire/01';
                end if;
                w_return_log     := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);
              exception
                when others then
                     w_errore := '[errore] soggetti modello aire/01';
                     raise errore;
              end;

           elsif w_anagrafe = 'RES' and w_tipo_evento = 'E' then
              w_errore := 'Tipo di pratica non gestito';
              raise errore;

           elsif w_anagrafe = 'RES' and w_tipo_evento = 'C' then
              w_errore := 'Tipo di pratica non gestito';
              raise errore;

           elsif w_anagrafe = 'RES' and w_tipo_evento = 'R' then
              w_errore := 'Tipo di pratica non gestito';
              raise errore;

           elsif w_anagrafe = 'AIR' and w_tipo_evento = 'I' then
              w_errore := 'Tipo di pratica non gestito';
              raise errore;

           elsif w_anagrafe = 'AIR' and w_tipo_evento = 'E' then
              w_errore := 'Tipo di pratica non gestito';
              raise errore;

           elsif w_anagrafe = 'AIR' and w_tipo_evento = 'C' then
              w_errore := 'Tipo di pratica non gestito';
              raise errore;

           elsif w_anagrafe = 'AIR' and w_tipo_evento = 'R' then
              w_errore := 'Tipo di pratica non gestito';
              raise errore;

           end if;

           begin
             delete anadoi
              where anagrafe     = w_anagrafe
                and tipo_evento  = w_tipo_evento
                and anno_pratica = a_anno_pratica
                and pratica      = a_pratica
             ;
             if sql%found then
                w_operazione_log := '[eliminato] dati occupazione immobile';
             elsif sql%notFound then
                w_operazione_log := '[NON trovato] dati occupazione immobile';
             end if;
             w_return_log     := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);
           exception
             when others then
                  w_errore := '[errore] dati occupazione immobile';
                  raise errore;
           end;

           begin
             delete anacom
              where anagrafe     = w_anagrafe
                and tipo_evento  = w_tipo_evento
                and anno_pratica = a_anno_pratica
                and pratica      = a_pratica
             ;
             if sql%found then
                w_operazione_log := '[eliminato] comunicazioni / adempimenti';
             elsif sql%notFound then
                w_operazione_log := '[NON trovato] comunicazioni / adempimenti';
             end if;
             w_return_log     := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);
           exception
             when others then
                  w_errore := '[errore] comunicazioni / adempimenti';
                  raise errore;
           end;

           begin
             delete anasap
              where anagrafe     = w_anagrafe
                and tipo_evento  = w_tipo_evento
                and anno_pratica = a_anno_pratica
                and pratica      = a_pratica
             ;
             if sql%found then
                w_operazione_log := '[eliminato] stato avanzamento pratica';
             elsif sql%notFound then
                w_operazione_log := '[NON trovato] stato avanzamento pratica';
             end if;
             w_return_log     := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);
           exception
             when others then
                  w_errore := '[errore] stato avanzamento pratica';
                  raise errore;
           end;

           begin
             delete anatpr
              where anagrafe     = w_anagrafe
                and tipo_evento  = w_tipo_evento
                and anno_pratica = a_anno_pratica
                and pratica      = a_pratica
             ;
             if sql%found then
                w_operazione_log := '[eliminato] testata pratica';
             elsif sql%notFound then
                w_operazione_log := '[NON trovato] testata pratica';
             end if;
             w_return_log     := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_note_log, w_terminalista_log, w_operazione_log);
           exception
             when others then
                  w_errore := '[errore] testata pratica';
                  raise errore;
           end;

        end if; -- if w_ctr_anacom = 0 then
     end if; -- if w_errore is null then
  end if; -- if a_anagrafe       is not null and

  if w_return is null then
     commit;
  end if;

  return w_return;
exception
  when errore then
       rollback;
       w_return_log     := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_errore, w_terminalista_log, w_operazione_log);
       w_errore         := 'Eliminazione non eseguita per errore: '||w_errore;
       return w_errore;
  when others then
       rollback;
       w_errore         := 'Errore generico in eliminazione pratica';
       w_return_log     := f_GSD_inserisci_log(w_fase_log, w_parametri_log, w_errore, w_terminalista_log, w_operazione_log);
       return w_errore;
end;
/
