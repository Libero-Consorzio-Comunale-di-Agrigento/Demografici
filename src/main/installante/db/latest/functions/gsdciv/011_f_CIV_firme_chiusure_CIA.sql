--liquibase formatted sql
--changeset amonopoli:202303231755_7 runOnChange:true stripComments:false
create or replace function f_CIV_firme_chiusura_CIA
(a_tipo_atto   in   number
,a_ufficio     in   number
,a_anno        in   number
,a_parte       in   number
,a_serie       in   varchar2
,a_atto        in   number
,a_natura      in   varchar2
)

return varchar2

IS

w_cognome_nome             varchar2(255);

w_comparso                 varchar2(255);
w_cognome_nome_dic         varchar2(255);
w_paternita                varchar2(255);
w_maternita                varchar2(255);

w_cognome_nome_m           varchar2(255);
w_cognome_nome_f           varchar2(255);

w_cognome_nome_tte_1       varchar2(255);
w_cognome_nome_tte_2       varchar2(255);

w_stringa_chi              clob;
w_stringa_dna              clob;
w_stringa_dfi              clob;
w_stringa_pre              clob;

w_interprete               varchar2(4000);

w_return                   varchar2(255);

begin
  if a_tipo_atto = 1 and nvl(a_natura,' ') not in ('A','P') then
     goto fine;
  elsif nvl(a_natura,' ') not in ('O') then
     goto fine;
  end if;

  if a_tipo_atto = 1 then
     begin
       select translate(cit.cognome_nome,'/',' ')
         into w_cognome_nome
         from civcit cit
        where ufficio = a_ufficio
          and anno    = a_anno
          and atto    = a_atto
          and rownum = 1
       ;
     exception
       when others then
            w_cognome_nome := '';
     end;

     w_return := 'f.to '||nvl(w_cognome_nome,'_________________________');

     goto fine;

  elsif a_tipo_atto = 2 then
     begin
       select translate(nas.paternita,'/',' ')
            , translate(nas.maternita,'/',' ')
         into w_paternita
            , w_maternita
         from civnas nas
        where nas.ufficio        = a_ufficio
          and nas.anno           = a_anno
          and nas.atto           = a_atto
          and nvl(nas.parte,0)   = nvl(a_parte,0)
          and nvl(nas.serie,' ') = nvl(a_serie,' ')
          and nas.cod_rec        in (0,3)
          and rownum = 1
       ;
     exception
       when others then
            w_paternita := '';
            w_maternita := '';
     end;

     begin
       select decode(dpa.tipo_dichiarante,'PD','o','MD','a')
            , decode(dpa.tipo_dichiarante,'PD',w_paternita,'MD',w_maternita)
         into w_comparso
            , w_cognome_nome_dic
         from civdpa dpa
        where dpa.tipo_atto      = a_tipo_atto
          and dpa.ufficio        = a_ufficio
          and dpa.anno           = a_anno
          and dpa.atto           = a_atto
          and nvl(dpa.parte,0)   = nvl(a_parte,0)
          and nvl(dpa.serie,' ') = nvl(a_serie,' ')
          and rownum = 1
       ;
     exception
       when others then
            w_comparso         := '';
            w_cognome_nome_dic := '';
     end;

     begin
       select upper(tli.riga_clob)
         into w_stringa_pre
         from civtli tli
        where tli.tipo_atto        = a_tipo_atto
          and tli.ufficio          = a_ufficio
          and tli.anno             = a_anno
          and tli.atto             = a_atto
          and nvl(tli.parte,0)     = nvl(a_parte,0)
          and nvl(tli.serie,' ')   = nvl(a_serie,' ')
          and upper(tli.riga_clob) like '%INTERPRETE%'
       ;
       w_interprete := ltrim(substr(w_stringa_pre,instr(w_stringa_pre,'PER MEZZO DI')+11));
       w_interprete := rtrim(rtrim(substr(w_interprete,1,instr(w_interprete,' NAT'))));
     exception
       when others then
            w_interprete := '';
     end;

     if w_stringa_pre like '%INTERVENUTO%' or w_stringa_chi like '%INTERVENUTA%' then
        if w_interprete is not null then
           w_return := 'f.to '||w_interprete;
        else
           w_return := 'f.to '||w_cognome_nome_dic;
        end if;
        goto fine;
     else
        w_return := 'f.to '||w_cognome_nome_dic;
        begin
          select upper(tli.riga_clob)
            into w_stringa_dna
            from civtli tli
           where tli.tipo_atto      = a_tipo_atto
             and tli.ufficio        = a_ufficio
             and tli.anno           = a_anno
             and tli.atto           = a_atto
             and nvl(tli.parte,0)   = nvl(a_parte,0)
             and nvl(tli.serie,' ') = nvl(a_serie,' ')
          ;
        exception
          when others then
               w_stringa_dna := '';
        end;

        if w_stringa_dna like '%QUI COMPARS%' then
           if nvl(upper(w_comparso),'O') = 'O' then
              w_return := w_return||' f.to '||w_maternita;
           elsif nvl(upper(w_comparso),'O') = 'A' then
              w_return := w_return||' f.to '||w_paternita;
           end if;
        end if;

        if w_interprete is not null then
           w_return := w_return||' f.to '||w_interprete;
        end if;

     end if;

  elsif a_tipo_atto in (4,-4) then
     if a_tipo_atto = 4 then
        begin
          select translate(mat.cognome_nome_m,'/',' ')
               , translate(mat.cognome_nome_f,'/',' ')
            into w_cognome_nome_m, w_cognome_nome_f
            from civmat mat
           where mat.ufficio        = a_ufficio
             and mat.anno           = a_anno
             and mat.atto           = a_atto
             and nvl(mat.parte,0)   = nvl(a_parte,0)
             and nvl(mat.serie,' ') = nvl(a_serie,' ')
             and mat.cod_rec        in (0,3)
             and rownum = 1
          ;
        exception
          when others then
               w_cognome_nome_m := rpad('_',25,'_');
               w_cognome_nome_f := rpad('_',25,'_');
        end;

     elsif a_tipo_atto = -4 then
        begin
          select translate(uci.cognome_nome_m,'/',' ')
               , translate(uci.cognome_nome_f,'/',' ')
            into w_cognome_nome_m, w_cognome_nome_f
            from civuci uci
           where uci.ufficio        = a_ufficio
             and uci.anno           = a_anno
             and uci.atto           = a_atto
             and nvl(uci.parte,0)   = nvl(a_parte,0)
             and nvl(uci.serie,' ') = nvl(a_serie,' ')
             and uci.cod_rec        in (0,3)
             and uci.natura         != 'V'
             and rownum = 1
          ;
        exception
          when others then
               w_cognome_nome_m := rpad('_',25,'_');
               w_cognome_nome_f := rpad('_',25,'_');
        end;
     end if;

     begin
       select tta.cognome_1||' '||tta.nome_1
            , tta.cognome_2||' '||tta.nome_2
         into w_cognome_nome_tte_1
            , w_cognome_nome_tte_2
         from civtta tta
        where tta.tipo_atto      = a_tipo_atto
          and tta.ufficio        = a_ufficio
          and tta.anno           = a_anno
          and tta.atto           = a_atto
          and nvl(tta.parte,0)   = nvl(a_parte,0)
          and nvl(tta.serie,' ') = nvl(a_serie,' ')
          and rownum = 1
       ;
     exception
       when others then
            w_cognome_nome_tte_1 := '';
            w_cognome_nome_tte_2 := '';
     end;

     begin
       select upper(tli.riga_clob)
         into w_stringa_dfi
         from civtli tli
        where upper(tli.riga_clob) like '%INTERPRETE%'
          and tli.tipo_atto        = a_tipo_atto
          and tli.ufficio          = a_ufficio
          and tli.anno             = a_anno
          and tli.atto             = a_atto
          and nvl(tli.parte,0)     = nvl(a_parte,0)
          and nvl(tli.serie,' ')   = nvl(a_serie,' ')
       ;
       w_interprete := ltrim(substr(w_stringa_dfi,instr(w_stringa_dfi,'PER MEZZO DI')+11));
       w_interprete := rtrim(rtrim(substr(w_interprete,1,instr(w_interprete,' NAT'))));
     exception
       when others then
            w_interprete := '';
     end;

     w_return := 'f.to '||w_cognome_nome_m||' f.to '||w_cognome_nome_f;
     if w_cognome_nome_tte_1 is not null then
        w_return := w_return||' f.to '||w_cognome_nome_tte_1;
     end if;
     if w_cognome_nome_tte_2 is not null then
        w_return := w_return||' f.to '||w_cognome_nome_tte_2;
     end if;
     if w_interprete is not null then
        w_return := w_return||' f.to '||w_interprete;
     end if;

  elsif a_tipo_atto = 5 then
     begin
       select dpa.cognome_dic||' '||dpa.nome_dic
         into w_cognome_nome_dic
         from civdpa dpa
        where dpa.tipo_atto      = a_tipo_atto
          and dpa.ufficio        = a_ufficio
          and dpa.anno           = a_anno
          and dpa.atto           = a_atto
          and nvl(dpa.parte,0)   = nvl(a_parte,0)
          and nvl(dpa.serie,' ') = nvl(a_serie,' ')
          and rownum = 1
       ;
     exception
       when others then
            w_cognome_nome_dic := '';
     end;

     if w_cognome_nome_dic is not null then
        w_return := 'f.to '||w_cognome_nome_dic;
     else
        w_return := '';
     end if;

  end if;

<< fine >>
  w_return := nvl(w_return,'______________________________');

  return w_return;

end;
/
