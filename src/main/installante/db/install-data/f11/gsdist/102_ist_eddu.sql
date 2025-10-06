--liquibase formatted sql
--changeset amonopoli:202503211055_2 runOnChange:true stripComments:false
declare
w_padre		number;
w_figlio	number;

begin
  begin 
    insert into a_voci_menu
	     (voce_menu, ambiente, acronimo, titolo, tipo_voce, tipo, modulo) 
    select 'ISTEDDU', ambiente, 'EDDU', 'ISTAT D.3.U (unioni civili)', 'F', 'F', 'ISTEDDU'
      from a_ambienti a
     where ambiente = 'GSD'
       and not exists (select 1 from a_voci_menu b
                        where b.voce_menu = 'ISTEDDU'
                          and b.ambinete  = a.ambiente)
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
    select distinct a.applicazione, '*', m.figlio, w_figlio, 'ISTEDDU', 25
      from a_menu m, a_applicazioni a
     where m.voce_menu	  = 'ISTEDIS'
       and m.applicazione = a.applicazione
       and substr(a.applicazione,1,6) in ('GSD','GSDANA','GSDCIV','GSDALL')
       and not exists (select 1 from a_menu b
                        where b.applicazione = a.applicazione
                          and b.voce_menu    = 'ISTEDDU'
                          and b.ruolo        = '*')
    UNION
    select distinct a.applicazione, 'GSD', m.figlio, w_figlio, 'ISTEDDU', 25
      from a_menu m, a_applicazioni a
     where m.voce_menu	  = 'ISTEDIS'
       and m.applicazione = a.applicazione
       and substr(a.applicazione,1,6) in ('GSD','GSDANA','GSDCIV','GSDALL')
       and not exists (select 1 from a_menu b
                        where b.applicazione = a.applicazione
                          and b.voce_menu    = 'ISTEDDU'
                          and b.ruolo        = 'GSD')
    UNION
    select distinct a.applicazione, 'RGSD', m.figlio, w_figlio, 'ISTEDDU', 25
      from a_menu m, a_applicazioni a
     where m.voce_menu	  = 'ISTEDIS'
       and m.applicazione = a.applicazione
       and substr(a.applicazione,1,6) in ('GSD','GSDANA','GSDCIV','GSDALL')
       and not exists (select 1 from a_menu b
                        where b.applicazione = a.applicazione
                          and b.voce_menu    = 'ISTEDDU'
                          and b.ruolo        = 'RGSD')
    ;
  end;
end;
/
delete a_passi_proc
 where voce_menu 	= 'ISTEDDU'
/
insert into a_passi_proc
	(VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, 
	 TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
select 'ISTEDDU', 1, 'ISTATEL - Estrazione Modelli D.3.U', '', '',
	 'Q', 'ISTEDDU', '', '', 'N'
  from dual
UNION
select 'ISTEDDU', 2, 'ISTATEL - Estrazione Modelli D.3.U', '', '',
	 'R', 'SI4V3WAS', '', '', 'N'
  from dual
UNION
select 'ISTEDDU', 3, 'ISTATEL - Estrazione Modelli D.3.U', '', '',
	 'Q', 'ACACANAS', '', '', 'N'
  from dual
/
delete a_selezioni
 where voce_menu = 'ISTEDDU'
/
insert into a_selezioni
	(PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, 
	 LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK)
select 'NUM_CARATTERI', 'ISTEDDU', 0, 'Caratteri per Substring', '', '',
	 5, 'C', 'S', '4000', '', '', '', ''
  from dual
UNION
select 'SE_RTRIM', 'ISTEDDU', 0, 'Abilita Substring', '', '',
	 10, 'C', 'S', 'SI', '', '', '', ''
  from dual
UNION
select 'SE_SUBSTR', 'ISTEDDU', 0, 'Abilita Substring', '', '',
	 10, 'C', 'S', 'SI', '', '', '', ''
  from dual
UNION
select 'TXTFILE', 'ISTEDDU', 0, 'Nome TXT File', '', '',
	 80, 'C', 'S', 'istatel\DU.txt', '', '', '', ''
  from dual
/
