--liquibase formatted sql
--changeset amonopoli:202510081420 runOnChange:true stripComments:false
create or replace function f_ANSC_stringa_unicode
(a_tabella_rif	IN	varchar2
,a_id_rif	IN	number
,a_campo	IN	varchar2
,a_stringa	IN	varchar2
)

return nvarchar2

IS

w_tabella_rif		varchar2(255) := upper(a_tabella_rif);
w_id_rif		varchar2(255) := a_id_rif;
w_campo			varchar2(255) := upper(a_campo);
w_campo_rif		varchar2(255);

w_stringa		nvarchar2(4000);

begin
  if w_tabella_rif is not null and w_id_rif is not null and w_campo is not null then
     if w_campo in ('COGNOME_NOME','COGNOME','NOME') then 
        w_campo_rif := 'COGNOME_NOME';
     elsif w_campo in ('COGNOME_NOME_1','COGNOME_1','NOME_1') then 
        w_campo_rif := 'COGNOME_NOME_1';
     elsif w_campo in ('COGNOME_NOME_2','COGNOME_2','NOME_2') then 
        w_campo_rif := 'COGNOME_NOME_2';
     elsif w_campo in ('COGNOME_NOME_PD','COGNOME_PD','NOME_PD') then 
        w_campo_rif := 'COGNOME_NOME_PD';
     elsif w_campo in ('COGNOME_NOME_MD','COGNOME_MD','NOME_MD') then 
        w_campo_rif := 'COGNOME_NOME_MD';
     elsif w_campo in ('COGNOME_NOME_CN','COGNOME_CN','NOME_CN') then 
        w_campo_rif := 'COGNOME_NOME_CN';
     end if;

     if w_campo_rif is not null then
        begin
          select case 
                   when w_campo in ('COGNOME_NOME', 'COGNOME_NOME_1', 'COGNOME_NOME_2', 'COGNOME_NOME_PD', 'COGNOME_NOME_MD', 'COGNOME_NOME_CN') then
                        uni.cognome_nome
                   when w_campo in ('COGNOME', 'COGNOME_1', 'COGNOME_2', 'COGNOME_PD', 'COGNOME_MD', 'COGNOME_CN') then
                        uni.cognome
                   when w_campo in ('NOME', 'NOME_1', 'NOME_2', 'NOME_PD', 'NOME_MD', 'NOME_CN') then
                        uni.nome
                 end
            into w_stringa
            from gsdana_unicode uni
           where tabella_rif = w_tabella_rif
             and id_rif      = w_id_rif
             and campo_rif   = w_campo_rif
          ;
        exception
          when others then
               w_stringa := '';
        end;
     end if;
  end if;

  return nvl(w_stringa,a_stringa);

end;
/
