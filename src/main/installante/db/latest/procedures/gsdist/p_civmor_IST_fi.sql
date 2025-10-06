--liquibase formatted sql
--changeset amonopoli:202302131300_1 runOnChange:true stripComments:false
CREATE OR REPLACE procedure CIVMOR_IST_FI
(a_cod_rec		IN 	number,
 a_natura		IN	varchar2,
 a_ufficio		IN	number,
 a_anno			IN	number,
 a_atto			IN	number,
 a_parte		IN	number,
 a_serie		IN	varchar2,
 a_cod_pro_mor		IN 	number,
 a_cod_com_mor		IN	number,
 a_data_mor		IN	number,
 a_ore			IN 	number,
 a_minuti		IN	number,
 a_cognome_nome		IN 	varchar2,
 a_sesso	 	IN	varchar2,
 a_data_nas		IN 	number,
 a_cod_pro_nas		IN 	number,
 a_cod_com_nas		IN 	number,
 a_stato_civile		IN	varchar2,
 a_data_nas_old		IN	number,
 a_nazionalita		IN	varchar2,
 a_atto_old		IN	number,
 a_data_reg		IN	number)
IS
  w_morte		number;
  w_nazionalita		varchar2(3);
  w_anno_mat		number;
  w_anno_nas_cn		number;
  w_ore_nas		number;
  w_minuti_nas		number;
  w_tipo_filiazione	varchar2(1);
  w_data_nas_mat	number;
  w_nazionalita_mat     varchar2(3);
  w_cod_fiscale_mat	varchar2(16);
  w_nazionalita_pat	varchar2(3);
  w_indicazione_eta	number;
  w_eta_compiuta	number;
begin
  if UPDATING then
     if a_atto_old < 0 and a_atto > 0 then
        begin
          update istmd4
             set atto = a_atto
           where ufficio        = a_ufficio
             and anno           = a_anno
             and parte          = a_parte
             and nvl(serie,' ') = nvl(a_serie,' ')
             and atto           = a_atto_old
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civmor_ist_fi','istmd4 - update');
          end if;
        end;
        begin
          update istm4b
             set atto = a_atto
           where ufficio        = a_ufficio
             and anno           = a_anno
             and parte          = a_parte
             and nvl(serie,' ') = nvl(a_serie,' ')
             and atto           = a_atto_old
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civmor_ist_fi','istm4b - update');
          end if;
        end;
     end if;
  end if;

  if UPDATING then
     if nvl(a_data_nas_old,0) != nvl(a_data_nas,0) then
        if add_months(to_date(a_data_nas,'j'),12)     <= to_date(nvl(a_data_mor,a_data_reg),'j') and
	   add_months(to_date(a_data_nas_old,'j'),12) > to_date(nvl(a_data_mor,a_data_reg),'j') 
	then
	   begin
	     delete istm4b
	      where ufficio		= a_ufficio
		and anno		= a_anno
		and atto		= a_atto
		and parte		= a_parte
		and nvl(serie,' ')	= nvl(a_serie,' ')
	     ;
             if sql%found then
                ISTAT_PKG.ins_log('civmor_ist_fi','istm4b - delete');
             end if;
	   end;
        elsif add_months(to_date(a_data_nas,'j'),12)     > to_date(nvl(a_data_mor,a_data_reg),'j') and
	      add_months(to_date(a_data_nas_old,'j'),12) <= to_date(nvl(a_data_mor,a_data_reg),'j') 
        then
	   begin
	     delete istmd4
	      where ufficio		= a_ufficio
		and anno		= a_anno
		and atto		= a_atto
		and parte		= a_parte
		and nvl(serie,' ')	= nvl(a_serie,' ')
	     ;
             if sql%found then
                ISTAT_PKG.ins_log('civmor_ist_fi','istmd4 - delete');
             end if;
	   end;
	else
	   goto label_fine;
	end if;
    else
	goto label_fine;
     end if;
  end if;

  begin
    select 1 into w_morte
      from menuditta
     where pro_cliente	= a_cod_pro_mor
       and com_cliente	= a_cod_com_mor
       and rownum	= 1
    ;
  exception
    when no_data_found then w_morte := 0;
    when others then w_morte := 0;
  end;
  if w_morte = 1 and a_natura ='O' and a_cod_rec = 3 then
     if add_months(to_date(a_data_nas,'j'),12) <= to_date(nvl(a_data_mor,a_data_reg),'j') then
