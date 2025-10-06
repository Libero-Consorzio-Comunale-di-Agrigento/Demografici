--liquibase formatted sql
--changeset amonopoli:202410281520 runOnChange:true stripComments:false
create or replace function f_CER_descrizione_estesa_dce
(a_descrizione	IN	varchar2)

return varchar2

IS

w_descrizione	varchar2(255);

w_errore	varchar2(4000);
errore		exception;

begin
  if a_descrizione is not null then
     w_descrizione := a_descrizione;
     if w_descrizione like 'CERTIFICATO CONTESTUALE%' then
        w_descrizione := replace(w_descrizione,'CERTIFICATO CONTESTUALE','CONTESTUALE');
     end if;
     if w_descrizione like 'CERTIFICATO CUMULATIVO%' then
        w_descrizione := replace(w_descrizione,'CERTIFICATO CUMULATIVO','CONTESTUALE');
     end if;
     if w_descrizione like 'ANSC -%' then
        w_descrizione := ltrim(substr(w_descrizione,7));
     end if;
     if w_descrizione like '%PAT/MAT%' then
        w_descrizione := replace(w_descrizione,'PAT/MAT','PATERNITA'' / MATERNITA''');
     end if;
     if w_descrizione like '%CON PAT.' then
        w_descrizione := replace(w_descrizione,'CON PAT.','CON PATERNITA'' / MATERNITA''');
     end if;
     if w_descrizione like '%CON PAT./MAT.' then
        w_descrizione := replace(w_descrizione,'PAT./MAT.','PATERNITA'' / MATERNITA''');
     end if;
     if w_descrizione like 'ATT.%DI REGOLARIT%' then
        w_descrizione := replace(w_descrizione,'ATT.','ATTESTAZIONE');
     end if;
     if w_descrizione like '%NON RESIDENTE' and w_descrizione not like 'DICH%' then
        w_descrizione := rtrim(replace(w_descrizione,'NON RESIDENTE',''));
     end if;
     if w_descrizione like '%NON RESIDENTI' and w_descrizione not like 'DICH%'  then
        w_descrizione := rtrim(replace(w_descrizione,'NON RESIDENTI',''));
     end if;
     if w_descrizione like '%(A.I.R.E.)' then
        w_descrizione := rtrim(replace(w_descrizione,'(A.I.R.E.)',''));
     end if;
     if w_descrizione like 'NRE ANPR -%' then
        w_descrizione := ltrim(substr(w_descrizione,11));
     end if;
     if w_descrizione like '%PER A/F%' then
        w_descrizione := replace(w_descrizione,'A/F','ASSEGNI FAMILIARI');
     end if;
     if w_descrizione like '%MAT/VED%' then
        w_descrizione := replace(w_descrizione,'MAT/VED','MATRIMONIO / VEDOVANZA');
     end if;
     if w_descrizione like '%CON RAPPORTI PAR.' then
        w_descrizione := replace(w_descrizione,'RAPPORTI PAR.','RAPPORTI PARENTELA');
     end if;

