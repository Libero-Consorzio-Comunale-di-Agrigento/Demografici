--liquibase formatted sql
--changeset amonopoli:202512190840_5 runOnChange:true stripComments:false
create or replace function f_TPR_get_matricola_min
(a_anagrafe 	IN  varchar2
,a_tipo_evento  IN  varchar2
,a_anno_pratica IN  number
,a_pratica  	IN  number
,a_anno_dic	IN  number
,a_numero_dic  	IN  number
)

return number

IS

w_anagrafe  	varchar2(255) := upper(a_anagrafe);
w_tipo_evento 	varchar2(255) := upper(a_tipo_evento);
w_anno_pratica	number := a_anno_pratica;
w_pratica 	number := a_pratica;
w_anno_dic	number := a_anno_dic;
w_numero_dic 	number := a_numero_dic;

cursor sel_min is
select apm.matricola, nvl(apm.nuova_sequenza_par,apm.sequenza_par_prec)
  from anaapm apm
 where apm.flag_soggetto     = 'S'
   and apm.annullamento      is null
   and apm.anno_dic          = w_anno_dic
   and apm.numero_dic        = w_numero_dic
   and w_anagrafe            = 'RES'	
   and w_tipo_evento         = 'I'
UNION
select cpm.matricola, ana.sequenza_par
  from anaana ana, anacpm cpm
 where ana.matricola         = cpm.matricola
   and cpm.flag_soggetto     = 'S'
   and cpm.annullamento      is null
   and cpm.anno_dic          = w_anno_dic
   and cpm.numero_dic        = w_numero_dic
   and w_anagrafe            = 'RES'	
   and w_tipo_evento         = 'C'
UNION
select crm.matricola, nvl(crm.nuova_sequenza_par,crm.sequenza_par_prec)
  from anacrm crm
 where crm.flag_soggetto     = 'S'
   and crm.flag_annullamento is null
   and crm.anno_pratica      = w_anno_pratica
   and crm.pratica           = w_pratica
   and w_anagrafe            = 'RES'	
   and w_tipo_evento         = 'E'
UNION
select rem.matricola, nvl(rem.nuova_sequenza_par,rem.sequenza_par_prec)
  from anarem rem
 where rem.flag_soggetto     = 'S'
   and rem.flag_annullamento is null
   and rem.anno_pratica      = w_anno_pratica
   and rem.pratica           = w_pratica
   and w_anagrafe            = 'RES'	
   and w_tipo_evento         = 'R'
UNION
select a0m.matricola, nvl(a0m.nuova_sequenza_par,a0m.sequenza_par_prec)
  from anaa0m a0m
 where a0m.flag_soggetto        = 'S'
   and a0m.flag_annullamento    is null
   and a0m.anno_protocollo_aire = w_anno_pratica
   and a0m.protocollo_aire      = w_pratica
   and w_anagrafe               = 'AIR'	
   and w_tipo_evento            = 'I'
   and a0m.anno_pratica||a0m.pratica is null
UNION
select c0m.matricola, ana.sequenza_par
  from anaana ana, anac0m c0m
 where ana.matricola            = c0m.matricola
   and c0m.flag_soggetto        = 'S'
   and c0m.annullamento         is null
   and c0m.anno_protocollo_aire = w_anno_pratica
   and c0m.protocollo_aire      = w_pratica
   and w_anagrafe               = 'AIR'	
   and w_tipo_evento            = 'C'
   and c0m.anno_pratica||c0m.pratica is null
UNION
select cam.matricola, nvl(cam.nuova_sequenza_par,cam.sequenza_par_prec)
  from anacam cam
 where cam.flag_soggetto        = 'S'
   and cam.flag_annullamento    is null
   and cam.anno_protocollo_aire = w_anno_pratica
   and cam.protocollo_aire      = w_pratica
   and w_anagrafe               = 'AIR'	
   and w_tipo_evento            = 'E'
 order by 2, 1 
;

w_matricola  	number;
w_sequenza	number;

begin
  if a_anagrafe is not null and a_tipo_evento is not null and a_anno_pratica is not null and a_pratica is not null then
     OPEN sel_min;
     FETCH sel_min INTO w_matricola, w_sequenza;
     CLOSE sel_min;
  end if;

  return w_matricola;

end;
/
