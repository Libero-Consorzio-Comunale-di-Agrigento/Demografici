--liquibase formatted sql
--changeset amonopoli:202503211055_1 runOnChange:true stripComments:false
declare
w_padre		number;
w_figlio	number;

begin
  begin 
    insert into a_voci_menu
	     (voce_menu, ambiente, acronimo, titolo, tipo_voce, tipo, modulo) 
    select 'ISTAMDU', ambiente, 'AMDU', 'ISTAT D.3.U (unioni civili)', 'F', 'F', 'ISTAMDU'
      from a_ambienti a
     where ambiente = 'GSD'
       and not exists (select 1 from a_voci_menu b
                        where b.voce_menu = 'ISTAMDU'
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
    select distinct a.applicazione, '*', m.figlio, w_figlio, 'ISTAMDU', 25
      from a_menu m, a_applicazioni a
     where m.voce_menu	  = 'ISTAMIS'
       and m.applicazione = a.applicazione
       and a.applicazione in ('GSD','GSDANA','GSDCIV','GSDALL')
       and not exists (select 1 from a_menu b
                        where b.applicazione = a.applicazione
                          and b.voce_menu    = 'ISTAMDU'
                          and b.ruolo        = '*')
    UNION
    select distinct a.applicazione, 'GSD', m.figlio, w_figlio, 'ISTAMDU', 25
      from a_menu m, a_applicazioni a
     where m.voce_menu	  = 'ISTAMIS'
       and m.applicazione = a.applicazione
       and a.applicazione in ('GSD','GSDANA','GSDCIV','GSDALL')
       and not exists (select 1 from a_menu b
                        where b.applicazione = a.applicazione
                          and b.voce_menu    = 'ISTAMDU'
                          and b.ruolo        = 'GSD')
    UNION
    select distinct a.applicazione, 'RGSD', m.figlio, w_figlio, 'ISTAMDU', 25
      from a_menu m, a_applicazioni a
     where m.voce_menu	  = 'ISTAMIS'
       and m.applicazione = a.applicazione
       and a.applicazione in ('GSD','GSDANA','GSDCIV','GSDALL')
       and not exists (select 1 from a_menu b
                        where b.applicazione = a.applicazione
                          and b.voce_menu    = 'ISTAMDU'
                          and b.ruolo        = 'RGSD')
    ;
  end;
end;
/
