--liquibase formatted sql
--changeset amonopoli:202606171635 runOnChange:true stripComments:false
create or replace trigger ANAMOV_ANPR_TIU
before INSERT
    or UPDATE
on ANAMOV
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;

w_id_operazione                 number;

w_servizio		        varchar2(255);
w_tipo_operazione	        varchar2(255);
w_data_pratica		        number;
w_data_decorrenza	        number;
w_data_definizione	        number;

w_archivio_rif                  varchar2(255) := 'MOV';

w_flag_no_ws                    varchar2(255);

w_fascia_fam		        number;

w_flag_90          	        varchar2(255);

w_flag_comune_subentrato 	varchar2(255);
w_flag_preliminare       	varchar2(255);

w_flag_ripristino		varchar2(255);
w_servizio_rif                  varchar2(255);
w_id_operazione_rif             number;
w_id_operazione_anpr_rif        number;

w_iscr_variata                  number;
w_rp_variato                    number;

w_rapporto_par_anpr		varchar2(255);

w_anagrafe_mov                  varchar2(255);
w_tipo_evento_mov               varchar2(255);
w_id_operazione_mov             number;

w_operazione_log                varchar2(255) := 'anamov_anpr_tiu';
w_errore                        varchar2(4000);

w_integrazione_anpr	varchar2(255) := f_valore_inp('ANPR',1,1,'X','S');

w_esiste_ciu			number;

begin
--
-- 20/09/2019 (AM) inizializzazione w_id_operazione prima della ANPCIU_NR (rif. ORA-00001)
-- 20/09/2019 (AM) 12-92 corretto "from anpciu_v" (rif. ORA-04091: table GSD.ANAMOV is mutating)
--

 if nvl(w_integrazione_anpr,'N') = 'S' then
--w_errore := 'anno_progr '||:new.anno_progr||' - numero_progr '||:new.numero_progr||' - cod_mov '||:new.cod_mov||' - cod_eve '||:new.cod_eve||' - matricola '||:new.matricola;
--ANPR_PKG.ins_log('',w_operazione_log,w_errore);
   if UPDATING then
      null;
--ANPR_pkg.ins_log('',w_operazione_log,'updating - anno_progr '||:new.anno_progr||' - numero_progr '||:new.numero_progr||' - cod_mov '||:new.cod_mov||' - cod_eve '||:new.cod_eve);
   end if;

   if INSERTING then
      if :new.terminalista = 'ANPR' then
         goto fine;
      end if;

      begin 
        ANAMOV_NR(:new.anno_progr, :new.numero_progr);
      end;