--dbms_output.put_line('oltre l''anno');
--dbms_output.put_line('a_cod_rec '||a_cod_rec);
--dbms_output.put_line('a_natura '||a_natura);
--dbms_output.put_line('a_ufficio '||a_ufficio);
--dbms_output.put_line('a_anno '||a_anno);
--dbms_output.put_line('a_atto '||a_atto);
--dbms_output.put_line('a_parte '||a_parte);
--dbms_output.put_line('a_serie '||a_serie);
--dbms_output.put_line('a_cod_pro_mor '||a_cod_pro_mor);
--dbms_output.put_line('a_cod_com_mor '||a_cod_com_mor);
--dbms_output.put_line('a_data_mor '||a_data_mor);
--dbms_output.put_line('a_data_reg '||a_data_reg);
--dbms_output.put_line('a_ore '||a_ore);
--dbms_output.put_line('a_minuti '||a_minuti);
--dbms_output.put_line('a_cognome_nome '||a_cognome_nome);
--dbms_output.put_line('a_sesso '||a_sesso);
--dbms_output.put_line('a_data_nas '||a_data_nas);
--dbms_output.put_line('a_cod_pro_nas '||a_cod_pro_nas);
--dbms_output.put_line('a_cod_com_nas '||a_cod_com_nas);
--dbms_output.put_line('a_stato_civile '||a_stato_civile);
	begin
	  select ana.nazionalita,
		 to_number(to_char(to_date(ana.data_mat,'j'),'yyyy')),
		 to_number(to_char(to_date(ana_cn.data_nas,'j'),'yyyy'))
	    into w_nazionalita, w_anno_mat, w_anno_nas_cn
	    from anaana ana_cn, anaana ana, civana civ
	   where ana_cn.matricola (+)	= ana.matricola_cn
  	     and ana.matricola (+)	= civ.matricola_1
  	     and civ.tipo_atto		= 5
	     and civ.ufficio		= a_ufficio
	     and civ.anno	 	= a_anno
	     and civ.atto		= a_atto
	     and civ.parte		= a_parte
  	     and nvl(civ.serie,' ')	= nvl(a_serie,' ')
	  ;
	exception
	  when no_data_found then null;
  	  when others then null;
	end;
--dbms_output.put_line('prima di insert istmd4');
	begin
	  insert into istmd4
		 (ufficio, anno, atto, parte, serie,
		  flag_separato, anno_nas_cn, anno_mat,
		  grado_istruzione, condizione_prof, posizione_prof, attivita_prof,
		  nazionalita, nazionalita_ita)
	  select a_ufficio, a_anno, a_atto, a_parte, a_serie,
		 '',
		 decode(a_stato_civile,'CN',w_anno_nas_cn,'UC',w_anno_nas_cn, to_number(null)),
		 decode(a_stato_civile,'CN',w_anno_mat,'UC',w_anno_mat, to_number(null)),
		 to_number(null), to_number(null), to_number(null), to_number(null),
		 nvl(a_nazionalita,w_nazionalita), to_number(null)
	    from dual
	   where not exists (select 'x'
			       from istmd4
			      where ufficio		= a_ufficio
				and anno		= a_anno
				and atto		= a_atto
				and parte		= a_parte
				and nvl(serie,' ')	= nvl(a_serie,' '))
	  ;
          if sql%found then
             ISTAT_PKG.ins_log('civmor_ist_fi','istmd4 - insert');
          end if;
	end;
--dbms_output.put_line('dopo insert istmd4');
     else	-- add_months(to_date(a_data_nas,'j'),12) <= to_date(nvl(a_data_mor,a_data_reg),'j')
