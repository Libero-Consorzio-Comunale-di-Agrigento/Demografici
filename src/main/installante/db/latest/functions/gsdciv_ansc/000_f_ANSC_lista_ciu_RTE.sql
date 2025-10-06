--liquibase formatted sql
--changeset amonopoli:202307311625_1 runOnChange:true stripComments:false
create or replace function f_ANSC_lista_ciu_RTE
(a_archivio_rif   IN varchar2
,a_id_rif         IN varchar2
)

return clob

IS

w_archivio_rif       varchar2(255) := upper(a_archivio_rif);

w_id_atto            varchar2(255);
w_id_usecase_ansc    number;

w_clob               clob;

cursor sel_tws_arc is
select tws_arc.*,
       tws.servizio,
       tws.descrizione des_servizio,
       tws.flag_allegati
  from anstws tws,
       anstws_arc tws_arc
 where tws.id            = tws_arc.id_anstws
   and tws_arc.archivio  = a_archivio_rif
   and tws_arc.id_anst03 = w_id_usecase_ansc
 order by sequenza
;

cursor sel_fas_a (p_id_atto varchar2) is
select ddo.descrizione des_civddo, fas_a.id
  from civddo ddo,
       civfas_alle fas_a,
       civfas fas
 where ddo.codice_ansc is not null
   and ddo.id          = fas.id_civddo
   and fas_a.id_civfas = fas.id
   and fas.id_atto     = p_id_atto
;

cursor sel_ciu (p_servizio varchar2, p_archivio_rif varchar2, p_id_rif number) is
select * from ansciu ciu
 where archivio_rif = p_archivio_rif
   and id_rif       = p_id_rif
   and servizio     = p_servizio
;


begin
  begin
    select nas.id_atto, nas.id_usecase_ansc
      into w_id_atto, w_id_usecase_ansc
      from civnas nas
     where id             = a_id_rif
       and w_archivio_rif = 'NAS'
    UNION
    select mor.id_atto, mor.id_usecase_ansc
      from civmor mor
     where id             = a_id_rif
       and w_archivio_rif = 'MOR'
    UNION
    select mat.id_atto, mat.id_usecase_ansc
      from civmat mat
     where id             = a_id_rif
       and w_archivio_rif = 'MAT'
    UNION
    select uci.id_atto, uci.id_usecase_ansc
      from civuci uci
     where id             = a_id_rif
       and w_archivio_rif = 'UCI'
    UNION
    select cit.id_atto, cit.id_usecase_ansc
      from civcit cit
     where id             = a_id_rif
       and w_archivio_rif = 'CIT'
    ;
  exception
    when others then
         w_id_atto         := '';
         w_id_usecase_ansc := '';
  end;

  if w_id_atto is not null and w_id_usecase_ansc is not null then
--dbms_output.put_line('w_id_atto: '||w_id_atto||' - w_id_usecase_ansc: '||w_id_usecase_ansc);
     for rec_tws_arc in sel_tws_arc loop
--dbms_output.put_line('rec_tws_arc: '||rec_tws_arc.id_anstws);
         if rec_tws_arc.flag_allegati = 'S' then
            for rec_fas_a in sel_fas_a (w_id_atto) loop
--dbms_output.put_line('rec_fas_a: '||rec_fas_a.des_civddo);
                for rec_ciu in sel_ciu (rec_tws_arc.id_anstws,'ALL',rec_fas_a.id) loop
--dbms_output.put_line('rec_ciu: '||rec_ciu.id_operazione);
                    w_clob := w_clob||
                              rpad(rec_tws_arc.servizio||' - '||rec_tws_arc.des_servizio||' ('||rec_fas_a.des_civddo||')',60,' ')||': '||
                                'idOperazioneComune '||rec_ciu.id_operazione||
                                ' - idOperazioneAnsc '||rec_ciu.id_operazione_ansc||
                                ' ('||nvl(nvl(rec_ciu.info_ws,rec_ciu.note_ws),rec_ciu.esito_ansc)||')'||chr(10);
                end loop;
            end loop;
         else --if rec_ws_arc.flag_allegato = 'S' then
            for rec_ciu in sel_ciu (rec_tws_arc.id_anstws,w_archivio_rif,a_id_rif) loop
--dbms_output.put_line('rec_ciu: '||rec_ciu.id_operazione);
                w_clob := w_clob||
                          rpad(rec_tws_arc.servizio||' - '||rec_tws_arc.des_servizio,60,' ')||': '||
                            'idOperazioneComune '||rec_ciu.id_operazione||
                            ' - idOperazioneAnsc '||rec_ciu.id_operazione_ansc||
                            ' ('||nvl(nvl(rec_ciu.info_ws,rec_ciu.note_ws),rec_ciu.esito_ansc)||')'||chr(10);
            end loop;
         end if;
     end loop;
  end if;

  return w_clob;

end;
/
