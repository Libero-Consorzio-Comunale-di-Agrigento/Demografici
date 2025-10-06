--liquibase formatted sql
--changeset amonopoli:202411191626_2 runAlways:true stripComments:false
declare
cursor sel_viste is
select 1       w_ord_1
     , c.tname w_ord_2
     , c.colno w_ord_3
     , f_STATS_descrizione_campo(c.cname) descrizione
     , f_STATS_codice_ente() ente
     , c.cname nome
     , decode(substr(c.coltype,1,9), 'DATE', 'D', 'CHAR', 'T', 'TIMESTAMP', 'DT', 'NUMBER', 'I', 'VARCHAR2', 'T') tipo_campo
     , decode(c.cname, 'TOTALE', 'SUM', 'NO_OP') tipo_funzione
     , sv.id id_vista
     , (c.colno*10) sequenza
  from stats_viste sv
     , col c
 where sv.nome = f_STATS_nome_vista(c.tname,'S')
   and (c.tname in ('ANAVBI','ANAVBI_TOTALE','ANAVBI_STORICO','ANAVMO','ANASTA_V')
        or c.tname like 'ANAVXX_%')
UNION
select 2       w_ord_1
     , c.tname w_ord_2
     , c.colno w_ord_3
     , 'Totale' descrizione
     , f_STATS_codice_ente() ente
     , c.cname nome
     , decode(substr(c.coltype,1,9), 'DATE', 'D', 'CHAR', 'T', 'TIMESTAMP', 'DT', 'NUMBER', 'I', 'VARCHAR2', 'T') tipo_campo
     , 'COUNT' tipo_funzione
     , sv.id id_vista
     , (c.colno*10) sequenza
  from stats_viste sv
     , col c
 where sv.nome = f_STATS_nome_vista(c.tname,'S')
   and (c.tname in ('ANAVBI','ANAVBI_TOTALE','ANAVBI_STORICO','ANAVMO','ANASTA_V')
        or c.tname like 'ANAVXX_%')
   and c.cname = 'MATRICOLA'
UNION
select 3       w_ord_1
     , c.tname w_ord_2
     , c.colno w_ord_3
     , f_STATS_descrizione_campo(c.cname) descrizione
     , f_STATS_codice_ente() ente
     , c.cname nome
     , decode(substr(c.coltype,1,9), 'DATE', 'D', 'CHAR', 'T', 'TIMESTAMP', 'DT', 'NUMBER', 'I', 'VARCHAR2', 'T') tipo_campo
     , decode(c.cname, 'TOTALE', 'SUM', 'NO_OP') tipo_funzione
     , sv.id id_vista
     , decode(c.cname, 'TOTALE', 0, (c.colno*10)) sequenza
  from stats_viste sv
     , col c
 where sv.nome = f_STATS_nome_vista(c.tname,'P')
   and (c.tname in ('ANAVBI','ANAVBI_TOTALE','ANAVBI_STORICO','ANAVMO','ANASTA_V')
        or c.tname like 'ANAVXX_%')
UNION
select 3       w_ord_1
     , c.tname w_ord_2
     , c.colno w_ord_3
     , 'Totale' descrizione
     , f_STATS_codice_ente() ente
     , c.cname nome
     , decode(substr(c.coltype,1,9), 'DATE', 'D', 'CHAR', 'T', 'TIMESTAMP', 'DT', 'NUMBER', 'I', 'VARCHAR2', 'T') tipo_campo
     , 'COUNT' tipo_funzione
     , sv.id id_vista
     , 0 sequenza
  from stats_viste sv
     , col c
 where sv.nome = f_STATS_nome_vista(c.tname,'P')
   and (c.tname in ('ANAVBI','ANAVBI_TOTALE','ANAVBI_STORICO','ANAVMO','ANASTA_V')
        or c.tname like 'ANAVXX_%')
   and c.cname = 'MATRICOLA'
 order by 1,2,3
;