--ANPR_pkg.ins_log('',w_operazione_log,'inserting - anno_progr '||:new.anno_progr||' - numero_progr '||:new.numero_progr||' - cod_mov '||:new.cod_mov||' - cod_eve '||:new.cod_eve);

      w_flag_no_ws := '';
      if :new.cod_mov = 1 then
         if :new.cod_mov = 1 and :new.cod_eve = 18 then
            begin
              select 'S'
                into w_flag_no_ws
                from anpn10
               where anagrafe_ads     = 'RES'
                 and tipo_evento_ads  = 'C'
                 and anno_pratica_ads = :new.anno_pratica
                 and pratica_ads      = :new.pratica
                 and rownum = 1
              ;
            exception
              when others then
                   w_flag_no_ws := '';
            end;
         else
            w_flag_comune_subentrato := f_ANPR_comune_subentrato(:new.cod_pro_eve,:new.cod_com_eve);
            w_flag_preliminare       := f_flag_preliminare('RES','I',:new.anno_pratica,:new.pratica);

            if :new.cod_eve != 17 and w_flag_preliminare is not null then
               begin
                 select decode(:new.cod_pro_eve||:new.cod_com_eve,'',1,
                          decode(:new.cod_eve||nvl(lpad(:new.cod_pro_eve,3,'0')||lpad(:new.cod_com_eve,3,'0'),'0'),
                            '2'||nvl(lpad(mov.cod_pro_eve,3,'0')||lpad(mov.cod_com_eve,3,'0'),'0'),0,1)),
                        decode(:new.rapporto_par,mov.rapporto_par,0,1)
                   into w_iscr_variata, w_rp_variato
                   from anamov mov
                  where mov.pratica      = :new.pratica
                    and mov.anno_pratica = :new.anno_pratica
                    and mov.cod_mov      = 1
                    and mov.cod_eve      = 17
                    and mov.matricola    = :new.matricola
                 ;
               exception
                 when others then
                      w_iscr_variata := 0;
                      w_rp_variato   := 0;
               end;
               if w_iscr_variata = 1 then
                  begin
                    insert into anpciu
                           (SERVIZIO, TIPO_OPERAZIONE, ARCHIVIO_RIF,
                            MATRICOLA, ANNO_RIF, NUMERO_RIF, DATA_REG, TERMINALISTA)
                    select 5014, 'V', 'SUB_I',
                           :new.matricola, :new.anno_progr, :new.numero_progr,
                           to_char(sysdate,'j'), si4.utente
                      from anpads
                     where matricola_ads = :new.matricola
                       and rownum        = 1
                    ;
                  exception
                    when others then
                         null;
                  end;
               end if;
               if w_rp_variato = 1 then
                  begin
                    insert into anpciu
                           (SERVIZIO, TIPO_OPERAZIONE, ARCHIVIO_RIF,
                            MATRICOLA, ANNO_RIF, NUMERO_RIF, DATA_REG, TERMINALISTA)
                    select 5001, 'C', 'MOV_RP',
                           :new.matricola, :new.anno_progr, :new.numero_progr,
                           to_char(sysdate,'j'), si4.utente
                      from anpads
                     where matricola_ads = :new.matricola
                       and rownum        = 1
                    ;
                  exception
                    when others then
                         null;
                  end;
               end if;
            end if;
         end if;
      elsif :new.cod_mov = 2 and :new.cod_eve not in (50,62) then
         begin
           select 'S'
             into w_flag_no_ws
             from anpn10
            where anagrafe_ads     = 'RES'
              and tipo_evento_ads  = 'C'
              and anno_pratica_ads = :new.anno_pratica
              and pratica_ads      = :new.pratica
              and rownum = 1
           ;
         exception
           when others then
                w_flag_no_ws := '';
         end;
      end if;

      if w_flag_no_ws is not null then
         goto fine;
      end if;

      if :new.cod_mov = 1 and :new.cod_eve = 18 then
         w_anagrafe_mov      := f_ANPR_anagrafe_ciu(:new.cod_mov,:new.cod_eve);
         w_tipo_evento_mov   := f_ANPR_tipo_evento_ciu(:new.cod_mov,:new.cod_eve,'S');
         w_id_operazione_mov := f_ANPR_id_operazione_rif(w_anagrafe_mov,w_tipo_evento_mov,:new.anno_pratica,:new.pratica);
         begin
           select max(ciu.id_operazione) 
             into w_id_operazione_rif
             from anpciu_rif rif
                , anpciu ciu
            where rif.id_operazione      = ciu.id_operazione
              and rif.id_operazione_rif  = w_id_operazione_mov
              and ciu.id_operazione_anpr is not null
              and ciu.servizio           in ('2003')
              and ciu.matricola          = :new.matricola
           ;
           if w_id_operazione_rif is not null then
              begin
                select ciu.servizio, ciu.id_operazione_anpr
                  into w_servizio_rif, w_id_operazione_anpr_rif
                  from anpciu ciu
                 where id_operazione = w_id_operazione_rif
                ;
              exception
                when others then
                     w_servizio_rif           := '';
                     w_id_operazione_anpr_rif := '';
              end;
              w_flag_comune_subentrato := f_ANPR_comune_subentrato(:new.cod_pro_eve,:new.cod_com_eve);
              if w_flag_comune_subentrato = 'S' then
                 w_flag_ripristino        := ''; 
                 w_servizio               := f_ANPR_codice_servizio(:new.cod_mov,:new.cod_eve,:new.cod_variazione,'','',:new.nucleo_arrivo,:new.nucleo_partenza);
                 w_id_operazione_rif      := '';
                 w_id_operazione_anpr_rif := '';
              else 
                 w_flag_ripristino        := 'S';
                 w_servizio               := f_ANPR_codice_servizio_ann(w_servizio_rif);
              end if;

           else
              ANPR_PKG.ins_log('',w_operazione_log,'flag_ripristino = null - errore: '||sqlerrm);
              w_flag_ripristino        := '';
              w_servizio               := f_ANPR_codice_servizio(:new.cod_mov,:new.cod_eve,:new.cod_variazione,w_flag_preliminare,w_flag_comune_subentrato,:new.nucleo_arrivo,:new.nucleo_partenza);
              w_id_operazione_rif      := '';
              w_id_operazione_anpr_rif := '';
           end if;
         end;

      elsif :new.cod_mov = 2 and :new.cod_eve = 62 then
         w_anagrafe_mov      := f_ANPR_anagrafe_ciu(:new.cod_mov,:new.cod_eve);
         w_tipo_evento_mov   := f_ANPR_tipo_evento_ciu(:new.cod_mov,:new.cod_eve,'S');
         w_id_operazione_mov := f_ANPR_id_operazione_rif(w_anagrafe_mov,w_tipo_evento_mov,:new.anno_pratica,:new.pratica);
         begin
           select max(ciu.id_operazione) 
             into w_id_operazione_rif
             from anpciu_rif rif
                , anpciu ciu
            where rif.id_operazione      = ciu.id_operazione
              and rif.id_operazione_rif  = w_id_operazione_mov
              and ciu.id_operazione_anpr is not null
              and ciu.servizio           in ('1002','5001','5005')
              and ciu.matricola          = :new.matricola
           ;
           if w_id_operazione_rif is not null then
              begin
                select ciu.servizio, ciu.id_operazione_anpr
                  into w_servizio_rif, w_id_operazione_anpr_rif
                  from anpciu ciu
                 where id_operazione = w_id_operazione_rif
                ;
              exception
                when others then
                     w_servizio_rif           := '';
                     w_id_operazione_anpr_rif := '';
              end;
              if nvl(substr(w_servizio_rif,1,1),' ') = '5' then
                 w_flag_ripristino := 'S';
                 w_servizio        := f_ANPR_codice_servizio_ann(w_servizio_rif);
              else
                 w_flag_ripristino        := '';
                 w_servizio               := f_ANPR_codice_servizio(:new.cod_mov,:new.cod_eve,:new.cod_variazione,w_flag_preliminare,w_flag_comune_subentrato);
                 w_id_operazione_rif      := '';
                 w_id_operazione_anpr_rif := '';
              end if;
           else
              ANPR_PKG.ins_log('',w_operazione_log,'flag_ripristino = null - errore: '||sqlerrm);
              w_flag_ripristino        := '';
              w_servizio               := f_ANPR_codice_servizio(:new.cod_mov,:new.cod_eve,:new.cod_variazione,w_flag_preliminare,w_flag_comune_subentrato);
              w_id_operazione_rif      := '';
              w_id_operazione_anpr_rif := '';
           end if;
         end;

      elsif :new.cod_mov in (10,11) and :new.cod_variazione = 'X' then
         w_anagrafe_mov      := f_ANPR_anagrafe_ciu(:new.cod_mov,:new.cod_eve);
         w_tipo_evento_mov   := f_ANPR_tipo_evento_ciu(:new.cod_mov,:new.cod_eve,'S');
         w_id_operazione_mov := f_ANPR_id_operazione_rif(w_anagrafe_mov,w_tipo_evento_mov,:new.anno_pratica,:new.pratica);
         begin
           select max(ciu.id_operazione) 
             into w_id_operazione_rif
             from anpciu_rif rif
                , anpciu ciu
            where rif.id_operazione      = ciu.id_operazione
              and rif.id_operazione_rif  = w_id_operazione_mov
              and ciu.id_operazione_anpr is not null
              and ciu.servizio           in ('5001','5005')
              and ciu.matricola          = :new.matricola
           ;
           if w_id_operazione_rif is not null then
              begin
                select ciu.servizio, ciu.id_operazione_anpr
                  into w_servizio_rif, w_id_operazione_anpr_rif
                  from anpciu ciu
                 where id_operazione = w_id_operazione_rif
                ;
              exception
                when others then
                     w_servizio_rif           := '';
                     w_id_operazione_anpr_rif := '';
              end;
              if nvl(substr(w_servizio_rif,1,1),' ') = '5' then
                 ANPR_PKG.ins_log('',w_operazione_log,'flag_ripristino = S - servizio_rif: '||w_servizio_rif);
                 w_flag_ripristino := 'S';
                 w_servizio        := f_ANPR_codice_servizio_ann(w_servizio_rif);
              else
                 ANPR_PKG.ins_log('',w_operazione_log,'flag_ripristino = null - servizio_rif: '||w_servizio_rif);
                 w_flag_ripristino        := '';
                 w_servizio               := f_ANPR_codice_servizio(:new.cod_mov,:new.cod_eve,:new.cod_variazione,w_flag_preliminare,w_flag_comune_subentrato,:new.nucleo_arrivo,:new.nucleo_partenza);
                 w_id_operazione_rif      := '';
                 w_id_operazione_anpr_rif := '';
              end if;
           else
              ANPR_PKG.ins_log('',w_operazione_log,'flag_ripristino = null - errore: '||sqlerrm);
              w_flag_ripristino        := '';
              w_servizio               := f_ANPR_codice_servizio(:new.cod_mov,:new.cod_eve,:new.cod_variazione,w_flag_preliminare,w_flag_comune_subentrato,:new.nucleo_arrivo,:new.nucleo_partenza);
              w_id_operazione_rif      := '';
              w_id_operazione_anpr_rif := '';
           end if;
         end;

      else
         w_servizio               := f_ANPR_codice_servizio(:new.cod_mov,:new.cod_eve,:new.cod_variazione,w_flag_preliminare,w_flag_comune_subentrato,:new.nucleo_arrivo,:new.nucleo_partenza,:new.matricola,:new.anno_pratica,:new.pratica);
         w_flag_ripristino        := '';
         w_id_operazione_rif      := '';
         w_id_operazione_anpr_rif := '';
      end if;
      w_tipo_operazione := f_ANPR_tipo_operazione(:new.cod_mov,:new.cod_eve,:new.cod_variazione);

      if :new.cod_mov in (1,2,3,4) then