--dbms_output.put_line('entro l''anno');
        begin
	  select nas.ore, nas.minuti, nas.tipo_filiazione,
	         mp4.data_nas_mat, mp4.nazionalita_mat, mp4.cod_fiscale_mat,
		 mp4.nazionalita_pat
	    into w_ore_nas, w_minuti_nas, w_tipo_filiazione,
		 w_data_nas_mat, w_nazionalita_mat, w_cod_fiscale_mat,
		 w_nazionalita_pat
	    from istmp4 mp4, civnas nas
	   where mp4.ufficio	(+)	= nas.ufficio
	     and mp4.anno	(+)	= nas.anno
	     and mp4.atto	(+)	= nas.atto
	     and mp4.parte	(+) 	= nas.parte
	     and mp4.serie	(+)	= nas.serie
	     and nas.cognome_nome	= a_cognome_nome
	     and nas.sesso		= a_sesso
	     and nas.data_nas		= a_data_nas
	  ;
--dbms_output.put_line('dopo select civnas');
	exception
	  when no_data_found then null;
	  when others then null;
	end;
--dbms_output.put_line('data mor '||a_data_mor);
--dbms_output.put_line('data_reg '||a_data_reg);
--dbms_output.put_line('data nas '||a_data_nas);
  	if nvl(a_data_mor,a_data_reg) = a_data_nas then
	   w_indicazione_eta := 1;
	   if a_ore is not null and w_ore_nas is not null then
	      w_eta_compiuta := a_ore - w_ore_nas;
	   end if;
	elsif (nvl(a_data_mor,a_data_reg) - a_data_nas) = 1 then
	   if a_ore is not null and w_ore_nas is not null then
	      if (24 - w_ore_nas + a_ore) > 23 then
		 w_indicazione_eta := 2;
		 w_eta_compiuta	   := 1;
	      else
		 w_indicazione_eta := 1;
		 w_eta_compiuta	   := 24 - w_ore_nas + a_ore;
	      end if;
	   end if;
  	elsif (nvl(a_data_mor,a_data_reg) - a_data_nas) between 2 and 29 then
	   w_indicazione_eta	:= 2;
	   w_eta_compiuta	:= nvl(a_data_mor,a_data_reg) - a_data_nas;
	else
           w_indicazione_eta	:= 3;
	   --w_eta_compiuta	:= trunc((nvl(a_data_mor,a_data_reg) - a_data_nas) / 30);
       w_eta_compiuta := trunc(months_between(to_date(nvl(a_data_mor,a_data_reg),'j'),to_date(a_data_nas,'j')));
  	end if;
--dbms_output.put_line('prima di insert istm4b');
--dbms_output.put_line('w_eta_compiuta '||w_eta_compiuta);
	begin
	  insert into istm4b
		(ufficio, anno, atto, parte, serie,
		 indicazione_eta, eta_compiuta, filiazione,
		 nazionalita_pat, data_nas_mat, nazionalita_mat,
		 cod_fiscale_mat)
	  select a_ufficio, a_anno, a_atto, a_parte, a_serie,
		 w_indicazione_eta, w_eta_compiuta,
		 decode(w_tipo_filiazione,'L',1,''),
		 w_nazionalita_pat, w_data_nas_mat, w_nazionalita_mat,
		 w_cod_fiscale_mat
	    from dual
	   where not exists (select 'x'
			       from istm4b
			      where ufficio	= a_ufficio
				and anno	= a_anno
				and atto	= a_atto
				and parte	= a_parte
				and nvl(serie,' ') = nvl(a_serie,' '))
  	  ;
          if sql%found then
             ISTAT_PKG.ins_log('civmor_ist_fi','istm4b - insert');
          end if;
--dbms_output.put_line('dopo di insert istm4b');
	end;
     end if;
  end if;

  if DELETING then
     if a_cod_rec in (0,3) then
        begin
          delete istmd4
           where ufficio        = a_ufficio
             and anno           = a_anno
             and parte          = a_parte
             and nvl(serie,' ') = nvl(a_serie,' ')
             and atto           = a_atto
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civmor_ist_fi','istmd4 - delete');
          end if;
        end;
        begin
          delete istm4b
           where ufficio        = a_ufficio
             and anno           = a_anno
             and parte          = a_parte
             and nvl(serie,' ') = nvl(a_serie,' ')
             and atto           = a_atto
          ;
          if sql%found then
             ISTAT_PKG.ins_log('civmor_ist_fi','istm4b - delete');
          end if;
        end;
     end if;
  end if;

<< label_fine >>
  null;

end;
/

