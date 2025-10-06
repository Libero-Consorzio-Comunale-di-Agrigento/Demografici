--liquibase formatted sql
--changeset amonopoli:202503211110_2 runOnChange:true stripComments:false
declare
w_figlio		number;

begin
  begin 
    insert into a_voci_menu
	     (voce_menu, ambiente, acronimo, titolo, tipo_voce, tipo, modulo, stringa) 
    select 'CIVVDD8', ambiente, 'VDD8', 'Riepilogo per Modello D.8', 'F', 'F', 'ISTEDD8', ''
      from a_ambienti a
     where ambiente = 'GSD'
       and not exists (select 1 from a_voci_menu b
                        where b.voce_menu = 'CIVVDD8'
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
    select distinct a.applicazione, '*', m.figlio, w_figlio, 'CIVVDD8', 101
      from a_menu m, a_applicazioni a
     where m.voce_menu	  = 'CIVVATT'
       and m.applicazione = a.applicazione
       and a.applicazione in ('GSD','GSDALL','GSDCIV')
       and not exists (select 1 from a_menu b
                        where b.applicazione = a.applicazione
                          and b.voce_menu    = 'CIVVDD8'
                          and b.ruolo        = '*')
    UNION
    select distinct a.applicazione, 'GSD', m.figlio, w_figlio, 'CIVVDD8', 101
      from a_menu m, a_applicazioni a
     where m.voce_menu	  = 'CIVVATT'
       and m.applicazione = a.applicazione
       and a.applicazione in ('GSD','GSDALL','GSDCIV')
       and not exists (select 1 from a_menu b
                        where b.applicazione = a.applicazione
                          and b.voce_menu    = 'CIVVDD8'
                          and b.ruolo        = 'GSD')
    UNION
    select distinct a.applicazione, 'RGSD', m.figlio, w_figlio, 'CIVVDD8', 101
      from a_menu m, a_applicazioni a
     where m.voce_menu	  = 'CIVVATT'
       and m.applicazione = a.applicazione
       and a.applicazione in ('GSD','GSDALL','GSDCIV')
       and not exists (select 1 from a_menu b
                        where b.applicazione = a.applicazione
                          and b.voce_menu    = 'CIVVDD8'
                          and b.ruolo        = 'RGSD')
    ;
  end;
 
end;
/

