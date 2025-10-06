--liquibase formatted sql
--changeset amonopoli:202503261002_2 runOnChange:false stripComments:false
CREATE OR REPLACE PACKAGE BODY AAASDOFU AS

PROCEDURE Main ( prenotazione Number, passo Number ) IS
  v_key_order    varchar(100);
  i              number(6) :=0;
  v_applicazione varchar(8);
  v_ruolo        varchar(4);
  v_voce_start   varchar(8);
  cursor para is select parametro,valore
                   from a_parametri
                  where no_prenotazione=prenotazione and
                        parametro in ('APPLICAZIONE','RUOLO','VOCE_START');
  cursor menu is select voce_menu,sequenza,level
                   from a_menu
                  where applicazione=v_applicazione and
                        ruolo=nvl(v_ruolo,'*')
                        connect by prior figlio=padre and
                                   prior applicazione=v_applicazione and
                                   prior ruolo=nvl(v_ruolo,'*')
                        start with
                            decode(v_voce_start,null,to_char(padre),voce_menu)=
                                   nvl(v_voce_start,'0');
  para_rec      para%ROWTYPE;
  menu_rec      menu%ROWTYPE;
BEGIN
    open para;                  /* Lettura parametri */
  loop
    fetch para into para_rec;
    exit when para%NOTFOUND;
    if   para_rec.parametro='APPLICAZIONE' then v_applicazione:=para_rec.valore;
    elsif para_rec.parametro='RUOLO'       then v_ruolo:=para_rec.valore;
    elsif para_rec.parametro='VOCE_START'  then v_voce_start:=para_rec.valore;
    end if;
  end loop;
  close para;
  open menu;                  /* Caricamento appoggio stampe */
  loop
    fetch menu into menu_rec;
    exit when menu%NOTFOUND;
    if menu_rec.level=1 then
      v_key_order:=ltrim(to_char(menu_rec.sequenza,'09'));
    else
      v_key_order:=substr(v_key_order,1,((menu_rec.level-1)*2))||
                   ltrim(to_char(menu_rec.sequenza,'09'));
    end if;
    insert into a_appoggio_stampe (no_prenotazione,no_passo,pagina,riga,testo)
    values (prenotazione,passo,0,i,rpad(menu_rec.voce_menu,10)||v_key_order);
     i:=i+1;
	 end loop;
  close menu;
  commit;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       Null;
     WHEN OTHERS THEN
       Null;
END main;

END AAASDOFU;
/

