--liquibase formatted sql
--changeset amonopoli:202602130945_1 runOnChange:true stripComments:false
create or replace function f_LGAA_revisione_sto
(a_tipo_lista		IN	varchar2
,a_sesso		IN	varchar2
,a_progressivo		IN	number
)

return varchar2

IS

w_matricola                number;
w_anno_revisione           number;
w_revisione                varchar2(255);
w_progr_revisione          number;
w_data_verbale             number;
w_data_revisione           number;
w_tipo_movimento           varchar2(255);
w_data_ord                 number;

cursor sel_sto is
select sto.matricola, sto.anno_revisione, sto.revisione, sto.progr_revisione,
       dsr.data_verbale, dsr.data_revisione, dmo.tipo_movimento,
       nvl(dsr.data_verbale,dsr.data_revisione) data_ord
  from eledmo dmo
     , eledsr dsr
     , elesta sto
     , eleela ele
 where dmo.cod_mo (+)      = sto.motivo
   and dsr.anno            = sto.anno_revisione
   and dsr.revisione       = sto.revisione
   and dsr.progr_revisione = sto.progr_revisione
   and ele.matricola       = sto.matricola
   and ele.tipo_lista      = sto.tipo_lista
   and sto.progr_lista_gen = a_progressivo
   and sto.tipo_lista      = a_tipo_lista
 order by 8 desc
;

cursor sel_sto_next is
select sto.matricola, sto.anno_revisione, sto.revisione, sto.progr_revisione,
       nvl(dsr.data_verbale,dsr.data_revisione) data_ord
  from eledsr dsr
     , elesta sto
     , eleela ele
 where nvl(dsr.data_verbale,dsr.data_revisione) > nvl(w_data_verbale,w_data_revisione)
   and dsr.anno            = sto.anno_revisione
   and dsr.revisione       = sto.revisione
   and dsr.progr_revisione = sto.progr_revisione
   and sto.progr_lista_gen != a_progressivo
   and sto.tipo_lista      = ele.tipo_lista
   and sto.matricola       = ele.matricola
   and ele.tipo_lista      = a_tipo_lista
   and ele.matricola       = w_matricola
 order by 5
;

w_estremi_sto              varchar2(255);

begin
  if a_sesso is not null and a_progressivo is not null then
     OPEN sel_sto;
     FETCH sel_sto INTO w_matricola, w_anno_revisione, w_revisione, w_progr_revisione, w_data_verbale, w_data_revisione, w_tipo_movimento, w_data_ord;
     CLOSE sel_sto;
     w_estremi_sto := w_anno_revisione||w_revisione||lpad(w_progr_revisione,2,'0');
  end if;

  if w_tipo_movimento in ('I','E') and w_matricola is not null then
     OPEN sel_sto_next;
     FETCH sel_sto_next INTO w_matricola, w_anno_revisione, w_revisione, w_progr_revisione, w_data_ord;
     CLOSE sel_sto_next;
     w_estremi_sto := w_anno_revisione||w_revisione||lpad(w_progr_revisione,2,'0');
  end if;

  return w_estremi_sto;

end;
/
create or replace function f_LGAA_matricola_sto
(a_tipo_lista		IN	varchar2
,a_sesso		IN	varchar2
,a_progressivo		IN	number
)

return number

IS

cursor sel_sto is
select ele.matricola, nvl(dsr.data_verbale,dsr.data_revisione) data_ord
  from eledsr dsr
     , elesta sto
     , eleela ele
 where dsr.anno            = sto.anno_revisione
   and dsr.revisione       = sto.revisione
   and dsr.progr_revisione = sto.progr_revisione
   and ele.matricola       = sto.matricola
   and ele.tipo_lista      = sto.tipo_lista
   and sto.progr_lista_gen = a_progressivo
   and sto.tipo_lista      = a_tipo_lista
  order by 2 desc
;

w_matricola                number;
w_data_ord                number;

begin 
  if a_sesso is not null and a_progressivo is not null then
     OPEN sel_sto;
     FETCH sel_sto INTO w_matricola,w_data_ord;
     CLOSE sel_sto;
  end if;

  return w_matricola;

end;
/
create or replace function f_LGAA_cognome_nome_sto
(a_tipo_lista		IN	varchar2
,a_sesso		IN	varchar2
,a_progressivo		IN	number
,a_matricola		IN	number
)

return varchar2

IS

w_cognome_nome		varchar2(255);

begin
  if a_sesso is not null and a_progressivo is not null and a_matricola is not null then
     begin
       select sto.cognome_nome
         into w_cognome_nome
         from elesta sto
        where sto.progr_lista_gen = a_progressivo
          and sto.matricola       = a_matricola
          and sto.tipo_lista      = a_tipo_lista
          and rownum = 1
       ;
     end;
  end if;

  return w_cognome_nome;

end;
/
create or replace view elelgaa_v
       (tipo_lista, sesso, progr_lista_gen, anno, fascicolo, sezione, matricola,
        cognome_nome, luogo_data_nas, atto, tribunale, indirizzo,
        professione, titolo_studio, 
        emigrato, motivo_1, motivo_2, verbale_1, verbale_2, stato,
        archivio_rif)
AS
select 
-- tipo_lista
       ele.tipo_lista, 
-- sesso
       ele.sesso,
-- progr_lista_gen
       progr_lista_gen,
-- anno
       ele.anno,
-- fascicolo
       ele.fascicolo,
-- sezione 
       ele.sezione,
-- matricola
       ele.matricola,
-- cognome_nome
       translate(ele.cognome_nome,'/',' ') cognome_nome,
