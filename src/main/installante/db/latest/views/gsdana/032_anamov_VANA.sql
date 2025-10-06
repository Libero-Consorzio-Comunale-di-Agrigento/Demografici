--liquibase formatted sql
--changeset amonopoli:202504021205 runAlways:true runOnChange:true stripComments:false
create or replace view anamov_VANA
AS
/*
20/07/2018 A.Monopoli: iscrizione preliminare (1-17) con accertamenti negativi (2-62) compare in Storico Ana?
(non ha mai funzionato la visualizzazione dei 2-51, ripristinati, perche'' cercava cod_eve = 52)
*/
select mov.*
     , f_SEN_privacy(mov.matricola,mov.anno_progr,mov.numero_progr) SEN_privacy   
  from anamov_v mov
 where ((cod_mov not in (1,2,3,4,5,10,11,12,13) 
        or (cod_eve in (1,50))						-- nascita / morte
        )
       or ((cod_mov = 2 and cod_eve = 62)				-- accertamenti negativi
           or (cod_mov = 1 and cod_eve in (4,17)			-- iscrizione preliminare / reimmi aire con accertamenti negativi
              and exists (select 1
                            from anamov b
                           where b.cod_mov      = 2 
                             and b.cod_eve      = 62	
                             and b.matricola    = mov.matricola
                             and b.anno_pratica = mov.anno_pratica
                             and b.pratica      = mov.pratica)
              )
           or (cod_mov = 1 and cod_eve = 18)				-- ripristino posizione anagrafica
           or (cod_mov = 2 and cod_eve = 51				-- emigrazione c/ripristino
              and exists (select 1
                            from anamov b
                           where b.cod_mov      = 1 
                             and b.cod_eve      = 18
                             and b.matricola    = mov.matricola
                             and b.anno_pratica = mov.anno_pratica
                             and b.pratica      = mov.pratica)
              )
          )
       )
   and mov.no_vana is null
/
comment on table anamov_VANA is 'VANA - Elenco Variazioni - con filtro - per Visualizzazione (view)'
/
