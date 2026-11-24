--liquibase formatted sql
--changeset amonopoli:202510010925 runOnChange:true stripComments:false
create or replace function F_ANA_GET_COD_FAM
(a_id		IN	number
,a_fascia	IN	number
)

return number

IS

w_id	number;

begin
  if a_id is not null then
     w_id := a_id;

  elsif a_id is null then
     if a_fascia in (1,2) then
        begin 
          select numero
            into w_id
            from anan01
           where cod_num = 'FRE'
          ;
        exception
          when no_data_found then
               w_id := 0;
               begin
                 insert into anan01 (cod_num, numero)
                 values ('FRE',0)
                 ;
               end;
          when others then
               goto fine;
        end;

     elsif a_fascia in (3,4) then
        begin 
          select numero
            into w_id
            from anan01
           where cod_num = 'FAR'
          ;
        exception
          when no_data_found then
               w_id := 0;
               begin
                 insert into anan01 (cod_num, numero)
                 values ('FAR',0)
                 ;
               end;
          when others then
               goto fine;
        end;

     elsif a_fascia = 6 then
        begin 
          select numero
            into w_id
            from anan01
           where cod_num = 'FNR'
          ;
        exception
          when no_data_found then
               w_id := 0;
               begin
                 insert into anan01 (cod_num, numero)
                 values ('FNR',0)
                 ;
               end;
          when others then
               goto fine;
        end;

     end if;
  end if;

  if w_id is not null then
     w_id := w_id + 1;

     if a_fascia in (1,2) then
        begin
          update anan01
             set numero = w_id
           where cod_num = 'FRE'
          ;
        end;

     elsif a_fascia in (3,4) then
        begin
          update anan01
             set numero = w_id
           where cod_num = 'FAR'
          ;
        end;

     elsif a_fascia = 6 then
        begin
          update anan01
             set numero = w_id
           where cod_num = 'FNR'
          ;
        end;
     end if;

  end if;

<< fine >>

  return w_id;

end;
/* End Procedure: F_ANA_GET_COD_FAM */
/