--RES/CIT/DIR.POL/NAS/ST.CIV
     if w_descrizione like '%/RES%' and w_descrizione not like '%/RESIDENZA%' then
        w_descrizione := replace(w_descrizione,'/RES','/RESIDENZA');
     elsif w_descrizione like '%/ RES%'  and w_descrizione not like '%/ RESIDENZA%' then
        w_descrizione := replace(w_descrizione,'/ RES','/RESIDENZA');
     elsif w_descrizione like '%RES/%' then
        w_descrizione := replace(w_descrizione,'RES/','RESIDENZA/');
     elsif w_descrizione like '%RES /%' then
        w_descrizione := replace(w_descrizione,'RES /','RESIDENZA/');
     end if;
     if w_descrizione like '%/CIT%' and w_descrizione not like '%/CITTADINANZA%' then
        w_descrizione := replace(w_descrizione,'/CIT','/CITTADINANZA');
     elsif w_descrizione like '%/ CIT%' and w_descrizione not like '%/ CITTADINANZA%' then
        w_descrizione := replace(w_descrizione,'/ CIT','/CITTADINANZA');
     elsif w_descrizione like '%CIT/%' then
        w_descrizione := replace(w_descrizione,'CIT/','CITTADINANZA/');
     elsif w_descrizione like '%CIT /%' then
        w_descrizione := replace(w_descrizione,'CIT /','CITTADINANZA/');
     end if;
     if w_descrizione like '%/NAS%' and w_descrizione not like '%/NASCITA%' then
        w_descrizione := replace(w_descrizione,'/NAS','/NASCITA');
     elsif w_descrizione like '%/ NAS%' and w_descrizione not like '%/ NASCITA%' then
        w_descrizione := replace(w_descrizione,'/ NAS','/NASCITA');
     elsif w_descrizione like '%NAS/%' then
        w_descrizione := replace(w_descrizione,'NAS/','NASCITA/');
     elsif w_descrizione like '%NAS /%' then
        w_descrizione := replace(w_descrizione,'NAS /','NASCITA/');
     end if;
     if w_descrizione like '%/SFA%' then
        w_descrizione := replace(w_descrizione,'/SFA','/STATO DI FAMIGLIA');
     elsif w_descrizione like '%/ SFA%' then
        w_descrizione := replace(w_descrizione,'/ SFA','/STATO DI FAMIGLIA');
     elsif w_descrizione like '%SFA/%' then
        w_descrizione := replace(w_descrizione,'SFA/','STATO DI FAMIGLIA/');
     elsif w_descrizione like '%SFA /%' then
        w_descrizione := replace(w_descrizione,'SFA /','STATO DI FAMIGLIA/');
     elsif w_descrizione like '%/STATO FAM%' then
        w_descrizione := replace(w_descrizione,'/STATO FAM','/STATO DI FAMIGLIA');
     elsif w_descrizione like '%/ STATO FAM%' then
        w_descrizione := replace(w_descrizione,'/ STATO FAM','/STATO DI FAMIGLIA');
     elsif w_descrizione like '%STATO FAM/%' then
        w_descrizione := replace(w_descrizione,'STATO FAM/','STATO DI FAMIGLIA/');
     elsif w_descrizione like '%STATO FAM /%' then
        w_descrizione := replace(w_descrizione,'STATO FAM /','STATO DI FAMIGLIA/');
     elsif w_descrizione like '%/FAM%' and w_descrizione not like '%/FAMIGLIA%' then
        w_descrizione := replace(w_descrizione,'/FAM','/STATO DI FAMIGLIA');
     elsif w_descrizione like '%/ FAM%' and w_descrizione not like '%/ FAMIGLIA%' then
        w_descrizione := replace(w_descrizione,'/ FAM','/STATO DI FAMIGLIA');
     elsif w_descrizione like '%FAM/%' then
        w_descrizione := replace(w_descrizione,'FAM/','STATO DI FAMIGLIA/');
     elsif w_descrizione like '%FAM /%' then
        w_descrizione := replace(w_descrizione,'FAM /','STATO DI FAMIGLIA/');
     end if;
     if w_descrizione like '%/DIR.POL%' then
        w_descrizione := replace(w_descrizione,'/DIR.POL','/DIRITTI POLITICI');
     elsif w_descrizione like '%/ DIR.POL%' then
        w_descrizione := replace(w_descrizione,'/ DIR.POL','/DIRITTI POLITICI');
     elsif w_descrizione like '%DIR.POL/%' then
        w_descrizione := replace(w_descrizione,'DIR.POL/','DIRITTI POLITICI/');
     elsif w_descrizione like '%DIR.POL /%' then
        w_descrizione := replace(w_descrizione,'DIR.POL /','DIRITTI POLITICI/');
     end if;
     if w_descrizione like '%/ST.CIV%' then
        w_descrizione := replace(w_descrizione,'/ST.CIV','/STATO CIVILE');
     elsif w_descrizione like '%/ ST.CIV%' then
        w_descrizione := replace(w_descrizione,'/ ST.CIV','/STATO CIVILE');
     elsif w_descrizione like '%ST.CIV/%' then
        w_descrizione := replace(w_descrizione,'ST.CIV/','STATO CIVILE/');
     elsif w_descrizione like '%ST.CIV /%' then
        w_descrizione := replace(w_descrizione,'ST.CIV /','STATO CIVILE/');
     elsif w_descrizione like '%/CIV%' then
        w_descrizione := replace(w_descrizione,'/CIV','/STATO CIVILE');
     elsif w_descrizione like '%/ CIV%' then
        w_descrizione := replace(w_descrizione,'/ CIV','/STATO CIVILE');
     elsif w_descrizione like '%CIV/%' then
        w_descrizione := replace(w_descrizione,'CIV/','STATO CIVILE/');
     elsif w_descrizione like '%CIV /%' then
        w_descrizione := replace(w_descrizione,'CIV /','STATO CIVILE/');
     end if;
     if w_descrizione like '%/BCO%' then
        w_descrizione := replace(w_descrizione,'/BCO','/BUONA CONDOTTA');
     elsif w_descrizione like '%/ BCO%' then
        w_descrizione := replace(w_descrizione,'/ BCO','/BUONA CONDOTTA');
     elsif w_descrizione like '%BCO/%' then
        w_descrizione := replace(w_descrizione,'BCO/','BUONA CONDOTTA/');
     elsif w_descrizione like '%BCO /%' then
        w_descrizione := replace(w_descrizione,'BCO /','BUONA CONDOTTA/');
     end if;
     if w_descrizione like '%/CGP%' then
        w_descrizione := replace(w_descrizione,'/CGP','/GODIMENTO DIRITTI POLITICI');
     elsif w_descrizione like '%/ CGP%' then
        w_descrizione := replace(w_descrizione,'/ CGP','/GODIMENTO DIRITTI POLITICI');
     elsif w_descrizione like '%CGP/%' then
        w_descrizione := replace(w_descrizione,'CGP/','GODIMENTO DIRITTI POLITICI/');
     elsif w_descrizione like '%CGP /%' then
        w_descrizione := replace(w_descrizione,'CGP /','GODIMENTO DIRITTI POLITICI/');
     end if;
     if w_descrizione like '%/CIL%' then
        w_descrizione := replace(w_descrizione,'/CIL','/ISCRIZIONE LISTE ELETTORALI');
     elsif w_descrizione like '%/ CIL%' then
        w_descrizione := replace(w_descrizione,'/ CIL','/ISCRIZIONE LISTE ELETTORALI');
     elsif w_descrizione like '%CIL/%' then
        w_descrizione := replace(w_descrizione,'CIL/','ISCRIZIONE LISTE ELETTORALI/');
     elsif w_descrizione like '%CIL /%' then
        w_descrizione := replace(w_descrizione,'CIL /','ISCRIZIONE LISTE ELETTORALI/');
     end if;
     if w_descrizione like '%[STR]%' then
        w_descrizione := replace(w_descrizione,'[STR]','');
     end if;
  end if;

  w_descrizione := replace(w_descrizione,'/',' / ');
  w_descrizione := replace(w_descrizione,'  ',' ');
  w_descrizione := ltrim(rtrim(w_descrizione));
  return w_descrizione;

exception
  when errore then
       return a_descrizione;
  when others then
       w_errore := 'errore ('||sqlerrm||')';
       return a_descrizione;
end;
/