<< iscrizione_cancellazione >>
         anpciu_PROC_upd(w_servizio,:new.matricola,:new.anno_progr,:new.numero_progr,:new.cod_mov,:new.cod_eve,:new.pratica,:new.anno_pratica);

         w_id_operazione := '';
         ANPCIU_NR(w_id_operazione,w_servizio);

         w_esiste_ciu := 0;
         if w_servizio = '5001' then
            begin
              select 1 into w_esiste_ciu
                from anamov mov, anpciu ciu
               where mov.cod_mov      = :new.cod_mov
                 and mov.pratica      = :new.pratica
                 and mov.anno_pratica = :new.anno_pratica
                 and mov.anno_progr   = ciu.anno_rif
                 and mov.numero_progr = ciu.numero_rif
                 and ciu.servizio     = '5001'
                 and rownum           = 1
              ;
            exception 
              when others then
                   w_esiste_ciu := 0;
            end;
         end if;

         if w_esiste_ciu = 0 then
            begin
              insert into anpciu
                     (ID_OPERAZIONE, SERVIZIO, TIPO_OPERAZIONE, ARCHIVIO_RIF,
                      MATRICOLA, ANNO_RIF, NUMERO_RIF,
                      TERMINALISTA, DATA_REG)
              values (w_id_operazione, w_servizio, w_tipo_operazione, w_archivio_rif,
                      :new.matricola, :new.anno_progr, :new.numero_progr,
                      :new.terminalista, :new.data_reg)
              ;
            exception
              when others then
