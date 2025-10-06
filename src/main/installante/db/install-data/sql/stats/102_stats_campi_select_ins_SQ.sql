--liquibase formatted sql
--changeset amonopoli:202411201301_2 runOnChange:true stripComments:false
declare
cursor sel_viste is
select ss.id w_ord_1
     , scv.id w_ord_2
     , scv.id
     , f_STATS_codice_ente() ente
     , to_char(null) etichetta
     , ss.id id_select
     , decode(scv.nome,'CODICE',1,'DESCRIZIONE',2) sequenza
     , decode(scv.nome,'CODICE','N','DESCRIZIONE','Y') dislplay
  from stats_campi_viste scv
     , stats_viste sv
     , stats_select ss
 where scv.nome in ('CODICE','DESCRIZIONE')
   and scv.id_vista     = sv.id
   and ss.tipo_select   = 'SQ'
   and ss.id_vista      = sv.id
   and sv.nome          like 'GSD%'
 order by 1, 2
;

w_version    number := 0;
w_data_creazione  date := sysdate;
w_data_aggiornamento  date := sysdate;
w_utente_creazione  varchar2(255) := 'ADS';
w_utente_aggiornamento  varchar2(255) := 'ADS';
w_label_size    varchar2(255) := to_char(null);

begin
  for rec in sel_viste loop
      begin
        insert into stats_campi_select
               (ID, VERSION, ID_CAMPO_VISTA, DATA_CREAZIONE, ENTE, ETICHETTA, DATA_AGGIORNAMENTO,
                ID_SELECT, SEQUENZA, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, DISPLAY, LABEL_SIZE)
        select stats_hibernate_sequence.nextval id
             , w_version
             , rec.id
             , w_data_creazione
             , rec.ente
             , rec.etichetta
             , w_data_aggiornamento
             , rec.id_select
             , rec.sequenza
             , w_utente_creazione
             , w_utente_aggiornamento
             , rec.dislplay
             , w_label_size
          from dual
         where not exists (select 1 from stats_campi_select b
                            where b.id_campo_vista = rec.id
                              and b.id_select      = rec.id_select)
        ;
      exception
        when others then
             null;
      end;
  end loop;
end;
/
