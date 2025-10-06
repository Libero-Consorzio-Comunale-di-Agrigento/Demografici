--liquibase formatted sql
--changeset amonopoli:202503261008_2 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE BODY adssmenu IS
  PROCEDURE Main ( prenotazione Number, passo Number ) is
    p_ordinamento     varchar(200)   := null;
   p_messaggio       varchar(80)    := null;
   p_applicazione    A_MENU.APPLICAZIONE%TYPE;
   p_ruolo           A_MENU.RUOLO%TYPE;
   p_no_prenotazione number      := prenotazione;
  BEGIN
   BEGIN
      select max(decode(parametro,'P_APPLICAZIONE',valore,' '))
            ,max(decode(parametro,'P_RUOLO',valore,'*'))
        into p_applicazione,p_ruolo
        from a_parametri
       where no_prenotazione = p_no_prenotazione
      ;
   END;
 FOR rmenu IN (select padre,figlio,voce_menu,level livello,sequenza,rownum
                   from a_menu
                  where applicazione = p_applicazione
                    and ruolo        = p_ruolo
             connect by prior figlio       = padre
                    and prior applicazione = p_applicazione
                    and prior ruolo        = p_ruolo
              start with padre = 0
                 )     LOOP
       p_ordinamento := substr(p_ordinamento,1,(rmenu.livello-1)*2)
                     ||lpad(to_char(rmenu.sequenza),4,'0');
       insert into a_appoggio_stampe
              (no_prenotazione,no_passo,pagina,riga,testo)
       values ( p_no_prenotazione,1,1,rmenu.rownum
               ,lpad(to_char(rmenu.padre),8,'0')||' '
              ||lpad(to_char(rmenu.figlio),8,'0')||' '
              ||lpad(to_char(rmenu.livello),2,'0')||' '
              ||p_ordinamento)
       ;
   END LOOP;
   commit;
EXCEPTION
   WHEN OTHERS THEN p_messaggio := SQLERRM;
     insert into a_appoggio_stampe
                                (no_prenotazione,no_passo,pagina,riga,testo)
                    values (p_no_prenotazione,1,1,1,p_messaggio)
                    ;
                    commit;
END;
END;
/

