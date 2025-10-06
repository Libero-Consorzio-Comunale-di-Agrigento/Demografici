--liquibase formatted sql
--changeset amonopoli:202503190840_4 runOnChange:true stripComments:false
declare
w_padre		number;
w_figlio	number;

begin
  begin 
    insert into a_voci_menu
	     (voce_menu, ambiente, acronimo, titolo, tipo_voce, tipo, modulo) 
    select 'ANAVOSI', ambiente, 'VOSI', 'Visualizzazione Ottica SchedeIndividuali', 'F', 'F', 'ANAVOSI'
      from a_ambienti a
     where ambiente = 'GSD'
       and not exists (select 1 from a_voci_menu b
                        where b.voce_menu = 'ANAVOSI'
                          and b.ambiente  = a.ambiente)
    ;
  end;

  begin
    select max(figlio) + 1
      into w_figlio
      from a_menu
    ;
  end;

  begin
    insert into a_menu 
	     (APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA)
    select distinct a.applicazione, '*', m.figlio, w_figlio, 'ANAVOSI', 130
      from a_menu m, a_applicazioni a
     where m.voce_menu	  = 'ANAVIAN'
       and m.applicazione = a.applicazione
       and a.applicazione in ('GSD','GSDALL','GSDANA')
       and not exists (select 1 from a_menu b
                        where b.voce_menu    = 'ANAVOSI'
                          AND b.applicazione = a.applicazione
                          and b.ruolo        = '*')
    UNION
    select distinct a.applicazione, 'GSD', m.figlio, w_figlio, 'ANAVOSI', 130
      from a_menu m, a_applicazioni a
     where m.voce_menu	  = 'ANAVIAN'
       and m.applicazione = a.applicazione
       and a.applicazione in ('GSD','GSDALL','GSDANA')
       and not exists (select 1 from a_menu b
                        where b.voce_menu    = 'ANAVOSI'
                          AND b.applicazione = a.applicazione
                          and b.ruolo        = 'GSD')
    UNION
    select distinct a.applicazione, 'RGSD', m.figlio, w_figlio, 'ANAVOSI', 130
      from a_menu m, a_applicazioni a
     where m.voce_menu	  = 'ANAVIAN'
       and m.applicazione = a.applicazione
       and a.applicazione in ('GSD','GSDALL','GSDANA')
       and not exists (select 1 from a_menu b
                        where b.voce_menu    = 'ANAVOSI'
                          AND b.applicazione = a.applicazione
                          and b.ruolo        = 'RGSD')
    ;
  end;
end;
/
