--liquibase formatted sql
--changeset snocca:202305171727_2 runAlways:true runOnChange:true stripComments:false
delete anstws_arc
/
declare
w_esiste_ddo		number;
w_esiste_r001		number;
w_esiste_r006_R012  number;

w_inserisci		    number;
w_inserisci_ann		number;
w_inserisci_prec	number;

cursor sel_tws_not is
select tws.id,
       decode(tws.id, 'R008_R', 10,
                      'R008_C', 20,
                      'R008_X', 25,
                      'R005_S', 30,
                      'R005_N', 40) sequenza,
       decode(tws.id, 'R008_R', '',
                      'R008_C', '',
                      'R008_X', '',
                      'R005_S', '',
                      'R005_N', '') id_servizio_prec,
       tws.flag_allegati
  from anstws tws
 where tws.id in ('R008_R', 'R008_C', 'R008_X','R005_S', 'R005_N')
 order by 2
;

cursor sel_tws_ann (tipo_ann in varchar2) is
select tws.id,
       decode(tws.id, 'R013',    10,
                      'R009_A',  20,
                      'R010_A',  25,
                      'R007_A',  30,
                      'R005_A',  35,
                      'R017',    40,
                      'R010_RA', 50,
                      'R007_RA', 60) sequenza,
       decode(tws.id, 'R013',   '',
                      'R009_A', '',
                      'R007_A', CASE WHEN tipo_ann like 'EMA' or tipo_ann like '%RET%' THEN 'R013' ELSE 'R009_A' END,
                      'R010_A', CASE WHEN tipo_ann like 'EMA' or tipo_ann like '%RET%' THEN 'R013' ELSE 'R009_A' END,
                      'R005_A', CASE WHEN tipo_ann like 'EMA' or tipo_ann like '%RET%' THEN 'R013' ELSE 'R009_A' END,
                      'R017', '',
                      'R010_RA', 'R017',
                      'R007_RA', 'R017') id_servizio_prec,
       tws.flag_allegati
  from anstws tws
 where tws.id in ('R013', 'R009_A', 'R007_A','R010_A','R005_A','R017','R010_RA','R007_RA')
 order by 2
;
cursor sel_tws_att is
select tws.id,
       decode(tws.id, 'R005_1', 5,  		--R005 - Consultazione ANSC - Soggetto 1
                      'R005_2', 6,  		--R005 - Consultazione ANSC - Soggetto 2
                      'R001_U', 10,  		--R001 - Allegato - Upload
                      'R001_V', 20,  		--R001 - Allegato - Verifica
                      'R009_V', 30,  		--R009 - Evento - Validazione
                      'R010'  , 50,  		--R010 - Anteprima
                      'R012_I', 60, 		--R012 - Firma Dichiarante Digitale - Invio Mail
                      'R006'  , 65,  		--R006 - Firma Dichiarante
                      'R010_C', 68,  		--R010 - Attestazione di conformità
                      'R007_C', 69,  		--R007 - Firma Attestazione di conformità
                      'R007'  , 70,  		--R007 - Firma USC
                      'R014'  , 80,  		--R014 - Evento - Validazione Data
                      'R005_E', 510, 		--R005 - Consultazione ANSC - Evento
                      'R008_E', 590, 		--R008_E - Consultazione Notifiche ANSC - Evento
                      'R008_A', 591, 		--R008_A - Consultazione Notifiche ANPR - Evento
                      'R002_1', 610, 		--R002 - Certificazione (certificato semplice)
                      'R002_2', 620, 		--R002 - Certificazione (estratto)
                      'R002_3', 630, 		--R002 - Certificazione (copia integrale)
                      'R012_V', 640, 		--R012 - Firma Dichiarante Digitale - Verifica presa visione
                      'R012_A', 650, 		--R012 - Firma Dichiarante Digitale - Annulla link
                      'R011'  , 910) sequenza,	--R011 - Cancellazione Atto
       decode(tws.id, 'R005_1', '',
                      'R005_2', '',
                      'R001_U', '',
                      'R001_V', 'R001_U',
                      'R009_V', 'R001_U',
                      'R010'  , 'R009_V',
                      'R012_I', 'R009_V',
                      'R006'  , 'R009_V',
                      'R010_C', 'R009_V',
                      'R007'  , 'R012_I',
                      'R007_C', 'R010_C',
                      'R014'  , 'R007',
                      'R005_E', 'R009_V',
                      'R002_1', 'R007',
                      'R002_2', 'R007',
                      'R002_3', 'R007',
                      'R012_V', 'R012_I',
                      'R012_A', 'R012_I',
                      'R008_E', 'R007',
                      'R008_A', 'R007',
                      'R011'  , '') id_servizio_prec,
       decode(tws.id, 'R006'  , 'CA', 'R012_I', 'EL', 'R014', 'VD', '' ) tipo_evento,
       tws.flag_allegati
  from anstws tws
 where tws.id in ('R001_U','R001_V','R009_V','R014','R010','R006','R012_I','R012_A','R012_V','R010_C','R007_C','R007','R005_E','R005_1','R005_2','R002_1','R002_2','R002_3','R011','R008_E','R008_A')
 order by 2