--                   raise_application_error(-20999,'Errore in inserimento ANPCIU - '||w_servizio||' ('||SQLERRM||')');
                   w_errore := w_servizio||' - cod_mov '||:new.cod_mov||' - cod_eve '||:new.cod_eve||' - matricola '||:new.matricola||' ('||SQLERRM||')';
                   ANPR_pkg.ins_log('',w_operazione_log,w_errore);
            end;
         end if;

         if w_servizio = '5001' and :new.cod_mov = 1 then
            begin
              select f_ADS_rapporto_par(rapporto_par_anpr,:new.sesso)
                into w_rapporto_par_anpr
                from anpads
               where matricola_ads = :new.matricola
                 and tipo_scheda_anpr = 'Famiglia ANPR'
                 and rownum = 1
              ;
            exception
              when others then
                   w_rapporto_par_anpr := '';
            end;
            if nvl(w_rapporto_par_anpr,:new.rapporto_par) != :new.rapporto_par then
               begin
                 insert into anpciu
                        (SERVIZIO, TIPO_OPERAZIONE, ARCHIVIO_RIF,
                         MATRICOLA, ANNO_RIF, NUMERO_RIF, DATA_REG, TERMINALISTA)
                 select 5001, 'C', 'MOV_RP',
                        :new.matricola, :new.anno_progr, :new.numero_progr,
                        to_char(sysdate,'j'), si4.utente
                   from anpads
                  where matricola_ads = :new.matricola
                    and rownum        = 1
                 ;
               exception
                 when others then
                      null;
               end;
            end if;
         end if;

      elsif ((:new.cod_mov in (10) and :new.cod_eve in (92)) 
             or (:new.cod_mov in (11,13) and :new.cod_eve in (91)) 
             or (:new.cod_mov in (97,98) and :new.cod_eve in (98)))
            and
            (:new.nucleo_arrivo is null
             or (:new.nucleo_arrivo = 1 and :new.rapporto_par = 'CF'))
      then
<< cambio_abitazione >>
         if :new.cod_mov in (10,11,97) then
            w_fascia_fam := 1;
         elsif :new.cod_mov in (12,13,98) then
            w_fascia_fam := 3;
         end if;

         anpciu_PROC_upd(w_servizio,:new.matricola,:new.anno_progr,:new.numero_progr,:new.cod_mov,:new.cod_eve,:new.pratica,:new.anno_pratica);

         w_anagrafe_mov      := f_ANPR_anagrafe_ciu(:new.cod_mov,:new.cod_eve);
         w_tipo_evento_mov   := f_ANPR_tipo_evento_ciu(:new.cod_mov,:new.cod_eve,'S');
         w_id_operazione_mov := f_ANPR_id_operazione_rif(w_anagrafe_mov,w_tipo_evento_mov,:new.anno_pratica,:new.pratica);

         if :new.cod_mov = 97 and :new.cod_eve = 98 then
            if :new.rapporto_par = 'CF' then
               w_archivio_rif := 'VIE_9';
            else
               goto no_insert_cambio_abitazione;
            end if;
         end if;

         w_id_operazione := '';
         ANPCIU_NR(w_id_operazione,w_servizio);
         begin
           insert into anpciu
                  (ID_OPERAZIONE, SERVIZIO, TIPO_OPERAZIONE, ARCHIVIO_RIF,
                   MATRICOLA, FASCIA_FAM, COD_FAM, ANNO_RIF, NUMERO_RIF,
                   TERMINALISTA, DATA_REG)
           select w_id_operazione, w_servizio, w_tipo_operazione, w_archivio_rif,
                   :new.matricola, w_fascia_fam, :new.cod_fam, :new.anno_progr, :new.numero_progr,
                   :new.terminalista, :new.data_reg
             from dual
            where not exists (select 'x' from anpciu_rif r, anpciu b
                               where r.id_operazione_rif       = w_id_operazione_mov
                                 and r.id_operazione_anpr_rif  = b.matricola
                                 and r.servizio_rif            = b.servizio
                                 and r.id_operazione           = b.id_operazione
                                 and b.servizio                = w_servizio
                                 and b.fascia_fam              = w_fascia_fam
                                 and b.cod_fam                 = :new.cod_fam
                                 and b.data_reg                = :new.data_reg)
           ;
         exception
           when others then
