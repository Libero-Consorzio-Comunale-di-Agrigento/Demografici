--liquibase formatted sql
--changeset amonopoli:202503270900_12 runOnChange:false stripComments:false
declare
w_menu		number;
w_passi_proc	number;

begin
  begin
    select 1 into w_menu
      from a_menu
     where applicazione = 'GSD'
       and rownum = 1
    ;
  exception
    when no_data_found then
         w_menu := 0;
    when others then
         w_menu := -1;
  end;

  if w_menu = 0 then
     begin
       select 1 into w_passi_proc
         from a_passi_proc
        where voce_menu in (select voce_menu from a_voci_menu where ambiente = 'GSD')
          and rownum = 1
       ;  
     exception
       when no_data_found then
            w_passi_proc := 0;
       when others then
            w_passi_proc := -1;
     end;

     if w_passi_proc = 0 then

begin
insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAAFRA', 1, 'Acquisizione File di Anomalie INA', '', '', 'C', '', 'ANAAFRA', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAAFRI', 1, 'Acquisizione File di Ritorno INA', '', '', 'C', '', 'ANAAFRI', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAAI01', 1, 'Estrazione Dati per ANAG-AIRE', '', '', 'Q', 'ANAAI01', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAAI01', 2, 'Estrazione Dati per ANAG-AIRE', '', '', 'R', 'SI4V3WAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAAI01', 3, 'Estrazione Dati per ANAG-AIRE', '', '', 'Q', 'ACACANAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAECP5', 1, 'Estrazione Modello CP.5', '', '', 'Q', 'ANAECP5', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAECP5', 2, 'Estrazione Modello CP.5', '', '', 'R', 'SI4V3WAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAECP5', 3, 'Estrazione Modello CP.5', '', '', 'Q', 'ACACANAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAELAC', 1, 'Estrazione LAC per ISTAT', '', '', 'Q', 'ANAELAC', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAELAC', 2, 'Estrazione LAC per ISTAT', '', '', 'R', 'SI4V3WAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAELAC', 3, 'Estrazione LAC per ISTAT', '', '', 'Q', 'ACACANAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAESQU', 1, 'Estrazione Stranieri per Questura', '', '', 'Q', 'ANAESQU', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAESQU', 2, 'Estrazione Stranieri per Questura', '', '', 'R', 'SI4V3WAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAESQU', 3, 'Estrazione Stranieri per Questura', '', '', 'Q', 'ACACANAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAEVNC', 1, 'Estrazione Vie e Numeri Civici', '', '', 'Q', 'ANAEVNC', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAEVNC', 2, 'Estrazione Vie e Numeri Civici', '', '', 'R', 'SI4V3WAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAEVNC', 3, 'Estrazione Vie e Numeri Civici', '', '', 'Q', 'ACACANAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAFSDE', 1, 'Fornitura Soggetti Deceduti', '', '', 'Q', 'ANAFSDE', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAFSDE', 2, 'Fornitura Soggetti Deceduti', '', '', 'R', 'SI4V3WAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAFSDE', 3, 'Fornitura Soggetti Deceduti', '', '', 'Q', 'ACACANAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAPINA', 1, 'Popolazione INA', '', '', 'Q', 'ANAPINA', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAPINA', 2, 'Popolazione INA', '', '', 'R', 'SI4V3WAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANAPINA', 3, 'Popolazione INA', '', '', 'Q', 'ACACANAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANARCFR', 1, 'Richiesta Codice Fiscale per Residenti', '', '', 'Q', 'ANARCFR', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANARCFR', 2, 'Richiesta Codice Fiscale per Residenti', '', '', 'R', 'ANARCFR', '', 'ANACRFR', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANARCFR', 3, 'Richiesta Codice Fiscale per Residenti', '', '', 'Q', 'ACACANAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANARSCA', 1, 'Rifornitura Soggetti Con Anomalia', '', '', 'Q', 'ANARSCA', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANARSCA', 2, 'Rifornitura Soggetti Con Anomalia', '', '', 'R', 'SI4V3WAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANARSCA', 3, 'Rifornitura Soggetti Con Anomalia', '', '', 'Q', 'ACACANAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANASTNA', 1, 'Rilevazione Stranieri per Nazionalita', '', '', 'Q', 'ANASTNA', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANASTNA', 2, 'Rilevazione Stranieri per Nazionalita', '', '', 'R', 'SI4V3WAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANASTNA', 3, 'Rilevazione Stranieri per Nazionalita', '', '', 'Q', 'ACACANAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANASTSA', 1, 'Rilevazione Stranieri per Nascita', '', '', 'Q', 'ANASTSA', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANASTSA', 2, 'Rilevazione Stranieri per Nascita', '', '', 'R', 'SI4V3WAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ANASTSA', 3, 'Rilevazione Stranieri per Nascita', '', '', 'Q', 'ACACANAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ELELASM', 1, 'Liste Aggiunte su Supporto Magnetico', '', '', 'Q', 'ELELASM', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ELELASM', 2, 'Liste Aggiunte su Supporto Magnetico', '', '', 'R', 'SI4V3WAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ELELASM', 3, 'Liste Aggiunte su Supporto Magnetico', '', '', 'Q', 'ACACANAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ELELESM', 1, 'Liste Elettorali su Supporto Magnetico', '', '', 'Q', 'ELELESM', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ELELESM', 2, 'Liste Elettorali su Supporto Magnetico', '', '', 'R', 'SI4V3WAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ELELESM', 3, 'Liste Elettorali su Supporto Magnetico', '', '', 'Q', 'ACACANAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ELEPSMI', 1, 'Presidenti di Seggio per Min. Interno', '', '', 'Q', 'ELEPSMI', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ELEPSMI', 2, 'Presidenti di Seggio per Min. Interno', '', '', 'R', 'SI4V3WAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('ELEPSMI', 3, 'Presidenti di Seggio per Min. Interno', '', '', 'Q', 'ACACANAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('LEVLLMD', 1, 'Liste di Leva per Min. Difesa - L', '', '', 'Q', 'LEVLLMD', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('LEVLLMD', 2, 'Liste di Leva per Min. Difesa - L', '', '', 'R', 'SI4V3WAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('LEVLLMD', 3, 'Liste di Leva per Min. Difesa - C', '', '', 'Q', 'LEVLLM1', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('LEVLLMD', 4, 'Liste di Leva per Min. Difesa - C', '', '', 'R', 'SI4V3WAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('LEVLLMD', 5, 'Liste di Leva per Min. Difesa - N', '', '', 'Q', 'LEVLLM2', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('LEVLLMD', 6, 'Liste di Leva per Min. Difesa - N', '', '', 'R', 'SI4V3WAS', '', '', 'N');

insert into a_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('LEVLLMD', 7, 'Liste di Leva per Min. Difesa', '', '', 'Q', 'ACACANAS', '', '', 'N');
end;

     end if;
  end if;
end;
/


