--liquibase formatted sql
--changeset amonopoli:202510011615 runOnChange:true stripComments:false
create or replace view anpt00 (codice, descrizione)
as
select 'SC01', 'NOTIFICA DI ISCRIZIONE'                                   from dual UNION -- (nas)
select 'SC02', 'NOTIFICA DI ISCRIZIONE O MUTAZIONE AIRE'                  from dual UNION -- (nas)
select 'SC03', 'NOTIFICA DI MUTAZIONE_ANAGRAFICA'                         from dual UNION -- (nas)
select 'SC08', 'NOTIFICA DI MUTAZIONE_CITTADINANZA'                       from dual UNION -- (cit)
select 'SC09', 'NOTIFICA DI MUTAZIONE_ACQUISISCI_MATRIMONIO_STATO_CIVILE' from dual UNION -- (mat)
select 'SC10', 'NOTIFICA DI MUTAZIONE_ANNULLA_MATRIMONIO_STATO_CIVILE'    from dual UNION -- (mat)
select 'SC11', 'NOTIFICA DI MUTAZIONE_UNIONE_CIVILE'                      from dual UNION -- (uci)
select 'SC15', 'NOTIFICA DI CANCELLAZIONE_DECESSO_VEDOVANZA'              from dual UNION -- (mor)
select 'SC16', 'NOTIFICA GENERICA'                                        from dual UNION --
select 'SC17', 'NOTIFICA DI RETTIFICA'                                    from dual UNION --
select 'SC18', 'NOTIFICA DI DISCORDANZA ANAGRAFICA'                       from dual 
/
comment on table anpt00 is 'ANPR - Codici di Notifiche ANSC (view)'
/
