--liquibase formatted sql
--changeset amonopoli:202405231620 runOnChange:true stripComments:false
CREATE OR REPLACE function f_nazione
(a_cod_pro	IN	number
,a_cod_com 	IN	number)

return varchar2

IS

w_ctr_pro	number;
w_nazione 	varchar2(255);

begin
  if a_cod_pro is not null and a_cod_com is not null then 
     if a_cod_pro < 201 then
        begin
          select 1 into w_ctr_pro
            from arcpro
           where cod_provincia = a_cod_pro
             and rownum = 1
          ;
          w_nazione := 'ITALIA';
        exception
          when others then
               w_nazione := '';
        end;    
        goto fine;
     end if;

     if a_cod_pro in (701,702,703) then
        if a_cod_com >= 500 then
           goto fine;
        end if;
     end if;
 
     begin
       select descrizione
         into w_nazione
         from arccom
        where cod_provincia = a_cod_pro
          and cod_comune    = 0
          and rownum        = 1
       ;
     exception 
       when others then
            w_nazione := '';
     end;
  end if;

<< fine >>
  return w_nazione;
  
exception
  when others then
       return null;
end;
/

