--liquibase formatted sql
--changeset amonopoli:202606081430_90 runOnChange:true stripComments:false
insert into anadep (COD_EP, DESCRIZIONE, FLAG_ON_LINE, FLAG_ESITO, FLAG_PERFEZIONAMENTO, FLAG_ANNULLAMENTO)
select 1, 'ACCERTAMENTO VIGILI', 'S', 'S', '', ''
  from dual
 where not exists (select 1 from anadep)
;
insert into anadep (COD_EP, DESCRIZIONE, FLAG_ON_LINE, FLAG_ESITO, FLAG_PERFEZIONAMENTO, FLAG_ANNULLAMENTO)
select 2, 'APR/4 A COMUNE DI PROVENIENZA', '', 'S', '', ''  from dual
 where not exists (select 1 from anadep)
;
insert into anadep (COD_EP, DESCRIZIONE, FLAG_ON_LINE, FLAG_ESITO, FLAG_PERFEZIONAMENTO, FLAG_ANNULLAMENTO)
select 3, 'APR/4 DA COMUNE DI EMIGRAZIONE', '', 'S', '', ''  from dual
 where not exists (select 1 from anadep)
;
insert into anadep (COD_EP, DESCRIZIONE, FLAG_ON_LINE, FLAG_ESITO, FLAG_PERFEZIONAMENTO, FLAG_ANNULLAMENTO)
select 4, 'CONFERMA DATI A COMUNE DI EMIGRAZIONE', '', 'S', '', ''  from dual
 where not exists (select 1 from anadep)
;
insert into anadep (COD_EP, DESCRIZIONE, FLAG_ON_LINE, FLAG_ESITO, FLAG_PERFEZIONAMENTO, FLAG_ANNULLAMENTO)
select 5, 'MOD. CONS/01 DA CONSOLATO', '', 'S', '', ''  from dual
 where not exists (select 1 from anadep)
;
insert into anadep (COD_EP, DESCRIZIONE, FLAG_ON_LINE, FLAG_ESITO, FLAG_PERFEZIONAMENTO, FLAG_ANNULLAMENTO)
select 6, 'COMUNICAZIONE A CONSOLATO', '', 'S', '', ''  from dual
 where not exists (select 1 from anadep)
;
insert into anadep (COD_EP, DESCRIZIONE, FLAG_ON_LINE, FLAG_ESITO, FLAG_PERFEZIONAMENTO, FLAG_ANNULLAMENTO)
select 7, 'PERFEZIONAMENTO', '', '', 'S', ''  from dual
 where not exists (select 1 from anadep)
;
insert into anadep (COD_EP, DESCRIZIONE, FLAG_ON_LINE, FLAG_ESITO, FLAG_PERFEZIONAMENTO, FLAG_ANNULLAMENTO)
select 8, 'ANNULLAMENTO', '', '', '', 'S'  from dual
 where not exists (select 1 from anadep)
;
insert into anadep (COD_EP, DESCRIZIONE, FLAG_ON_LINE, FLAG_ESITO, FLAG_PERFEZIONAMENTO, FLAG_ANNULLAMENTO)
select 9, 'RICHIESTA ESTRATTO DI NASCITA', '', 'S', '', ''  from dual
 where not exists (select 1 from anadep)
;
insert into anadep (COD_EP, DESCRIZIONE, FLAG_ON_LINE, FLAG_ESITO, FLAG_PERFEZIONAMENTO, FLAG_ANNULLAMENTO)
select 10, 'RICHIESTA ESTRATTO DI RUOLO MATRICOLARE', '', 'S', '', ''  from dual
 where not exists (select 1 from anadep)
;
insert into anadep (COD_EP, DESCRIZIONE, FLAG_ON_LINE, FLAG_ESITO, FLAG_PERFEZIONAMENTO, FLAG_ANNULLAMENTO)
select 11, 'NOTIFICA AVVIO PROCEDIMENTO', '', 'S', '', ''  from dual
 where not exists (select 1 from anadep)
;
insert into anadep (COD_EP, DESCRIZIONE, FLAG_ON_LINE, FLAG_ESITO, FLAG_PERFEZIONAMENTO, FLAG_ANNULLAMENTO)
select 12, 'PROVVEDIMENTO DI CANCELLAZIONE', '', 'S', '', ''  from dual
 where not exists (select 1 from anadep)
;
insert into anadep (COD_EP, DESCRIZIONE, FLAG_ON_LINE, FLAG_ESITO, FLAG_PERFEZIONAMENTO, FLAG_ANNULLAMENTO)
select 13, 'NOTIFICA ARCHIVIAZIONE PRATICA', '', 'S', '', ''  from dual
 where not exists (select 1 from anadep)
;
insert into anadep (COD_EP, DESCRIZIONE, FLAG_ON_LINE, FLAG_ESITO, FLAG_PERFEZIONAMENTO, FLAG_ANNULLAMENTO)
select 14, 'SOSPENSIONE DEI TERMINI (10BIS L.241/90)', '', 'S', '', ''  from dual
 where not exists (select 1 from anadep)
;
insert into anadep (COD_EP, DESCRIZIONE, FLAG_ON_LINE, FLAG_ESITO, FLAG_PERFEZIONAMENTO, FLAG_ANNULLAMENTO)
select 90, 'RICHIESTA WEB DEL CITTADINO', '', 'S', '', ''  from dual
 where not exists (select 1 from anadep)
;
insert into anadep (COD_EP, DESCRIZIONE, FLAG_ON_LINE, FLAG_ESITO, FLAG_PERFEZIONAMENTO, FLAG_ANNULLAMENTO)
select 91, 'RICHIESTA ANPR DEL CITTADINO', '', 'S', '', ''  from dual
 where not exists (select 1 from anadep)
;
