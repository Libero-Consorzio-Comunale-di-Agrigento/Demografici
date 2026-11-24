--liquibase formatted sql
--changeset amonopoli:202603161050 runOnChange:true stripComments:false
create or replace view eletim_var
       (variabile, sequenza)
as
select '<COMMISSIONE>'        , 1  from dual UNION
select '<DATA_RIF_SEMESTRALE>', 2  from dual UNION
select '<DATA_BLOCCO_LISTE>'  , 3  from dual UNION
select '<DATA_ELEZIONI>'      , 4  from dual UNION
select '<FIRMA>'              , 5  from dual UNION
select '<VERBALE>'            , 6  from dual UNION
select '<DATA_VERBALE>'       , 7  from dual UNION
select '<DATA_BLOCCO_LISTE>'  , 8  from dual UNION
select '<ELETTORI_ELETTRICI>' , 9  from dual UNION
select '<TOT_ISCRITTI>'       , 10 from dual UNION 
select '<TOT_VOTANTI>'        , 11 from dual UNION
select '<NUMERO_PAGINE>'      , 12 from dual UNION
select '<COMUNE>'             , 13 from dual UNION
select '<SOLO_COMUNE>'        , 14 from dual UNION
select '<DATA_OGGI>'          , 15 from dual UNION
select '<SEZIONE>'            , 16 from dual 
/
comment on table eletim_var is 'Elettorale - Variabili per composizione Timbri Liste'
/