--                raise_application_error(-20999,'Errore in inserimento ANPCIU - '||w_servizio||' ('||SQLERRM||')');
                w_errore := w_servizio||' - cod_mov '||:new.cod_mov||' - cod_eve '||:new.cod_eve||' - matricola '||:new.matricola||' ('||SQLERRM||')';
                ANPR_pkg.ins_log('',w_operazione_log,w_errore);
         end;
<< no_insert_cambio_abitazione >>
null;

      elsif :new.cod_mov in (12) and :new.cod_eve in (92) then
<< cambio_abitazione_aire >>
         w_fascia_fam := 3;

         anpciu_PROC_upd(w_servizio,:new.matricola,:new.anno_progr,:new.numero_progr,:new.cod_mov,:new.cod_eve,:new.pratica,:new.anno_pratica);

         w_id_operazione := '';
         ANPCIU_NR(w_id_operazione,w_servizio);
         begin
           insert into anpciu
                  (ID_OPERAZIONE, SERVIZIO, TIPO_OPERAZIONE, ARCHIVIO_RIF,
                   MATRICOLA, FASCIA_FAM, COD_FAM, ANNO_RIF, NUMERO_RIF,
                   TERMINALISTA, DATA_REG)
           select w_id_operazione, w_servizio, w_tipo_operazione, w_archivio_rif,
                   :new.matricola, w_fascia_fam, :new.cod_fam, :new.anno_progr, :new.numero_progr,
                   :new.terminalista, :new.data_reg
             from dual
            where not exists (select 'x' from anpciu b
                               where b.servizio   = w_servizio
                                 and b.fascia_fam = w_fascia_fam
                                 and b.cod_fam    = :new.cod_fam
                                 and b.matricola  = :new.matricola
                                 and b.data_reg   = :new.data_reg)
           ;
         exception
           when others then
--                raise_application_error(-20999,'Errore in inserimento ANPCIU - '||w_servizio||' ('||SQLERRM||')');
                w_errore := w_servizio||' - cod_mov '||:new.cod_mov||' - cod_eve '||:new.cod_eve||' - matricola '||:new.matricola||' ('||SQLERRM||')';
                ANPR_pkg.ins_log('',w_operazione_log,w_errore);         end;

      elsif :new.cod_mov in (10,12) and :new.cod_eve = 90 then