w_versione		number        := 0;
w_data_creazione	date          := sysdate;
w_data_aggiornamento	date          := sysdate;
w_utente_creazione	varchar2(255) := 'ADS';
w_utente_aggiornamento	varchar2(255) := 'ADS';

begin
  for rec in sel_viste loop
      begin
        insert into stats_campi_viste
               (ID, VERSION, DATA_CREAZIONE, DESCRIZIONE, ENTE, DATA_AGGIORNAMENTO, NOME,
                TIPO_CAMPO, TIPO_FUNZIONE, UTENTE_CREAZIONE, UTENTE_AGGIORNAMENTO, ID_VISTA,
                SEQUENZA)
        select stats_hibernate_sequence.nextval id
             , w_versione
             , w_data_creazione
             , rec.descrizione
             , rec.ente
             , w_data_aggiornamento
             , rec.nome
             , rec.tipo_campo
             , rec.tipo_funzione
             , w_utente_creazione
             , w_utente_aggiornamento
             , rec.id_vista
             , rec.sequenza
          from dual
         where not exists (select 1 from stats_campi_viste cv
                            where cv.id_vista      = rec.id_vista
                              and cv.nome          = rec.nome
                              and cv.tipo_funzione = rec.tipo_funzione)
        ;
      exception
        when others then
             null;
      end;
  end loop;
end;
/
update stats_campi_viste cv
   set sequenza = 0
 where tipo_funzione != 'NO_OP'
   and nvl(sequenza,999) > 0
   and id_vista in (select id from stats_viste where nome in ('GSD_INDIVIDUI_ANA',
                                                              'GSD_INDIVIDUI_ANA_STORICO',
                                                              'GSD_INDIVIDUI_ANA_TOTALE',
                                                              'GSD_MOVIMENTI_ANA',
                                                              'GSD_STATISTICHE_ANA',
                                                              'GSD_INDIVIDUI_ANA_P',
                                                              'GSD_INDIVIDUI_ANA_STORICO_P',
                                                              'GSD_INDIVIDUI_ANA_TOTALE_P',
                                                              'GSD_MOVIMENTI_ANA_P',
                                                              'GSD_STATISTICHE_ANA_P'))
/
update stats_campi_viste cv
   set sequenza = (select c.colno*10 from stats_viste v, col c
                    where v.id = cv.id_vista
                      and c.tname = decode(v.nome,'GSD_INDIVIDUI_ANA',           'ANAVBI',
                                                  'GSD_INDIVIDUI_ANA_STORICO',   'ANAVBI_STORICO',
                                                  'GSD_INDIVIDUI_ANA_TOTALE',    'ANAVBI_TOTALE',
                                                  'GSD_MOVIMENTI_ANA',           'ANAVMO',
                                                  'GSD_STATISTICHE_ANA',         'ANASTA_V',
                                                  'GSD_INDIVIDUI_ANA_P',         'ANAVBI',
                                                  'GSD_INDIVIDUI_ANA_STORICO_P', 'ANAVBI_STORICO',
                                                  'GSD_INDIVIDUI_ANA_TOTALE_P',  'ANAVBI_TOTALE',
                                                  'GSD_MOVIMENTI_ANA_P',         'ANAVMO',
                                                  'GSD_STATISTICHE_ANA_P',       'ANASTA_V')
                      and c.cname = cv.nome)
 where nvl(sequenza,999) > 0
   and id_vista in (select id from stats_viste where nome in ('GSD_INDIVIDUI_ANA',
                                                              'GSD_INDIVIDUI_ANA_STORICO',
                                                              'GSD_INDIVIDUI_ANA_TOTALE',
                                                              'GSD_MOVIMENTI_ANA',
                                                              'GSD_STATISTICHE_ANA',
                                                              'GSD_INDIVIDUI_ANA_P',
                                                              'GSD_INDIVIDUI_ANA_STORICO_P',
                                                              'GSD_INDIVIDUI_ANA_TOTALE_P',
                                                              'GSD_MOVIMENTI_ANA_P',
                                                              'GSD_STATISTICHE_ANA_P'))
/