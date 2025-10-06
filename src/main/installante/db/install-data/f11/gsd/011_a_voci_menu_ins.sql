--liquibase formatted sql
--changeset amonopoli:202503270900_11 runOnChange:false stripComments:false
declare
w_menu		number;
w_voci_menu	number;

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
       select 1 into w_voci_menu
         from a_voci_menu
        where ambiente = 'GSD'
          and rownum = 1
       ;
     exception
       when no_data_found then
            w_voci_menu := 0;
       when others then
            w_voci_menu := -1;
     end;

     if w_voci_menu = 0 then

begin
insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('MENUARC', 'GSD', 'ARC', '', '', 'Archivi', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('MENUANA', 'GSD', 'ANA', '', '', 'Anagrafe', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('MENUCIV', 'GSD', 'CIV', '', '', 'Stato Civile', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('MENUELE', 'GSD', 'ELE', '', '', 'Elettorale', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('MENULEV', 'GSD', 'LEV', '', '', 'Leve', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('MENUCER', 'GSD', 'CER', '', '', 'Certificazione', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('GSDMENU', 'GSD', 'MENU', '', '', 'Servizi Demografici', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCSARC', 'GSD', 'SARC', '', '', 'Stampe Archivi', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCPARC', 'GSD', 'PARC', '', '', 'Personalizzazioni Archivi', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCGPRO', 'GSD', 'GPRO', '', '', 'Gestione Archivio Province', '', '', 'F', 'F', 'ARCGPRO', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCVCOM', 'GSD', 'VCOM', '', '', 'Visual.  Archivio Comuni', '', '', 'F', 'F', 'ARCVCOM', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCGCOM', 'GSD', 'GCOM', '', '', 'Gestione Archivio Comuni', '', '', 'F', 'F', 'ARCGCOM', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCVVIE', 'GSD', 'VVIE', '', '', 'Visual.  Archivio Vie', '', '', 'F', 'F', 'ARCVVIE', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCGVIE', 'GSD', 'GVIE', '', '', 'Gestione Archivio Vie', '', '', 'F', 'F', 'ARCGVIE', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCGCON', 'GSD', 'GCON', '', '', 'Gestione Archivio Consolati', '', '', 'F', 'F', 'ARCGCON', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCGDCO', 'GSD', 'GDCO', '', '', 'Gestione Archivio Tipi Consolato', '', '', 'F', 'F', 'ARCGDCO', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCGTES', 'GSD', 'GTES', '', '', 'Gestione Archivio Territori Esteri', '', '', 'F', 'F', 'ARCGTES', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCGINP', 'GSD', 'GINP', '', '', 'Installazione Parametri', '', '', 'F', 'F', 'ARCGINP', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCADNC', 'GSD', 'ADNC', '', '', 'Definizione Numerazione Civica', '', '', 'F', 'F', 'ARCADNC', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCSPCO', 'GSD', 'SPCO', '', '', 'Stampa Province in ordine di Codice', '', '', 'F', 'D', 'ARCSPCO', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCSCCO', 'GSD', 'SCCO', '', '', 'Stampa Comuni in ordine di Codice', '', '', 'F', 'D', 'ARCSCCO', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCSCIA', 'GSD', 'SCIA', '', '', 'Stampa Comuni Italiani in ord.Alfabetico', '', '', 'F', 'D', 'ARCSCIA', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCSCEA', 'GSD', 'SCEA', '', '', 'Stampa Comuni Esteri   in ord.Alfabetico', '', '', 'F', 'D', 'ARCSCEA', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCSVIA', 'GSD', 'SVIA', '', '', 'Stampa Vie in ordine Alfabetico', '', '', 'F', 'D', 'ARCSVIA', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCSVIC', 'GSD', 'SVIC', '', '', 'Stampa Vie in ordine di Codice', '', '', 'F', 'D', 'ARCSVIC', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCSCON', 'GSD', 'SCON', '', '', 'Stampa Consolati', '', '', 'F', 'D', 'ARCSCON', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCSTES', 'GSD', 'STES', '', '', 'Stampa Territori Esteri', '', '', 'F', 'D', 'ARCSTES', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCSCCE', 'GSD', 'SCCE', '', '', 'Stampa Controllo Comuni Errati', '', '', 'F', 'D', 'ARCSCCE', '72 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCSDIC', 'GSD', 'SDIC', '', '', 'Stampa Diretta di Controllo', '', '', 'F', 'D', 'ARCSDIC', '66 ', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('PARCGCER', 'GSD', 'GCER', '', '', 'Gestione Comuni Errati', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('PARCGVIR', 'GSD', 'GVIR', '', '', 'Gestione Vie Ripetute', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCECER', 'GSD', 'ECER', '', '', 'Estrazione Comuni Errati', '', '', 'F', 'D', 'ARCECER', '66 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCACER', 'GSD', 'ACER', '', '', 'Aggiornamento Comuni Errati', '', '', 'F', 'F', 'ARCACER', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCSCER', 'GSD', 'SCER', '', '', 'Stampa Comuni Errati', '', '', 'F', 'D', 'ARCSCER', '66 -dp', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANADANA', 'GSD', 'DANA', '', '', 'Dizionario', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAGARC', 'GSD', 'GARC', '', '', 'Generazione Archivi', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAARES', 'GSD', 'ARES', '', '', 'Gestione Anagrafe Residenti', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAAIRE', 'GSD', 'AIRE', '', '', 'Gestione A.I.R.E.', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAECIV', 'GSD', 'ECIV', '', '', 'Eventi di Stato Civile', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVIAN', 'GSD', 'VIAN', '', '', 'Visualizzazioni', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASTAN', 'GSD', 'STAN', '', '', 'Stampe', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAPANA', 'GSD', 'PANA', '', '', 'Personalizzazioni Anagrafe', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAGCEN', 'GSD', 'GCEN', '', '', 'Gestione Censimento', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAELEV', 'GSD', 'ELEV', '', '', 'Eliminazione Eventi', '', '', 'F', 'D', 'ANAELEV', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAGDOC', 'GSD', 'GDOC', '', '', 'Gestione Documenti', '', '', 'F', 'F', 'ANAGDOC', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAAGEV', 'GSD', 'AGEV', '', '', 'Aggiornamento Eventi', '', '', 'F', 'D', 'ANAAGEV', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANARMIN', 'GSD', 'RMIN', '', '', 'Rettifica Minuscole', '', '', 'F', 'F', 'ANARIND', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANANOTE', 'GSD', 'NOTE', '', '', 'Aggiornamento Note', '', '', 'F', 'F', 'ANANOTE', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('DANASDAN', 'GSD', 'SDAN', '', '', 'Stampa Dizionario', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANADSEN', 'GSD', 'DSEN', '', '', 'Dizionario Sentenze', '', '', 'F', 'F', 'ANADSEN', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANADANG', 'GSD', 'DANG', '', '', 'Dizionario Anagrafe Generale', '', '', 'F', 'F', 'ANADANG', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANADTER', 'GSD', 'DTER', '', '', 'Dizionario Territorio', '', '', 'F', 'F', 'ANADTER', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANADDOC', 'GSD', 'DDOC', '', '', 'Dizionario Documenti', '', '', 'F', 'F', 'ANADDOC', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAAVST', 'GSD', 'AVST', '', '', 'Visualizz. Suddivisioni Territoriali', '', '', 'F', 'F', 'ANAAVST', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASDUT', 'GSD', 'SDUT', '', '', 'Elenco Unita'' Territoriali', '', '', 'F', 'D', 'ANASDUT', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASDST', 'GSD', 'SDST', '', '', 'Elenco Suddivisioni Territoriali', '', '', 'F', 'D', 'ANASDST', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASDTS', 'GSD', 'SDTS', '', '', 'Elenco Titoli di Studio', '', '', 'F', 'D', 'ANASDTS', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASDPR', 'GSD', 'SDPR', '', '', 'Elenco Professioni', '', '', 'F', 'D', 'ANASDPR', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASDCI', 'GSD', 'SDCI', '', '', 'Elenco Cittadinanze', '', '', 'F', 'D', 'ANASDCI', '72 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASDCA', 'GSD', 'SDCA', '', '', 'Elenco Categorie Documenti', '', '', 'F', 'D', 'ANASDCA', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASDUP', 'GSD', 'SDUP', '', '', 'Elenco Uffici Postali', '', '', 'F', 'D', 'ANASDUP', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASAST', 'GSD', 'SAST', '', '', 'Stampa Suddivisioni Territoriali per Via', '', '', 'F', 'D', 'ANASAST', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASSAG', 'GSD', 'SSAG', '', '', 'Stampa Stradario Alfabetico Generale', '', '', 'F', 'D', 'ANASSAG', '72 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACANA', 'GSD', 'CANA', '', '', 'Caricamento anagrafe residenti', '', '', 'F', 'F', 'ANACANA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACAIR', 'GSD', 'CAIR', '', '', 'Caricamento A.I.R.E.', '', '', 'F', 'F', 'ANACAIR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASCAM', 'GSD', 'SCAM', '', '', 'Stampa Caricamento Anagrafe', '', '', 'F', 'D', 'ANASCAM', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASCAA', 'GSD', 'SCAA', '', '', 'Stampa Caricamento in ordine Alfabetico', '', '', 'F', 'D', 'ANASCAA', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACANR', 'GSD', 'CANR', '', '', 'Caricamento Anagrafe Non Residenti', '', '', 'F', 'F', 'ANACANR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAFAIR', 'GSD', 'FAIR', '', '', 'Nuovi Codici Famiglia A.I.R.E.', '', '', 'F', 'F', 'ANAFAIR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANA2FAM', 'GSD', '2FAM', '', '', 'Inserimento famiglie non piu'' residenti', '', '', 'F', 'F', 'ANA2FAM', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANARSTO', 'GSD', 'RSTO', '', '', 'Residenze Storiche', '', '', 'F', 'F', 'ANARSTO', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANARSTA', 'GSD', 'RSTA', '', '', 'Residenze Storiche A.I.R.E.', '', '', 'F', 'F', 'ANARSTA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAFSTO', 'GSD', 'FSTO', '', '', 'Chiusure Famiglia Storiche', '', '', 'F', 'F', 'ANAFSTO', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACSPT', 'GSD', 'CSPT', '', '', 'Schedario Popolazione Temporanea', '', '', 'F', 'F', 'ANARIND', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAAALB', 'GSD', 'AALB', '', '', 'Albero dei Nati Residenti', '', '', 'F', 'F', 'ANARIND', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAESTC', 'GSD', 'ESTC', '', '', 'Eventi Storici di Stato Civile', '', '', 'F', 'F', 'ANAESTC', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAFSTA', 'GSD', 'FSTA', '', '', 'Chiusure Famiglia Storiche A.I.R.E.', '', '', 'F', 'F', 'ANAFSTA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAESTO', 'GSD', 'ESTO', '', '', 'Eventi Storici', '', '', 'F', 'F', 'ANAESTO', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASSPT', 'GSD', 'SSPT', '', '', 'Stampa Schedario Popolazione Temp.', '', '', 'F', 'D', 'ANASSPT', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARESGEVR', 'GSD', 'GEVR', '', '', 'Gestione Eventi Residenti', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANARANR', 'GSD', 'RANR', '', '', 'Rettifica Anagrafe Residenti', '', '', 'F', 'F', 'ANARANR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('GEVRGAP4', 'GSD', 'GAP4', '', '', 'Gestione Modello APR/4', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAIAPR', 'GSD', 'IAPR', '', '', 'Iscrizioni in APR', '', '', 'F', 'F', 'ANAIAPR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACAPR', 'GSD', 'CAPR', '', '', 'Cancellazioni dall''APR', '', '', 'F', 'F', 'ANACAPR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACABI', 'GSD', 'CABI', '', '', 'Cambio di Abitazione', '', '', 'F', 'F', 'ANACABI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANARICO', 'GSD', 'RICO', '', '', 'Ricomparsa dopo Irreperibilita`', '', '', 'F', 'F', 'ANARIND', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAMORP', 'GSD', 'MORP', '', '', 'Modifica Rapporti Parentela', '', '', 'F', 'F', 'ANAMORP', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACAMO', 'GSD', 'CAMO', '', '', 'Cancellazione Anagrafica per Morte', '', '', 'F', 'F', 'ANACAMO', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAAINI', 'GSD', 'AINI', '', '', 'Individui Non Immigrabili', '', '', 'F', 'F', 'ANAAINI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('GEVRGEPT', 'GSD', 'GEPT', '', '', 'Gestione Eventi per Tipo', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACAP4', 'GSD', 'CAP4', '', '', 'Caricamento Mod. APR/4', '', '', 'F', 'F', 'ANACAP4', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANARAP4', 'GSD', 'RAP4', '', '', 'Rettifica Mod. APR/4', '', '', 'F', 'F', 'ANARAP4', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASAP4', 'GSD', 'SAP4', '', '', 'Stampa Mod. APR/4', '', '', 'F', 'D', 'ANASAP4', '114', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASREN', 'GSD', 'SREN', '', '', 'Stampa Richiesta Estratti di Nascita', '', '', 'F', 'D', 'ANASREN', '70 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASMPC', 'GSD', 'SMPC', '', '', 'Stampa Modulo per aggiornamento PT e CC', '', '', 'F', 'D', 'ANASMPC', '78', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVAP4', 'GSD', 'VAP4', '', '', 'Visualizzazione Mod. APR/4', '', '', 'F', 'F', 'ANAVAP4', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVAPM', 'GSD', 'VAPM', '', '', 'Visualizzazione Individui in APR/4', '', '', 'F', 'F', 'ANAVAPM', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAAAP4', 'GSD', 'AAP4', '', '', 'Annullamento Mod. APR/4', '', '', 'F', 'F', 'ANAAAP4', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASCAP', 'GSD', 'SCAP', '', '', 'Stampa Comunicazioni Annullamento APR/4', '', '', 'F', 'D', 'ANASCAP', '70 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAEAP4', 'GSD', 'EAP4', '', '', 'Eliminazione Mod. APR/4', '', '', 'F', 'F', 'ANAEAP4', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACCP4', 'GSD', 'CCP4', '', '', 'Caricamento Mod. APR/4 (Cancellazione)', '', '', 'F', 'F', 'ANACCP4', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASCP4', 'GSD', 'SCP4', '', '', 'Stampa Mod. APR/4 (Cancellazione)', '', '', 'F', 'F', 'ANASCP4', '114', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVCPM', 'GSD', 'VCPM', '', '', 'Visualizzazione Cancellati', '', '', 'F', 'F', 'ANAVCPM', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('AIREGEVA', 'GSD', 'GEVA', '', '', 'Gestione Eventi A.I.R.E.', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANARANA', 'GSD', 'RANA', '', '', 'Rettifica A.I.R.E.', '', '', 'F', 'F', 'ANARANA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('GEVAGA01', 'GSD', 'GA01', '', '', 'Gestione Modello AIRE/01', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAISAI', 'GSD', 'ISAI', '', '', 'Iscrizione Motivi Vari', '', '', 'F', 'F', 'ANAISAI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACVAI', 'GSD', 'CVAI', '', '', 'Cancellazione Motivi Vari', '', '', 'F', 'F', 'ANACVAI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASCAI', 'GSD', 'SCAI', '', '', 'Scissione A.I.R.E.', '', '', 'F', 'F', 'ANASCAI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACREA', 'GSD', 'CREA', '', '', 'Cambio di Residenza', '', '', 'F', 'F', 'ANACREA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAMRPA', 'GSD', 'MRPA', '', '', 'Modifica Rapporti Parentela', '', '', 'F', 'F', 'ANAMRPA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACA01', 'GSD', 'CA01', '', '', 'Caricamento Mod. AIRE/01', '', '', 'F', 'F', 'ANACA01', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANARA01', 'GSD', 'RA01', '', '', 'Rettifica Mod. AIRE/01', '', '', 'F', 'F', 'ANARA01', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASA01', 'GSD', 'SA01', '', '', 'Stampa Mod. AIRE/01', '', '', 'F', 'D', 'ANASA01', '100', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVA0M', 'GSD', 'VA0M', '', '', 'Visualizzazione Mod. AIRE/01', '', '', 'F', 'F', 'ANAVA0M', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVA0I', 'GSD', 'VA0I', '', '', 'Visualizzazione Individui in AIRE/01', '', '', 'F', 'F', 'ANAVA0I', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACC01', 'GSD', 'CC01', '', '', 'Caricamento Mod. AIRE/01 (Cancellazione)', '', '', 'F', 'F', 'ANACC01', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASCNA', 'GSD', 'SCNA', '', '', 'Nascita', '', '', 'F', 'F', 'ANASCNA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASCMA', 'GSD', 'SCMA', '', '', 'Matrimonio', '', '', 'F', 'F', 'ANASCMA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASCMO', 'GSD', 'SCMO', '', '', 'Morte', '', '', 'F', 'F', 'ANASCMO', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASCDV', 'GSD', 'SCDV', '', '', 'Divorzio', '', '', 'F', 'F', 'ANASCDV', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAAGES', 'GSD', 'AGES', '', '', 'Aggiornamento Eventi di Stato Civile', '', '', 'F', 'D', 'ANAAGES', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('VIANVRPR', 'GSD', 'VRPR', '', '', 'Visualizzazione Registri Pratiche', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVANA', 'GSD', 'VANA', '', '', 'Visualizzazione Anagrafe', '', '', 'F', 'F', 'ANARIND', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVEVE', 'GSD', 'VEVE', '', '', 'Visualizzazione Eventi', '', '', 'F', 'F', 'ANARIND', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVDOC', 'GSD', 'VDOC', '', '', 'Visualizzazione Documenti', '', '', 'F', 'F', 'ANARIND', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVDOG', 'GSD', 'VDOG', '', '', 'Visualizzazione Documenti Generale', '', '', 'F', 'F', 'ANAVDOG', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVANM', 'GSD', 'VANM', '', '', 'Visualizzazione Anagrafe Minima', '', '', 'F', 'F', 'ANARIND', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVNCO', 'GSD', 'VNCO', '', '', 'Visualizzazione Nuclei Coabitanti', '', '', 'F', 'F', 'ANAVNCO', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVMOV', 'GSD', 'VMOV', '', '', 'Visualizzazione Movimenti', '', '', 'F', 'F', 'ANAVMOV', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVSEN', 'GSD', 'VSEN', '', '', 'Visualizzazione Sentenze', '', '', 'F', 'F', 'ANAVSEN', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVCEN', 'GSD', 'VCEN', '', '', 'Visualizzazione Dati Censimento', '', '', 'F', 'F', 'ANAVCEN', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVTPR', 'GSD', 'VTPR', '', '', 'Visualizzazione Pratiche', '', '', 'F', 'F', 'ANAVTPR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVFAM', 'GSD', 'VFAM', '', '', 'Visualizzazione Famiglie', '', '', 'F', 'F', 'ANAVFAM', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAMTPR', 'GSD', 'MTPR', '', '', 'Monitoraggio Avanzamento Pratiche', '', '', 'F', 'F', 'ANAMTPR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVNCD', 'GSD', 'VNCD', '', '', 'Vis. Nuclei Coabitanti alla Data', '', '', 'F', 'F', 'ANAVNCD', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVR01', 'GSD', 'VR01', '', '', 'Visualizzazione Registri A.I.R.E.', '', '', 'F', 'F', 'ANAVR01', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVDAL', 'GSD', 'VDAL', '', '', 'Verifica Disponibilit  Alloggi', '', '', 'F', 'F', 'ANAVDAL', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASAIA', 'GSD', 'SAIA', '', '', 'Interrogazione S.A.I.A.', '', '', 'F', 'F', 'ANASAIA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVANG', 'GSD', 'VANG', '', '', 'Visualizzazione Anagrafe Generale', '', '', 'F', 'F', 'ANAVANG', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVIGI', 'GSD', 'VIGI', '', '', 'Vigilanza Anagrafica', '', '', 'F', 'F', 'ANAVIGI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('GSDVLOG', 'GSD', 'VLOG', '', '', 'Visualizzazione Log Fasi', '', '', 'F', 'F', 'GSDVLOG', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVRIR', 'GSD', 'VRIR', '', '', 'Registro Iscrizioni (Residenti)', '', '', 'F', 'F', 'ANAVRIR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVRCR', 'GSD', 'VRCR', '', '', 'Registro Cancellazioni (Residenti)', '', '', 'F', 'F', 'ANAVRCR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('STANSPAN', 'GSD', 'SPAN', '', '', 'Stampe Periodiche', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('STANSSTA', 'GSD', 'SSTA', '', '', 'Statistiche', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('STANSSAA', 'GSD', 'SSAA', '', '', 'Visualizzazione Indici', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('STANSVAN', 'GSD', 'SVAN', '', '', 'Stampe Varie Anagrafe', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASRPR', 'GSD', 'SRPR', '', '', 'Stampa Registri Pratiche', '', '', 'F', 'D', 'ANASRPR', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASCAW', 'GSD', 'SCAW', '', '', 'Stampa Comunicazioni (A4)', '', '', 'F', 'D', 'ANASCAW', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASR01', 'GSD', 'SR01', '', '', 'Stampa Registri A.I.R.E.', '', '', 'F', 'D', 'ANASR01', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASAPW', 'GSD', 'SAPW', '', '', 'Stampa Adempimenti Pratica (A4)', '', '', 'F', 'D', 'ANASAPW', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('SPANSPSI', 'GSD', 'SPSI', '', '', 'Aggiornamento Schede Individuali', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('SPANSPFF', 'GSD', 'SPFF', '', '', 'Aggiornamento Fogli Famiglia', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('SPANSPVA', 'GSD', 'SPVA', '', '', 'Stampe Varie', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASRGP', 'GSD', 'SRGP', '', '', 'Rilevazione Giornaliera Pop. Res.  AP/10', '', '', 'F', 'D', 'ANASRGP', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASRMP', 'GSD', 'SRMP', '', '', 'Rilevazione Mensile Pop. Res.      D.7.B', '', '', 'F', 'D', 'ANASRMP', '88 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASRAP', 'GSD', 'SRAP', '', '', 'Rilevazione Annuale Pop. Res.      AP/11', '', '', 'F', 'D', 'ANASRAP', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASMP2', 'GSD', 'SMP2', '', '', 'Stampa Modello ISTAT P.2', '', '', 'F', 'D', 'ANASMP2', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAIST3', 'GSD', 'IST3', '', '', 'Rilevazione Annuale Stranieri        P/3', '', '', 'F', 'D', 'ANAIST3', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASMAG', 'GSD', 'SMAG', '', '', 'Stampa Movimenti Anagrafe Generale', '', '', 'F', 'D', 'ANASMAG', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACSTR', 'GSD', 'CSTR', '', '', 'Stampa di Controllo Stranieri', '', '', 'F', 'D', 'ANACSTR', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASI01', 'GSD', 'SI01', '', '', 'Elenco Schede da Archiviare', '', '', 'F', 'D', 'ANASI01', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASI02', 'GSD', 'SI02', '', '', 'Elenco Nuove Schede', '', '', 'F', 'D', 'ANASI02', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASI03', 'GSD', 'SI03', '', '', 'Elenco Variazioni Indirizzo', '', '', 'F', 'D', 'ANASI03', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASI04', 'GSD', 'SI04', '', '', 'Elenco Variazioni', '', '', 'F', 'D', 'ANASI04', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASI05', 'GSD', 'SI05', '', '', 'Nuove Schede', '', '', 'F', 'D', 'ANASI05', '54', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAFF01', 'GSD', 'FF01', '', '', 'Elenco Fogli da Archiviare', '', '', 'F', 'D', 'ANAFF01', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAFF02', 'GSD', 'FF02', '', '', 'Elenco Nuovi Fogli', '', '', 'F', 'D', 'ANAFF02', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAFF03', 'GSD', 'FF03', '', '', 'Elenco Variazioni Indirizzo', '', '', 'F', 'D', 'ANAFF03', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAFF04', 'GSD', 'FF04', '', '', 'Elenco Variazioni', '', '', 'F', 'D', 'ANAFF04', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAFF05', 'GSD', 'FF05', '', '', 'Etichette per Aggiornamento Fogli', '', '', 'F', 'D', 'ANAFF05', '12 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAFF06', 'GSD', 'FF06', '', '', 'Fogli Famiglia', '', '', 'F', 'D', 'ANAFF06', '103', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAFF07', 'GSD', 'FF07', '', '', 'Elenco Cancellazioni dai Fogli', '', '', 'F', 'D', 'ANAFF07', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAFF08', 'GSD', 'FF08', '', '', 'Elenco Aggiornamento Fogli', '', '', 'F', 'D', 'ANAFF08', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVA01', 'GSD', 'VA01', '', '', 'Elenco Immigrati', '', '', 'F', 'D', 'ANAVA01', '70', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVA02', 'GSD', 'VA02', '', '', 'Elenco Emigrati', '', '', 'F', 'D', 'ANAVA02', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVA03', 'GSD', 'VA03', '', '', 'Elenco Cambi Indirizzo', '', '', 'F', 'D', 'ANAVA03', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVA04', 'GSD', 'VA04', '', '', 'Elenco Nascite', '', '', 'F', 'D', 'ANAVA04', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVA05', 'GSD', 'VA05', '', '', 'Elenco Matrimoni', '', '', 'F', 'D', 'ANAVA05', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVA06', 'GSD', 'VA06', '', '', 'Elenco Decessi', '', '', 'F', 'D', 'ANAVA06', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVA07', 'GSD', 'VA07', '', '', 'Elenco Irreperibili', '', '', 'F', 'D', 'ANAVA07', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVA08', 'GSD', 'VA08', '', '', 'Agg. Ruoli Matricolari per Emigrati', '', '', 'F', 'D', 'ANAVA08', '54', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVAI8', 'GSD', 'VAI8', '', '', 'Agg. Ruoli Matricolari per Imm. (Bianco)', '', '', 'F', 'D', 'ANAVAI8', '70 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVAE8', 'GSD', 'VAE8', '', '', 'Agg. Ruoli Matricolari per Emi. (Bianco)', '', '', 'F', 'D', 'ANAVAE8', '70 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVA09', 'GSD', 'VA09', '', '', 'Elenco Immigrazioni Militari in Congedo', '', '', 'F', 'D', 'ANAVA09', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVA11', 'GSD', 'VA11', '', '', 'Elenco Comunicazioni Ufficio Elettorale', '', '', 'F', 'D', 'ANAVA11', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVA12', 'GSD', 'VA12', '', '', 'Etichette per Ufficio Igiene', '', '', 'F', 'D', 'ANAVA12', '12 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVA13', 'GSD', 'VA13', '', '', 'Elenco Comunicazioni Ufficio Igiene', '', '', 'F', 'D', 'ANAVA13', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVA14', 'GSD', 'VA14', '', '', 'Elenco Cambi Generalita'' e Cittadinanza', '', '', 'F', 'D', 'ANAVA14', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVA16', 'GSD', 'VA16', '', '', 'Elenco Cambi Ind. Militari in Congedo', '', '', 'F', 'D', 'ANAVA16', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVA10', 'GSD', 'VA10', '', '', 'Elenco Emigrazioni Militari in Congedo', '', '', 'F', 'D', 'ANAVA10', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVA15', 'GSD', 'VA15', '', '', 'Elenco Decessi Militari in Congedo', '', '', 'F', 'D', 'ANAVA15', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('SSTAEPSM', 'GSD', 'EPSM', '', '', 'Estrazione per Supporto Magnetico', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASEIN', 'GSD', 'SEIN', '', '', 'Stampa Elenchi Individui', '', '', 'F', 'D', 'ANASEIN', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASTIN', 'GSD', 'STIN', '', '', 'Stampa Totali Individui', '', '', 'F', 'D', 'ANASEIN', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASETI', 'GSD', 'SETI', '', '', 'Stampa Etichette Individui', '', '', 'F', 'D', 'ANASETI', '21', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASETP', 'GSD', 'SETP', '', '', 'Stampa Etichette Parametriche', '', '', 'F', 'D', 'ANASETP', '12', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASPCN', 'GSD', 'SPCN', '', '', 'Stampa per Classi di Nascita', '', '', 'F', 'D', 'ANASPCN', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASTPR', 'GSD', 'STPR', '', '', 'Stampa Totale Popolazione Residente', '', '', 'F', 'D', 'ANASTPR', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAASTA', 'GSD', 'ASTA', '', '', 'Aggiornamento Statistiche Storiche', '', '', 'F', 'F', 'ANAASTA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASETW', 'GSD', 'SETW', '', '', 'Stampa Etichette Individui (A4)', '', '', 'F', 'D', 'ANASETW', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAIST2', 'GSD', 'IST2', '', '', 'Rilevazione Pop. Residente per Nascita', '', '', 'F', 'D', 'ANAIST2', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASST2', 'GSD', 'SST2', '', '', 'Rilevazione Pop. Residente (Stampa)', '', '', 'F', 'D', 'ANASST2', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANATPAT', 'GSD', 'TPAT', '', '', 'Trasferimenti Residenza per Patenti', '', '', 'F', 'D', 'ANATPAT', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANATMCT', 'GSD', 'TMCT', '', '', 'Trasferimenti Residenza per M.C.T.C.', '', '', 'F', 'D', 'ANATMCT', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASPAT', 'GSD', 'SPAT', '', '', 'Elenco Trasferimenti Residenza Patenti', '', '', 'F', 'D', 'ANASPAT', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASMCT', 'GSD', 'SMCT', '', '', 'Elenco Trasferimenti Residenza M.C.T.C.', '', '', 'F', 'D', 'ANASMCT', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANATFSM', 'GSD', 'TFSM', '', '', 'Trasferimento File su Supporto Magnetico', '', '', 'F', 'D', 'ANATFSM', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAESQU', 'GSD', 'ESQU', '', '', 'Estrazione Stranieri per Questura', '', '', 'F', 'D', 'ANAESQU', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAEVNC', 'GSD', 'EVNC', '', '', 'Estrazione Vie e Numeri Civici', '', '', 'F', 'F', 'ANAEVNC', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAAI01', 'GSD', 'AI01', '', '', 'Estrazione Dati per ANAG-AIRE', '', '', 'F', 'D', 'ANAAI01', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASTNA', 'GSD', 'STNA', '', '', 'Rilevazione Stranieri per Nazionalita', '', '', 'F', 'D', 'ANASTNA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASTSA', 'GSD', 'STSA', '', '', 'Rilevazione Stranieri per Nascita', '', '', 'F', 'D', 'ANASTSA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASSCI', 'GSD', 'SSCI', '', '', 'Stampa Schede Individuali da Archivio', '', '', 'F', 'D', 'ANASSCI', '18', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASFFA', 'GSD', 'SFFA', '', '', 'Stampa Fogli di Famiglia da Archivio', '', '', 'F', 'D', 'ANASFFA', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASEAF', 'GSD', 'SEAF', '', '', 'Stampa Etichetta Agg. Fogli da Archivio', '', '', 'F', 'D', 'ANASEAF', '12', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASSCH', 'GSD', 'SSCH', '', '', 'Stampa Schedario Anagrafico', '', '', 'F', 'D', 'ANASSCH', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASIAI', 'GSD', 'SIAI', '', '', 'Stampa Iscritti A.I.R.E.', '', '', 'F', 'D', 'ANASIAI', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASIAG', 'GSD', 'SIAG', '', '', 'Stampa Iscritti A.I.R.E. Generale', '', '', 'F', 'D', 'ANASIAG', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASSTR', 'GSD', 'SSTR', '', '', 'Stampa Stranieri', '', '', 'F', 'D', 'ANASSTR', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASECO', 'GSD', 'SECO', '', '', 'Stampa Elenco Convivenze', '', '', 'F', 'D', 'ANASECO', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASDOC', 'GSD', 'SDOC', '', '', 'Stampa Elenco Documenti', '', '', 'F', 'D', 'ANASDOC', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAETIC', 'GSD', 'ETIC', '', '', 'Etichetta Anagrafica Individuale', '', '', 'F', 'D', 'ANAETIC', '18', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASEMC', 'GSD', 'SEMC', '', '', 'Elenco Emigrati con Carta d''Identita''', '', '', 'F', 'D', 'ANASEMC', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASMOC', 'GSD', 'SMOC', '', '', 'Elenco Morti con Carta d''Identita''', '', '', 'F', 'D', 'ANASMOC', '72 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASCID', 'GSD', 'SCID', '', '', 'Stampa Elenco Carte d''Identita'' Emesse', '', '', 'F', 'D', 'ANASCID', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASEMI', 'GSD', 'SEMI', '', '', 'Stampa Emigrati', '', '', 'F', 'D', 'ANASEMI', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASMOR', 'GSD', 'SMOR', '', '', 'Stampa Morti', '', '', 'F', 'D', 'ANASMOR', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASIRR', 'GSD', 'SIRR', '', '', 'Stampa Irreperibili', '', '', 'F', 'D', 'ANASIRR', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASINI', 'GSD', 'SINI', '', '', 'Stampa Individui Non Immigrabili', '', '', 'F', 'D', 'ANASINI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACCFI', 'GSD', 'CCFI', '', '', 'Calcolo Codice Fiscale Individuale', '', '', 'F', 'D', 'ANACCFI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACOFI', 'GSD', 'COFI', '', '', 'Calcolo Codice Fiscale', '', '', 'F', 'D', 'ANACOFI', '66 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASLCF', 'GSD', 'SLCF', '', '', 'Stampa Lettera Codice Fiscale', '', '', 'F', 'D', 'ANASLCF', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAACCE', 'GSD', 'ACCE', '', '', 'Acquisizione Codice Ecografico', '', '', 'F', 'F', 'ANAACCE', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASAP6', 'GSD', 'SAP6', '', '', 'Stampa Mod. AP6 (Bianco)', '', '', 'F', 'D', 'ANASAP6', '70', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASAP5', 'GSD', 'SAP5', '', '', 'Stampa Mod. AP5 (Bianco)', '', '', 'F', 'D', 'ANASAP5', '70', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAGSTR', 'GSD', 'GSTR', '', '', 'Gestione Stradario', '', '', 'F', 'F', 'ANAGSTR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVSTR', 'GSD', 'VSTR', '', '', 'Visualizzazione Stradario', '', '', 'F', 'D', 'ANAVSTR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('PANAGAMF', 'GSD', 'GAMF', '', '', 'Gestione Archivio Ministero Finanze', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASECL', 'GSD', 'SECL', '', '', 'Stampa Ecografici Liberi', '', '', 'F', 'F', 'ANASECL', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('PANACNSD', 'GSD', 'CNSD', '', '', 'Gestione Archivio CNSD', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACREF', 'GSD', 'CREF', '', '', 'Cambio di Residenza per piu'' famiglie', '', '', 'F', 'F', 'ANACREF', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASSTP', 'GSD', 'SSTP', '', '', 'Stampa Stradario Parametrica', '', '', 'F', 'D', 'ANASSTP', '72 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAAACI', 'GSD', 'AACI', '', '', 'Aggiornamento Cittadinanze Individuo', '', '', 'F', 'D', 'ANARIND', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVACI', 'GSD', 'VACI', '', '', 'Visualizzazione Cittadinanze Individuo', '', '', 'F', 'D', 'ANAVACI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASACI', 'GSD', 'SACI', '', '', 'Stampa Cittadinanze Inidividuo', '', '', 'F', 'D', 'ANASACI', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACENS', 'GSD', 'CENS', '', '', 'Aggiornamento Dati Censimento', '', '', 'F', 'F', 'ANACENS', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAAINR', 'GSD', 'AINR', '', '', 'Aggiornamento Individui non Residenti', '', '', 'F', 'F', 'ANAAINR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACNIM', 'GSD', 'CNIM', '', '', 'Caricamento Individui Non Immigrati', '', '', 'F', 'F', 'ANACNIM', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAANOC', 'GSD', 'ANOC', '', '', 'Abitazioni non Occupate', '', '', 'F', 'F', 'ANAANOC', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASANO', 'GSD', 'SANO', '', '', 'Stampa Abitazioni non Occupate', '', '', 'F', 'D', 'ANASANO', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASNIM', 'GSD', 'SNIM', '', '', 'Stampa Individui Non Immigrati', '', '', 'F', 'D', 'ANASNIM', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASINC', 'GSD', 'SINC', '', '', 'Stampa Individui Non Censiti', '', '', 'F', 'D', 'ANASINC', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASCP9', 'GSD', 'SCP9', '', '', 'Stampa Modello CP. 9', '', '', 'F', 'D', 'ANASCP9', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACP10', 'GSD', 'CP10', '', '', 'Stampa Modello CP.10', '', '', 'F', 'D', 'ANACP10', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAELAC', 'GSD', 'ELAC', '', '', 'Estrazione LAC per ISTAT', '', '', 'F', 'D', 'ANAELAC', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAECP5', 'GSD', 'ECP5', '', '', 'Estrazione Modello CP.5', '', '', 'F', 'D', 'ANAECP5', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVDCIV', 'GSD', 'DCIV', '', '', 'Dizionario', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVGEAR', 'GSD', 'GEAR', '', '', 'Generazione Archivi', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVIATT', 'GSD', 'IATT', '', '', 'Inserimento Atti', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVRATT', 'GSD', 'RATT', '', '', 'Rettifica Atti', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVVATT', 'GSD', 'VATT', '', '', 'Visualizzazione Indici', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVSPSC', 'GSD', 'SPSC', '', '', 'Stampe Periodiche', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVRANN', 'GSD', 'RANN', '', '', 'Registrazione Annotazioni', '', '', 'F', 'F', 'CIVRANN', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVVANN', 'GSD', 'VANN', '', '', 'Visualizzazione Annotazioni', '', '', 'F', 'D', 'CIVVANN', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVSCSW', 'GSD', 'SCSW', '', '', 'Stampa Comunicazioni (A4)', '', '', 'F', 'D', 'CIVSCSW', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVSCPW', 'GSD', 'SCPW', '', '', 'Stampa Comunicazioni per Atto (A4)', '', '', 'F', 'D', 'CIVSCPW', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVVANU', 'GSD', 'VANU', '', '', 'Visualizzazione Annotazioni Utilizzate', '', '', 'F', 'F', 'CIVVANU', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('DCIVSDSC', 'GSD', 'SDSC', '', '', 'Stampa Dizionario', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVDCSC', 'GSD', 'DCSC', '', '', 'Dizionario Comunicazioni', '', '', 'F', 'F', 'CIVDCSC', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVDDGE', 'GSD', 'DDGE', '', '', 'Dizionario Dati Generali', '', '', 'F', 'F', 'CIVDDGE', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVDFSC', 'GSD', 'DFSC', '', '', 'Dizionario Formulario di Stato Civile', '', '', 'F', 'F', 'CIVDFSC', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVDTAT', 'GSD', 'DTAT', '', '', 'Dizionario Tipi di Atto', '', '', 'F', 'F', 'CIVDTAT', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVCFMI', 'GSD', 'CFMI', '', '', 'Copia Formato Minute', '', '', 'F', 'D', 'CIVCFMI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVSDMM', 'GSD', 'SDMM', '', '', 'Elenco Motivi di Morte', '', '', 'F', 'D', 'CIVSDMM', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVSDFA', 'GSD', 'SDFA', '', '', 'Elenco Formule Annotazioni', '', '', 'F', 'D', 'CIVSDFA', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVSDTA', 'GSD', 'SDTA', '', '', 'Elenco Testi Annotazioni', '', '', 'F', 'D', 'CIVSDTA', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVSDFC', 'GSD', 'SDFC', '', '', 'Elenco Formule per Composizione Atti', '', '', 'F', 'D', 'CIVSDFC', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVSDTC', 'GSD', 'SDTC', '', '', 'Elenco Testi per Composizione Atti', '', '', 'F', 'D', 'CIVSDTC', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVSDCS', 'GSD', 'SDCS', '', '', 'Elenco Comunicazioni di Stato Civile', '', '', 'F', 'D', 'CIVSDCO', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVSDMI', 'GSD', 'SDMI', '', '', 'Stampa Minute', '', '', 'F', 'D', 'CIVSDMI', '72 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVCNAS', 'GSD', 'CNAS', '', '', 'Caricamento Atti di Nascita', '', '', 'F', 'F', 'CIVCNAS', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVCCIT', 'GSD', 'CCIT', '', '', 'Caricamento Atti di Cittadinanza', '', '', 'F', 'F', 'CIVCCIT', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVCPUB', 'GSD', 'CPUB', '', '', 'Caricamento Pubblicazioni di Matrimonio', '', '', 'F', 'F', 'CIVCPUB', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVCMAT', 'GSD', 'CMAT', '', '', 'Caricamento Atti di Matrimonio', '', '', 'F', 'F', 'CIVCMAT', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVCMOR', 'GSD', 'CMOR', '', '', 'Caricamento Atti di Morte', '', '', 'F', 'F', 'CIVCMOR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVCATA', 'GSD', 'CATA', '', '', 'Controllo Atti doppi in Anagrafe', '', '', 'F', 'D', 'CIVCATA', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVTASC', 'GSD', 'TASC', '', '', 'Trasferimento Atti Anagrafe-Stato Civile', '', '', 'F', 'D', 'CIVTASC', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVANAS', 'GSD', 'ANAS', '', '', 'Atti di Nascita', '', '', 'F', 'D', 'CIVANAS', '127', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVACIT', 'GSD', 'ACIT', '', '', 'Atti di Cittadinanza', '', '', 'F', 'D', 'CIVACIT', '127', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVAVPB', 'GSD', 'AVPB', '', '', 'Verbali di Pubblicazione', '', '', 'F', 'D', 'CIVAVPB', '70', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVAMAT', 'GSD', 'AMAT', '', '', 'Atti di Matrimonio', '', '', 'F', 'D', 'CIVAMAT', '127', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVAMOR', 'GSD', 'AMOR', '', '', 'Atti di Morte', '', '', 'F', 'D', 'CIVAMOR', '127', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVADIV', 'GSD', 'ADIV', '', '', 'Sentenze di Divorzio', '', '', 'F', 'D', 'CIVADIV', '127', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVRCIT', 'GSD', 'RCIT', '', '', 'Atti di Cittadinanza', '', '', 'F', 'F', 'CIVRCIT', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVRNAS', 'GSD', 'RNAS', '', '', 'Atti di Nascita', '', '', 'F', 'F', 'CIVRNAS', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVRPUB', 'GSD', 'RPUB', '', '', 'Pubblicazioni di Matrimonio', '', '', 'F', 'F', 'CIVRPUB', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVRMAT', 'GSD', 'RMAT', '', '', 'Atti di Matrimonio', '', '', 'F', 'F', 'CIVRMAT', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVRMOR', 'GSD', 'RMOR', '', '', 'Atti di Morte', '', '', 'F', 'F', 'CIVRMOR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVVNAS', 'GSD', 'VNAS', '', '', 'Atti di Nascita', '', '', 'F', 'D', 'CIVVNAS', '127', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVVCIT', 'GSD', 'VCIT', '', '', 'Atti di Cittadinanza', '', '', 'F', 'D', 'CIVVCIT', '127', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVVPUB', 'GSD', 'VPUB', '', '', 'Pubblicazioni di Matrimonio', '', '', 'F', 'D', 'CIVVPUB', '70', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVVVPB', 'GSD', 'VVPB', '', '', 'Verbali di Pubblicazione', '', '', 'F', 'D', 'CIVVVPB', '70', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVVMAT', 'GSD', 'VMAT', '', '', 'Atti di Matrimonio', '', '', 'F', 'D', 'CIVVMAT', '127', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVVMOR', 'GSD', 'VMOR', '', '', 'Atti di Morte', '', '', 'F', 'D', 'CIVVMOR', '127', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVSIAN', 'GSD', 'SIAN', '', '', 'Stampa Indici Annuali', '', '', 'F', 'D', 'CIVSIAN', '108 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVSIDE', 'GSD', 'SIDE', '', '', 'Stampa Indici Decennali', '', '', 'F', 'D', 'CIVSIDE', '108 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVSPCI', 'GSD', 'SPCI', '', '', 'Elenco Cittadinanze', '', '', 'F', 'D', 'CIVSPCI', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVSPNA', 'GSD', 'SPNA', '', '', 'Elenco Nascite', '', '', 'F', 'D', 'CIVSPNA', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVSPMA', 'GSD', 'SPMA', '', '', 'Elenco Matrimoni', '', '', 'F', 'D', 'CIVSPMA', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVSPMO', 'GSD', 'SPMO', '', '', 'Elenco Morti', '', '', 'F', 'D', 'CIVSPMO', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVSPRA', 'GSD', 'SPRA', '', '', 'Stampa Prospetto Riassuntivo Atti', '', '', 'F', 'D', 'CIVSPRA', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVSFCR', 'GSD', 'SFCR', '', '', 'Stampa Formule di Chiusura Registri', '', '', 'F', 'D', 'CIVSFCR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEDELE', 'GSD', 'DELE', '', '', 'Dizionario', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAREL', 'GSD', 'AREL', '', '', 'Archivio Elettorale', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELERLEL', 'GSD', 'RLEL', '', '', 'Revisioni Liste Elettorali', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELELELE', 'GSD', 'LELE', '', '', 'Liste Elettorali', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEELEZ', 'GSD', 'ELEZ', '', '', 'Elezioni', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEGSCR', 'GSD', 'GSCR', '', '', 'Gestione Scrutatori', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEGPSE', 'GSD', 'GPSE', '', '', 'Gestione Presidenti di Seggio', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEGGPO', 'GSD', 'GGPO', '', '', 'Gestione Giudici Popolari', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESVEL', 'GSD', 'SVEL', '', '', 'Stampe Varie', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEGLAG', 'GSD', 'GLAG', '', '', 'Gestione Liste Aggiunte', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('DELESDEL', 'GSD', 'SDEL', '', '', 'Stampa Dizionario', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEDELG', 'GSD', 'DELG', '', '', 'Dizionario Elettorale Generale', '', '', 'F', 'F', 'ELEDELG', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEDMEL', 'GSD', 'DMEL', '', '', 'Dizionario Motivi Elettorali', '', '', 'F', 'F', 'ELEDMEL', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEDELZ', 'GSD', 'DELZ', '', '', 'Dizionario Elezioni', '', '', 'F', 'F', 'ELEDELZ', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEDNUM', 'GSD', 'DNUM', '', '', 'Dizionario Numerazioni', '', '', 'F', 'F', 'ELEDNUM', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEDREL', 'GSD', 'DREL', '', '', 'Dizionario Revisioni Elettorali', '', '', 'F', 'F', 'ELEDREL', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEDSEZ', 'GSD', 'DSEZ', '', '', 'Dizionario Sezioni Elettorali', '', '', 'F', 'F', 'ELEDSEZ', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEADVS', 'GSD', 'ADVS', '', '', 'Visual. Suddivisioni Sezioni', '', '', 'F', 'F', 'ELEADVS', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESDLR', 'GSD', 'SDLR', '', '', 'Elenco Luoghi di Riunione', '', '', 'F', 'D', 'ELESDLR', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESDMO', 'GSD', 'SDMO', '', '', 'Elenco Motivi', '', '', 'F', 'D', 'ELESDMO', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESDSE', 'GSD', 'SDSE', '', '', 'Elenco Sezioni Elettorali', '', '', 'F', 'D', 'ELESDSE', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESDSR', 'GSD', 'SDSR', '', '', 'Storico Revisioni', '', '', 'F', 'D', 'ELESDSR', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESDCC', 'GSD', 'SDCC', '', '', 'Collegi/Circoscrizioni', '', '', 'F', 'D', 'ELESDCC', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESSCO', 'GSD', 'SSCO', '', '', 'Sezioni per Collegio/Circoscrizione', '', '', 'F', 'D', 'ELESSCO', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARELGTEL', 'GSD', 'GTEL', '', '', 'Gestione Tessera Elettorale', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEGAEL', 'GSD', 'GAEL', '', '', 'Generazione Archivio Elettori', '', '', 'F', 'F', 'ELEGAEL', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEVELE', 'GSD', 'VELE', '', '', 'Visualizzazione Elettorale', '', '', 'F', 'F', 'ANARIND', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEASEL', 'GSD', 'ASEL', '', '', 'Aggiornamento Storico Elettorale', '', '', 'F', 'F', 'ELEASEL', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEGAEF', 'GSD', 'GAEF', '', '', 'Generazione Archivio Elettori Fiorano', '', '', 'F', 'F', 'ELEGAEF', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARELGOVI', 'GSD', 'GOVI', '', '', 'Gestione Opzione di Voto in Italia', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEVTEL', 'GSD', 'VTEL', '', '', 'Visualizzazione Totale Elettori', '', '', 'F', 'F', 'ELEVTEL', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEVTEA', 'GSD', 'VTEA', '', '', 'Vis. Totale Elettori Liste Aggiunte', '', '', 'F', 'F', 'ELEVTEA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAPSE', 'GSD', 'APSE', '', '', 'Agg. Provvedimenti di Sospensione', '', '', 'F', 'F', 'ELEAPSE', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEASVE', 'GSD', 'ASVE', '', '', 'Anteprima di Stampa Verbali Elettorali', '', '', 'F', 'F', 'ELEASVE', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEENOT', 'GSD', 'ENOT', '', '', 'Aggiornamento Note Elettorali', '', '', 'F', 'F', 'ELEENOT', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEVELG', 'GSD', 'VELG', '', '', 'Visualizzazione Elettorale Generale', '', '', 'F', 'F', 'ANARIND', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESAEL', 'GSD', 'SAEL', '', '', 'Salvataggio Archivi Elettorali', '', '', 'F', 'F', 'ELESAEL', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEANTE', 'GSD', 'ANTE', '', '', 'Assegnazione Numeri Tessera Elettorale', '', '', 'F', 'D', 'ELEANTE', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELETELE', 'GSD', 'TELE', '', '', 'Tessere Elettorali', '', '', 'F', 'D', 'ELETELE', '36', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEETEM', 'GSD', 'ETEM', '', '', 'Elenco Tessere Elettorali Emesse', '', '', 'F', 'D', 'ELEETEM', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEDRTP', 'GSD', 'DRTP', '', '', 'Dich. di Ricevuta Tessera Ele.', '', '', 'F', 'D', 'ELEDRTP', '36', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEDRTE', 'GSD', 'DRTE', '', '', 'Dich. di Ricevuta Tessera Ele. (Bianco)', '', '', 'F', 'D', 'ELEDRTE', '70', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEATEE', 'GSD', 'ATEE', '', '', 'Agg. Tessere Elettorali Emesse', '', '', 'F', 'F', 'ELEATEE', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEVTEE', 'GSD', 'VTEE', '', '', 'Visual. Tessere Elettorali Emesse', '', '', 'F', 'F', 'ELEVTEE', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEEATE', 'GSD', 'EATE', '', '', 'Etichette per Agg. Tessere Elettorali', '', '', 'F', 'D', 'ELEEATE', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEEVLR', 'GSD', 'EVLR', '', '', 'Etichette per Tessere Elettorali', '', '', 'F', 'D', 'ELEEVLR', '72 f CA=40', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('RLELRDI1', 'GSD', 'RDI1', '', '', 'Revisione Dinamica  1^ Tornata', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('RLELRDI2', 'GSD', 'RDI2', '', '', 'Revisione Dinamica  2^ Tornata', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('RLELCIND', 'GSD', 'CIND', '', '', 'Cambi Indirizzo', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('RLELRSEM', 'GSD', 'RSEM', '', '', 'Revisione Semestrale', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('RLELBLIS', 'GSD', 'BLIS', '', '', 'Blocco Liste', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('RLELGMFR', 'GSD', 'GMFR', '', '', 'Gestione Movimenti Fuori Revisione', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELERSEI', 'GSD', 'RSEI', '', '', 'Rilevazione Sezioni Elettorali-Iscritti', '', '', 'F', 'D', 'ELERSEI', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEEME1', 'GSD', 'EME1', '', '', 'Estrazione Movimenti Elettorali', '', '', 'F', 'D', 'ELEEMEL', 'CA=DP', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCO1', 'GSD', 'SCO1', '', '', 'Stampa di Controllo', '', '', 'F', 'D', 'ELESCON', '72 CA=13', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAME1', 'GSD', 'AME1', '', '', 'Aggiornamento Movimenti Elettorali', '', '', 'F', 'F', 'ELEAMEL', 'CA=DP', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESME1', 'GSD', 'SME1', '', '', 'Sospensione Movimenti Elettorali', '', '', 'F', 'F', 'ELESMEL', 'CA=DP', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESEC1', 'GSD', 'SEC1', '', '', 'Stampa Elenco Cancellandi', '', '', 'F', 'D', 'ELEELEN', '72 CA=14', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESTE1', 'GSD', 'STE1', '', '', 'Stampa Telegrammi per Emigrati', '', '', 'F', 'D', 'ELESTEL', '70 CA=31', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELES34D', 'GSD', 'S34D', '', '', 'Stampa Modello 3-4/D', '', '', 'F', 'D', 'ELES34D', '54 f CA=15', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELES34B', 'GSD', 'S34B', '', '', 'Stampa Modelli 3-4/D e 6/D (Bianco)', '', '', 'F', 'D', 'ELES34B', '66 CA=15', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESEC3', 'GSD', 'SEC3', '', '', 'Stampa Elenco Comuni per 3-4/D', '', '', 'F', 'D', 'ELESECD', '66 f CA=32', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESV01', 'GSD', 'SV01', '', '', 'Stampa Verbale di Revisione', '', '', 'F', 'F', 'ELESVER', 'CA=DP', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESPR1', 'GSD', 'SPR1', '', '', 'Stampa Prospetto Riassuntivo Rettifiche', '', '', 'F', 'D', 'ELESPRR', '70 f CA=DP', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAAE1', 'GSD', 'AAE1', '', '', 'Aggiornamento Archivio Elettori', '', '', 'F', 'D', 'ELEAAEL', 'CA=DP', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCL1', 'GSD', 'SCL1', '', '', 'Stampa di Controllo Liste Aggiunte', '', '', 'F', 'D', 'ELESCLA', 'CA=DP', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEVME1', 'GSD', 'VME1', '', '', 'Visualizzazione Movimenti Elettorali', '', '', 'F', 'F', 'ELEVMEL', 'CA=DP', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('RDI2SRD2', 'GSD', 'SRD2', '', '', 'Stampe Revisione 2^ Tornata', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEEME2', 'GSD', 'EME2', '', '', 'Estrazione Movimenti Elettorali', '', '', 'F', 'D', 'ELEEMEL', 'CA=DS', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCO2', 'GSD', 'SCO2', '', '', 'Stampa di Controllo', '', '', 'F', 'D', 'ELESCON', '66 f CA=16', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAME2', 'GSD', 'AME2', '', '', 'Aggiornamento Movimenti Elettorali', '', '', 'F', 'F', 'ELEAMEL', 'CA=DS', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESME2', 'GSD', 'SME2', '', '', 'Sospensione Movimenti Elettorali', '', '', 'F', 'F', 'ELESMEL', 'CA=DS', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAPR2', 'GSD', 'APR2', '', '', 'Assegnazione Progressivi', '', '', 'F', 'F', 'ELEAFPR', 'CA=DS', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESV02', 'GSD', 'SV02', '', '', 'Stampa Verbale di Revisione', '', '', 'F', 'F', 'ELESVER', 'CA=DS', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESPR2', 'GSD', 'SPR2', '', '', 'Stampa Prospetto Riassuntivo Rettifiche', '', '', 'F', 'D', 'ELESPRR', '70 f CA=DS', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAAE2', 'GSD', 'AAE2', '', '', 'Aggiornamento Archivio Elettori', '', '', 'F', 'D', 'ELEAAEL', 'CA=DS', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCL2', 'GSD', 'SCL2', '', '', 'Stampa di Controllo Liste Aggiunte', '', '', 'F', 'D', 'ELESCLA', 'CA=DS', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEVME2', 'GSD', 'VME2', '', '', 'Visualizzazione Movimenti Elettorali', '', '', 'F', 'F', 'ELEVMEL', 'CA=DS', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESEC2', 'GSD', 'SEC2', '', '', 'Stampa Elenco Cancellandi', '', '', 'F', 'D', 'ELEELEN', '66 f CA=17', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCC2', 'GSD', 'SCC2', '', '', 'Stampa Elenco Cancellandi   (Cambi Ind.)', '', '', 'F', 'D', 'ELEELEN', '66 CA=33', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESEI2', 'GSD', 'SEI2', '', '', 'Stampa Elenco Iscrivendi', '', '', 'F', 'D', 'ELEELEN', '66 CA=19', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESIC2', 'GSD', 'SIC2', '', '', 'Stampa Elenco Iscrivendi    (Cambi Ind.)', '', '', 'F', 'D', 'ELEELEN', '72 CA=34', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCR2', 'GSD', 'SCR2', '', '', 'Stampa Comunic. Revisione Dinamica', '', '', 'F', 'D', 'ELESCRS', '70 f CA=DS', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESTE2', 'GSD', 'STE2', '', '', 'Stampa Telegrammi per Immigrati', '', '', 'F', 'D', 'ELESTEL', '36 f CA=39', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESFP2', 'GSD', 'SFP2', '', '', 'Stampa Fascicoli', '', '', 'F', 'D', 'ELESFAS', '6  CA=18', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESM5D', 'GSD', 'SM5D', '', '', 'Stampa Modello 5/D', '', '', 'F', 'D', 'ELESM5D', '42 f CA=20', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESM5B', 'GSD', 'SM5B', '', '', 'Stampa Modello 5/D (Bianco)', '', '', 'F', 'D', 'ELESM5B', '70 CA=20', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESEC5', 'GSD', 'SEC5', '', '', 'Stampa Elenco Comuni per 5/D', '', '', 'F', 'D', 'ELESECD', '66 f CA=38', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESSI2', 'GSD', 'SSI2', '', '', 'Stampa Schede Individuali', '', '', 'F', 'D', 'ELESSIN', '33 CA=21', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCS2', 'GSD', 'SCS2', '', '', 'Stampa Coda Sezionale', '', '', 'F', 'D', 'ELESCSE', '90 CA=22', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCG2', 'GSD', 'SCG2', '', '', 'Stampa Coda Generale', '', '', 'F', 'D', 'ELESCGE', '90 CA=23', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEEAT2', 'GSD', 'EAT2', '', '', 'Etichette per Tessere Elettorali', '', '', 'F', 'D', 'ELEEATE', '72 f CA=40', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELECSA2', 'GSD', 'CSA2', '', '', 'Stampa Coda Sezionale (Foglio A3)', '', '', 'F', 'D', 'ELECSA3', 'CA=22', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELECGA2', 'GSD', 'CGA2', '', '', 'Stampa Coda Generale (Foglio A3)', '', '', 'F', 'D', 'ELECGA3', 'CA=23', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESM6B', 'GSD', 'SM6B', '', '', 'Stampa Modelli 6/D (Bianco)', '', '', 'F', 'D', 'ELES34B', 'CA=46', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEEMEC', 'GSD', 'EMEC', '', '', 'Estrazione Movimenti Elettorali', '', '', 'F', 'D', 'ELEEMEL', 'CA=CI', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCOC', 'GSD', 'SCOC', '', '', 'Stampa di Controllo', '', '', 'F', 'D', 'ELESCON', '66 f CA=24', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAMEC', 'GSD', 'AMEC', '', '', 'Aggiornamento Movimenti Elettorali', '', '', 'F', 'F', 'ELEAMEL', 'CA=CI', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAPRC', 'GSD', 'APRC', '', '', 'Assegnazione Progressivi', '', '', 'F', 'F', 'ELEAFPR', 'CA=CI', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESECC', 'GSD', 'SECC', '', '', 'Stampa Elenco Cancellandi', '', '', 'F', 'D', 'ELEELEN', '66 f CA=25', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESEIC', 'GSD', 'SEIC', '', '', 'Stampa Elenco Iscrivendi', '', '', 'F', 'D', 'ELEELEN', '66 f CA=26', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESSIC', 'GSD', 'SSIC', '', '', 'Stampa Schede Individuali', '', '', 'F', 'D', 'ELESSIN', '33 CA=30', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCSC', 'GSD', 'SCSC', '', '', 'Stampa Coda Sezionale', '', '', 'F', 'D', 'ELESCSE', '90 f CA=27', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELECSAC', 'GSD', 'CSAC', '', '', 'Stampa Coda Sezionale (Foglio A3)', '', '', 'F', 'F', 'ELECSA3', 'CA=27', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEEATC', 'GSD', 'EATC', '', '', 'Etichette per Tessere Elettorali', '', '', 'F', 'D', 'ELEEATE', '72 f CA=41', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESVEC', 'GSD', 'SVEC', '', '', 'Stampa Verbale di Revisione', '', '', 'F', 'F', 'ELESVER', 'CA=CI', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESPRC', 'GSD', 'SPRC', '', '', 'Stampa Prospetto Riassuntivo Rettifiche', '', '', 'F', 'D', 'ELESPRR', '70 f CA=CI', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAAEC', 'GSD', 'AAEC', '', '', 'Aggiornamento Archivio Elettori', '', '', 'F', 'D', 'ELEAAEL', 'CA=CI', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEVMEC', 'GSD', 'VMEC', '', '', 'Visualizzazione Movimenti Elettorali', '', '', 'F', 'F', 'ELEVMEL', 'CA=CI', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('RSEMAD1S', 'GSD', 'AD1S', '', '', 'Adempimenti 1^ Scadenza', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('RSEMSCOL', 'GSD', 'SCOL', '', '', 'Scolmamenti', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('RSEMAD2S', 'GSD', 'AD2S', '', '', 'Adempimenti 2^ Scadenza', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('RSEMAD3S', 'GSD', 'AD3S', '', '', 'Adempimenti 3^ Scadenza', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEEMES', 'GSD', 'EMES', '', '', 'Estrazione Movimenti Elettorali', '', '', 'F', 'D', 'ELEEMEL', 'CA=SE', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCOS', 'GSD', 'SCOS', '', '', 'Stampa di Controllo', '', '', 'F', 'D', 'ELESCON', '66 CA=1', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAMES', 'GSD', 'AMES', '', '', 'Aggiornamento Movimenti Elettorali', '', '', 'F', 'F', 'ELEAMEL', 'CA=SE', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCRS', 'GSD', 'SCRS', '', '', 'Stampa Comunic. Revisione Semestrale', '', '', 'F', 'D', 'ELESCRS', '70 f CA=SE', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESPRS', 'GSD', 'SPRS', '', '', 'Stampa Prospetto Riassuntivo Rettifiche', '', '', 'F', 'D', 'ELESPRR', '70 f CA=SE', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAAES', 'GSD', 'AAES', '', '', 'Aggiornamento Archivio Elettori', '', '', 'F', 'D', 'ELEAAEL', 'CA=SE', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCLS', 'GSD', 'SCLS', '', '', 'Stampa di Controllo Liste Aggiunte', '', '', 'F', 'D', 'ELESCLA', 'CA=SE', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEVMES', 'GSD', 'VMES', '', '', 'Visualizzazione Movimenti Elettorali', '', '', 'F', 'F', 'ELEVMEL', 'CA=SE', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAFSS', 'GSD', 'AFSS', '', '', 'Assegnazione Fascicoli', '', '', 'F', 'D', 'ELEAFAS', 'CA=SE', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESFPS', 'GSD', 'SFPS', '', '', 'Stampa Fascicoli Personali', '', '', 'F', 'D', 'ELESFAS', '12 f CA=3', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESEPR', 'GSD', 'SEPR', '', '', 'Stampa Elenco Preparatorio', '', '', 'F', 'D', 'ELEELEN', '66 CA=2', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESRDO', 'GSD', 'SRDO', '', '', 'Stampa Richiesta Documenti', '', '', 'F', 'D', 'ELESRDO', '54 f CA=4', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESRDB', 'GSD', 'SRDB', '', '', 'Stampa Richiesta Documenti (Bianco)', '', '', 'F', 'D', 'ELESRDB', '66 CA=4', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESECR', 'GSD', 'SECR', '', '', 'Stampa Elenco Comuni per Rich. Documenti', '', '', 'F', 'D', 'ELESECR', '66 CA=37', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESSIF', 'GSD', 'SSIF', '', '', 'Stampa Scheda Informativa', '', '', 'F', 'D', 'ELESSIF', '70 f CA=5', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESV03', 'GSD', 'SV03', '', '', 'Stampa Verbale di Revisione (Mod.3)', '', '', 'F', 'F', 'ELESVER', 'CA=SE', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEEELR', 'GSD', 'EELR', '', '', 'Estrazione Elettori Residenti', '', '', 'F', 'D', 'ELEEELR', 'CA=SE', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEEELE', 'GSD', 'EELE', '', '', 'Estrazione Elettori all''Estero', '', '', 'F', 'D', 'ELEEELE', 'CA=SE', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEESCO', 'GSD', 'ESCO', '', '', 'Eliminazione Scolmamenti', '', '', 'F', 'D', 'ELEESCO', 'CA=SE', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEEATS', 'GSD', 'EATS', '', '', 'Etichette per Tessere Elettorali', '', '', 'F', 'D', 'ELEEATE', '72 CA=42', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESPEL', 'GSD', 'SPEL', '', '', 'Stampa Primo Elenco', '', '', 'F', 'D', 'ELEELEN', '66 CA=6', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESSEL', 'GSD', 'SSEL', '', '', 'Stampa Secondo Elenco', '', '', 'F', 'D', 'ELEELEN', '66 f CA=7', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESEVI', 'GSD', 'SEVI', '', '', 'Stampa Elenco Variaz. per Iscrizioni', '', '', 'F', 'D', 'ELEELEN', '66 f CA=8', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESEVR', 'GSD', 'SEVR', '', '', 'Stampa Elenco Variaz. per Radiazioni', '', '', 'F', 'D', 'ELEELEN', '66 f CA=9', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESV06', 'GSD', 'SV06', '', '', 'Stampa Verbale di Revisione (Mod.6)', '', '', 'F', 'F', 'ELESVER', 'CA=SE', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESV14', 'GSD', 'SV14', '', '', 'Stampa Verbale di Revisione (Mod.14)', '', '', 'F', 'F', 'ELESVER', 'CA=SE', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESNCS', 'GSD', 'SNCS', '', '', 'Stampa Notifica di Cancellazione', '', '', 'F', 'D', 'ELESNCS', '66 CA=43', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAPRS', 'GSD', 'APRS', '', '', 'Assegnazione Progressivi', '', '', 'F', 'D', 'ELEAPRO', 'CA=SE', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESSIS', 'GSD', 'SSIS', '', '', 'Stampa Schede Individuali', '', '', 'F', 'D', 'ELESSIN', '33 CA=10', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCSS', 'GSD', 'SCSS', '', '', 'Stampa Coda Sezionale', '', '', 'F', 'D', 'ELESCSE', '72 CA=11', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCGS', 'GSD', 'SCGS', '', '', 'Stampa Coda Generale', '', '', 'F', 'D', 'ELESCGE', '90 CA=12', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESV10', 'GSD', 'SV10', '', '', 'Stampa Verbale di Revisione (Mod.10)', '', '', 'F', 'F', 'ELESVER', 'CA=SE', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESV15', 'GSD', 'SV15', '', '', 'Stampa Verbale di Revisione (Mod.15)', '', '', 'F', 'F', 'ELESVER', 'CA=SE', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELECSAS', 'GSD', 'CSAS', '', '', 'Stampa Coda Sezionale (Foglio A3)', '', '', 'F', 'D', 'ELECSA3', 'CA=11', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELECGAS', 'GSD', 'CGAS', '', '', 'Stampa Coda Generale (Foglio A3)', '', '', 'F', 'D', 'ELECGA3', 'CA=12', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEEMEB', 'GSD', 'EMEB', '', '', 'Estrazione Movimenti Elettorali', '', '', 'F', 'D', 'ELEEMEL', 'CA=BL', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCOB', 'GSD', 'SCOB', '', '', 'Stampa di Controllo', '', '', 'F', 'D', 'ELESCON', '66 f CA=28', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAMEB', 'GSD', 'AMEB', '', '', 'Aggiornamento Movimenti Elettorali', '', '', 'F', 'F', 'ELEAMEL', 'CA=BL', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESECB', 'GSD', 'SECB', '', '', 'Stampa Elenco Cancellandi', '', '', 'F', 'D', 'ELEELEN', '66 f CA=29', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESVEB', 'GSD', 'SVEB', '', '', 'Stampa Verbale di Revisione', '', '', 'F', 'F', 'ELESVER', 'CA=BL', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESPRB', 'GSD', 'SPRB', '', '', 'Stampa Prospetto Riassuntivo Rettifiche', '', '', 'F', 'D', 'ELESPRR', '70 f CA=BL', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAAEB', 'GSD', 'AAEB', '', '', 'Aggiornamento Archivio Elettori', '', '', 'F', 'D', 'ELEAAEL', 'CA=BL', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESMEB', 'GSD', 'SMEB', '', '', 'Sospensione Movimenti Elettorali', '', '', 'F', 'F', 'ELESMEL', 'CA=BL', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEVMEB', 'GSD', 'VMEB', '', '', 'Visualizzazione Movimenti Elettorali', '', '', 'F', 'F', 'ELEVMEL', 'CA=BL', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEEMEF', 'GSD', 'EMEF', '', '', 'Estrazione Movimenti Elettorali', '', '', 'F', 'D', 'ELEEMEF', 'CA=FR', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCOF', 'GSD', 'SCOF', '', '', 'Stampa di Controllo', '', '', 'F', 'D', 'ELESCOF', '66 CA=35', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAMEF', 'GSD', 'AMEF', '', '', 'Aggiornamento Movimenti Elettorali', '', '', 'F', 'F', 'ELEAMEF', 'CA=FR', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESMEF', 'GSD', 'SMEF', '', '', 'Sospensione Movimenti Elettorali', '', '', 'F', 'F', 'ELESMEL', 'CA=FR', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAFSF', 'GSD', 'AFSF', '', '', 'Assegnazione Fascicoli-Sezioni', '', '', 'F', 'D', 'ELEAFSF', 'CA=FR', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESFPF', 'GSD', 'SFPF', '', '', 'Stampa Fascicoli Personali', '', '', 'F', 'D', 'ELESFPF', '12 f CA=36', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAAEF', 'GSD', 'AAEF', '', '', 'Aggiornamento Archivio Elettori', '', '', 'F', 'D', 'ELEAAEF', 'CA=FR', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEVMEF', 'GSD', 'VMEF', '', '', 'Visualizzazione Movimenti Elettorali', '', '', 'F', 'F', 'ELEVMEL', 'CA=FR', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELERPSE', 'GSD', 'RPSE', '', '', 'Riassegnazione Progr. Sezionali', '', '', 'F', 'D', 'ELERPSE', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELERPGE', 'GSD', 'RPGE', '', '', 'Riassegnazione Progr. Generali', '', '', 'F', 'D', 'ELERPGE', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELERFAS', 'GSD', 'RFAS', '', '', 'Riassegnazione Fascicoli', '', '', 'F', 'D', 'ELERFAS', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESLGE', 'GSD', 'SLGE', '', '', 'Stampa Lista Generale', '', '', 'F', 'D', 'ELESLGE', '90', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESLSE', 'GSD', 'SLSE', '', '', 'Stampa Lista Sezionale', '', '', 'F', 'D', 'ELESLSE', '90', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESSIG', 'GSD', 'SSIG', '', '', 'Stampa Schede Individuali Generali', '', '', 'F', 'D', 'ELESSIG', '33', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESFPE', 'GSD', 'SFPE', '', '', 'Stampa Fascicoli Personali', '', '', 'F', 'D', 'ELESFPE', '9', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELELESM', 'GSD', 'LESM', '', '', 'Liste Elettorali su Supporto Magnetico', '', '', 'F', 'F', 'ELELESM', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELELSA3', 'GSD', 'LSA3', '', '', 'Stampa Lista Sezionale (Foglio A3)', '', '', 'F', 'D', 'ELELSA3', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELELGA3', 'GSD', 'LGA3', '', '', 'Stampa Coda Generale (Foglio A3)', '', '', 'F', 'D', 'ELELGA3', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCEL', 'GSD', 'SCEL', '', '', 'Stampa Certificati Elettorali', '', '', 'F', 'D', 'ELESCEL', '36 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCED', 'GSD', 'SCED', '', '', 'Stampa Certificati Elettorali Doppio T.', '', '', 'F', 'D', 'ELESCED', '36 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESPEV', 'GSD', 'SPEV', '', '', 'Stampa Prospetto Elettori Votanti', '', '', 'F', 'D', 'ELESPEV', '70 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESENV', 'GSD', 'SENV', '', '', 'Stampa Elettori non votanti', '', '', 'F', 'D', 'ELESENV', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESECA', 'GSD', 'SECA', '', '', 'Stampa Elettori per la Camera', '', '', 'F', 'D', 'ELESECA', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESEVP', 'GSD', 'SEVP', '', '', 'Elettori Votanti per la Prima Volta', '', '', 'F', 'D', 'ELESEVP', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAISL', 'GSD', 'AISL', '', '', 'Individui Sottoscrittori Liste', '', '', 'F', 'F', 'ELEAISL', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESISL', 'GSD', 'SISL', '', '', 'Stampa Individui Sottoscrittori Liste', '', '', 'F', 'D', 'ELESISL', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEALPR', 'GSD', 'ALPR', '', '', 'Aggiornamento Liste Presentate', '', '', 'F', 'F', 'ELEALPR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESLPR', 'GSD', 'SLPR', '', '', 'Stampa Liste Presentate', '', '', 'F', 'D', 'ELESLPR', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESPEA', 'GSD', 'SPEA', '', '', 'Stampa Prospetto Elettori - Aggiunte', '', '', 'F', 'D', 'ELESPEA', '70 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('GSCRAALS', 'GSD', 'AALS', '', '', 'Aggiornamento Albo', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('GSCRELSC', 'GSD', 'ELSC', '', '', 'Elezioni', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('GSCRSVSC', 'GSD', 'SVSC', '', '', 'Stampe Varie', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEGASC', 'GSD', 'GASC', '', '', 'Generazione Archivio Scrutatori', '', '', 'F', 'F', 'ELEGASC', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEEMSC', 'GSD', 'EMSC', '', '', 'Estrazione Movimenti Scrutatori', '', '', 'F', 'D', 'ELEEMSC', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCTS', 'GSD', 'SCTS', '', '', 'Stampa di Controllo', '', '', 'F', 'D', 'ELESCTS', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAMSC', 'GSD', 'AMSC', '', '', 'Aggiornamento Movimenti Scrutatori', '', '', 'F', 'F', 'ELEAMSC', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESRPS', 'GSD', 'SRPS', '', '', 'Stampa Richiesta Certificato Penale', '', '', 'F', 'D', 'ELESRPS', '70 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESNIE', 'GSD', 'SNIE', '', '', 'Stampa Notifica Iscrivendi (Etichette)', '', '', 'F', 'D', 'ELESNIE', '6  f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESNIS', 'GSD', 'SNIS', '', '', 'Stampa Notifica Iscrivendi', '', '', 'F', 'D', 'ELESNIS', '70 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESEIS', 'GSD', 'SEIS', '', '', 'Stampa Elenco Iscrivendi', '', '', 'F', 'D', 'ELESEIS', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESECS', 'GSD', 'SECS', '', '', 'Stampa Elenco Cancellandi', '', '', 'F', 'D', 'ELESECS', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAASC', 'GSD', 'AASC', '', '', 'Aggiornamento Archivio Scrutatori', '', '', 'F', 'D', 'ELEAASC', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESVAS', 'GSD', 'SVAS', '', '', 'Stampa Verbale Aggiornamento Albo', '', '', 'F', 'D', 'ELESVER', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEESSE', 'GSD', 'ESSE', '', '', 'Estrazione Scrutatori ai Seggi', '', '', 'F', 'D', 'ELEESSE', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEASSE', 'GSD', 'ASSE', '', '', 'Aggiornamento Scrutatori ai Seggi', '', '', 'F', 'F', 'ELEASSE', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESNSE', 'GSD', 'SNSE', '', '', 'Stampa Notifica per Seggi', '', '', 'F', 'D', 'ELESNSE', '70 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESNSI', 'GSD', 'SNSI', '', '', 'Stampa Notifica per Seggi Individuale', '', '', 'F', 'D', 'ELESNSI', '70 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESESE', 'GSD', 'SESE', '', '', 'Stampa Elenco Scrutatori ai Seggi', '', '', 'F', 'D', 'ELESESE', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESESS', 'GSD', 'SESS', '', '', 'Stampa Etichette Scrutatori ai Seggi', '', '', 'F', 'D', 'ELESESS', '6', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESENS', 'GSD', 'SENS', '', '', 'Stampa Estratto Nomina Scrutatori', '', '', 'F', 'D', 'ELESENS', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESASC', 'GSD', 'SASC', '', '', 'Stampa Aggiornamento Scrutatori', '', '', 'F', 'D', 'ELESASC', '66 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESALS', 'GSD', 'SALS', '', '', 'Stampa Albo Scrutatori', '', '', 'F', 'D', 'ELESALS', '66 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESETS', 'GSD', 'SETS', '', '', 'Stampa Etichette Scrutatori', '', '', 'F', 'D', 'ELESETS', '6', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('GPSEAALP', 'GSD', 'AALP', '', '', 'Aggiornamento Albo Presidenti', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('GPSESVPS', 'GSD', 'SVPS', '', '', 'Stampe Varie', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEGAPS', 'GSD', 'GAPS', '', '', 'Generazione Archivio Presidenti', '', '', 'F', 'F', 'ELEGAPS', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEEMPS', 'GSD', 'EMPS', '', '', 'Estrazione Movimenti Presidenti', '', '', 'F', 'D', 'ELEEMPS', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCTP', 'GSD', 'SCTP', '', '', 'Stampa di Controllo', '', '', 'F', 'D', 'ELESCTP', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAMPS', 'GSD', 'AMPS', '', '', 'aggiornamento Movimenti Presidenti', '', '', 'F', 'F', 'ELEAMPS', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESRPP', 'GSD', 'SRPP', '', '', 'Stampa Richiesta Certificato Penale', '', '', 'F', 'D', 'ELESRPP', '70 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESEIP', 'GSD', 'SEIP', '', '', 'Stampa Elenco Iscrivendi', '', '', 'F', 'D', 'ELESEIP', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESECP', 'GSD', 'SECP', '', '', 'Stampa Elenco Cancellandi', '', '', 'F', 'D', 'ELESECP', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAAPS', 'GSD', 'AAPS', '', '', 'Aggiornamento Archivio Presidenti', '', '', 'F', 'D', 'ELEAAPS', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESVAP', 'GSD', 'SVAP', '', '', 'Stampa Verbale Aggiornamento Albo', '', '', 'F', 'D', 'ELESVER', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESALP', 'GSD', 'SALP', '', '', 'Stampa Albo Presidenti', '', '', 'F', 'D', 'ELESALP', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEPSMI', 'GSD', 'PSMI', '', '', 'Presidenti di Seggio per Min. Interno', '', '', 'F', 'D', 'ELEPSMI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('GGPOAALG', 'GSD', 'AALG', '', '', 'Aggiornamento Albo', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('GGPOSVGP', 'GSD', 'SVGP', '', '', 'Stampe Varie', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEGAGP', 'GSD', 'GAGP', '', '', 'Generazione Archivio Giudici Popolari', '', '', 'F', 'F', 'ELEGAGP', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('AALGSTGP', 'GSD', 'STGP', '', '', 'Stampe Aggiornamento Albo', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEEMGP', 'GSD', 'EMGP', '', '', 'Estrazione Movimenti', '', '', 'F', 'D', 'ELEEMGP', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCTG', 'GSD', 'SCTG', '', '', 'Stampa di Controllo', '', '', 'F', 'D', 'ELESCTG', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAMGP', 'GSD', 'AMGP', '', '', 'Aggiornamento Movimenti', '', '', 'F', 'F', 'ELEAMGP', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAAGP', 'GSD', 'AAGP', '', '', 'Aggiornamento Archivio Giudici', '', '', 'F', 'D', 'ELEAAGP', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESVAG', 'GSD', 'SVAG', '', '', 'Stampa Verbale Aggiornamento Albo', '', '', 'F', 'D', 'ELESVER', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESRCP', 'GSD', 'SRCP', '', '', 'Stampa Richiesta Certificato Penale', '', '', 'F', 'D', 'ELESRCP', '70 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESACP', 'GSD', 'SACP', '', '', 'Stampa Accertamento Carichi Pendenti', '', '', 'F', 'D', 'ELESACP', '70 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESEIG', 'GSD', 'SEIG', '', '', 'Stampa Elenco Iscrivendi', '', '', 'F', 'D', 'ELESEIG', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESECG', 'GSD', 'SECG', '', '', 'Stampa Elenco Cancellandi', '', '', 'F', 'D', 'ELESECG', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESEGG', 'GSD', 'SEGG', '', '', 'Stampa Elenco Generale  (con iscrivendi)', '', '', 'F', 'D', 'ELESEGG', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESETG', 'GSD', 'SETG', '', '', 'Stampa Etichette Movimenti', '', '', 'F', 'D', 'ELESETG', '12', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCCR', 'GSD', 'SCCR', '', '', 'Stampa Cert. Cumulativo Requisiti Legge', '', '', 'F', 'D', 'ELESCCR', '70 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESALG', 'GSD', 'SALG', '', '', 'Stampa Albo', '', '', 'F', 'D', 'ELESALG', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESEGP', 'GSD', 'SEGP', '', '', 'Stampa Etichette', '', '', 'F', 'D', 'ELESEGP', '12 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESVSS', 'GSD', 'SVSS', '', '', 'Stampa Vie Suddivise per Sezioni', '', '', 'F', 'D', 'ELESVSS', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESSTE', 'GSD', 'SSTE', '', '', 'Stampa Stradario Elettorale', '', '', 'F', 'D', 'ELESSTE', '72 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESELE', 'GSD', 'SELE', '', '', 'Stampa Elenco Elettori all''estero', '', '', 'F', 'D', 'ELESELE', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESETE', 'GSD', 'SETE', '', '', 'Stampa Etichette Elettori all''estero', '', '', 'F', 'D', 'ELESETE', '6', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESELS', 'GSD', 'SELS', '', '', 'Stampa Estratto Liste Sezionali', '', '', 'F', 'D', 'ELESELS', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCAR', 'GSD', 'SCAR', '', '', 'Stampa Caricamento Dati Elettorali', '', '', 'F', 'D', 'ELESCAR', '66 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESTEC', 'GSD', 'STEC', '', '', 'Stampa Totale Elettori per Collegio', '', '', 'F', 'D', 'ELESTEC', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCSV', 'GSD', 'SCSV', '', '', 'Stampa Cambi Indirizzo senza Var.Sezione', '', '', 'F', 'D', 'ELESCSV', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESTEV', 'GSD', 'STEV', '', '', 'Stampa Totali Elettori per Via', '', '', 'F', 'D', 'ELESTEV', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESEVS', 'GSD', 'SEVS', '', '', 'Stampa Elenco Variazioni Statiche', '', '', 'F', 'D', 'ELESEVS', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVLMIL', 'GSD', 'LMIL', '', '', 'Leva Militare', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVGRMA', 'GSD', 'GRMA', '', '', 'Gestione Ruoli Matricolari', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVDLEV', 'GSD', 'DLEV', '', '', 'Dizionario', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVSDES', 'GSD', 'SDES', '', '', 'Elenco Esiti', '', '', 'F', 'D', 'LEVSDES', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVSDCO', 'GSD', 'SDCO', '', '', 'Elenco Corpi', '', '', 'F', 'D', 'LEVSDCO', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVSDGR', 'GSD', 'SDGR', '', '', 'Elenco Gradi', '', '', 'F', 'D', 'LEVSDGR', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVSDAR', 'GSD', 'SDAR', '', '', 'Elenco Armi', '', '', 'F', 'D', 'LEVSDAR', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LMILSCAC', 'GSD', 'SCAC', '', '', 'Stampe Corrispondenza con Altri Comuni', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LMILSTLM', 'GSD', 'STLM', '', '', 'Stampe Leva Militare', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVELMI', 'GSD', 'ELMI', '', '', 'Estrazione Leva Militare', '', '', 'F', 'D', 'LEVELMI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVALMI', 'GSD', 'ALMI', '', '', 'Aggiornamento Leva Militare', '', '', 'F', 'F', 'LEVALMI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVSEPL', 'GSD', 'SEPL', '', '', 'Stampa Elenco Preparatorio Leva', '', '', 'F', 'D', 'LEVSEPL', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVANLI', 'GSD', 'ANLI', '', '', 'Assegnazione Numero Lista', '', '', 'F', 'D', 'LEVANLI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVAGNE', 'GSD', 'AGNE', '', '', 'Agg. Giovani Nati e Residenti Altrove', '', '', 'F', 'F', 'LEVAGNE', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVSTCN', 'GSD', 'STCN', '', '', 'Stampa Trasmissione Cert. di Nascita', '', '', 'F', 'D', 'LEVSTCN', '70 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVSRCN', 'GSD', 'SRCN', '', '', 'Stampa Richiesta Certificati di Nascita', '', '', 'F', 'D', 'LEVSRCN', '70 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVSAIS', 'GSD', 'SAIS', '', '', 'Stampa Assicurazione di Iscrizione', '', '', 'F', 'D', 'LEVSAIS', '70 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVSRCA', 'GSD', 'SRCA', '', '', 'Stampa Rich. Certificati e Assicurazione', '', '', 'F', 'D', 'LEVSRCA', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVSETL', 'GSD', 'SETL', '', '', 'Stampa Etichette Leva', '', '', 'F', 'D', 'LEVSETL', '12 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVSELI', 'GSD', 'SELI', '', '', 'Stampa Etichette Leva Individuali', '', '', 'F', 'D', 'LEVSELI', '12 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVSLLE', 'GSD', 'SLLE', '', '', 'Stampa Lista di Leva', '', '', 'F', 'D', 'LEVSLLE', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVSGIS', 'GSD', 'SGIS', '', '', 'Stampa Giovani Iscritti', '', '', 'F', 'D', 'LEVSGIS', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVSGNE', 'GSD', 'SGNE', '', '', 'Stampa Giovani Nati e Residenti Altrove', '', '', 'F', 'D', 'LEVSGNE', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVSGND', 'GSD', 'SGND', '', '', 'Stampa Giovani Nati e Deceduti', '', '', 'F', 'D', 'LEVSGND', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CERDCER', 'GSD', 'DCER', '', '', 'Dizionario', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CERCERW', 'GSD', 'CERW', '', '', 'Emissione Certificati (A4)', '', '', 'F', 'D', 'CERCERW', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CERCETI', 'GSD', 'CETI', '', '', 'Emissione Etichette', '', '', 'F', 'D', 'CERCETI', '9', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CERSIND', 'GSD', 'SIND', '', '', 'Sospensione Individuo', '', '', 'F', 'F', 'CERSIND', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CERIVES', 'GSD', 'IVES', '', '', 'Inibizione Validita'' per l''Espatrio', '', '', 'F', 'F', 'CERIVES', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CERECEM', 'GSD', 'ECEM', '', '', 'Elenco Certificati Emessi', '', '', 'F', 'D', 'CERECEM', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CERVDIR', 'GSD', 'VDIR', '', '', 'Visualizzazione Diritti', '', '', 'F', 'F', 'CERVDIR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CERSDIR', 'GSD', 'SDIR', '', '', 'Stampa Diritti', '', '', 'F', 'D', 'CERSDIR', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CEREISO', 'GSD', 'EISO', '', '', 'Elenco Individui Sospesi', '', '', 'F', 'D', 'CEREISO', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CERANCE', 'GSD', 'ANCE', '', '', 'Annullamento Certificati Emessi', '', '', 'F', 'F', 'CERANCE', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CERECID', 'GSD', 'ECID', '', '', 'Eliminazione Carte di Identita'' Emesse', '', '', 'F', 'D', 'CERECID', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CERSSCE', 'GSD', 'SSCE', '', '', 'Stampa Statistica Certificati Emessi', '', '', 'F', 'D', 'CERSSCE', '72 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CERCMAW', 'GSD', 'CMAW', '', '', 'Certificazione di Massa (A4)', '', '', 'F', 'D', 'CERCMAW', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('DCERSDCR', 'GSD', 'SDCR', '', '', 'Stampa Dizionario', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CERAFCI', 'GSD', 'AFCI', '', '', 'Fornitura Carte d''Identita''', '', '', 'F', 'F', 'CERAFCI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('GSDEURO', 'GSD', 'EURO', '', '', 'Trasformazione Importi per EURO', '', '', 'F', 'F', 'CEREURO', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CERADCE', 'GSD', 'ADCE', '', '', 'Dizionario Certificati', '', '', 'F', 'F', 'CERADCE', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CERDCEG', 'GSD', 'DCEG', '', '', 'Dizionario Certificazione Generale', '', '', 'F', 'F', 'CERDCEG', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CERSDCE', 'GSD', 'SDCE', '', '', 'Elenco Certificati', '', '', 'F', 'D', 'CERSDCE', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CERSDRI', 'GSD', 'SDRI', '', '', 'Elenco Modalita'' di Rilascio', '', '', 'F', 'D', 'CERSDRI', '66', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAOVI', 'GSD', 'AOVI', '', '', 'Aggiornamento Opzione di Voto in Italia', '', '', 'F', 'F', 'ELEAOVI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEVOVI', 'GSD', 'VOVI', '', '', 'Vis. Opzione di Voto in Italia', '', '', 'F', 'F', 'ELEVOVI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAAOV', 'GSD', 'AAOV', '', '', 'Assegnazione Automatica Opzione di Voto', '', '', 'F', 'F', 'ELEAAOV', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVLLMD', 'GSD', 'LLMD', '', '', 'Liste di Leva per Ministero Difesa', '', '', 'F', 'F', 'LEVLLMD', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAIMMI', 'GSD', 'IMMI', '', '', 'Immigrazione', '', '', 'F', 'F', 'ANAIMMI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAIMAI', 'GSD', 'IMAI', '', '', 'Immigrazione A.I.R.E.', '', '', 'F', 'F', 'ANAIMAI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAISUF', 'GSD', 'ISUF', '', '', 'Iscrizione d''Ufficio', '', '', 'F', 'F', 'ANAISUF', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAEMIG', 'GSD', 'EMIG', '', '', 'Emigrazione', '', '', 'F', 'F', 'ANAEMIG', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAEMAI', 'GSD', 'EMAI', '', '', 'Emigrazione A.I.R.E.', '', '', 'F', 'F', 'ANAEMAI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACIRR', 'GSD', 'CIRR', '', '', 'Cancellazione per Irreperibilit ', '', '', 'F', 'F', 'ANACIRR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASCIS', 'GSD', 'SCIS', '', '', 'Scissione', '', '', 'F', 'F', 'ANASCIS', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANACRES', 'GSD', 'CRES', '', '', 'Cambio di Residenza', '', '', 'F', 'F', 'ANACRES', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANARCFR', 'GSD', 'RCFR', '', '', 'Richiesta Codice Fiscale per Residenti', '', '', 'F', 'D', 'ANARCFR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAADMF', 'GSD', 'ADMF', '', '', 'Acquisizione Dati Ministero Finanze', '', '', 'F', 'D', 'ANAADMF', '66 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVDMF', 'GSD', 'VDMF', '', '', 'Visualizzazione Dati Ministero Finanze', '', '', 'F', 'F', 'ANAVDMF', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASAMF', 'GSD', 'SAMF', '', '', 'Stampa Anomalie Ministero Finanze', '', '', 'F', 'D', 'ANASAMF', '66 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANASCTC', 'GSD', 'SCTC', '', '', 'Stampa Controllo Contribuenti', '', '', 'F', 'D', 'ANASCOC', '66 f', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAACFR', 'GSD', 'ACFR', '', '', 'Aggiornamento Codici Fiscali Residenti', '', '', 'F', 'D', 'ANAACFR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAFSDE', 'GSD', 'FSDE', '', '', 'Fornitura Soggetti Deceduti', '', '', 'F', 'D', 'ANAFSDE', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANARSCA', 'GSD', 'RSCA', '', '', 'Rifornitura Soggetti Con Anomalia', '', '', 'F', 'D', 'ANARSCA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVVRNA', 'GSD', 'VRNA', '', '', 'Visualizzazione Rubrica Nascite', '', '', 'F', 'F', 'CIVVRNA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('CIVSRNA', 'GSD', 'SRNA', '', '', 'Stampa Rubrica Nascite', '', '', 'F', 'D', 'CIVSRNA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAAFRA', 'GSD', 'AFRA', '', '', 'Acquisizione File di Anomalie INA', '', '', 'F', 'D', 'ANAAFRA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAAFRI', 'GSD', 'AFRI', '', '', 'Acquisizione File di Ritorno INA', '', '', 'F', 'D', 'ANAAFRI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAPINA', 'GSD', 'PINA', '', '', 'Popolazione INA', '', '', 'F', 'F', 'ANAPINA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ANAVFRI', 'GSD', 'VFRI', '', '', 'Visualizzazione File di Ritorno INA', '', '', 'F', 'F', 'ANAVFRI', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVAPRU', 'GSD', 'APRU', '', '', 'Assegnazione Progressivi Ruoli', '', '', 'F', 'D', 'LEVAPRU', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVARUO', 'GSD', 'ARUO', '', '', 'Aggiornamento Ruoli', '', '', 'F', 'F', 'LEVARUO', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVSEDC', 'GSD', 'SEDC', '', '', 'Stampa Etichette Dati Congedo', '', '', 'F', 'D', 'LEVSEDC', '12', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVSEMA', 'GSD', 'SEMA', '', '', 'Stampa Etichette Matricola e Arma', '', '', 'F', 'D', 'LEVSEMA', '12', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVSRUO', 'GSD', 'SRUO', '', '', 'Stampa Ruoli', '', '', 'F', 'D', 'LEVSRUO', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('DLEVSDLE', 'GSD', 'SDLE', '', '', 'Stampa Dizionario', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('LEVDLEG', 'GSD', 'DLEG', '', '', 'Dizionario Leve Generale', '', '', 'F', 'F', 'LEVDLEG', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEADTL', 'GSD', 'ADTL', '', '', 'Tipi di Lista', '', '', 'F', 'F', 'ELEADTL', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEGAEA', 'GSD', 'GAEA', '', '', 'Generazione Archivio Elettori - Aggiunte', '', '', 'F', 'F', 'ELEGAEA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCLA', 'GSD', 'SCLA', '', '', 'Stampa di Controllo - Aggiunte', '', '', 'F', 'D', 'ELESCLA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('GLAGALAG', 'GSD', 'ALAG', '', '', 'Aggiornamento Liste Aggiunte', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('GLAGLELA', 'GSD', 'LELA', '', '', 'Liste Elettorali Aggiunte', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('GLAGGTEA', 'GSD', 'GTEA', '', '', 'Gestione Tessera Aggiunte', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEDLAG', 'GSD', 'DLAG', '', '', 'Dizionario Liste Aggiunte', '', '', 'F', 'F', 'ELEDLAG', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEEMLA', 'GSD', 'EMLA', '', '', 'Estrazione Movimenti - Aggiunte', '', '', 'F', 'D', 'ELEEMLA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESCML', 'GSD', 'SCML', '', '', 'Stampa di Controllo Movimenti - Aggiunte', '', '', 'F', 'D', 'ELESCML', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAMLA', 'GSD', 'AMLA', '', '', 'Aggiornamento Movimenti - Aggiunte', '', '', 'F', 'F', 'ELEAMLA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESRDA', 'GSD', 'SRDA', '', '', 'Stampa Richiesta Documenti - Aggiunte', '', '', 'F', 'D', 'ELESRDA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAPRA', 'GSD', 'APRA', '', '', 'Assegnazione Progressivi - Aggiunte', '', '', 'F', 'F', 'ELEAPRA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESPLA', 'GSD', 'SPLA', '', '', 'Stampa Prospetto Riassuntivo - Aggiunte', '', '', 'F', 'D', 'ELESPLA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEAALA', 'GSD', 'AALA', '', '', 'Aggiornamento Archivio - Aggiunte', '', '', 'F', 'D', 'ELEAALA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ALAGSALA', 'GSD', 'SALA', '', '', 'Stampe Aggiornamento Liste Aggiunte', '', '', 'N', 'M', '', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESVLI', 'GSD', 'SVLI', '', '', 'Stampa Verbale Iscrizioni - Aggiunte', '', '', 'F', 'D', 'ELESVLA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESVLV', 'GSD', 'SVLV', '', '', 'Stampa Verbale Variazioni - Aggiunte', '', '', 'F', 'D', 'ELESVLA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESVLR', 'GSD', 'SVLR', '', '', 'Stampa Verbale Irreperibili - Aggiunte', '', '', 'F', 'D', 'ELESVLA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESVLB', 'GSD', 'SVLB', '', '', 'Stampa Verbale Blocco Liste - Aggiunte', '', '', 'F', 'D', 'ELESVLA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELERPLA', 'GSD', 'RPLA', '', '', 'Riassegnazione Progressivi - Aggiunte', '', '', 'F', 'F', 'ELERPLA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESLGA', 'GSD', 'SLGA', '', '', 'Stampa Lista Generale - Aggiunte', '', '', 'F', 'D', 'ELESLGA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEGAA3', 'GSD', 'GAA3', '', '', 'Stampa Lista Gen. (Foglio A3) - Aggiunte', '', '', 'F', 'D', 'ELEGAA3', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESLSA', 'GSD', 'SLSA', '', '', 'Stampa Lista Sezionale - Aggiunte', '', '', 'F', 'D', 'ELESLSA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESAA3', 'GSD', 'SAA3', '', '', 'Stampa Lista Sez. (Foglio A3) - Aggiunte', '', '', 'F', 'D', 'ELESAA3', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESFPA', 'GSD', 'SFPA', '', '', 'Stampa Fascicoli Personali - Aggiunte', '', '', 'F', 'D', 'ELESFPA', '9', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESELA', 'GSD', 'SELA', '', '', 'Stampa Estratto Liste Sez. - Aggiunte', '', '', 'F', 'D', 'ELESELA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELELASM', 'GSD', 'LASM', '', '', 'Liste Aggiunte su Supporto Magnetico', '', '', 'F', 'D', 'ELELASM', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEANTA', 'GSD', 'ANTA', '', '', 'Assegnazione Numeri Tessera - Aggiunte', '', '', 'F', 'D', 'ELEANTA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELETELA', 'GSD', 'TELA', '', '', 'Tessere Elettorali - Aggiunte', '', '', 'F', 'D', 'ELETELA', '36', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEATEA', 'GSD', 'ATEA', '', '', 'Tessere Elettorali Emesse - Aggiunte', '', '', 'F', 'F', 'ELEATEA', '72', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEEATA', 'GSD', 'EATA', '', '', 'Etichette Tessere Elettorali - Aggiunte', '', '', 'F', 'D', 'ELEEATA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCEVIR', 'GSD', 'EVIR', '', '', 'Estrazione Vie Ripetute', '', '', 'F', 'D', 'ARCEVIR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCSVIR', 'GSD', 'SVIR', '', '', 'Stampa Vie Ripetute', '', '', 'F', 'D', 'ARCSVIR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ARCAVIR', 'GSD', 'AVIR', '', '', 'Aggiornamento Vie Ripetute', '', '', 'F', 'D', 'ARCAVIR', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESNIA', 'GSD', 'SNIA', '', '', 'Stampa Notifiche Iscrivendi - Aggiunte', '', '', 'F', 'D', 'ELESNIA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESNCA', 'GSD', 'SNCA', '', '', 'Stampa Notifiche Cancellandi - Aggiunte', '', '', 'F', 'D', 'ELESNCA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELESEVA', 'GSD', 'SEVA', '', '', 'Stampa Elenchi Verbale - Aggiunte', '', '', 'F', 'D', 'ELESEVA', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELECSAA', 'GSD', 'CSAA', '', '', 'Stampa Coda Sez. (Foglio A3) - Aggiunte', '', '', 'F', 'D', 'ELESAA3', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELECGAA', 'GSD', 'CGAA', '', '', 'Stampa Coda Gen. (Foglio A3) - Aggiunte', '', '', 'F', 'D', 'ELEGAA3', '', null, '', '');

insert into a_voci_menu (VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O, PROPRIETA)
values ('ELEEATV', 'GSD', 'EATV', '', '', 'Etic. Tessere Elettorali - Aggiunte', '', '', 'F', 'D', 'ELEEATA', '72 CA=40', null, '', '');

--

insert into a_voci_menu (voce_menu, ambiente, acronimo, titolo, tipo_voce, tipo, modulo) 
values ('GSDSTART', 'GSD', 'START', 'Start', 'F', 'F', 'GSDSTART');
end;

     end if;
  end if;
end;
/
