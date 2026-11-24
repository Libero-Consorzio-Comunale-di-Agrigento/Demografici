--liquibase formatted sql
--changeset amonopoli:202603191245_2 runOnChange:true stripComments:false
delete arcdnc
 where elemento in ('FLAG_METRICO','PROGR_SNC','FLAG_LETTERA','FLAG_ESPONENTE','COLORE','SCALA_ESTERNA',
                    'FLAG_NUI','NUI','CORTE','INTERNO2','SUB_INTERNO2','SECONDARIO')
/
insert into arcdnc 
       (ELEMENTO, FLAG_ESTERNO, FLAG_INTERNO, SEQUENZA, SEPARATORE, FLAG_VISIBILE, FLAG_DEFAULT, COD_VIA, ID, VERSION, D_DATA_ULT_AGG, TERMINALISTA)
select 'FLAG_METRICO', 'S', '', 15, '', '',  '', '', ARCDNC_SQ.nextVal, 0, sysdate, ''
  from dual
 where not exists (select 'x' from arcdnc b
                    where b.elemento = 'FLAG_METRICO')
/
insert into arcdnc 
       (ELEMENTO, FLAG_ESTERNO, FLAG_INTERNO, SEQUENZA, SEPARATORE, FLAG_VISIBILE, FLAG_DEFAULT, COD_VIA, ID, VERSION, D_DATA_ULT_AGG, TERMINALISTA)
select 'PROGR_SNC', 'S', '', 17, ' SNC ', '', '', '', ARCDNC_SQ.nextVal, 0, sysdate, ''
  from dual
 where not exists (select 'x' from arcdnc b
                    where b.elemento = 'PROGR_SNC')
/
insert into arcdnc 
       (ELEMENTO, FLAG_ESTERNO, FLAG_INTERNO, SEQUENZA, SEPARATORE, FLAG_VISIBILE, FLAG_DEFAULT, COD_VIA, ID, VERSION, D_DATA_ULT_AGG, TERMINALISTA)
select 'FLAG_LETTERA', 'S', '', 25, '', '', 'S', '', ARCDNC_SQ.nextVal, 0, sysdate, ''
  from dual
 where not exists (select 'x' from arcdnc b
                    where b.elemento = 'FLAG_LETTERA')
/
insert into arcdnc 
       (ELEMENTO, FLAG_ESTERNO, FLAG_INTERNO, SEQUENZA, SEPARATORE, FLAG_VISIBILE, FLAG_DEFAULT, COD_VIA, ID, VERSION, D_DATA_ULT_AGG, TERMINALISTA)
select 'FLAG_ESPONENTE', 'S', '', 27, '', '', '', '', ARCDNC_SQ.nextVal, 0, sysdate, ''
  from dual
 where not exists (select 'x' from arcdnc b
                    where b.elemento = 'FLAG_ESPONENTE')
/
insert into arcdnc 
       (ELEMENTO, FLAG_ESTERNO, FLAG_INTERNO, SEQUENZA, SEPARATORE, FLAG_VISIBILE, FLAG_DEFAULT, COD_VIA, ID, VERSION, D_DATA_ULT_AGG, TERMINALISTA)
select 'SCALA_ESTERNA', 'S', '', 30, '', '', '', '', ARCDNC_SQ.nextVal, 0, sysdate, ''
  from dual
 where not exists (select 'x' from arcdnc b
                    where b.elemento = 'SCALA_ESTERNA')
/
insert into arcdnc 
       (ELEMENTO, FLAG_ESTERNO, FLAG_INTERNO, SEQUENZA, SEPARATORE, FLAG_VISIBILE, FLAG_DEFAULT, COD_VIA, ID, VERSION, D_DATA_ULT_AGG, TERMINALISTA)
select 'COLORE', 'S', '', 40, '', '', '', '', ARCDNC_SQ.nextVal, 0, sysdate, ''
  from dual
 where not exists (select 'x' from arcdnc b
                    where b.elemento = 'COLORE')
/
insert into arcdnc 
       (ELEMENTO, FLAG_ESTERNO, FLAG_INTERNO, SEQUENZA, SEPARATORE, FLAG_VISIBILE, FLAG_DEFAULT, COD_VIA, ID, VERSION, D_DATA_ULT_AGG, TERMINALISTA)
