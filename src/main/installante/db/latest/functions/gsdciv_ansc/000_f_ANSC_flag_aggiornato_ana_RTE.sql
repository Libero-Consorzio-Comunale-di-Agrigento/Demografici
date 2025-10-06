--liquibase formatted sql
--changeset amonopoli:202311101045 runOnChange:true stripComments:false
create or replace function f_ANSC_flag_aggiornato_ana_RTE
(a_archivio_rif		IN	varchar2
,a_id_atto_ansc		IN	varchar2
)

return varchar2

IS

cursor sel_mat_uci is
select 'SI' flag, matricola
  from anaana
 where a_id_atto_ansc in (atto_mat_digitale,atto_mat_tr_digitale,atto_div_digitale)
;

w_matricola	varchar2(255);

w_flag      	varchar2(255);

begin
  if a_id_atto_ansc is not null then
     if a_archivio_rif = 'NAS' then
        begin
          select 'SI', matricola
            into w_flag, w_matricola
            from anaana
           where a_id_atto_ansc in (atto_nas_digitale,atto_nas_tr_digitale)
             and rownum =1
          ;
        exception
          when others then
               w_flag := 'NO';
        end;
    
     elsif a_archivio_rif = 'MOR' then
        begin
          select 'SI', matricola
            into w_flag, w_matricola
            from anaana
           where a_id_atto_ansc in (atto_mor_digitale,atto_mor_tr_digitale,atto_ved_digitale)
             and rownum =1
          ;
        exception
          when others then
               w_flag := 'NO';
        end;
    
     elsif a_archivio_rif in ('MAT','UCI') then
        w_flag      := 'NO';
        w_matricola := '';
        for rec in sel_mat_uci loop
            w_flag := rec.flag;
            if w_matricola is null then
               w_matricola := rec.matricola;
            else
               w_matricola := w_matricola||' - '||rec.matricola;
            end if;

        end loop;

     elsif a_archivio_rif in ('CIT') then
        begin
          select 'nazionalita: '||ana.nazionalita, ana.matricola
            into w_flag, w_matricola
            from anaana ana
               , anpna0 na0
           where ana.matricola = f_ADS_matricola(na0.idSchedaSoggettoAnpr_1,'','','','','')
             and na0.idAnsc    = a_id_atto_ansc
             and rownum =1
          ;
        exception
          when others then
               w_flag := 'NO';
        end;

     end if;
  end if;

  if nvl(w_flag,'NO') != 'NO' then
     w_flag := w_flag||' (matr. '||w_matricola||')';
  end if;

  return w_flag;

end;
/