-- luogo_data_nas
       substr(d.descrizione,1,26)||decode(d.sigla_provincia,'','',' ('||d.sigla_provincia||')')||
         ' il '||to_char(to_date(data_nas,'j'),'dd/mm/yyyy'),
-- atto
       decode(ana.atto_nas_digitale,'',
         atto_nas||' '||parte_nas||serie_nas||' '||ufficio_nas,
         ana.atto_nas_digitale)||
         decode(ana.cod_com_atto_nas||ana.cod_pro_atto_nas,ana.cod_com_nas||ana.cod_pro_nas,'',
           decode(n.descrizione,'','',' - '||n.descrizione||decode(n.sigla_provincia,'','',' ('||n.sigla_provincia||')'))),
-- tribunale
       c.descrizione||decode(c.sigla_provincia,'','',' ('||c.sigla_provincia||')'),
-- indirizzo
       decode(cod_via_ele,'',
         via_aire_ele||' '||
           b.descrizione||decode(b.sigla_provincia,'','',' ('||b.sigla_provincia||')'),
         bvie.denom_uff||civico_esterno_ele||
           decode(f_valore_inp('INTERNO_E',1,1,'X','S'),'N','',civico_interno_ele)) indirizzo,
-- professione
       to_char(null),
-- titolo_studio
       to_char(null),
-- emigrato
       decode(ana.fascia,3,'RESIDENTE ALL''ESTERO',
                         4,'RESIDENTE ALL''ESTERO',''),
-- motivo_1
       decode(ele.stato,'E','','CANCELLAZIONE PER'),
-- motivo_2
       decode(ele.stato,'E','',substr(dmo.descrizione,1,25)),
-- verbale_1
       decode(ele.stato,'E','',decode(dsr.verbale,'','','Verbale N.'||dsr.verbale)),
-- verbale_2
       decode(ele.stato,'E','',decode(dsr.data_verbale,'','','del '||to_char(to_date(dsr.data_verbale,'j'),'dd/mm/yyyy'))),
-- stato
       ele.stato,
--
-- archivio_rif
       'ELA'
  from eledmo dmo,eledsr dsr,arcvie bvie,
       arccom b,arccom c,arccom d, arccom n,
       anaana ana,eleela ele
 where b.cod_comune    (+)   = ele.cod_com_aire_ele
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
UNION
select 
-- tipo_lista
       sto.tipo_lista,
-- sesso
       lg_x.sesso, 
-- progr_lista_gen
       lg_x.progressivo,
-- anno
       sto.anno,
-- fascicolo
       sto.fascicolo,
-- sezione
       sto.sezione,
-- matricola
       sto.matricola,
-- cognome_nome
       translate(nvl(f_LGAA_cognome_nome_sto(sto.tipo_lista,lg_x.sesso,lg_x.progressivo,sto.matricola),ele.cognome_nome),'/',' '),
-- luogo_data_nas
       substr(d.descrizione,1,26)||decode(d.sigla_provincia,'','',' ('||d.sigla_provincia||')')||
         ' il '||to_char(to_date(data_nas,'j'),'dd/mm/yyyy'),
-- atto
       decode(ana.atto_nas_digitale,'',
         atto_nas||' '||parte_nas||serie_nas||' '||ufficio_nas,
         ana.atto_nas_digitale)||
         decode(ana.cod_com_atto_nas||ana.cod_pro_atto_nas,ana.cod_com_nas||ana.cod_pro_nas,'',
         decode(n.descrizione,'','',' - '||n.descrizione||decode(n.sigla_provincia,'','',' ('||n.sigla_provincia||')'))),
-- tribunale
       c.descrizione||decode(c.sigla_provincia,'','',' ('||c.sigla_provincia||')') tribunale,
-- indirizzo
       decode(cod_via_ele,'',
         via_aire_ele||' '||
           b.descrizione||decode(b.sigla_provincia,'','',' ('||b.sigla_provincia||')'),
         bvie.denom_uff||civico_esterno_ele||
           decode(f_valore_inp('INTERNO_E',1,1,'X','S'),'N','',civico_interno_ele)),
-- professione
       to_char(null),
-- titolo_studio
       to_char(null),
-- emigrato
       decode(ana.fascia,3,'RESIDENTE ALL''ESTERO',
                         4,'RESIDENTE ALL''ESTERO','') emigrato,
-- motivo_1
       'CANCELLAZIONE PER',
-- motivo_2
       substr(dmo.descrizione,1,21),
-- verbale_1
       decode(dsr.verbale,'','','Verbale N.'||dsr.verbale),
-- verbale_2
       decode(dsr.data_verbale,'','','del '||to_char(to_date(dsr.data_verbale,'j'),'dd/mm/yyyy')),
-- stato
       'C',
--
-- archivio_rif
       'STA'
  from menuditta m,
       elelga3_n lg_x,
       eledmo dmo,eledsr dsr,arcvie bvie,
       arccom b,arccom c,arccom d, arccom n,
       anaana ana,eleela ele,elesta sto,elen02 n02
 where b.cod_comune    (+)   = ele.cod_com_aire_ele
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
         f_LGAA_revisione_sto(sto.tipo_lista,lg_x.sesso,lg_x.progressivo)
   and sto.matricola            = f_LGAA_matricola_sto(sto.tipo_lista,lg_x.sesso,lg_x.progressivo)
   and lg_x.progressivo        <= n02.numero_x
   and lg_x.sesso              = 'X'
   and not exists (select 'x'
                     from eleela e
                    where e.progr_lista_gen = lg_x.progressivo)
/
comment on table elelga3_v is 'Elettorale - Dati per Stampa Lista Generale - Aggiunte (view)'
/
