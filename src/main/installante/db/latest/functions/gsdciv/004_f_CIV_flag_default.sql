--liquibase formatted sql
--changeset amonopoli:202301201135_2 runOnChange:true stripComments:false
create or replace function F_CIV_FLAG_DEFAULT
(a_tipo_atto		IN	number
,a_parte		IN	number
,a_serie		IN	varchar2
,a_richiamo		IN	number
,a_progr_dettaglio	IN	number
,a_formula		IN	varchar2
,a_tipo_annotazione	IN	varchar2
,a_categoria		IN	varchar2
,a_flag_default		IN	varchar2
)

return varchar2

IS

w_flag		varchar2(1);

begin
  if a_tipo_atto = 2 then
     if a_parte||a_serie != '2B' then
        if a_richiamo = 1 and a_progr_dettaglio = 0 then
           if a_formula = '2-TES' then
              w_flag := 'S';
           else
              w_flag := null;
           end if;
        elsif a_richiamo = 4 and a_progr_dettaglio = 1 and a_formula = '1' then
           w_flag := 'S';
        elsif a_richiamo = 4 and a_progr_dettaglio != 1 and a_formula in ('5-PAT','5-MAT') then
           w_flag := a_flag_default;
        elsif a_richiamo = 5 and a_progr_dettaglio = 0 then
           if a_formula = '2-DNA' then
              w_flag := 'S';
           else
              w_flag := null;
           end if;
        elsif a_richiamo = 5 and a_progr_dettaglio = 1 and a_formula in ('14','15') then
           w_flag := 'S';
        elsif a_richiamo = 5 and a_progr_dettaglio = 2 and a_formula in ('19','20') then
           w_flag := 'S';
        elsif a_richiamo = 9 and a_progr_dettaglio = 1 then
           w_flag := 'S';
        elsif a_richiamo = 9 and a_progr_dettaglio = 2 then
           w_flag := 'S';
        elsif a_richiamo = 9 and a_formula = '2-CIR-PAR' then
           if a_parte||a_serie != '1B' then
              w_flag := 'S';
           else
              w_flag := '';
           end if;
        elsif a_richiamo = 9 and a_formula = '41-BIS' then
           if a_parte||a_serie != '1B' then
              w_flag := '';
           else
              w_flag := 'S';
           end if;
        elsif a_richiamo = 10 and a_formula in ('197-2/A','197-2/B') then
           w_flag := 'S';
        elsif a_richiamo = 99 then
           if a_formula like a_tipo_atto||'-%-'||a_parte||a_serie||'%' then
              w_flag := 'S';
           end if;
        else
           if a_formula like '%CNA%' then
              w_flag := null;
           elsif a_tipo_annotazione = 'W' then
              w_flag := 'S';
           else
              w_flag := a_flag_default;
           end if;
        end if;

     elsif a_parte||a_serie = '2B' then
        if a_richiamo = 1 and a_progr_dettaglio = 0 and a_categoria = 'CNA' then
           w_flag := a_flag_default;
        elsif a_richiamo = 5 and a_progr_dettaglio = 0 and a_categoria = 'CNA' then
           w_flag := a_flag_default;
        elsif instr(a_formula,a_categoria) > 0 then
           w_flag := 'S';
        elsif a_richiamo = 9 and a_progr_dettaglio = 1 then
           w_flag := 'S';
        elsif a_richiamo = 98 then
           w_flag := a_flag_default;
        elsif instr(a_formula,a_categoria) = 0 then
           w_flag := null;
        end if;

     end if;

  elsif a_tipo_atto = 3 then
    if a_richiamo = 1 and a_formula not like '3-TES-STR' then
       w_flag := 'S';
    elsif a_richiamo = 3 and a_formula not like '3-SPO-STR' then
       w_flag := 'S';
    elsif a_richiamo not in (1,3) and a_formula like '3-%' then
       w_flag := 'S';
    end if;

  elsif a_tipo_atto = 4 then
     if a_parte||a_serie != '2C' then
        if a_richiamo = 0 then 	-- testata trascrizione
           if a_formula like '%AVV%' then
              w_flag := null;
           else
              w_flag := 'S';
           end if;
        elsif a_richiamo = 1 then 	-- testata orginale
           if a_formula like a_tipo_atto||'-%-'||a_parte||a_serie||'%' then
              w_flag := 'S';
           elsif a_formula = '4-TES-2A' and a_parte = 2 and a_serie = 'B' then
              w_flag := 'S';
           end if;
        elsif a_richiamo in (3,99) then
           if a_formula like a_tipo_atto||'-%-'||a_parte||a_serie||'%' then
              w_flag := 'S';
           end if;
        elsif a_richiamo = 6 and a_progr_dettaglio = 1 then
           if a_formula in ('54/A','54/B','55') then
              w_flag := 'S';
           end if;
        elsif a_richiamo in (9,13) and a_formula in ('62','62-BIS') then
            w_flag := 'S';
        elsif a_richiamo = 9 and a_formula = '4-CON-PAT' then
            w_flag := 'S';
        else
           w_flag := a_flag_default;
        end if;

     elsif a_parte||a_serie = '2C' then
        if a_richiamo = 3 and a_progr_dettaglio = 0 then	-- sposi
           if a_categoria in ('UAC','UCO') and a_formula like '%DIV%' then
              w_flag := 'S';
           elsif a_formula like a_tipo_atto||'-%-'||a_parte||a_serie||'%' then
              w_flag := 'S';
           end if;
        elsif a_richiamo = 10 and a_progr_dettaglio = 1 then	-- chiusura
           w_flag := a_flag_default;
        elsif a_richiamo = 98 then				-- margine
           w_flag := a_flag_default;
        elsif a_richiamo = 99 and a_progr_dettaglio = 0 then	-- firme
           if instr(a_formula,a_categoria) > 0 then
              w_flag := 'S';
           elsif a_categoria in ('UAC','UCO') and a_formula like '%DIV%' then
              w_flag := 'S';
           elsif a_categoria not in ('UAC','UCO','AVV') then
              if a_formula like a_tipo_atto||'-%-'||a_parte||a_serie||'%' then
                 w_flag := 'S';
              end if;
           end if;
        elsif instr(a_formula,a_categoria) > 0 then
           w_flag := 'S';
        elsif instr(a_formula,a_categoria) = 0 then
           w_flag := null;
        end if;

     end if;

  elsif a_tipo_atto = 5 then
     if a_parte||a_serie != '2C' then
        if a_richiamo in (0,1,5,6) then
           if a_formula like a_tipo_atto||'-%-'||a_parte||a_serie then
              w_flag := 'S';
           elsif a_formula like a_tipo_atto||'-%-2BB' and a_serie = 'B BIS' then
              w_flag := 'S';
           end if;
        elsif a_richiamo = 4 and a_progr_dettaglio = 0 then
           w_flag := 'S';
        elsif a_richiamo in (99) then
           if a_formula like a_tipo_atto||'-%-'||a_parte||a_serie then
              w_flag := 'S';
           elsif a_formula like a_tipo_atto||'-%-2BB' and a_serie = 'B BIS' then
              w_flag := 'S';
           end if;
        else
           w_flag := a_flag_default;
        end if;

     elsif a_parte||a_serie = '2C' then
        if a_richiamo = 10 and a_progr_dettaglio = 1 then	-- chiusura
           w_flag := a_flag_default;
        elsif a_richiamo = 98 then				-- margine
           w_flag := a_flag_default;
        elsif a_richiamo = 99 and a_progr_dettaglio = 0 then	-- firme
           if instr(a_formula,a_categoria) > 0 then
              w_flag := 'S';
           end if;
        elsif instr(a_formula,a_categoria) > 0 then
           w_flag := 'S';
        elsif instr(a_formula,a_categoria) = 0 then
           w_flag := null;
        end if;

     end if;

  elsif a_tipo_atto = -4 then
     if a_parte||a_serie is null then
        if instr(a_formula,a_categoria) > 0 then
           w_flag := 'S';
        elsif a_richiamo = 6 and a_progr_dettaglio = 1 and a_formula like '0-PDO-PVNP' then	-- documenti non presentati
           if a_categoria <> 'PV2' then
              w_flag := 'S';
           end if;
        elsif a_richiamo = 6 and a_progr_dettaglio = 2 and a_formula like '0-PDO-PV%' then	-- chiusura documenti
           w_flag := 'S';
        else
           w_flag := null;
        end if;

     elsif a_parte||a_serie is not null then
        if instr(a_formula,a_categoria) > 0 then
           w_flag := 'S';
        elsif a_richiamo = 1 and a_formula = '0-TES-T1' and a_categoria = 'T2' and a_parte = 2 then
              w_flag := 'S';
        elsif a_richiamo = 3 and a_formula = '0-SPO' then
           w_flag := 'S';
        elsif a_richiamo = 3 and a_categoria in ('UAC','UCO') and a_formula like '%SPO-DIV%' then
            w_flag := 'S';
        elsif a_richiamo = 5 and a_formula = '0-TTE' then
           w_flag := 'S';
        elsif a_richiamo = 6 and a_formula like '0-PDO%' and a_formula not like '0-PDO-PV%' then
           w_flag := 'S';
        elsif a_richiamo = 8 and a_formula in ('73-QUINQUI') then
            w_flag := 'S';
        elsif a_richiamo = 9 and a_formula in ('73-SEXIES','73-SEPTIES','0-CON-PAT') then
            w_flag := 'S';
        elsif a_richiamo = 99 and a_formula = '0-FIR' then
            w_flag := 'S';
        elsif a_richiamo = 99 and a_categoria in ('UAC','UCO') and a_formula like '%DIV%' then
            w_flag := 'S';
        else
           w_flag := a_flag_default;
        end if;

     end if;

  else
     w_flag := a_flag_default;
  end if;

  return w_flag;

end;
/