<< cambio_rapporto_par >>
         if :new.rapporto_par = 'CF' then
            begin
              select 'S'
                into w_flag_90
                from anacre cre, anatpr tpr
               where nvl(cre.data_decorrenza,tpr.data_pratica) = :new.data_eve
                 and cre.cod_fam_prov = :new.cod_fam
                 and cre.anno_pratica = tpr.anno_pratica
                 and cre.pratica      = tpr.pratica
                 and tpr.anagrafe     = 'RES'
                 and tpr.tipo_evento  = 'E'
                 and tpr.pratica      = :new.pratica
                 and tpr.anno_pratica = :new.anno_pratica
                 and rownum = 1
              UNION
              select 'S'
                from anacaa caa, anatpr tpr
               where caa.cod_fam_prov         = :new.cod_fam
                 and caa.anno_protocollo_aire = tpr.anno_pratica
                 and caa.protocollo_aire      = tpr.pratica
                 and tpr.anagrafe             = 'AIR'
                 and tpr.tipo_evento          = 'E'
                 and tpr.data_pratica         = :new.data_eve
                 and tpr.pratica              = :new.pratica
                 and tpr.anno_pratica         = :new.anno_pratica
                 and rownum = 1
              UNION
              select 'S'
                from anaa01 a01, anatpr tpr
               where nvl(a01.data_decorrenza,a01.data_pratica) = :new.data_eve
                 and a01.anno_pratica   = tpr.anno_pratica
                 and a01.pratica        = tpr.pratica
                 and tpr.anagrafe       = 'RES'
                 and tpr.tipo_evento    = 'C'
                 and tpr.cod_variazione = 'A'
                 and tpr.cod_fam_dic    = :new.cod_fam
                 and tpr.pratica        = :new.pratica
                 and tpr.anno_pratica   = :new.anno_pratica
                 and rownum = 1
              UNION
              select 'S'
                from anpn10 n10, anacp4 cp4, anatpr tpr
               where n10.anagrafe_ads     = tpr.anagrafe
                 and n10.tipo_evento_ads  = tpr.tipo_evento
                 and n10.anno_pratica_ads = tpr.anno_pratica
                 and n10.pratica_ads      = tpr.pratica
                 and nvl(cp4.data_decorrenza,tpr.data_pratica) = :new.data_eve
                 and cp4.cod_fam_prov = :new.cod_fam
                 and cp4.anno_pratica = tpr.anno_pratica
                 and cp4.pratica      = tpr.pratica
                 and tpr.anagrafe     = 'RES'
                 and tpr.tipo_evento  = 'C'
                 and tpr.pratica      = :new.pratica
                 and tpr.anno_pratica = :new.anno_pratica
                 and rownum = 1
              UNION
              select 'S'
                from anac01 c01, anatpr tpr
               where nvl(c01.data_decorrenza,c01.data_pratica) = :new.data_eve
                 and c01.anno_pratica   = tpr.anno_pratica
                 and c01.pratica        = tpr.pratica
                 and tpr.anagrafe       = 'RES'
                 and tpr.tipo_evento    = 'I'
                 and tpr.cod_variazione = 'A'
                 and tpr.cod_fam_dic    = :new.cod_fam
                 and tpr.pratica        = :new.pratica
                 and tpr.anno_pratica   = :new.anno_pratica
                 and rownum = 1
              UNION
              select 'S'
                from anpn10 n10, anac01 c01, anatpr tpr
               where n10.anagrafe_ads         = tpr.anagrafe
                 and n10.tipo_evento_ads      = tpr.tipo_evento
                 and n10.anno_pratica_ads     = tpr.anno_pratica
                 and n10.pratica_ads          = tpr.pratica
                 and nvl(c01.data_decorrenza,tpr.data_pratica) = :new.data_eve
                 and c01.cod_fam              = :new.cod_fam
                 and c01.anno_protocollo_aire = tpr.anno_pratica
                 and c01.protocollo_aire      = tpr.pratica
                 and tpr.anagrafe             = 'AIR'
                 and tpr.tipo_evento          = 'C'
                 and tpr.pratica              = :new.pratica
                 and tpr.anno_pratica         = :new.anno_pratica
                 and rownum = 1
              ;
            exception 
              when others then
                   w_flag_90 := '';
                   w_errore := w_servizio||' - cod_mov '||:new.cod_mov||' - cod_eve '||:new.cod_eve||' - matricola '||:new.matricola||' - CF ('||SQLERRM||')';
                   ANPR_pkg.ins_log('',w_operazione_log,w_errore);
            end;

         elsif :new.pratica is null then
            begin
              w_flag_90 := 'S';
            exception 
              when others then
                   w_flag_90 := '';
                   w_errore := w_servizio||' - cod_mov '||:new.cod_mov||' - cod_eve '||:new.cod_eve||' - matricola '||:new.matricola||' - no_pratica ('||SQLERRM||')';
                   ANPR_pkg.ins_log('',w_operazione_log,w_errore);
            end;

         elsif :new.pratica is not null then
            begin
              select 'S' 
                into w_flag_90
                from dual
               where not exists (select 'x' from anatpr 
                                  where data_pratica = :new.data_eve
                                    and data_reg     = :new.data_reg
                                    and pratica      = :new.pratica
                                    and anno_pratica = :new.anno_pratica
                                    and tipo_evento  in ('C','E'))
              ;
            exception 
              when others then
                   w_flag_90 := '';
                   w_errore := w_servizio||' - cod_mov '||:new.cod_mov||' - cod_eve '||:new.cod_eve||' - matricola '||:new.matricola||' - pratica ('||SQLERRM||')';
                   ANPR_pkg.ins_log('',w_operazione_log,w_errore);
            end;
         end if;

         if w_flag_90 is not null then
            if :new.cod_mov = 10 then
               w_fascia_fam := 1;
            elsif :new.cod_mov = 12 then
               w_fascia_fam := 3;
            end if;

            anpciu_PROC_upd(w_servizio,:new.matricola,:new.anno_progr,:new.numero_progr,:new.cod_mov,:new.cod_eve,:new.pratica,:new.anno_pratica);

            w_id_operazione := '';
            ANPCIU_NR(w_id_operazione,w_servizio);
            begin
              insert into anpciu
                     (ID_OPERAZIONE, SERVIZIO, TIPO_OPERAZIONE, ARCHIVIO_RIF,
                      MATRICOLA, FASCIA_FAM, COD_FAM, ANNO_RIF, NUMERO_RIF,
                      TERMINALISTA, DATA_REG)
              select w_id_operazione, w_servizio, w_tipo_operazione, w_archivio_rif,
                     :new.matricola, w_fascia_fam, :new.cod_fam, :new.anno_progr, :new.numero_progr,
                     :new.terminalista, :new.data_reg
                from dual
               where not exists (select 'x' from anpciu b
                                  where b.servizio   = w_servizio
                                    and b.fascia_fam = w_fascia_fam
                                    and b.cod_fam    = :new.cod_fam
                                    and b.matricola  = :new.matricola
                                    and b.data_reg   = :new.data_reg)
              ;
            exception 
              when others then
