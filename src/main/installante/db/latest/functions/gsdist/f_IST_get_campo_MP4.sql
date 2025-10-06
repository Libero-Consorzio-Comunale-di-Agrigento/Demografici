--liquibase formatted sql
--changeset amonopoli:202503211120_3 runOnChange:true stripComments:false
create or replace function f_IST_get_campo_MP4
(a_matricola		IN	number
,a_campo		IN	varchar2
)

return varchar2

IS

w_campo			varchar2(255) := upper(a_campo);


w_ista_dter_inp		varchar2(255);

w_intestatario		varchar2(255);
w_cognome_intestatario	varchar2(255);
w_nome_intestatario 	varchar2(255);
w_indirizzo		varchar2(255);
w_cod_via		varchar2(255);
w_num_civ		varchar2(255);
w_suffisso		varchar2(255);
w_data_reg_j		varchar2(255);

w_return		varchar2(255);

begin
  if a_matricola is not null and w_campo is not null then
     begin
       select translate(mov.intestatario,'/',' '),
              substr(mov.intestatario,1,instr(mov.intestatario,'/')-1),
              substr(mov.intestatario,instr(mov.intestatario,'/')+1),
              vie.denom_uff||mov.civico_esterno,
              mov.cod_via,
              mov.num_civ,
              mov.suffisso,
              mov.data_reg
         into w_intestatario, 
              w_cognome_intestatario, 
              w_nome_intestatario, 
              w_indirizzo, 
              w_cod_via, 
              w_num_civ, 
              w_suffisso,
              w_data_reg_j
         from arcvie vie, anamov mov
        where vie.cod_via (+) = mov.cod_via
          and mov.cod_mov     = 1
          and mov.cod_eve     = 1
          and mov.matricola   = a_matricola
       ;
     exception
       when others then
            w_return := '';
     end;

     if w_campo = 'SEZIONE_CENS' then
        w_ista_dter_inp := nvl(rtrim(f_valore_inp('ISTA_DTER',1,2,'9','')),'0');
        if w_ista_dter_inp != '0' then
           w_return := substr(f_unita_territoriale(w_ista_dter_inp,w_cod_via,w_num_civ,w_suffisso),21,4);
        end if;

     elsif w_campo = 'INTESTATARIO' then
        w_return := w_intestatario;
 
     elsif w_campo = 'COGNOME_INTESTATARIO' then
        w_return := w_cognome_intestatario;
 
     elsif w_campo = 'NOME_INTESTATARIO' then
        w_return := w_nome_intestatario;
 
     elsif w_campo = 'INDIRIZZO' then
        w_return := w_indirizzo;

     elsif w_campo = 'DATA_REG_J' then
        w_return := w_data_reg_j;

     else
        w_return := '';
     
     end if; --if w_campo =...
  end if; --if a_matricola is not null and w_campo is not null then

  return w_return;

end;
/
