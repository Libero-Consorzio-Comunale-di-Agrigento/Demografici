--liquibase formatted sql
--changeset amonopoli:202305181200 runOnChange:true stripComments:false
create or replace function F_ANSCIU_NR
(a_id		IN 	number
)

return number

IS

w_anno		number;
w_numero	number;

w_id		number;

begin
 if a_id is null then
    begin 
      select anno, numero + 1
        into w_anno, w_numero
        from ansn01
       where anno                     = to_char(sysdate,'yyyy')
      ; 
      update ansn01
         set numero = w_numero
       where anno  	              = w_anno
      ;
    exception
      when no_data_found then
           w_anno 	:= to_char(sysdate,'yyyy');
           w_numero	:= 1;
           begin
             insert into ansn01 (anno, numero)
             values (w_anno, w_numero)
	     ;
           exception
             when others then
                  w_anno         := '';
                  w_numero       := '';
           end;
      when others then
           w_anno 	  := '';
	   w_numero	  := '';
    end;

    if w_anno is not null and w_numero is not null then
       w_id := w_anno||lpad(w_numero,6,'0');
    else 
       w_id := to_number(null);
    end if;
 else
    w_id := a_id;
 end if;

 return w_id;

end;
/* End Procedure: ANSCIU_NR */
/

	