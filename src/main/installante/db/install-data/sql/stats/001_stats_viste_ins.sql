--liquibase formatted sql
--changeset amonopoli:202411191626_1 runAlways:true stripComments:false
declare
cursor sel_tab is
select 1 w_ord_1
     , t.tname w_ord_2
     , f_STATS_descrizione_vista(t.tname) descrizione
     , f_STATS_codice_ente() ente
     , f_STATS_nome_vista(t.tname,'S') nome
     , 'S' tipo
  from tab t
 where (t.tname in ('ANAVBI','ANAVBI_TOTALE','ANAVBI_STORICO','ANAVMO','ANASTA_V')
        or t.tname like 'ANAVXX_%')
UNION
select 2 w_ord_1
     , t.tname w_ord_2
     , f_STATS_descrizione_vista(t.tname) descrizione
     , f_STATS_codice_ente() ente
     , f_STATS_nome_vista(t.tname,'P')  nome
     , 'P' tipo
  from tab t
 where (t.tname in ('ANAVBI','ANAVBI_TOTALE','ANAVBI_STORICO','ANAVMO','ANASTA_V')
        or t.tname like 'ANAVXX_%')
 order by 1, 2
;

w_version		number        := 0;
w_area			varchar2(255) := 'DE';
w_data_creazione	date          := sysdate;
w_data_aggiornamento	date          := sysdate;
w_note			varchar2(255) := '';
w_utente_creazione	varchar2(255) := 'ADS';
w_utente_aggiornamento	varchar2(255) := 'ADS';
w_valido	 	varchar2(255) := 'Y';
w_tipo_vista		varchar2(255) := 'D';

begin
  for rec in sel_tab loop
      begin
        insert into stats_viste
               (ID, VERSION, AREA, DATA_CREAZIONE, DESCRIZIONE, ENTE,
                DATA_AGGIORNAMENTO, NOME, NOTE, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO,
                VALIDO, TIPO_VISTA, TIPO)
        select stats_hibernate_sequence.nextval
              , w_version
              , w_area
              , w_data_creazione
              , rec.descrizione
              , rec.ente
              , w_data_aggiornamento
              , rec.nome
              , w_note
              , w_utente_creazione
              , w_utente_aggiornamento
              , w_valido
              , w_tipo_vista
              , rec.tipo
           from dual
          where not exists (select 'x' from stats_viste v
                             where nome = rec.nome
                               and ente = rec.ente)
         ;
       exception
         when others then
              null;
       end;
  end loop;
end;
/
