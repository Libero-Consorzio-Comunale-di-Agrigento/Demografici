--liquibase formatted sql
--changeset amonopoli:202501281130_2 runOnChange:true stripComments:false
create or replace function f_CERW_catalogo_FAM_zk
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
	select fascia fascia_ord, sequenza_par sequenza_ord, data_nas data_nas_ord,
               fam.*
	  from cerfam_zk fam
         where fascia  		= decode(p_fascia, 1, 1, 2, 1, 3)
           and cod_fam 		= nvl(w_cod_fam,p_cod_fam)
           and ((to_char(nvl(p_data_sto,sysdate),'j') between nvl(fam.data_inizio_fam,0) and nvl(fam.data_fine_fam,9999999)))
           and ((rapporto_par  not in ('CC','IC') and tipo_fam is null)
 	        or
                (rapporto_par in ('CC','IC') and tipo_fam = 1 and matricola = p_matricola))
           and p_id_catalogo not in (8,18)
        UNION
	select fascia fascia_ord, sequenza_par sequenza_ord, data_nas data_nas_ord,
               fam.*
	  from cerfam_zk fam
         where ((fascia in (1,2) and p_fascia in (1,2))
               or (fascia in (3,4) and p_fascia in (3,4)))
           and cod_fam 		= nvl(w_cod_fam,p_cod_fam)
           and ((to_char(nvl(p_data_sto,sysdate),'j') between nvl(fam.data_inizio_fam,0) and nvl(fam.data_fine_fam,9999999)))
           and ((rapporto_par  not in ('CC','IC') and tipo_fam is null)
 	        or
                (rapporto_par in ('CC','IC') and tipo_fam = 1 and matricola = p_matricola))
           and p_id_catalogo in (8,18)
         order by 1,2,3
	;

begin
  begin
    select cod_fam
      into w_cod_fam
      from cerfam_zk fam
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

      if p_id_catalogo in (1,11) then
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

      elsif p_id_catalogo in (2,12) then
	 w_dati_fam	:= rec.COGNOME_NOME||chr(9)||chr(9)||rec.RAPPORTO_PARENTELA||chr(10)||
			   chr(9)||rec.NAT_OA||' il '||rec.DATA_NASCITA||' a '||rec.COMUNE_NASCITA;
       if rec.atto_nascita is not null or rec.comune_atto_nascita is not null then
          w_dati_fam := w_dati_fam||chr(10)||
			      chr(9)||rec.ATTO_NASCITA||' '||rec.COMUNE_ATTO_NASCITA;
       end if;
       w_dati_fam    := w_dati_fam||chr(10)||
			   chr(9)||rec.RESIDENZA_FAM;

      elsif p_id_catalogo in (3,13) then
	 w_dati_fam	:= rec.COGNOME_NOME||chr(9)||chr(9)||rec.RAPPORTO_PARENTELA||chr(10)||
			   chr(9)||rec.NAT_OA||' il '||rec.DATA_NASCITA||' a '||rec.COMUNE_NASCITA;
       if rec.atto_nascita is not null or rec.comune_atto_nascita is not null then
          w_dati_fam := w_dati_fam||chr(10)||
			      chr(9)||rec.ATTO_NASCITA||' '||rec.COMUNE_ATTO_NASCITA;
       end if;
       w_dati_fam    := w_dati_fam||chr(10)||
			   chr(9)||rec.STATO_CIVILE||' '||rec.COGNOME_NOME_CONIUGE||chr(10)||
			   chr(9)||rec.RESIDENZA_FAM;

      elsif p_id_catalogo in (4,14) then
	 w_dati_fam	:= rec.COGNOME_NOME;
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

      elsif p_id_catalogo in (5,15) then
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
			   chr(9)||rec.RESIDENZA_FAM||chr(10)||
			   chr(9)||'Cittadinanza '||rec.CITTADINANZA;

      elsif p_id_catalogo in (6,16) then
	 w_dati_fam	:= rec.COGNOME_NOME||chr(9)||chr(9)||rec.RAPPORTO_PARENTELA||chr(10)||
			   chr(9)||rec.NAT_OA||' il '||rec.DATA_NASCITA||' a '||rec.COMUNE_NASCITA;
       if rec.atto_nascita is not null or rec.comune_atto_nascita is not null then
          w_dati_fam := w_dati_fam||chr(10)||
			      chr(9)||rec.ATTO_NASCITA||' '||rec.COMUNE_ATTO_NASCITA;
       end if;
       w_dati_fam    := w_dati_fam||chr(10)||
			   chr(9)||rec.STATO_CIVILE||' '||rec.COGNOME_NOME_CONIUGE;
       if rec.estremi_mat_ved is not null then
          w_dati_fam := w_dati_fam||chr(10)||
  	 	 	      chr(9)||rec.ESTREMI_MAT_VED;
       end if;
       w_dati_fam    := w_dati_fam||chr(10)||
			   chr(9)||rec.RESIDENZA_FAM||chr(10)||
			   chr(9)||'Cittadinanza '||rec.CITTADINANZA;

      elsif p_id_catalogo in (7,17) then
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

      elsif p_id_catalogo in (8,18) then
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
			   chr(9)||rec.INDIRIZZO_FAM||chr(10)||
			   chr(9)||rec.RESIDENZA_FAM||chr(10)||
			   chr(9)||rec.STATO_CIVILE||' '||rec.COGNOME_NOME_CONIUGE;
       if rec.estremi_mat_ved is not null then
          w_dati_fam := w_dati_fam||chr(10)||
  	 	 	      chr(9)||rec.ESTREMI_MAT_VED;
       end if;
       if rec.atto_mat_ved is not null then
          w_dati_fam := w_dati_fam||chr(10)||
			   chr(9)||rec.ATTO_MAT_VED;
       end if;
       w_dati_fam    := w_dati_fam||chr(10)||
			   chr(9)||rec.ESTREMI_ULTIMO_EVENTO||chr(10)||
			   chr(9)||rec.PRATICA_ULTIMO_EVENTO||chr(10)||
			   chr(9)||'Cittadinanza: '||chr(9)||rec.CITTADINANZA||chr(10)||
			   chr(9)||'Titolo di studio: '||chr(9)||rec.TITOLO_STUDIO||chr(10)||
			   chr(9)||'Professione: '||chr(9)||rec.PROFESSIONE||chr(10)||
			   chr(9)||'Documenti: '||chr(10)|| 
			   f_CERW_catalogo_doc(rec.matricola, 'XX', 1);

      elsif p_id_catalogo in (9,19) then
       if rec.rapporto_par in ('CF','IS','IC','CC') then
   	    w_dati_fam    := rec.COGNOME_NOME||chr(9)||chr(9)||rec.RAPPORTO_PARENTELA||chr(10);
       else
	    w_dati_fam    := rec.COGNOME_NOME||chr(10);
       end if;
	 w_dati_fam    := w_dati_fam||
			   chr(9)||rec.NAT_OA||' il '||rec.DATA_NASCITA||' a '||rec.COMUNE_NASCITA;

      elsif p_id_catalogo = 10 then
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
