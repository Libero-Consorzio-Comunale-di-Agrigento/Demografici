--liquibase formatted sql
--changeset amonopoli:202511171555 runOnChange:true stripComments:false
create or replace function f_GSD_des_stato_ana_x_civ
(a_cognome        IN       varchar
,a_nome           IN       varchar
,a_sesso          IN       varchar
,a_data_nas       IN       date
,a_cod_pro_nas    IN       number
,a_cod_com_nas    IN       number
)

return varchar2

IS

w_cognome         varchar2(255) := a_cognome;
w_nome            varchar2(255) := a_nome;
w_sesso           varchar2(255) := a_sesso;
w_data_nas        date := a_data_nas;
w_cod_pro_nas     number := a_cod_pro_nas;
w_cod_com_nas     number := a_cod_com_nas;

w_esiste_nas      number := 0;
w_esiste_mor      number := 0;
w_esiste_mat      number := 0;
w_esiste_uci      number := 0;
w_esiste_cit      number := 0;

w_esiste_all      number := 0;

w_des_stato_ana   varchar2(4000);

begin
  if w_cognome||w_nome||w_sesso||w_data_nas||w_cod_pro_nas||w_cod_com_nas is not null then
     begin
       select 1 into w_esiste_nas
         from civnas
        where cognome                                        = w_cognome
          and nome                                           = w_nome
          and nvl(sesso,' ')                                 = nvl(w_sesso,' ')
          and nvl(d_data_nas,to_date('01011800','ddmmyyyy')) = nvl(w_data_nas,to_date('01011800','ddmmyyyy'))
          and nvl(cod_pro_nas,0)                             = nvl(w_cod_pro_nas,0)
          and nvl(cod_com_nas,0)                             = nvl(w_cod_com_nas,0)
          and cod_rec in (0,3)
          and rownum  = 1
       ;
     exception
       when others then
            w_esiste_nas := 0;
     end;
     begin
       select 1 into w_esiste_mor
         from civmor
        where cognome                                        = w_cognome
          and nome                                           = w_nome
          and nvl(sesso,' ')                                 = nvl(w_sesso,' ')
          and nvl(d_data_nas,to_date('01011800','ddmmyyyy')) = nvl(w_data_nas,to_date('01011800','ddmmyyyy'))
          and nvl(cod_pro_nas,0)                             = nvl(w_cod_pro_nas,0)
          and nvl(cod_com_nas,0)                             = nvl(w_cod_com_nas,0)
          and cod_rec in (0,3)
          and rownum  = 1
       ;
     exception
       when others then
            w_esiste_mor := 0;
     end;
     begin
       select 1 into w_esiste_cit
         from civcit
        where cognome                                        = w_cognome
          and nome                                           = w_nome
          and nvl(sesso,' ')                                 = nvl(w_sesso,' ')
          and nvl(d_data_nas,to_date('01011800','ddmmyyyy')) = nvl(w_data_nas,to_date('01011800','ddmmyyyy'))
          and nvl(cod_pro_nas,0)                             = nvl(w_cod_pro_nas,0)
          and nvl(cod_com_nas,0)                             = nvl(w_cod_com_nas,0)
          and cod_rec in (0,3)
          and rownum  = 1
       ;
     exception
       when others then
            w_esiste_cit := 0;
     end;
     begin
       select 1 into w_esiste_mat
         from civmat
        where cognome_m                                        = w_cognome
          and nome_m                                           = w_nome
          and nvl(d_data_nas_m,to_date('01011800','ddmmyyyy')) = nvl(w_data_nas,to_date('01011800','ddmmyyyy'))
          and nvl(cod_pro_nas_m,0)                             = nvl(w_cod_pro_nas,0)
          and nvl(cod_com_nas_m,0)                             = nvl(w_cod_com_nas,0)
          and w_sesso = 'M'
          and cod_rec in (0,3)
          and rownum  = 1
       ;
     exception
       when others then
            w_esiste_mat := 0;
     end;
     begin
       select 1 into w_esiste_mat
         from civmat
        where cognome_f                                        = w_cognome
          and nome_f                                           = w_nome
          and nvl(d_data_nas_f,to_date('01011800','ddmmyyyy')) = nvl(w_data_nas,to_date('01011800','ddmmyyyy'))
          and nvl(cod_pro_nas_f,0)                             = nvl(w_cod_pro_nas,0)
          and nvl(cod_com_nas_f,0)                             = nvl(w_cod_com_nas,0)
          and w_sesso = 'F'
          and cod_rec in (0,3)
          and rownum  = 1
       ;
     exception
       when others then
            w_esiste_mat := 0;
     end;
     begin
       select 1 into w_esiste_uci
         from civuci
        where cognome_m                                        = w_cognome
          and nome_m                                           = w_nome
          and sesso_m                                          = w_sesso
          and nvl(d_data_nas_m,to_date('01011800','ddmmyyyy')) = nvl(w_data_nas,to_date('01011800','ddmmyyyy'))
          and nvl(cod_pro_nas_m,0)                             = nvl(w_cod_pro_nas,0)
          and nvl(cod_com_nas_m,0)                             = nvl(w_cod_com_nas,0)
          and cod_rec in (0,3)
          and rownum  = 1
       ;
     exception
       when others then
            w_esiste_uci := 0;
     end;
     begin
       select 1 into w_esiste_uci
         from civuci
        where cognome_f                                        = w_cognome
          and nome_f                                           = w_nome
          and sesso_f                                          = w_sesso
          and nvl(d_data_nas_f,to_date('01011800','ddmmyyyy')) = nvl(w_data_nas,to_date('01011800','ddmmyyyy'))
          and nvl(cod_pro_nas_f,0)                             = nvl(w_cod_pro_nas,0)
          and nvl(cod_com_nas_f,0)                             = nvl(w_cod_com_nas,0)
          and cod_rec in (0,3)
          and rownum  = 1
       ;
     exception
       when others then
            w_esiste_uci := 0;
     end;
  end if;
  
  w_esiste_all := w_esiste_nas + w_esiste_mor + w_esiste_mat + w_esiste_uci + w_esiste_cit;
  
  if w_esiste_all > 0 then
     w_des_stato_ana := 'Atti di:';
     if w_esiste_nas = 1 then
        w_des_stato_ana := w_des_stato_ana||' Nascita -';
     end if;
     if w_esiste_mor = 1 then
        w_des_stato_ana := w_des_stato_ana||' Morte -';
     end if;
     if w_esiste_mat = 1 then
        w_des_stato_ana := w_des_stato_ana||' Matrimonio -';
     end if;
     if w_esiste_uci = 1 then
        w_des_stato_ana := w_des_stato_ana||' Unione Civile -';
     end if;
     if w_esiste_nas = 1 then
        w_des_stato_ana := w_des_stato_ana||' Cittadinanza -';
     end if;
     w_des_stato_ana := rtrim(rtrim(w_des_stato_ana),'-');
  end if;
  
  return w_des_stato_ana;

end;
/
