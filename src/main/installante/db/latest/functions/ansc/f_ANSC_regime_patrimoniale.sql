--liquibase formatted sql
--changeset ftravaglini:202306151210 runOnChange:true stripComments:false
create or replace function f_ANSC_regime_patrimoniale
(a_cod_conv_flag	IN	varchar2
,a_cod_scelta_conv	IN	number           
)

return number

IS

w_cod_conv_flag		varchar2(2);
w_cod_conv       	varchar2(3);

w_return		number;

begin
  if a_cod_conv_flag is null then
     w_cod_conv_flag := 'NO';
     w_cod_conv      := w_cod_conv_flag;
  else
     w_cod_conv_flag := upper(a_cod_conv_flag);   
     w_cod_conv      := w_cod_conv_flag || to_char(a_cod_scelta_conv);	   
  end if;

  begin
    select id 
      into w_return 
      from anst49 
     where convenzioni_ads = w_cod_conv
    ;
  exception
    when others then
         w_cod_conv := 'XX';
         begin
           select id into w_return 
             from anst49 
            where convenzioni_ads = w_cod_conv
         ;
         exception
           when others then
                w_return := 5;
       end;
  end;
  
  return w_return;
end;
/
