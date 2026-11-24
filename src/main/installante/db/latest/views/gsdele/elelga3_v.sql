--liquibase formatted sql
--changeset amonopoli:202602121600_1 runOnChange:true stripComments:false
create or replace view elelga3_v
       (sesso, progr_lista_gen, anno, fascicolo, sezione, matricola,
        cognome_nome, luogo_data_nas, atto, tribunale, indirizzo,
        professione, titolo_studio, emigrato, motivo_1, motivo_2,
        verbale_1, verbale_2, stato)
AS
select ele.sesso sesso,progr_lista_gen progr_lista_gen,
       ele.anno anno,ele.fascicolo fascicolo,ele.sezione,ele.matricola,
       translate(ele.cognome_nome,'/',' ') cognome_nome,
       substr(d.descrizione,1,26)||decode(d.sigla_provincia,'','',' ('||d.sigla_provincia||')')||
         ' il '||to_char(to_date(data_nas,'j'),'dd/mm/yyyy') luogo_data_nas,
       decode(ana.atto_nas_digitale,'',
         atto_nas||' '||parte_nas||serie_nas||' '||ufficio_nas,
         ana.atto_nas_digitale)||
         decode(ana.cod_com_atto_nas||ana.cod_pro_atto_nas,ana.cod_com_nas||ana.cod_pro_nas,'',
           decode(n.descrizione,'','',' - '||n.descrizione||decode(n.sigla_provincia,'','',' ('||n.sigla_provincia||')'))) atto,
       c.descrizione||decode(c.sigla_provincia,'','',' ('||c.sigla_provincia||')') tribunale,
       decode(cod_via_ele,'',
         via_aire_ele||' '||
           b.descrizione||decode(b.sigla_provincia,'','',' ('||b.sigla_provincia||')'),
         bvie.denom_uff||civico_esterno_ele||
           decode(f_valore_inp('INTERNO_E',1,1,'X','S'),'N','',civico_interno_ele)) indirizzo,
       to_char(null) professione,
       nvl(anadts.descrizione,' ') titolo_studio,
       decode(ana.fascia,3,'RESIDENTE ALL''ESTERO',
                         4,'RESIDENTE ALL''ESTERO','') emigrato,
       decode(ele.stato,'E','','CANCELLAZIONE PER') motivo_1,
       decode(ele.stato,'E','',substr(dmo.descrizione,1,25)) motivo_2,
       decode(ele.stato,'E','',decode(dsr.verbale,'','','Verbale N.'||dsr.verbale)) verbale_1,
       decode(ele.stato,'E','',decode(dsr.data_verbale,'','','del '||to_char(to_date(dsr.data_verbale,'j'),'dd/mm/yyyy')))verbale_2,
       ele.stato
  from anadts,anadpr,eledmo dmo,eledsr dsr,arcvie bvie,
       arccom b,arccom c,arccom d, arccom n,
       anaana ana,eleana ele
 where anadts.cod_ts      (+)   = ana.titolo_studio
   and anadpr.sesso       (+) = ana.sesso
   and anadpr.cod_pr      (+)   = ana.cod_prof
   and b.cod_comune    (+)   = ele.cod_com_aire_ele
   and b.cod_provincia (+)   = ele.cod_pro_aire_ele
   and bvie.cod_via       (+)   = ele.cod_via_ele
   and c.cod_comune    (+)   = substr(lpad(d.tribunale,6,0),4,3)
   and c.cod_provincia (+)   = substr(lpad(d.tribunale,6,0),1,3)
   and d.cod_comune    (+)   = ana.cod_com_nas
   and d.cod_provincia (+)   = ana.cod_pro_nas
   and n.cod_comune    (+)   = ana.cod_com_atto_nas
   and n.cod_provincia (+)   = ana.cod_pro_atto_nas
   and dmo.cod_mo               = ele.motivo
   and dsr.anno        (+)      = ele.anno
   and dsr.revisione   (+)      = ele.revisione
   and dsr.progr_revisione (+)  = ele.progr_revisione
   and ana.matricola            = ele.matricola
   and ele.progr_lista_gen      is not null
   and not exists (select 'x'
                     from elemov mov
                    where ele.matricola         = mov.matricola
                      and tipo_movimento        in ('E')
                      and progr_riassegnato  = 1)
UNION
select ana.sesso,
       ele.progr_lista_gen,ele.anno,ele.fascicolo,
       mov.sezione,mov.matricola,
       translate(ana.cognome_nome,'/',' '),
       d.descrizione||decode(d.sigla_provincia,'','',' ('||d.sigla_provincia||')')||
         ' il '||to_char(to_date(data_nas,'j'),'dd/mm/yyyy'),
       decode(ana.atto_nas_digitale,'',
         atto_nas||' '||parte_nas||serie_nas||' '||ufficio_nas,
         atto_nas_digitale)||
         decode(ana.cod_com_atto_nas||ana.cod_pro_atto_nas,ana.cod_com_nas||ana.cod_pro_nas,'',
           decode(n.descrizione,'','',' - '||n.descrizione||decode(n.sigla_provincia,'','',' ('||n.sigla_provincia||')'))) atto,
       c.descrizione||decode(c.sigla_provincia,'','',' ('||c.sigla_provincia||')'),
       decode(cod_via_ele,'',
         via_aire_ele||' '||b.descrizione||
           decode(b.sigla_provincia,'','',' ('||b.sigla_provincia||')'),
         bvie.denom_uff||civico_esterno_ele||
           decode(f_valore_inp('INTERNO_E',1,1,'X','S'),'N','',civico_interno_ele)),
       to_char(null) professione,
       nvl(anadts.descrizione,' '),
       decode(ana.fascia,3,'RESIDENTE ALL''ESTERO',
                         4,'RESIDENTE ALL''ESTERO',''),
       '','','','', ele.stato
  from anadts,anadpr,arcvie bvie,
       arccom b,arccom c,arccom d, arccom n,
       anaana ana,eleana ele,elemov mov
 where anadts.cod_ts   (+)   = ana.titolo_studio
   and anadpr.sesso   (+)      = ana.sesso
   and anadpr.cod_pr   (+)   = ana.cod_prof
   and b.cod_comune    (+)   = cod_com_aire_ele
   and b.cod_provincia (+)   = cod_pro_aire_ele
   and bvie.cod_via    (+)   = cod_via_ele
   and c.cod_comune    (+)   = substr(lpad(d.tribunale,6,0),4,3)
   and c.cod_provincia (+)   = substr(lpad(d.tribunale,6,0),1,3)
   and d.cod_comune    (+)   = ana.cod_com_nas
   and d.cod_provincia (+)   = ana.cod_pro_nas
   and n.cod_comune    (+)   = ana.cod_com_atto_nas
   and n.cod_provincia (+)   = ana.cod_pro_atto_nas
   and ele.matricola   (+)   = mov.matricola
   and ana.matricola         = mov.matricola
   and mov.tipo_movimento    = 'E'
   and mov.revisione         = 'SE'
   and mov.progr_riassegnato = 1
