--liquibase formatted sql
--changeset amonopoli:202410171230_7 runOnChange:true stripComments:false
create or replace function f_CERW_catalogo_FAM_MIN	
		(p_matricola		number,
		 p_cod_fam		number,
		 p_fascia		number,
	 	 p_data_sto		date,
	 	 p_id_catalogo		number)

return varchar2

IS

w_cod_fam		number;
w_progr_fam		number;
w_dati_fam		varchar2(32000);
w_catalogo		varchar2(32000);

cursor sel_fam is
	select *
	  from cerfam fam
         where fascia  		= decode(p_fascia, 1, 1, 2, 1, 3)
           and cod_fam 		= nvl(w_cod_fam,p_cod_fam)
           and to_char(nvl(p_data_sto,sysdate),'j') between nvl(fam.data_inizio_fam,0) and nvl(fam.data_fine_fam,0)
           and ((rapporto_par  not in ('CC','IC') and tipo_fam is null)
 	        or
                (rapporto_par in ('CC','IC') and tipo_fam = 1 and matricola = p_matricola))
           and add_months(to_date(data_nas,'j'),216) <= sysdate
         order by fascia, sequenza_par, data_nas
	;

begin
  begin
    select cod_fam
      into w_cod_fam
      from cerfam fam
     where fascia  	= decode(p_fascia, 1, 1, 2, 1, 3)
       and matricola	= p_matricola
       and to_char(nvl(p_data_sto,sysdate),'j') between nvl(fam.data_inizio_fam,0) and nvl(fam.data_fine_fam,0)
    ;
  exception
    when others then
         w_cod_fam := p_cod_fam;
  end;

  w_progr_fam	:= 0;

  for rec in sel_fam loop
      w_progr_fam	:= w_progr_fam + 1;

      if p_id_catalogo = 1 then
	 w_dati_fam	:= rec.COGNOME_NOME||chr(9)||chr(9)||rec.RAPPORTO_PARENTELA||chr(10)||
			   chr(9)||rec.NAT_OA||' il '||rec.DATA_NASCITA||' a '||rec.COMUNE_NASCITA;
       if rec.atto_nascita is not null or rec.comune_atto_nascita is not null then
          w_dati_fam := w_dati_fam||chr(10)||
			      chr(9)||rec.ATTO_NASCITA||' '||rec.COMUNE_ATTO_NASCITA;
       end if;
       w_dati_fam    := w_dati_fam||chr(10)||
			   chr(9)||rec.RESIDENZA_FAM;

      elsif p_id_catalogo = 2 then
       if rec.rapporto_par in ('CF','IS','IC','CC') then
   	    w_dati_fam    := rec.COGNOME_NOME||chr(9)||chr(9)||rec.RAPPORTO_PARENTELA||chr(10);
       else
	    w_dati_fam    := rec.COGNOME_NOME||chr(10);
       end if;
	 w_dati_fam    := w_dati_fam||
			      chr(9)||rec.NAT_OA||' il '||rec.DATA_NASCITA||' a '||rec.COMUNE_NASCITA;
       if rec.atto_nascita is not null or rec.comune_atto_nascita is not null then
          w_dati_fam := w_dati_fam||chr(10)||
			      chr(9)||rec.ATTO_NASCITA||' '||rec.COMUNE_ATTO_NASCITA;
       end if;
       w_dati_fam    := w_dati_fam||chr(10)||
			      chr(9)||rec.RESIDENZA_FAM;

      elsif p_id_catalogo = 3 then
	 w_dati_fam	:= rec.COGNOME_NOME||chr(9)||chr(9)||rec.RAPPORTO_PARENTELA||chr(10)||
			   chr(9)||rec.NAT_OA||' il '||rec.DATA_NASCITA||' a '||rec.COMUNE_NASCITA;
       if rec.atto_nascita is not null or rec.comune_atto_nascita is not null then
          w_dati_fam := w_dati_fam||chr(10)||
			      chr(9)||rec.ATTO_NASCITA||' '||rec.COMUNE_ATTO_NASCITA;
       end if;
       w_dati_fam    := w_dati_fam||chr(10)||
			   chr(9)||rec.STATO_CIVILE||' '||rec.COGNOME_NOME_CONIUGE||chr(10)||
			   chr(9)||rec.RESIDENZA_FAM;

      elsif p_id_catalogo = 4 then
	 w_dati_fam	:= rec.COGNOME_NOME||chr(9)||chr(9)||rec.RAPPORTO_PARENTELA;
       if rec.paternita is not null or rec.maternita is not null then 
          w_dati_fam := w_dati_fam||chr(10)||
			      chr(9)||rec.PATERNITA||chr(9)||rec.MATERNITA;
       end if;
       w_dati_fam := w_dati_fam||chr(10)||
			   chr(9)||rec.NAT_OA||' il '||rec.DATA_NASCITA||' a '||rec.COMUNE_NASCITA;
       if rec.atto_nascita is not null or rec.comune_atto_nascita is not null then
          w_dati_fam := w_dati_fam||chr(10)||
			      chr(9)||rec.ATTO_NASCITA||' '||rec.COMUNE_ATTO_NASCITA;
       end if;
       w_dati_fam    := w_dati_fam||chr(10)||
			   chr(9)||rec.STATO_CIVILE||' '||rec.COGNOME_NOME_CONIUGE||chr(10)||
			   chr(9)||rec.RESIDENZA_FAM;

      elsif p_id_catalogo = 5 then
       if rec.rapporto_par in ('CF','IS','IC','CC') then
   	    w_dati_fam    := rec.COGNOME_NOME||chr(9)||chr(9)||rec.RAPPORTO_PARENTELA||chr(10);
       else
	    w_dati_fam    := rec.COGNOME_NOME||chr(10);
       end if;
	 w_dati_fam    := w_dati_fam||
			   chr(9)||rec.NAT_OA||' il '||rec.DATA_NASCITA||' a '||rec.COMUNE_NASCITA;

      end if;

      if w_progr_fam = 1 then
	 w_catalogo	:= w_dati_fam;
      else
	 w_catalogo 	:= w_catalogo||chr(10)||chr(10)||w_dati_fam;
      end if;
  end loop;

  w_catalogo := w_catalogo||chr(10);

  return w_catalogo;

exception
  when others then
       w_catalogo := '';
       return w_catalogo;
end;
/
