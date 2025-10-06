--liquibase formatted sql
--changeset amonopoli:202503101300 runOnChange:true stripComments:false
create or replace trigger ANAEVE_TIU
before INSERT
    or UPDATE
on ANAEVE
for each row
declare
   integrity_error  exception;
   errno            integer;
   errmsg           char(200);
   dummy            integer;
   found            boolean;
begin
   begin  -- Check DATA Integrity on INSERT or UPDATE
     :new.cod_fam_unique       := nvl(:new.cod_fam_unique,f_ANA_get_cod_fam_unique(:new.cod_mov,:new.cod_fam));

     :new.civico_esterno := f_civico_esterno(:new.cod_via
					     ,:new.num_civ
					     ,:new.suffisso
					     ,:new.scala
					     ,:new.piano
					     ,:new.interno
					     ,:new.sub_interno);
     :new.civico_interno := f_civico_interno(:new.cod_via
					     ,:new.num_civ
					     ,:new.suffisso
					     ,:new.scala
					     ,:new.piano
					     ,:new.interno
					     ,:new.sub_interno);

     if INSERTING then
        if :new.data_inizio is null and :new.d_data_inizio is not null then
	     :new.data_inizio := to_number(to_char(:new.d_data_inizio,'j'));
        end if;
        if :new.d_data_inizio is null and :new.data_inizio is not null then
	     :new.d_data_inizio := to_date(:new.data_inizio,'j');
        end if;
        if :new.data_eve is null and :new.d_data_eve is not null then
	     :new.data_eve := to_number(to_char(:new.d_data_eve,'j'));
        end if;
        if :new.d_data_eve is null and :new.data_eve is not null then
	     :new.d_data_eve	:= to_date(:new.data_eve,'j');
        end if;
        if :new.data_reg is null and :new.d_data_reg is not null then
	     :new.data_reg := to_number(to_char(:new.d_data_reg,'j'));
        end if;
        if :new.d_data_reg is null and :new.data_reg is not null then
	     :new.d_data_reg := to_date(:new.data_reg,'j');
        end if;
        if :new.data_ric is null and :new.d_data_ric is not null then
	     :new.data_ric := to_number(to_char(:new.d_data_ric,'j'));
        end if;
        if :new.d_data_ric is null and :new.data_ric is not null then
	     :new.d_data_ric	:= to_date(:new.data_ric,'j');
        end if;
     end if;

     if UPDATING then
	  if nvl(:new.data_inizio, 0) != nvl(:old.data_inizio, 0) then
	     :new.d_data_inizio := to_date(:new.data_inizio,'j');
	  end if;
	  if nvl(trunc(:new.d_data_inizio), to_date('01/01/1800','dd/mm/yyyy')) !=
	     nvl(trunc(:old.d_data_inizio), to_date('01/01/1800','dd/mm/yyyy')) 
          then
	     :new.data_inizio := to_char(:new.d_data_inizio,'j');
	  end if;
	  if nvl(:new.data_eve, 0) != nvl(:old.data_eve, 0) then
	     :new.d_data_eve := to_date(:new.data_eve,'j');
	  end if;
	  if nvl(trunc(:new.d_data_eve), to_date('01/01/1800','dd/mm/yyyy')) !=
	     nvl(trunc(:old.d_data_eve), to_date('01/01/1800','dd/mm/yyyy')) 
          then
	     :new.data_eve := to_char(:new.d_data_eve,'j');
	  end if;
	  if nvl(:new.data_reg, 0) != nvl(:old.data_reg, 0) then
	     :new.d_data_reg := to_date(:new.data_reg,'j');
	  end if;
	  if nvl(trunc(:new.d_data_reg), to_date('01/01/1800','dd/mm/yyyy')) !=
	     nvl(trunc(:old.d_data_reg), to_date('01/01/1800','dd/mm/yyyy')) 
          then
	     :new.data_reg := to_char(:new.d_data_reg,'j');
	  end if;
	  if nvl(:new.data_ric, 0) != nvl(:old.data_ric, 0) then
	     :new.d_data_ric := to_date(:new.data_ric,'j');
	  end if;
	  if nvl(trunc(:new.d_data_ric), to_date('01/01/1800','dd/mm/yyyy')) !=
	     nvl(trunc(:old.d_data_ric), to_date('01/01/1800','dd/mm/yyyy')) 
          then
	     :new.data_ric := to_char(:new.d_data_ric,'j');
	  end if;
     end if;
   end;

exception
   when integrity_error then
        IntegrityPackage.InitNestLevel;
        raise_application_error(errno, errmsg);
   when others then
        IntegrityPackage.InitNestLevel;
        raise;
end;
/
