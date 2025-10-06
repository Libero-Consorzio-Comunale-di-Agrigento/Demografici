--liquibase formatted sql
--changeset amonopoli:202304281630_1 runOnChange:true stripComments:false
create or replace function f_ANSC_flag_esiste_campo_jsn
(a_id_sezione	in	number)

return varchar2

IS

w_esiste	varchar2(1);

begin
  w_esiste := '';
  
  if a_id_sezione is not null then 
     begin
       select 'S' 
         into w_esiste
         from ansjsn_campi
        where id_sezione = a_id_sezione
          and rownum = 1
       ;
     exception
       when others then
           w_esiste := '';
     end;

--
-- 16/05/2023 (SN)
-- aggiunto controllo di esistenza id_padre in ansjsn_sezioni (id_padre)
-- uso il flag per capire se andare in ricorsione indipendentemente dal fatto che ci siano dei figli di tipo campo o di tipo sezione
--
     if w_esiste is null then
        begin
          select 'S' 
            into w_esiste
            from ansjsn_sezioni s
           where s.id_padre = a_id_sezione
             and rownum = 1
          ;
        exception
          when others then
              w_esiste := '';
       end;
     end if;
  end if;

  return w_esiste;
end;
/