--                   raise_application_error(-20999,'Errore in inserimento ANPCIU - '||w_servizio||' ('||SQLERRM||')');
                   w_errore := w_servizio||' - cod_mov '||:new.cod_mov||' - cod_eve '||:new.cod_eve||' - matricola '||:new.matricola||' ('||SQLERRM||')';
                   ANPR_pkg.ins_log('',w_operazione_log,w_errore);            end;
         end if;

      elsif (:new.cod_mov in (97,98) and :new.cod_eve in (99) and
             :new.cognome_nome_prec||:new.sesso_prec||
              :new.data_nas_prec||:new.anno_nas_prec||:new.cod_pro_nas_prec||:new.cod_com_nas_prec||
              :new.cod_pro_atto_nas_prec||:new.cod_com_atto_nas_prec||
              :new.atto_nas_prec||:new.parte_nas_prec||:new.serie_nas_prec||:new.ufficio_nas_prec||:new.anno_atto_nas_prec||
              :new.stato_civile_prec||:new.cognome_nome_cn_prec||:new.matricola_cn_prec||
              :new.data_mat_prec||
              :new.cod_pro_mat_prec||:new.cod_com_mat_prec||
              :new.cod_pro_atto_mat_prec||:new.cod_com_atto_mat_prec||
              :new.atto_mat_prec||:new.parte_mat_prec||:new.serie_mat_prec||:new.ufficio_mat_prec||:new.anno_atto_mat_prec||
              :new.data_ved_prec||
              :new.cod_pro_ved_prec||:new.cod_com_ved_prec||
              :new.cod_pro_atto_ved_prec||:new.cod_com_atto_ved_prec||
              :new.atto_ved_prec||:new.parte_ved_prec||:new.serie_ved_prec||:new.ufficio_ved_prec||:new.anno_atto_ved_prec||
              :new.data_div_prec||:new.data_div_ann_prec||:new.data_div_giu_prec||
              :new.cod_pro_div_prec||:new.cod_com_div_prec||
              :new.cod_pro_atto_div_prec||:new.cod_com_atto_div_prec||
              :new.atto_div_prec||:new.parte_div_prec||:new.serie_div_prec||:new.ufficio_div_prec||:new.anno_atto_div_prec||
              :new.nazionalita_prec||:new.data_inizio_naz_prec||
              f_ANPR_condizione_non_prof(:new.cod_prof_prec,:new.sesso_prec)||f_ANPR_posizione_prof(:new.posizione_prof_prec)||f_ANPR_titolo_studio(:new.titolo_studio_prec)||
              :new.paternita_prec||:new.matricola_pd_prec||
              :new.maternita_prec||:new.matricola_md_prec||
              :new.atto_nas_digitale_prec||:new.atto_mat_digitale_prec||
              :new.atto_ved_digitale_prec||:new.atto_div_digitale_prec
             != :new.cognome_nome||:new.sesso||
                 :new.data_nas||:new.anno_nas||:new.cod_pro_nas||:new.cod_com_nas||
                 :new.cod_pro_atto_nas||:new.cod_com_atto_nas||
                 :new.atto_nas||:new.parte_nas||:new.serie_nas||:new.ufficio_nas||:new.anno_atto_nas||
                 :new.stato_civile||:new.cognome_nome_cn||:new.matricola_cn||
                 :new.data_mat||
                 :new.cod_pro_mat||:new.cod_com_mat||
                 :new.cod_pro_atto_mat||:new.cod_com_atto_mat||
                 :new.atto_mat||:new.parte_mat||:new.serie_mat||:new.ufficio_mat||:new.anno_atto_mat||
                 :new.data_ved||
                 :new.cod_pro_ved||:new.cod_com_ved||
                 :new.cod_pro_atto_ved||:new.cod_com_atto_ved||
                 :new.atto_ved||:new.parte_ved||:new.serie_ved||:new.ufficio_ved||:new.anno_atto_ved||
                 :new.data_div||:new.data_div_ann||:new.data_div_giu||
                 :new.cod_pro_div||:new.cod_com_div||
                 :new.cod_pro_atto_div||:new.cod_com_atto_div||
                 :new.atto_div||:new.parte_div||:new.serie_div||:new.ufficio_div||:new.anno_atto_div||
                 :new.nazionalita||:new.data_inizio_naz||
                 f_ANPR_condizione_non_prof(:new.cod_prof,:new.sesso)||f_ANPR_posizione_prof(:new.posizione_prof)||f_ANPR_titolo_studio(:new.titolo_studio)||
                 :new.paternita||:new.matricola_pd||
                 :new.maternita||:new.matricola_md||
                 :new.atto_nas_digitale||:new.atto_mat_digitale||
                 :new.atto_ved_digitale||:new.atto_div_digitale
            )
            OR
            (:new.cod_mov in (97) and :new.cod_eve in (99) and
             nvl(:new.anno_cens_prec||:new.sezione_cens_prec||:new.foglio_cens_prec,' ')
             != nvl(:new.anno_cens||:new.sezione_cens||:new.foglio_cens,' '))
            OR
            (:new.cod_mov in (97,98) and :new.cod_eve in (93,97))
            OR
            (:new.cod_mov in (97,98) and :new.cod_eve in (94))
      then
<< rettifica >>
         anpciu_PROC_upd(w_servizio,:new.matricola,:new.anno_progr,:new.numero_progr,:new.cod_mov,:new.cod_eve,:new.pratica,:new.anno_pratica);

         w_id_operazione := '';
         ANPCIU_NR(w_id_operazione,w_servizio);
         begin
           insert into anpciu
                  (ID_OPERAZIONE, SERVIZIO, TIPO_OPERAZIONE, ARCHIVIO_RIF,
                   MATRICOLA, ANNO_RIF, NUMERO_RIF,
                   TERMINALISTA, DATA_REG)
           values (w_id_operazione, w_servizio, w_tipo_operazione, w_archivio_rif,
                   :new.matricola, :new.anno_progr, :new.numero_progr,
                   :new.terminalista, :new.data_reg)
           ;
         exception
           when others then
