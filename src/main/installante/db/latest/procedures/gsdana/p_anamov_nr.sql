--liquibase formatted sql
--changeset amonopoli:202606101435_1 runOnChange:true stripComments:false
create or replace procedure ANAMOV_NR
( a_anno_progr		IN OUT	number,
  a_numero_progr	IN OUT	number
)
is
begin
   if a_anno_progr is null and a_numero_progr is null then
       begin 
          select anno, numero + 1
            into a_anno_progr, a_numero_progr
            from anan02
	   where anno = to_char(sysdate,'yyyy')
          ; 
	  update anan02
	     set numero = a_numero_progr
	   where anno  	= a_anno_progr
	  ;
       exception
	 when no_data_found then
	      a_anno_progr 	:= to_char(sysdate,'yyyy');
	      a_numero_progr	:= 1;
	      begin
	        insert into anan02 (anno, numero)
		values (a_anno_progr, a_numero_progr)
		;
	      exception
		when others then
		     a_anno_progr 	:= '';
		     a_numero_progr	:= '';
	      end;
	 when others then
	      a_anno_progr 	:= '';
	      a_numero_progr	:= '';
       end;
    end if;
end;
/
