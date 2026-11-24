--liquibase formatted sql
--changeset amonopoli:202603221425 runOnChange:true stripComments:false
create or replace function f_ANPR_tipo_evento_ciu
(a_cod_mov		IN 	number
,a_cod_eve		IN	number
,a_flag_procedimento	IN	varchar2 default null
)

return varchar2

IS

w_anagrafe		varchar2(255);
w_tipo_evento		varchar2(255);

begin
        if a_cod_mov = 1 then 
           w_anagrafe    := 'RES';
           if a_cod_eve = 18 and nvl(a_flag_procedimento,'N') = 'S' then
              w_tipo_evento := 'C';
           else 
              w_tipo_evento := 'I';
           end if;
        elsif a_cod_mov = 2 then 
           w_anagrafe    := 'RES';
           if a_cod_eve = 62 and nvl(a_flag_procedimento,'N') = 'S' then
              w_tipo_evento := 'I';
           else
              w_tipo_evento := 'C';
           end if;
        elsif a_cod_mov = 3 and a_cod_eve = 52 then
           w_anagrafe    := 'RES';
           w_tipo_evento := 'C';
        elsif a_cod_mov = 3 and a_cod_eve != 52 then 
           w_anagrafe    := 'AIR';
           w_tipo_evento := 'I';
        elsif a_cod_mov = 4 then
           w_anagrafe    := 'AIR';
           w_tipo_evento := 'C';
        elsif a_cod_mov in (10,11) and a_cod_eve in (90,91,92) then 
           w_anagrafe    := 'RES';
           w_tipo_evento := 'E';
        elsif a_cod_mov in (12,13) and a_cod_eve in (90,91,92) then 
           w_anagrafe    := 'AIR';
           w_tipo_evento := 'E';
        elsif a_cod_mov = 97 and a_cod_eve in (93,94,97,98,99) then 
           w_anagrafe    := 'RES';
           w_tipo_evento := 'R';
        elsif a_cod_mov = 98 and a_cod_eve in (93,94,97,98,99) then 
           w_anagrafe    := 'AIR';
           w_tipo_evento := 'R';
        end if;

  return w_tipo_evento;
end;
/
