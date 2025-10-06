--liquibase formatted sql
--changeset amonopoli:202503211150_1 runOnChange:true stripComments:false
create or replace procedure CIVNAS_IST_FI
(a_cod_rec		IN	number,
 a_natura		IN	varchar2,
 a_ufficio		IN	number,
 a_anno			IN	number,
 a_atto			IN	number,
 a_parte		IN	number,
 a_serie		IN	varchar2,
 a_cod_pro_res		IN	number,
 a_cod_com_res		IN	number,
 a_nato_morto		IN	varchar2,
 a_d_data_nas_pd	IN	date,
 a_nazionalita_pd       IN	varchar2,
 a_d_data_nas_md	IN	date,
 a_nazionalita_md       IN	varchar2,
 a_atto_old		IN	number)
IS
  w_residente	number;
begin

--
-- l'inserimento dell'atto di nascita in CIVNAS
-- produce il riempimento della tabella ISTMP4
--
-- 25/11/2015 - A.Monopoli
-- if DELETING
--

  if UPDATING then
     if a_atto_old < 0 and a_atto > 0 then
        begin
          update istmp4
             set atto = a_atto
           where ufficio        = a_ufficio
             and anno           = a_anno
             and parte          = a_parte
             and nvl(serie,' ') = nvl(a_serie,' ')
             and atto           = a_atto_old
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civnas_ist_fi','istmp4 - update');
          end if;
        end;
     end if;
  end if;

  if INSERTING then
   begin 
    select 1 into w_residente
      from menuditta
     where pro_cliente	= a_cod_pro_res
       and com_cliente	= a_cod_com_res
       and rownum	= 1
    ;
   exception
    when no_data_found then w_residente := 0;
    when others then w_residente := 0;
   end;

   if w_residente = 1 and a_cod_rec = 3 and a_natura in ('O','T') and a_nato_morto is null then 
     begin
       insert into istmp4
	      (ufficio, anno, atto, parte, serie,
 	       data_nas_pat, stato_civile_pat, nazionalita_pat,
 	       data_nas_mat, stato_civile_mat, nazionalita_mat,
	       cod_fiscale_mat, cod_fiscale_pat)
       select a_ufficio, a_anno, a_atto, a_parte, a_serie,
	      nvl(ana_p.data_nas,to_char(a_d_data_nas_pd,'j')),
              ana_p.stato_civile, 
              nvl(ana_p.nazionalita,a_nazionalita_pd),
	      nvl(ana_m.data_nas,to_char(a_d_data_nas_md,'j')),
              ana_m.stato_civile, 
              nvl(ana_m.nazionalita,a_nazionalita_md),
	      ana_m.cod_fiscale,
              ana_p.cod_fiscale
	 from anaana ana_p, anaana ana_m, civana ana
        where ana_p.matricola	(+)	= ana.matricola_1
          and ana_m.matricola	(+)	= ana.matricola_2
  	  and ana.tipo_atto		= 2
 	  and ana.ufficio		      = a_ufficio
	  and ana.anno			= a_anno
	  and ana.atto			= a_atto
	  and ana.parte			= a_parte
        and nvl(ana.serie,' ')	= nvl(a_serie,' ')
	  and not exists (select 'x' from istmp4
			   where ufficio	      = a_ufficio
			     and anno		= a_anno
			     and atto		= a_atto
		 	     and parte		= a_parte	
			     and nvl(serie,' ') = nvl(a_serie,' '))
       ;
       if sql%found then
          ISTAT_PKG.ins_log('civnas_ist_fi','istmp4 - insert');
       end if;
     end;
   end if;
  end if;

  if DELETING then
     if a_cod_rec in (0,3) then
        begin
          delete istmp4
           where ufficio        = a_ufficio
             and anno           = a_anno
             and parte          = a_parte
             and nvl(serie,' ') = nvl(a_serie,' ')
             and atto           = a_atto
             and matricola      is null
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civnas_ist_fi','istmp4 - delete');
          end if;
        end;
     end if;
  end if;
  
end;
/
