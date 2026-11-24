--liquibase formatted sql
--changeset amonopoli:202606091150_11 runOnChange:true stripComments:false
create or replace procedure ANAAP4_FI
(a_anno_dic			IN	number
,a_numero_dic		IN 	number
,a_flag_aggregazione 	IN	varchar2
,a_cod_fam_dest		IN	number
,a_cod_via_new		IN	number
,a_num_civ_new		IN 	number
,a_suffisso_new		IN	varchar2
,a_scala_new		IN	varchar2
,a_piano_new		IN	varchar2
,a_interno_new		IN	number
,a_sub_interno_new	IN	varchar2
,a_cod_via_old		IN	number
,a_num_civ_old		IN 	number
,a_suffisso_old		IN	varchar2
,a_scala_old		IN	varchar2
,a_piano_old		IN	varchar2
,a_interno_old		IN	number
,a_sub_interno_old	IN	varchar2)

is

w_ctr_IS	number := 0;

begin
-- Creata il 07/05/2012 (A.Monopoli)

if UPDATING then
   if a_flag_aggregazione is not null and
      (a_cod_via_new              != a_num_civ_new           or
       nvl(a_num_civ_new,0)       != nvl(a_num_civ_old,0)    or
       nvl(a_suffisso_new,' ')    != nvl(a_suffisso_old,' ') or
       nvl(a_scala_new,' ')       != nvl(a_scala_old,' ')    or
       nvl(a_piano_new,' ')	   != nvl(a_piano_old,' ')	 or
       nvl(a_interno_new,0)	   != nvl(a_interno_old,0)     or
       nvl(a_sub_interno_new,' ') != nvl(a_sub_interno_old,' '))
   then
      begin 
        select 1
          into w_ctr_IS
          from anaana ana, anaapm apm
         where ana.matricola		  = apm.matricola
           and ana.rapporto_par	  = 'CF'
           and ana.cod_fam		  = a_cod_fam_dest
           and ana.fascia + 0		  = 1
           and apm.nuovo_rapporto_par = 'CF'
           and apm.flag_soggetto	  = 'S'
           and apm.annullamento	  is null
           and apm.anno_dic		  = a_anno_dic
           and apm.numero_dic		  = a_numero_dic
        ;
      exception
        when others then
             w_ctr_IS := 0;
      end;

      if w_ctr_IS = 1 then
         begin
           update anafam
              set cod_via	= a_cod_via_new,
                  num_civ	= a_num_civ_new,
                  suffisso	= a_suffisso_new,
                  scala		= a_scala_new,
                  piano		= a_piano_new,
                  interno	= a_interno_new,
                  sub_interno	= a_sub_interno_new
            where cod_fam	= a_cod_fam_dest
              and fascia + 0	= 1
           ;
         exception
           when others then
                raise_application_error (-20999,'Errore in aggiornamento ANAFAM ('||SQLERRM||')');
         end;
      end if;
   end if;
end if;

end;
/