select 'FLAG_NUI', '', 'S', 15, '', '', '', '', ARCDNC_SQ.nextVal, 0, sysdate, ''
  from dual
 where not exists (select 'x' from arcdnc b
                    where b.elemento = 'FLAG_NUI')
   and not exists (select 'x' from anpinp c
                    where c.parametro = 'INTERNO_NUI'
                      and upper(substr(c.valore,1,1)) = 'S')
/
insert into arcdnc 
       (ELEMENTO, FLAG_ESTERNO, FLAG_INTERNO, SEQUENZA, SEPARATORE, FLAG_VISIBILE, FLAG_DEFAULT, COD_VIA, ID, VERSION, D_DATA_ULT_AGG, TERMINALISTA)
select 'FLAG_NUI', '', 'S', 15, '', '', 'S', '', ARCDNC_SQ.nextVal, 0, sysdate, ''
  from dual
 where not exists (select 'x' from arcdnc b
                    where b.elemento = 'FLAG_NUI')
   and exists (select 'x' from anpinp c
                where c.parametro = 'INTERNO_NUI'
                  and upper(substr(valore,1,1)) = 'S')
/
insert into arcdnc 
       (ELEMENTO, FLAG_ESTERNO, FLAG_INTERNO, SEQUENZA, SEPARATORE, FLAG_VISIBILE, FLAG_DEFAULT, COD_VIA, ID, VERSION, D_DATA_ULT_AGG, TERMINALISTA)
select 'NUI', '', 'S', 25, ' NUI ', '', '', '', ARCDNC_SQ.nextVal, 0, sysdate, ''
  from dual
 where not exists (select 'x' from arcdnc b
                    where b.elemento = 'NUI')
/
insert into arcdnc 
       (ELEMENTO, FLAG_ESTERNO, FLAG_INTERNO, SEQUENZA, SEPARATORE, FLAG_VISIBILE, FLAG_DEFAULT, COD_VIA, ID, VERSION, D_DATA_ULT_AGG, TERMINALISTA)
select 'CORTE', '', 'S', 50, ' corte ', '', '', '', ARCDNC_SQ.nextVal, 0, sysdate, ''
  from dual
 where not exists (select 'x' from arcdnc b
                    where b.elemento = 'CORTE')
/
insert into arcdnc 
       (ELEMENTO, FLAG_ESTERNO, FLAG_INTERNO, SEQUENZA, SEPARATORE, FLAG_VISIBILE, FLAG_DEFAULT, COD_VIA, ID, VERSION, D_DATA_ULT_AGG, TERMINALISTA)
select 'INTERNO2', '', 'S', 60, ' Int.(2)', '', '', '', ARCDNC_SQ.nextVal, 0, sysdate, ''
  from dual
 where not exists (select 'x' from arcdnc b
                    where b.elemento = 'INTERNO2')
/
insert into arcdnc 
       (ELEMENTO, FLAG_ESTERNO, FLAG_INTERNO, SEQUENZA, SEPARATORE, FLAG_VISIBILE, FLAG_DEFAULT, COD_VIA, ID, VERSION, D_DATA_ULT_AGG, TERMINALISTA)
select 'SUB_INTERNO2', '', 'S', 70, '/', '', '', '', ARCDNC_SQ.nextVal, 0, sysdate, ''
  from dual
 where not exists (select 'x' from arcdnc b
                    where b.elemento = 'SUB_INTERNO2')
/
insert into arcdnc 
       (ELEMENTO, FLAG_ESTERNO, FLAG_INTERNO, SEQUENZA, SEPARATORE, FLAG_VISIBILE, FLAG_DEFAULT, COD_VIA, ID, VERSION, D_DATA_ULT_AGG, TERMINALISTA)
select 'SECONDARIO', '', 'S', 80, ' sec. ', '', '', '', ARCDNC_SQ.nextVal, 0, sysdate, ''
  from dual
 where not exists (select 'x' from arcdnc b
                    where b.elemento = 'SECONDARIO')
/