;
-- se tipo_evento = 'NE' (nessun firmatario) il servizio R007 non deve dipendere dal servizio R006
cursor sel_eve is
select 'NE' as tipo_evento, 'R007' as id_servizio_prec_std, 'R009_V' as id_servizio_prec_alt, 'S' as flag_anagrafe
  from dual
union
select 'NEAL' as tipo_evento, 'R007' as id_servizio_prec_std, 'R007_C' as id_servizio_prec_alt, 'S' as flag_anagrafe
  from dual
union
select 'CA' as tipo_evento, 'R007' as id_servizio_prec_std, 'R007_C' as id_servizio_prec_alt, 'S' as flag_anagrafe
  from dual
union
select 'CAEL' as tipo_evento, 'R007' as id_servizio_prec_std, 'R007_C' as id_servizio_prec_alt, 'S' as flag_anagrafe
  from dual
union
select 'NE' as tipo_evento, 'R014' as id_servizio_prec_std, 'R007' as id_servizio_prec_alt, to_char(null) as flag_anagrafe
  from dual
union
select 'NEAL' as tipo_evento, 'R014' as id_servizio_prec_std, 'R007' as id_servizio_prec_alt, to_char(null) as flag_anagrafe
  from dual
union
select 'CA' as tipo_evento, 'R014' as id_servizio_prec_std, 'R007' as id_servizio_prec_alt, to_char(null) as flag_anagrafe
  from dual
union
select 'EL' as tipo_evento, 'R014' as id_servizio_prec_std, 'R007' as id_servizio_prec_alt, to_char(null) as flag_anagrafe
  from dual
union
select 'CAEL' as tipo_evento, 'R014' as id_servizio_prec_std, 'R007' as id_servizio_prec_alt, to_char(null) as flag_anagrafe
  from dual
union
select 'CAEL' as tipo_evento, 'R006' as id_servizio_prec_std, 'R009_V' as id_servizio_prec_alt, 'S' as flag_anagrafe
  from dual
union
select 'CAEL' as tipo_evento, 'R012_I' as id_servizio_prec_std, 'R009_V' as id_servizio_prec_alt, 'S' as flag_anagrafe
  from dual
union
select 'CA' as tipo_evento, 'R010_C' as id_servizio_prec_std, 'R006' as id_servizio_prec_alt, 'S' as flag_anagrafe
  from dual
union
select 'EL' as tipo_evento, 'R010_C' as id_servizio_prec_std, 'R012_I' as id_servizio_prec_alt, 'S' as flag_anagrafe
  from dual
union
select 'CAEL' as tipo_evento, 'R010_C' as id_servizio_prec_std, 'R006' as id_servizio_prec_alt, 'S' as flag_anagrafe
  from dual
;
-- ANNOTAZIONI
cursor sel_cux_ann is
select cu2.id, 2 as tipo_atto, cu2.sigla_categoria as sigla_categoria, cu2.tipo_atto_ansc as tipo_atto_ansc, 'NAS' as archivio
  from anscu2 cu2
 where tipo_atto_ansc = 'Annotazione' and flag_visibile = 'S'
union
select cu4.id, 4 as tipo_atto, cu4.sigla_categoria as sigla_categoria, cu4.tipo_atto_ansc as tipo_atto_ansc, 'MAT' as archivio
  from anscu4 cu4
 where tipo_atto_ansc = 'Annotazione' and flag_visibile = 'S'
union
select cuu.id, -4 as tipo_atto, cuu.sigla_categoria as sigla_categoria, cuu.tipo_atto_ansc as tipo_atto_ansc, 'UCI' as archivio
  from anscuu cuu
 where tipo_atto_ansc = 'Annotazione' and flag_visibile = 'S'
union
select cu5.id, 5 as tipo_atto, cu5.sigla_categoria as sigla_categoria, cu5.tipo_atto_ansc as tipo_atto_ansc, 'MOR' as archivio
  from anscu5 cu5
 where tipo_atto_ansc = 'Annotazione' and flag_visibile = 'S'
union
select cu1.id, 1 as tipo_atto, cu1.sigla_categoria as sigla_categoria, cu1.tipo_atto_ansc as tipo_atto_ansc, 'CIT' as archivio
  from anscu1 cu1
 where tipo_atto_ansc = 'Annotazione' and flag_visibile = 'S'
