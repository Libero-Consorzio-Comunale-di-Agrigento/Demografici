--liquibase formatted sql
--changeset amonopoli:202305291125 runOnChange:true stripComments:false
CREATE OR REPLACE function f_ANPR_luogo
(a_cod_provincia   number
,a_cod_comune      number
,a_data            number
,a_tipo_luogo      number	-- 1=luogo_eccezionale, 2=comune, 3=localita
,a_tipo_des        number)      -- per tipo_luogo = 2: 1=descrizione, 2=codiceistat      , 3=sigla provincia
				-- per tipo_luogo = 3: 1=localita   , 2=descrizione stato, 3=codice stato
return varchar2						 
IS
w_codice	varchar2(6);
w_des		varchar2(255);
w_sigla_pro	varchar2(255);

w_count_t02	number;
begin
    if a_tipo_luogo = 1 then
       if a_cod_provincia in (198,199) then
         w_des := f_comune_al(a_cod_provincia,a_cod_comune,a_data);
       else
         w_des := '';
       end if;

    elsif a_tipo_luogo = 2 then
       if a_cod_provincia < 198 or (a_cod_provincia in (701,702,703) and a_cod_comune > 500) then
          begin
            select lpad(cod_provincia_prec,3,'0')||lpad(cod_comune_prec,3,'0')
                 , sigla_provincia_prec
              into w_codice
                 , w_sigla_pro
              from arccom_rinumerati
             where cod_provincia = a_cod_provincia
               and cod_comune    = a_cod_Comune
               and nvl(a_data,to_char(sysdate,'j')) between data_inizio_validita and data_fine_validita
               and rownum        = 1
            ;
          exception 
            when others then
                 w_codice := lpad(a_cod_provincia,3,'0')||lpad(a_cod_comune,3,'0');
          end;

          if a_tipo_des = 1 then
--             begin
--               select t03.descrizione
--                 into w_des
--                 from anpt03 t03
--                where t03.codice                       = w_codice
--                  and nvl(a_data,to_char(sysdate,'j')) between t03.data_istituzione and t03.data_cessazione
--                  and rownum                           = 1
--               ;
--             exception 
--               when others then
--                    w_des := '';
--             end;
             if w_des is null then
                w_des := f_comune_al(a_cod_provincia,a_cod_comune,a_data);
             end if;

          elsif a_tipo_des = 2 then
             w_des := w_codice;
             
          elsif a_tipo_des = 3 then
--             begin
--               select t03.sigla_provincia
--                 into w_des
--                 from anpt03 t03
--                where t03.codice                       = w_codice
--                  and nvl(a_data,to_char(sysdate,'j')) between t03.data_istituzione and t03.data_cessazione
--                  and rownum                           = 1
--               ;
--             exception 
--               when others then
--                    w_des := '';
--             end;
             if w_des is null then
                if w_sigla_pro is not null then
                   w_des := w_sigla_pro;
                else 
                   w_des := f_sigla_provincia_al(a_cod_provincia,a_cod_comune,a_data);
                end if;
             end if;
          end if;
       else
          w_des := '';
       end if;

    else
       if (a_cod_provincia > 199 and a_cod_provincia not in (701,702,703)) or
          (a_cod_provincia in (701,702,703) and a_cod_comune < 500) 
       then
          if a_tipo_des = 1 then
             w_des := f_comune_al(a_cod_provincia,a_cod_comune,a_data);
             if w_des is null then
		w_des := f_comune_al(a_cod_provincia,0,a_data);
             end if;

          elsif a_tipo_des = 2 then
             begin
               select descrizione
                 into w_des
                 from anpt02
                where codice = a_cod_provincia
                  and nvl(a_data,to_char(sysdate,'j')) between data_inizio_validita and data_fine_validita
               ;
             exception
               when others then
                    w_des := '';
             end;
             if w_des is null then
                w_des := f_comune_al(a_cod_provincia,0,a_data);
             end if;

          elsif a_tipo_des = 3 then
             begin
               select codice
                 into w_des
                 from anpt02
                where codice = a_cod_provincia
                  and nvl(a_data,to_char(sysdate,'j')) between data_inizio_validita and data_fine_validita
               ;
             exception
               when others then
                    w_des := '';
             end;
             if w_des is null then
                begin
                  select count(*) into w_count_t02
                    from anpt02
                  ;
                exception
                  when others then
                       w_count_t02 := 0;
                end;
                if w_count_t02 > 0 then
                   w_des := '998';
                else
                   w_des := a_cod_provincia;
                end if;
             end if;
          end if;
       else
          w_des := '';
       end if;
    end if;

    return w_des;
end;
/
