--liquibase formatted sql
--changeset amonopoli:202503240925_2 runOnChange:true stripComments:false
CREATE OR REPLACE PACKAGE BODY SI4V2 IS
  procedure sql_execute
  (testo_sql in varchar2)
  is
  begin
    si4.sql_execute(testo_sql);
  exception when others then
    raise_application_error(-20901,'Errore istruzione "'||testo_sql||'". Verificare l''esistenza dell''oggetto.');
  end;
  procedure grant_to
  (utente varchar2)
  is
  begin
--   sql_execute('grant select,insert,update,delete on MENUACC   to '||utente);
--   sql_execute('grant select,insert,update,delete on MENUAMB   to '||utente);
--   sql_execute('grant select,insert,update,delete on MENUAPP   to '||utente);
--   sql_execute('grant select,insert,update,delete on MENUAUT   to '||utente);
--   sql_execute('grant select,insert,update,delete on MENUDAC   to '||utente);
   sql_execute('grant select,insert,update,delete on MENUDITTA   to '||utente);
--   sql_execute('grant select,insert,update,delete on MENUDMY   to '||utente);
--   sql_execute('grant select,insert,update,delete on MENUELA   to '||utente);
--   sql_execute('grant select,insert,update,delete on MENUMEN   to '||utente);
--   sql_execute('grant select,insert,update,delete on MENUMENUTE   to '||utente);
--   sql_execute('grant select,insert,update,delete on MENUNUM   to '||utente);
--   sql_execute('grant select,insert,update,delete on MENUPRO   to '||utente);
--   sql_execute('grant select,insert,update,delete on MENUPROPRT   to '||utente);
--   sql_execute('grant select,insert,update,delete on MENUPRT   to '||utente);
--   sql_execute('grant select,insert,update,delete on MENUREP   to '||utente);
--   sql_execute('grant select,insert,update,delete on MENUSTP   to '||utente);
--   sql_execute('grant select,insert,update,delete on MENUUFS   to '||utente);
--   sql_execute('grant select,insert,update,delete on MENUUSR   to '||utente);
--   sql_execute('grant select,insert,update,delete on MENUUTE   to '||utente);
--   sql_execute('grant select on REGISTRO               to '||utente);
--   sql_execute('grant execute on REGISTRO_UTILITY         to '||utente);
   sql_execute('grant select,insert,update,delete on COM      to '||utente);
--   sql_execute('grant select,insert,update,delete on REG      to '||utente);
--   sql_execute('grant select,insert,update,delete on USL      to '||utente);
  end;
END;
/
