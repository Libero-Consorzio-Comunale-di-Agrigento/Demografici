--liquibase formatted sql
--changeset amonopoli:202311301710 runOnChange:true stripComments:false
create or replace function f_ANSC_recupera_otp_UTE
(a_terminalista    IN  varchar2
)

return varchar2

IS

w_ore_otp	number;
w_minuti_otp	number;
w_ore_sys	number;
w_minuti_sys	number;

--
-- 30/11/2023 (AM): al momento impostiamo fisso 239 min (4 ore, meno un minuto)
--                  in corso di valutazione l'uso di parametro ansinp.DURATA_OTP
--
w_durata_otp	number := 239; -- in minuti

w_otp      	varchar2(255);

begin
  begin
    select ute.ansc_otp, 
           to_char(ute.d_data_ansc_otp,'hh24'), to_char(ute.d_data_ansc_otp,'mi'), 
           to_char(sysdate,'hh24'), to_char(sysdate,'mi')
      into w_otp, w_ore_otp, w_minuti_otp, w_ore_sys, w_minuti_sys
      from ansute ute
     where cod_utente              = a_terminalista
       and nvl(ansc_consenso,'NO') = 'SI'
       and trunc(d_data_ansc_otp)  = trunc(sysdate)
    ;
    w_minuti_otp := (w_ore_otp*60)+w_minuti_otp;
    w_minuti_sys := (w_ore_sys*60)+w_minuti_sys;

    if (w_minuti_sys - w_minuti_otp) >= w_durata_otp then
       w_otp := '';
    end if;
    
  exception
    when others then
         w_otp := '';
  end;

  return w_otp;

end;
/