--                raise_application_error(-20999,'Errore in inserimento ANPCIU - '||w_servizio||' ('||SQLERRM||')');
                w_errore := w_servizio||' - cod_mov '||:new.cod_mov||' - cod_eve '||:new.cod_eve||' - matricola '||:new.matricola||' ('||SQLERRM||')';
                ANPR_pkg.ins_log('',w_operazione_log,w_errore);
         end;

      else
         null;
--anpr_pkg.ins_log('',w_operazione_log,'ELSE - anno_progr '||:new.anno_progr||' - numero_progr '||:new.numero_progr||' - cod_mov '||:new.cod_mov||' - cod_eve '||:new.cod_eve);
      end if;

      if (:new.cod_mov = 11 or (:new.cod_mov = 97 and :new.cod_eve = 98) or (:new.cod_mov = 1 and substr(w_servizio,1,1) = '5'))
          and
         (nvl(f_senza_fissa_dimora(:new.cod_via_prec,:new.num_civ_prec,:new.suffisso_prec,:new.interno_prec),' ') != 
            nvl(f_senza_fissa_dimora(:new.cod_via,:new.num_civ,:new.suffisso,:new.interno),' '))
      then
<< senza_fissa_dimora >>
         w_servizio := '5008';

         anpciu_PROC_upd(w_servizio,:new.matricola,:new.anno_progr,:new.numero_progr,:new.cod_mov,:new.cod_eve,:new.pratica,:new.anno_pratica);

         w_id_operazione := '';
         ANPCIU_NR(w_id_operazione,w_servizio);
         begin
           insert into anpciu
                  (ID_OPERAZIONE, SERVIZIO, TIPO_OPERAZIONE, ARCHIVIO_RIF,
                   MATRICOLA, ANNO_RIF, NUMERO_RIF,
                   TERMINALISTA, DATA_REG)
           select w_id_operazione, w_servizio, w_tipo_operazione, 'SFD',
                   :new.matricola, :new.anno_progr, :new.numero_progr,
                   :new.terminalista, :new.data_reg
             from dual
            where not exists (select 'x' from anpciu b
                               where b.servizio      = w_servizio
                                 and b.matricola     = :new.matricola
                                 and b.anno_rif      = :new.anno_progr
                                 and b.numero_rif    = :new.numero_progr)
           ;
         exception
           when others then
                w_errore := '['||:new.cod_mov||'-'||:new.cod_eve||'-'||:new.matricola||' - SFD]';
                w_errore := w_errore||' Errore in inserimento comunicazione ('||SQLERRM||')';
                ANPR_pkg.ins_log('',w_operazione_log,w_errore);
         end;
      end if;

   end if;

   if nvl(w_flag_ripristino,'N') = 'S' then
      if w_id_operazione_rif is not null and w_servizio_rif is not null and w_id_operazione_anpr_rif is not null then
         begin
           insert into anpciu_rif
                  (ID_OPERAZIONE, ID_OPERAZIONE_RIF, SERVIZIO_RIF, ID_OPERAZIONE_ANPR_RIF, FLAG_ANNULLAMENTO)
           values (w_id_operazione, w_id_operazione_rif, w_servizio_rif, w_id_operazione_anpr_rif, 'S')
           ;
         exception
           when others then
                w_errore := w_servizio||' - cod_mov '||:new.cod_mov||' - cod_eve '||:new.cod_eve||' - matricola '||:new.matricola||' ('||SQLERRM||')';
                ANPR_pkg.ins_log('',w_operazione_log,w_errore);
         end;
      end if;
   else
      if w_servizio in ('1002','2003','5001','5005') and :new.anno_pratica is not null and :new.pratica is not null then
         w_anagrafe_mov      := f_ANPR_anagrafe_ciu(:new.cod_mov,:new.cod_eve);
         w_tipo_evento_mov   := f_ANPR_tipo_evento_ciu(:new.cod_mov,:new.cod_eve,'S');
         w_id_operazione_mov := f_ANPR_id_operazione_rif(w_anagrafe_mov,w_tipo_evento_mov,:new.anno_pratica,:new.pratica);
         begin 
           insert into anpciu_rif
                  (ID_OPERAZIONE, ID_OPERAZIONE_RIF, SERVIZIO_RIF, ID_OPERAZIONE_ANPR_RIF)
           select w_id_operazione, w_id_operazione_mov, w_servizio, :new.matricola
             from dual
            where not exists (select 'x' from anpciu_rif r
                               where r.id_operazione = w_id_operazione)
          ;
        exception
          when others then
               null;
        end;
      end if;
   end if;
 end if; -- nvl(w_integrazione_anpr,'N') = 'S' 

<< fine >>
null;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/* End Trigger: ANAMOV_ANPR_TIU */
/
