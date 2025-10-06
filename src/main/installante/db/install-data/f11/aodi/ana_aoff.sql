--liquibase formatted sql
--changeset amonopoli:202503190840_3 runOnChange:true stripComments:false
declare
w_padre		number;
w_figlio		number;

begin
  begin 
    insert into a_voci_menu
	     (voce_menu, ambiente, acronimo, titolo, tipo_voce, tipo, modulo) 
    select 'ANAAOFF', ambiente, 'AOFF', 'Acquisizione Ottica Fogli di Famiglia', 'F', 'F', 'ANAAOFF'
      from a_ambienti a
     where ambiente = 'GSD'
       and not exists (select 1 from a_voci_menu b
                        where b.voce_menu = 'ANAAOFF'
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
    select distinct a.applicazione, '*', m.figlio, w_figlio, 'ANAAOFF', 43
      from a_menu m, a_applicazioni a
     where m.voce_menu	  = 'ANAPANA'
       and m.applicazione = a.applicazione
       and a.applicazione in ('GSD','GSDANA','GSDALL')
       and not exists (select 1 from a_menu b
                        where b.voce_menu    = 'ANAAOFF'
                          AND b.applicazione = a.applicazione
                          and b.ruolo        = '*')
    UNION
    select distinct a.applicazione, 'GSD', m.figlio, w_figlio, 'ANAAOFF', 43
      from a_menu m, a_applicazioni a
     where m.voce_menu	  = 'ANAPANA'
       and m.applicazione = a.applicazione
       and a.applicazione in ('GSD','GSDANA','GSDALL')
       and not exists (select 1 from a_menu b
                        where b.voce_menu    = 'ANAAOFF'
                          AND b.applicazione = a.applicazione
                          and b.ruolo        = '*')
    UNION
    select distinct a.applicazione, 'RGSD', m.figlio, w_figlio, 'ANAAOFF', 43
      from a_menu m, a_applicazioni a
     where m.voce_menu	  = 'ANAPANA'
       and m.applicazione = a.applicazione
       and a.applicazione in ('GSD','GSDANA','GSDALL')
       and not exists (select 1 from a_menu b
                        where b.voce_menu    = 'ANAAOFF'
                          AND b.applicazione = a.applicazione
                          and b.ruolo        = '*')
    ;
  end;
end;
/
