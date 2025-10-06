--liquibase formatted sql
--changeset amonopoli:202411201301_1 runOnChange:true stripComments:false
declare
cursor sel_viste is
select sv.nome w_ord_2
     , sv.descrizione||' - Filtro'  descrizione
     , f_STATS_codice_ente()    ente
     , sysdate        data_aggiornamento
     , sv.descrizione       nome
     , sv.id        id_vista
     , sv.tipo      tipo
  from stats_viste sv
 where sv.nome like 'GSD%'
   and sv.nome not like '%INDIVIDUI_ANA%'
   and sv.nome not like '%MOVIMENTI_ANA%'
   and sv.nome not like '%STATISTICHE_ANA%'
 order by 1
;

w_versione    number        := 0;
w_data_creazione  date          := sysdate;
w_data_aggiornamento  date          := sysdate;
w_note      varchar2(255) := to_char(null);
w_tipo_select   varchar2(255) := 'SQ';
w_utente_creazione  varchar2(255) := 'ADS';
w_utente_aggiornamento  varchar2(255) := 'ADS';
w_valido    varchar2(255) := 'Y';
w_valori_distinti varchar2(255) := to_char(null);

begin
  for rec in sel_viste loop
      begin
        insert into stats_select
               (ID, VERSION, DATA_CREAZIONE, DESCRIZIONE, ENTE,
                DATA_AGGIORNAMENTO, NOME, NOTE, TIPO_SELECT, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, VALIDO, ID_VISTA,
                VALORI_DISTINTI, TIPO)
        select stats_hibernate_sequence.nextval id
             , w_versione
             , w_data_creazione
             , rec.descrizione
             , rec.ente
             , w_data_aggiornamento
             , rec.nome
             , w_note
             , w_tipo_select
             , w_utente_creazione
             , w_utente_aggiornamento
             , w_valido
             , rec.id_vista
             , w_valori_distinti
             , rec.tipo
          from dual
         where not exists (select 1 from stats_select s
                            where s.ID_VISTA     = rec.id_vista)
        ;
      exception
        when others then
             null;
      end;
  end loop;
end;
/