;
-- NASCITE
cursor sel_cux is
select cu2.id, 2 as tipo_atto, cu2.sigla_categoria as sigla_categoria,
       cu2.tipo_atto_ansc as tipo_atto_ansc, 'NAS' as archivio, nvl(cta.flag_anagrafe, cu2.flag_servizio) as flag_anagrafe
  from anscu2 cu2, civcta cta
 where cta.tipo_atto (+) = 2
   and cta.sigla     (+) = substr(cu2.sigla_categoria,1,3)
   and nvl(tipo_atto_ansc, '--') != 'Annotazione'
   and flag_visibile = 'S'
union
-- MORTI
select cu5.id, 5 as tipo_atto, cu5.sigla_categoria as sigla_categoria,
       cu5.tipo_atto_ansc as tipo_atto_ansc, 'MOR' as archivio, nvl(cta.flag_anagrafe, cu5.flag_servizio) as flag_anagrafe
  from anscu5 cu5, civcta cta
 where cta.tipo_atto (+) = 5
   and cta.sigla     (+) = substr(cu5.sigla_categoria,1,3)
   and nvl(tipo_atto_ansc, '--') != 'Annotazione'
   and flag_visibile = 'S'
union
-- MATRIMONI
select cu4.id, 4 as tipo_atto, cu4.sigla_categoria as sigla_categoria,
       cu4.tipo_atto_ansc as tipo_atto_ansc, 'MAT' as archivio, nvl(cta.flag_anagrafe, cu4.flag_servizio) as flag_anagrafe
  from anscu4 cu4, civcta cta
 where cta.tipo_atto (+) = 4
   and cta.sigla     (+) = substr(cu4.sigla_categoria,1,3)
   and nvl(tipo_atto_ansc, '--') != 'Annotazione'
   and flag_visibile = 'S'
union
-- UNIONI CIVILI
select cuu.id, -4 as tipo_atto, cuu.sigla_categoria as sigla_categoria,
       cuu.tipo_atto_ansc as tipo_atto_ansc, 'UCI' as archivio, nvl(cta.flag_anagrafe, cuu.flag_servizio) as flag_anagrafe
  from anscuu cuu, civcta cta
 where cta.tipo_atto (+) = -4
   and cta.sigla     (+) = substr(cuu.sigla_categoria,1,3)
   and nvl(tipo_atto_ansc, '--') != 'Annotazione'
   and flag_visibile = 'S'
union
-- CITTADINANZE
select cu1.id, 1 as tipo_atto, cu1.sigla_categoria as sigla_categoria,
       cu1.tipo_atto_ansc as tipo_atto_ansc, 'CIT' as archivio, nvl(cta.flag_anagrafe, cu1.flag_servizio) as flag_anagrafe
  from anscu1 cu1, civcta cta
 where cta.tipo_atto (+) = 1
   and cta.sigla     (+) = substr(cu1.sigla_categoria,1,3)
   and nvl(tipo_atto_ansc, '--') != 'Annotazione'
   and flag_visibile = 'S'
;

begin
  -- NOTIFICHE
  for rec_tws in sel_tws_not loop
     begin
       insert into anstws_arc (id, archivio, id_anstws, sequenza, id_anst03, id_anstws_prec, tipo_evento, version )
       select '', 'NOT', rec_tws.id, rec_tws.sequenza, to_number(null), rec_tws.id_servizio_prec, to_char(null), 0
         from dual
        where not exists (select 1
                            from anstws_arc b
                           where b.id_anstws = rec_tws.id
                             and b.archivio  = 'NOT')
       ;
     exception
       when others then
            null;
     end;
  end loop; -- sel_tws_not

  -- ANNOTAZIONI
  for rec_cux in sel_cux_ann loop
      for rec_tws in sel_tws_ann(rec_cux.sigla_categoria) loop
          w_inserisci_ann := 1;

          if rec_tws.id in ('R009_A') then
            if rec_cux.sigla_categoria like 'EMA' or rec_cux.sigla_categoria like '%RET%' then
               w_inserisci_ann :=0;
            end if;
          elsif rec_tws.id in ('R013') then
            if rec_cux.sigla_categoria like 'AUT' or rec_cux.sigla_categoria like '%COM%' or rec_cux.sigla_categoria like '%AMM%' then
               w_inserisci_ann :=0;
            end if;
          end if;

          if w_inserisci_ann = 1 then
               begin
                 insert into anstws_arc (id, archivio, id_anstws, sequenza, id_anst03, id_anstws_prec, tipo_evento, version )
                 select '', 'ANN', rec_tws.id, rec_tws.sequenza, rec_cux.id, rec_tws.id_servizio_prec, to_char(null), 0
                   from dual
                  where not exists (select 1
                                      from anstws_arc b
                                     where b.id_anstws = rec_tws.id
                                       and b.id_anst03 = rec_cux.id
                                       and b.archivio  = rec_cux.archivio)
                 ;
               exception
                 when others then
                      null;
               end;
          end if;
      end loop; -- sel_tws_ann
  end loop; --sel_cux_ann

  -- ATTI
  for rec_tws in sel_tws_att loop
      for rec_cux in sel_cux loop
        if nvl(rec_cux.tipo_atto_ansc, 'X') in ('Annotazione') then
             null; --patch per versione oracle Valeggio
        else

