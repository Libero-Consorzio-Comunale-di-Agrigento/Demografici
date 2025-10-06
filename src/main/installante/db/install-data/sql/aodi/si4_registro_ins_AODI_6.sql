--liquibase formatted sql
--changeset amonopoli:202503191000_6 runOnChange:true stripComments:false
DECLARE
  out_valore  		varchar2(200);
  w_istanza		varchar2(200);
  w_dislocazione	varchar2(200);
BEGIN
  begin
    select istanza, dislocazione
      into w_istanza, w_dislocazione
      from ad4_istanze
     where istanza 	= '${istanzaAD4}'
       and rownum	= 1
    ;
  exception
    when others then
	 w_istanza      := '';
         w_dislocazione := '';
  end;
  
  if w_istanza is not null and w_dislocazione is not null then
     si4_registro_utility.leggi_stringa('DB_USERS/'||w_istanza,'Log GDM',out_valore, false);  
     IF nvl(out_valore,' ') = ' ' THEN
        BEGIN
          si4_registro_utility.scrivi_stringa('DB_USERS/'||w_istanza,'Log GDM','SI','',false);
        EXCEPTION 
	  WHEN OTHERS THEN
               if instr(sqlerrm,'ORA-20922') != 0 then   
                  si4_registro_utility.crea_chiave('DB_USERS/'||w_istanza);
               end if;   
               si4_registro_utility.scrivi_stringa('DB_USERS/'||w_istanza,'Log GDM','SI','',false);     
        END;
     END IF;
  END IF;
END;
/