UNION
select lg_x.sesso, 
       lg_x.progressivo progr_lista_gen,
       sto.anno anno,sto.fascicolo fascicolo,sto.sezione,sto.matricola,
       translate(nvl(f_LGA3_cognome_nome_sto(lg_x.sesso,lg_x.progressivo,sto.matricola),ele.cognome_nome),'/',' ') cognome_nome,
       substr(d.descrizione,1,26)||decode(d.sigla_provincia,'','',' ('||d.sigla_provincia||')')||
         ' il '||to_char(to_date(data_nas,'j'),'dd/mm/yyyy') luogo_data_nas,
       decode(ana.atto_nas_digitale,'',
         atto_nas||' '||parte_nas||serie_nas||' '||ufficio_nas,
         ana.atto_nas_digitale)||
         decode(ana.cod_com_atto_nas||ana.cod_pro_atto_nas,ana.cod_com_nas||ana.cod_pro_nas,'',
         decode(n.descrizione,'','',' - '||n.descrizione||decode(n.sigla_provincia,'','',' ('||n.sigla_provincia||')'))) atto,
       c.descrizione||decode(c.sigla_provincia,'','',' ('||c.sigla_provincia||')') tribunale,
       decode(cod_via_ele,'',
         via_aire_ele||' '||
           b.descrizione||decode(b.sigla_provincia,'','',' ('||b.sigla_provincia||')'),
         bvie.denom_uff||civico_esterno_ele||
           decode(f_valore_inp('INTERNO_E',1,1,'X','S'),'N','',civico_interno_ele)) indirizzo,
       to_char(null) professione,
       nvl(anadts.descrizione,' ') titolo_studio,
       decode(ana.fascia,3,'RESIDENTE ALL''ESTERO',
                         4,'RESIDENTE ALL''ESTERO','') emigrato,
       'CANCELLAZIONE PER' motivo_1,
       substr(dmo.descrizione,1,21) motivo_2,
       decode(dsr.verbale,'','','Verbale N.'||dsr.verbale) verbale_1,
       decode(dsr.data_verbale,'','','del '||to_char(to_date(dsr.data_verbale,'j'),'dd/mm/yyyy'))  verbale_2,
       'C'
  from menuditta m,
       elelga3_n lg_x,
       anadts,anadpr,eledmo dmo,eledsr dsr,arcvie bvie,
       arccom b,arccom c,arccom d, arccom n,
       anaana ana,eleana ele,elesto sto,elen02 n02
 where anadts.cod_ts      (+)   = ana.titolo_studio
   and anadpr.sesso       (+) = ana.sesso
   and anadpr.cod_pr      (+)   = ana.cod_prof
   and b.cod_comune    (+)   = ele.cod_com_aire_ele
   and b.cod_provincia (+)   = ele.cod_pro_aire_ele
   and bvie.cod_via       (+)   = ele.cod_via_ele
   and c.cod_comune    (+)   = substr(lpad(d.tribunale,6,0),4,3)
   and c.cod_provincia (+)   = substr(lpad(d.tribunale,6,0),1,3)
   and d.cod_comune    (+)   = ana.cod_com_nas
   and d.cod_provincia (+)   = ana.cod_pro_nas
   and n.cod_comune    (+)   = ana.cod_com_atto_nas
   and n.cod_provincia (+)   = ana.cod_pro_atto_nas
   and dmo.cod_mo      (+)         = sto.motivo
   and dsr.anno        (+)      = sto.anno_revisione
   and dsr.revisione   (+)      = sto.revisione
   and dsr.progr_revisione (+)  = sto.progr_revisione
   and ana.matricola            = sto.matricola
   and ele.matricola            = sto.matricola
   and sto.anno_revisione||sto.revisione||lpad(sto.progr_revisione,2,'0') =
         f_LGA3_revisione_sto(lg_x.sesso,lg_x.progressivo)
   and sto.matricola            = f_LGA3_matricola_sto(lg_x.sesso,lg_x.progressivo)
   and lg_x.progressivo        <= n02.numero_x
   and lg_x.sesso              = 'X'
   and not exists (select 'x'
                     from eleana e
                    where e.progr_lista_gen = lg_x.progressivo)
order by 2,7
/
comment on table elelga3_v is 'Elettorale - Dati per Stampa Lista Generale (view)'
/
