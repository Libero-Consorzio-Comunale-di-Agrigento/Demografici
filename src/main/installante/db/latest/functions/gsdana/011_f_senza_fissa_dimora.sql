--liquibase formatted sql
--changeset amonopoli:202505300910 runOnChange:true stripComments:false
create or replace function F_SENZA_FISSA_DIMORA
		(a_cod_via	number
		,a_num_civ	number
		,a_suffisso	varchar2
		,a_interno	number)

return varchar

IS

w_sfd_inp		varchar2(255);
w_sfd_dter_inp	varchar2(255);
w_ctr_UT		varchar2(255);
w_return		varchar2(255);

begin
  begin 
    select rtrim(inp.valore) 
      into w_sfd_inp
      from arcinp inp
     where parametro 	= 'SMP2_SFD'
       and rownum 	= 1
    ;
  exception
    when no_data_found then
         w_sfd_inp := 'NESSUNO';
    when others then
         w_sfd_inp := 'NESSUNO';
  end;
         
  if w_sfd_inp = 'NESSUNO' then
     w_return	:= 'N';
  elsif w_sfd_inp = 'SFD_DTER' then
     w_sfd_dter_inp := rtrim(f_valore_inp('SFD_DTER',1,2,'9',''));
     if ltrim(w_sfd_dter_inp,'0') is not null then
        w_ctr_UT := f_unita_territoriale(w_sfd_dter_inp,a_cod_via,a_num_civ,a_suffisso||a_interno);
        if w_ctr_UT is null then
           w_return	:= 'N';
        else
           w_return	:= 'S';
        end if;
     else
        w_return	:= 'N';
     end if;
  elsif w_sfd_inp like '%,%' then
     begin
       select 'S'
         into w_return
         from dual
        where w_sfd_inp like to_char(a_cod_via)||',%'
           or w_sfd_inp like '%,'||to_char(a_cod_via)
           or w_sfd_inp like '%,'||to_char(a_cod_via)||',%'
       ;
     exception
       when others then
            w_return := 'N';
     end;
  else
     begin
       select 'S'
         into w_return
         from dual
        where a_cod_via = to_number(w_sfd_inp)
       ;
     exception
       when others then
            w_return := 'N';
     end;
  end if;

  return w_return;

end;
/
