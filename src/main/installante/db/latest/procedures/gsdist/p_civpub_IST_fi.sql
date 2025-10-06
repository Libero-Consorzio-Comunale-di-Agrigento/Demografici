--liquibase formatted sql
--changeset amonopoli:202401181010_1 runOnChange:true stripComments:false
create or replace procedure CIVPUB_IST_FI
(a_cod_rec		IN 	number,
 a_ufficio		IN	number,
 a_anno			IN	number,
 a_atto			IN	number,
 a_parte		IN	number,
 a_serie		IN	varchar2,
 a_cod_pro_mat		IN	number,
 a_cod_com_mat		IN 	number,
 a_cognome_nome_m	IN	varchar2,
 a_data_nas_m		IN	number,
 a_cod_pro_res_m	IN	number,
 a_cod_com_res_m	IN	number,
 a_cognome_nome_f	IN	varchar2,
 a_data_nas_f		IN	number,
 a_cod_pro_res_f	IN	number,
 a_cod_com_res_f	IN	number,
 a_atto_old 		IN	number,
 a_cod_pro_mat_old 	IN	number,
 a_cod_com_mat_old 	IN	number
)

IS

  w_matrimonio			number;
  w_stato_civile_m		varchar2(2);
  w_data_fine_mat_m		number;
  w_stato_civile_f		varchar2(2);
  w_data_fine_mat_f		number;

begin
--
-- l'inserimento della pubblicazione in CIVPUB
-- produce il riempimento della tabella ISTMD3
--
-- 25/11/2015 (AM): if DELETING
-- 18/01/2024 (AM): gestito UPDATE di comune matrimonio
--

  if UPDATING then
     if a_atto_old < 0 and a_atto > 0 then
        begin
          update istmd3
             set atto_pub = a_atto
           where ufficio_pub        = a_ufficio
             and anno_pub           = a_anno
             and parte_pub          = a_parte
             and nvl(serie_pub,' ') = nvl(a_serie,' ')
             and atto_pub           = a_atto_old
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civpub_ist_fi','istmd3 - update');
          end if;
        end;
     end if;
  end if;

  begin
    select 1 into w_matrimonio
      from menuditta
     where pro_cliente = a_cod_pro_mat
       and com_cliente = a_cod_com_mat
       and rownum = 1
    ;
  exception
    when no_data_found then w_matrimonio := 0;
    when others then w_matrimonio := 0;
  end;

  if INSERTING or (UPDATING and nvl(a_cod_pro_mat_old||a_cod_com_mat_old,0) != nvl(a_cod_pro_mat||a_cod_com_mat,0)) then
   if w_matrimonio = 1 and a_cod_rec = 3 then

	begin
	  select ana_m.stato_civile, 
		 decode(ana_m.stato_civile,
		   'VE',ana_m.data_ved,
		   'VU',ana_m.data_ved,
		   'DV',nvl(ana_m.data_div_ann,ana_m.data_div),
    	 	   'GC',nvl(ana_m.data_div_ann,ana_m.data_div),
    	 	   'GU',nvl(ana_m.data_div_ann,ana_m.data_div)),
		 ana_f.stato_civile, 
		 decode(ana_f.stato_civile,
		   'VE',ana_f.data_ved,
		   'VU',ana_f.data_ved,
		   'DV',nvl(ana_f.data_div_ann,ana_f.data_div),
		   'GC',nvl(ana_f.data_div_ann,ana_f.data_div),
		   'GU',nvl(ana_f.data_div_ann,ana_f.data_div))
	    into w_stato_civile_m, w_data_fine_mat_m,
	         w_stato_civile_f, w_data_fine_mat_f
	    from anaana ana_m, anaana ana_f, civana ana
	   where ana_m.matricola (+)	= ana.matricola_1
  	     and ana_f.matricola (+)	= ana.matricola_2
  	     and ana.tipo_atto		= 3
	     and ana.ufficio		= a_ufficio
	     and ana.anno	 	= a_anno
	     and ana.atto		= a_atto
	     and ana.parte		= a_parte	
  	     and nvl(ana.serie,' ')	= nvl(a_serie,' ')
	  ;
	exception
	  when no_data_found then null;
  	  when others then null;
	end;

	begin
	  insert into istmd3
		 (ufficio_mat, anno_mat, atto_mat, parte_mat, serie_mat,
 		  ufficio_pub, anno_pub, atto_pub, parte_pub, serie_pub,
 		  stato_civile_m, data_fine_mat_m, grado_istruzione_m,
 		  condizione_prof_m, posizione_prof_m, attivita_prof_m,
	  	  cod_pro_res_post_m, cod_com_res_post_m,
 		  stato_civile_f, data_fine_mat_f, grado_istruzione_f,
		  condizione_prof_f, posizione_prof_f, attivita_prof_f,
		  cod_pro_res_post_f, cod_com_res_post_f)
	  select '', '', '', '', '',
		 a_ufficio, a_anno, a_atto, a_parte, a_serie,
		 w_stato_civile_m, w_data_fine_mat_m, '',
		 '', '', '',
		 a_cod_pro_res_m, a_cod_com_res_m,
		 w_stato_civile_f, w_data_fine_mat_f, '',
	         '', '', '',
		 a_cod_pro_res_f, a_cod_com_res_f
	    from dual
	   where not exists (select 'x' 
			       from istmd3
			      where ufficio_pub		= a_ufficio
				and anno_pub		= a_anno
				and atto_pub		= a_atto
				and parte_pub		= a_parte
				and nvl(serie_pub,' ')	= nvl(a_serie,' '))
	  ;
          if sql%found then
             ISTAT_PKG.ins_log('civpub_ist_fi','istmd3 - insert');
          end if;
	end;
   end if;
  end if;

  if DELETING then
     if a_cod_rec in (0,3) then
        begin
          delete istmd3
           where ufficio_pub        = a_ufficio
             and anno_pub           = a_anno
             and parte_pub          = a_parte
             and nvl(serie_pub,' ') = nvl(a_serie,' ')
             and atto_pub           = a_atto
             and atto_mat           is null
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civpub_ist_fi','istmd3 - delete');
          end if;
        end;
     end if;
  end if;

end;
/