<< ctr_servizio >>
          w_inserisci := 1; -- '1' = inserire servizio / '0' = non inserire servizio
          if rec_tws.id like 'R001%' and rec_tws.flag_allegati = 'S' then
-- R001 - Upload / Verifica
-- R006 - Firma Dic (Upload) (SN): carico sempre, poi filtro per tipo_evento
-- controllo documenti in anstws_ddo per il caso d'uso che si sta trattando, se il servizio prevede l'invio di allegati (rif. tws.flag_allegati)
             begin
               select 1 into w_esiste_ddo
                 from anstws_ddo
                where id_anstws = rec_tws.id
                  and id_anst03 = rec_cux.id
                  and rownum = 1
               ;
-- inserire a condizione che esista un documento in anstws_ddo per quel caso d'uso
               w_inserisci := 1;
             exception
               when no_data_found then
                    w_inserisci := 0;
               when others then
                    w_inserisci := 1;
             end;

          elsif rec_tws.id in ('R002_1','R002_2') then
             if (rec_cux.tipo_atto = 2 and rec_cux.sigla_categoria in ('RIC', 'RPN', 'ADO', 'CGE')) or
                (rec_cux.tipo_atto = 1) or
                (rec_cux.tipo_atto = 4 and rec_cux.tipo_atto_ansc = 'Sep_Div') or
                (rec_cux.tipo_atto = -4 and rec_cux.tipo_atto_ansc = 'Sciogl_UnCiv') then
                w_inserisci := 0;
             end if;

          elsif rec_tws.id in ('R005_2') then
             if rec_cux.tipo_atto in (1,2,5) then
                w_inserisci := 0;
             end if;

          end if;

<< ctr_servizio_prec >>
          w_inserisci_prec := 1; -- '1' = inserire servizio_prec / '0' = non inserire servizio_prec
          if rec_tws.id like 'R009%' then
-- nel caso di servizio R009 (Validazione), il servizio_prec viene inserito solo se esiste, per lo stesso caso d'uso, il servizio R001 (Upload / Verifica)
             begin
               select 1 into w_esiste_r001
                 from anstws_arc
                where id_anstws like 'R001%'
                  and id_anst03 = rec_cux.id
                  and rownum = 1
               ;
               w_inserisci_prec := 1;
             exception
               when no_data_found then
                    w_inserisci_prec := 0;
               when others then
                    w_inserisci_prec := 1;
             end;

          else
             w_inserisci_prec := 1;
          end if;
    
<< inserimento >>
          if w_inserisci = 1 then
             for rec_eve in sel_eve loop
               if rec_eve.id_servizio_prec_std = rec_tws.id then
                 begin
                   insert into anstws_arc (id, archivio, id_anstws, sequenza, id_anst03, id_anstws_prec, tipo_evento, version )
                   select '', rec_cux.archivio, rec_tws.id, rec_tws.sequenza, rec_cux.id, rec_eve.id_servizio_prec_alt, rec_eve.tipo_evento, 0
                     from dual
                    where not exists (select 1
                                        from anstws_arc b
                                       where b.id_anstws = rec_tws.id
                                         and b.id_anst03 = rec_cux.id
                                         and b.archivio  = rec_cux.archivio
                                         and b.tipo_evento = rec_eve.tipo_evento)
                     and (rec_eve.flag_anagrafe = 'S' or nvl(rec_eve.flag_anagrafe, rec_cux.flag_anagrafe) = 'S')
                   ;
                 exception
                   when others then
                        null;
                 end;
               end if;
             end loop; -- sel_eve

             begin
               insert into anstws_arc (id, archivio, id_anstws, sequenza, id_anst03, id_anstws_prec, tipo_evento, version )
               select '', rec_cux.archivio, rec_tws.id, rec_tws.sequenza, rec_cux.id, decode(w_inserisci_prec,0,'',rec_tws.id_servizio_prec), rec_tws.tipo_evento, 0
                 from dual
                where not exists (select 1
                                    from anstws_arc b
                                   where b.id_anstws = rec_tws.id
                                     and b.id_anst03 = rec_cux.id
                                     and b.archivio  = rec_cux.archivio
                                     and b.tipo_evento is null)
               ;
             exception
               when others then
                    null;
             end;
          end if; -- if w_inserisci = 1 then
        end if; -- if nvl(rec_cux.tipo_atto_ansc, 'X') in ('Annotazione') then
      end loop; --sel_cux
  end loop; -- sel_tws_att
end;
/
