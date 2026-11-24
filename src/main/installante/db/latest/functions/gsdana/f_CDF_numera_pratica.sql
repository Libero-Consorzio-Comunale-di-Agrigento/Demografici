--liquibase formatted sql
--changeset amonopoli:202606151230 runOnChange:true stripComments:false
create or replace function f_CDF_numera_pratica
(a_tipo_pratica		IN	varchar2
,a_anno_pratica		IN	number
)
 
return number

is

w_tipo_pratica		varchar2(255) := upper(a_tipo_pratica);
w_anno_pratica		number := a_anno_pratica;

w_pratica		number;

begin
  if w_tipo_pratica is not null and w_anno_pratica is not null then
     if w_tipo_pratica = 'I' then
        begin
          select nvl(max(pratica_inizio),0) + 1
            into w_pratica         
            from anacdf
           where anno_pratica_inizio = w_anno_pratica
             and (cod_pro_inizio,cod_com_inizio) = (select pro_cliente, com_cliente from menuditta)
          ;
        exception
          when others then 
               w_pratica := '';
        end;

     elsif w_tipo_pratica = 'F' then
        begin
          select nvl(max(pratica_fine),0) + 1
            into w_pratica         
            from anacdf
           where anno_pratica_fine = w_anno_pratica
             and (cod_pro_fine,cod_com_fine) = (select pro_cliente, com_cliente from menuditta)
          ;
        exception
          when others then 
               w_pratica := '';
        end;
     end if;

  end if; --if w_tipo_pratica is not null and w_anno_pratica is not null then

  return w_pratica;      

exception
  when others then
       w_pratica          := '';
       return w_pratica         ;
end;
/
