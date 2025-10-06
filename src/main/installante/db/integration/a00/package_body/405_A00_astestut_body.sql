--liquibase formatted sql
--changeset amonopoli:202503261020_2 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE BODY astestut IS
 procedure open_st_cv( putente in varchar2, pgruppo in varchar2, pente in varchar2, pprenotazione in number, st_cv in out stcurtyp, pnome_stampa in varchar2,pcodice in varchar2, pstato in varchar2, pdata in date, ppagine in number) is
 begin
  open st_cv for
    select prefisso||to_char(no_stampa) nome_stampa,  AST.data_preparazione,  AST.voce_menu,  AST.passo,  AST.pagine, AST.stato, AST.stampa, AST.gruppo, AST.utente, AST.no_prenotazione, null classe, null id_repsrv_stampa
	  from a_stampe AST
	  where ( utente = putente or
	         ( ast.gruppo = pgruppo and
			 'G' = ( select cats.tipo_visura
			           from a_catalogo_stampe cats
					  where cats.stampa = ast.stampa
			        )
			  )
			 ) and pente = ( select ente from a_prenotazioni where a_prenotazioni.no_prenotazione = ast.no_prenotazione )
			 and no_prenotazione = nvl(pprenotazione,no_prenotazione)
       and prefisso||to_char(no_stampa) = nvl(pnome_stampa,prefisso||to_char(no_stampa))
       and ast.data_preparazione = nvl(pdata,ast.data_preparazione)
       and ast.voce_menu = nvl(pcodice,ast.voce_menu)
       and ast.stato = nvl(pstato,ast.stato)
       and ast.pagine = nvl(ppagine,ast.pagine)
	   union
		select substr(ASW.stampa,1,instr(asw.stampa,'.')-1) nome_stampa, ASW.data_stampa data_preparazione, ASW.voce_menu,1 PASSO, ASW.pagine, ASW.stato, ASW.voce_menu STAMPA, ASW.gruppo, ASW.utente, 0 PRENOTAZIONE, asw.classe classe, asw.id_repsrv_stampa id_repsrv_stampa
		  from a_stampeweb ASW
		 where utente = putente
       and asw.voce_menu = nvl(pcodice,asw.voce_menu)
       and asw.stato = nvl(pstato,asw.stato)
       and asw.data_stampa = nvl(pdata,asw.data_stampa)
    --   and UPPER(substr(ASW.stampa,1,instr(asw.stampa,'.')-1)) = nvl(UPPER(pnome_stampa),UPPER(substr(ASW.stampa,1,instr(asw.stampa,'.')-1)))
	   and UPPER(ASW.stampa) = nvl(UPPER(pnome_stampa),UPPER(ASW.stampa))
	order by 2 desc
		 ;
 end open_st_cv;
 procedure stut_lock(putente in varchar2, pstampa in varchar2, id_repsrv_stampa in varchar2, pclasse in varchar2) is
   v_rownum			 number;
 begin
   if id_repsrv_stampa is null then
      select rownum
	    into v_rownum
	    from a_stampe
	   where utente = putente
	     and prefisso||no_stampa = pstampa
		 for update
		 ;
	else
	  select rownum
	    into v_rownum
	    from a_stampeweb
	   where utente = putente
	     and upper(STAMPA) like upper(pstampa)||'%'
		 and classe=pclasse
		 for update
		 ;
	end if;
 end;
-- procedure stut_update(putente in varchar2, pstampa in varchar2, pid_repsrv_stampa in varchar2, pstato in varchar2) is
 procedure stut_update(precord in sttype) is
 begin
 	if precord.id_repsrv_stampa is null then
      update a_stampe
	     set stato = precord.stato
	   where utente = precord.utente
	     and prefisso||no_stampa = precord.nome_stampa;
 	else
	  update a_stampeweb
	     set stato = precord.stato
	   where utente = precord.utente
	     and STAMPA like precord.nome_stampa||'.%';
 	end if;
	commit;
end;
  procedure stut_delete(precord in sttype) is
  begin
    if precord.id_repsrv_stampa is null then
      delete a_stampe
	   where utente = precord.utente
	     and prefisso||no_stampa = precord.nome_stampa;
 	else
	  delete a_stampeweb
	   where utente = precord.utente
	     and STAMPA like precord.nome_stampa||'.%';
 	end if;
	commit;
  end;
END;
/

