--liquibase formatted sql
--changeset amonopoli:202502241255_1 runOnChange:true stripComments:false
CREATE OR REPLACE function f_stato_interno
(a_cod_via          	IN  	number,
 a_num_civ		IN	number,
 a_suffisso		IN	varchar2,
 a_interno		IN	number,
 a_sub_interno		IN	varchar2,
 a_scala		IN	varchar2,
 a_cod_fam		IN 	number,
 a_piano		IN	varchar2	default null
)

return varchar2

IS

w_stato	varchar2(200);

begin
  begin
   select 'Occupato' stato
     into w_stato
     from dual
    where exists (select 'X'
                    from anaana ana, anafam fam
                   where ana.fascia		= fam.fascia
		     and ana.cod_fam		= fam.cod_fam
		     and fam.cod_via		= a_cod_via
                     and nvl(fam.num_civ,0) 	= nvl(a_num_civ,0)
                     and nvl(fam.suffisso,' ')	= nvl(a_suffisso,' ')
                     and nvl(fam.interno,0)	= nvl(a_interno,0)
		     and nvl(fam.sub_interno,' ') = nvl(a_sub_interno,' ')
		     and nvl(fam.scala,' ')	= nvl(a_scala,' ')
		     and nvl(fam.piano,' ')	= nvl(a_piano,' ')
                     and fam.fascia 		= 1)
   union
   select 'Libero' stato
     from dual
    where not exists (select 'X'
                        from anaana ana, anafam fam
                       where ana.fascia			= fam.fascia
			 and ana.cod_fam		= fam.cod_fam
			 and fam.cod_via		= a_cod_via
                         and nvl(fam.num_civ,0) 	= nvl(a_num_civ,0)
                         and nvl(fam.suffisso,' ')	= nvl(a_suffisso,' ')
                         and nvl(fam.interno,0) 	= nvl(a_interno,0)
                         and nvl(fam.sub_interno,' ') 	= nvl(a_sub_interno,' ')
			 and nvl(fam.scala,' ')		= nvl(a_scala,' ')
			 and nvl(fam.piano,' ')		= nvl(a_piano,' ')
                         and fam.fascia 		= 1);
  exception
    when others then
      w_stato := null;
  end;
  if w_stato is null or upper(w_stato) = upper('Libero') then
    /* ricerca per prenotazione */
    begin
      select 'Prenotato'
        into w_stato
  	from dual
       where exists (select 'X'
   		       from anacrm crm, anacre cre, anatpr tpr
                      where cre.cod_via		   	= a_cod_via
                        and nvl(cre.num_civ,0)     	= nvl(a_num_civ,0)
                        and nvl(cre.suffisso,' ')  	= nvl(a_suffisso,' ')
                        and nvl(cre.interno,0)     	= nvl(a_interno,0)
                        and nvl(cre.sub_interno,' ')     	= nvl(a_sub_interno,' ')
		        and nvl(cre.scala,' ')		= nvl(a_scala,' ')
		        and nvl(cre.piano,' ')		= nvl(a_piano,' ')
                        and nvl(cre.cod_fam_dest,0)	= nvl(a_cod_fam,nvl(cre.cod_fam_dest,0))
  	  	        and crm.anno_pratica		= cre.anno_pratica
			and crm.pratica			= cre.pratica
			and crm.flag_soggetto		is not null
			and crm.flag_annullamento	is null
                        and cre.flag_aggregazione 	is null
                        and cre.anno_pratica 		= tpr.anno_pratica
                        and cre.pratica 		= tpr.pratica
                        and tpr.flag_perfezionamento 	is null
                        and tpr.flag_annullamento 	is null
			and tpr.tipo_evento 		= 'E'
                        and tpr.anagrafe 		= 'RES')
          or exists (select 'X'
                       from anaapm apm, anaap4 ap4,anatpr tpr
                      where ap4.cod_via		  	= a_cod_via
                        and nvl(ap4.num_civ,0)    	= nvl(a_num_civ,0)
                        and nvl(ap4.suffisso,' ') 	= nvl(a_suffisso,' ')
                        and nvl(ap4.interno,0)    	= nvl(a_interno,0)
                        and nvl(ap4.sub_interno,' ')    	= nvl(a_sub_interno,' ')
			and nvl(ap4.scala,' ')		= nvl(a_scala,' ')
			and nvl(ap4.piano,' ')		= nvl(a_piano,' ')
                        and nvl(ap4.cod_fam_dest,0)	= nvl(a_cod_fam,nvl(ap4.cod_fam_dest,0))
			and apm.anno_dic		= ap4.anno_dic
			and apm.numero_dic		= ap4.numero_dic
			and apm.annullamento		is null
                        and ap4.flag_aggregazione 	is null
                        and ap4.anno_dic 		= tpr.anno_pratica
                        and ap4.numero_dic		= tpr.pratica
                        and tpr.flag_perfezionamento 	is null
                        and tpr.flag_annullamento 	is null
                        and tpr.tipo_evento 		= 'I'
                        and tpr.anagrafe 		= 'RES');
    exception
      when others then
         null;
    end;
  else
    begin
      select 'In Cancellazione'
        into w_stato
        from dual
       where exists (select 'X'
                       from anacrm crm, anacre cre, anafam fam, anatpr tpr
                      where fam.cod_via		   	= a_cod_via
                        and nvl(fam.num_civ,0)     	= nvl(a_num_civ,0)
                        and nvl(fam.suffisso,' ')  	= nvl(a_suffisso,' ')
                        and nvl(fam.interno,0)     	= nvl(a_interno,0)
                        and nvl(fam.sub_interno,' ')     	= nvl(a_sub_interno,' ')
			and nvl(fam.scala,' ')		= nvl(a_scala,' ')
			and nvl(fam.piano,' ')		= nvl(a_piano,' ')
                        and fam.cod_fam                 = nvl(a_cod_fam,fam.cod_fam)
  	  	        and crm.anno_pratica		= cre.anno_pratica
			and crm.pratica			= cre.pratica
			and crm.flag_soggetto		is not null
			and crm.flag_annullamento	is null
                        and cre.flag_intero_nucleo 	is not null
                        and cre.cod_fam_prov 		is not null
                        and fam.fascia	 		= 1
                        and fam.cod_fam 		= cre.cod_fam_prov
                        and tpr.anno_pratica 		= cre.anno_pratica
                        and tpr.pratica 		= cre.pratica
                        and tpr.flag_perfezionamento 	is null
                        and tpr.flag_annullamento	is null
                        and tpr.tipo_evento 		= 'E'
                        and tpr.anagrafe 		= 'RES')
           or exists (select 'X'
                        from anacpm cpm, anacp4 cp4, anafam fam, anatpr tpr
                       where fam.cod_via	    	= a_cod_via
                         and nvl(fam.num_civ,0)     	= nvl(a_num_civ,0)
                         and nvl(fam.suffisso,' ')  	= nvl(a_suffisso,' ')
                         and nvl(fam.interno,0)     	= nvl(a_interno,0)
                         and nvl(fam.sub_interno,' ')     	= nvl(a_sub_interno,' ')
			 and nvl(fam.scala,' ')		= nvl(a_scala,' ')
			 and nvl(fam.piano,' ')		= nvl(a_piano,' ')
                         and fam.cod_fam                = nvl(a_cod_fam,fam.cod_fam)
			 and cpm.anno_dic		= cp4.anno_dic
			 and cpm.numero_DIC		= cp4.numero_dic
			 and cpm.flag_soggetto		is not null
			 and cpm.annullamento		is null
                         and cp4.flag_intero_nucleo 	is not null
                         and cp4.cod_fam_prov 		is not null
                         and fam.fascia	 		= 1
                         and fam.cod_fam 		= cp4.cod_fam_prov
                         and tpr.anno_pratica 		= cp4.anno_pratica
                         and tpr.pratica 		= cp4.pratica
                         and tpr.flag_perfezionamento 	is null
                         and tpr.flag_annullamento 	is null
                         and tpr.tipo_evento 		= 'C'
                         and anagrafe 			= 'RES');
    exception
      when others then
        null;
    end;
  end if;
  return w_stato;
end;
/

