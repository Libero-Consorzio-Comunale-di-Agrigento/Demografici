--liquibase formatted sql
--changeset amonopoli:202503261115_1 runOnChange:false stripComments:false
CREATE OR REPLACE TRIGGER A_ISTANZE_AMBIENTE_AD4_TIU
before INSERT or UPDATE
on A_ISTANZE_AMBIENTE
for each row
declare
   cursor cpk_istanze(var_usr varchar) is
          select max(progetto) progetto
            from AD4_ISTANZE
           where user_oracle = var_usr
           group by user_oracle;
   cursor c_ver_inst(var_usr varchar, var_prog varchar) is
          select installazione, versione
            from AD4_ISTANZE
           where user_oracle = var_usr
             and progetto    = var_prog;
   v_ver_inst       c_ver_inst%rowtype;
   v_progetto       varchar2(8);
   found            boolean;
begin
   if INSERTING then
      begin
         if :new.ambiente is not null then
            open  cpk_istanze(:new.user_oracle);
            fetch cpk_istanze into v_progetto;
            found := cpk_istanze%FOUND;
            close cpk_istanze;
            if found then
               open c_ver_inst(:new.user_oracle, v_progetto);
               fetch c_ver_inst into v_ver_inst;
               close c_ver_inst;
               if ad4_istanze_tpk.EXISTS_ID(:new.ambiente||:new.ente||:new.gruppo_ling) = 0 then
                  ad4_istanze_tpk.ins ( p_istanza => :new.ambiente||:new.ente||:new.gruppo_ling
                                      , p_progetto => v_progetto
                                      , p_ente => :new.ente
                                      , p_descrizione => :new.descrizione
                                      , p_user_oracle => :new.user_oracle
                                      , p_password_oracle => :new.password
                                      , p_dislocazione => :new.dislocazione
                                      , p_versione => v_ver_inst.versione
                                      , p_installazione => v_ver_inst.installazione
                                      );
               end if;                                                   
            else
               if ad4_progetti_tpk.exists_id(:new.ambiente) = 0 then
                  ad4_progetti_tpk.ins( p_progetto => :new.ambiente
                                      , p_descrizione => :new.descrizione
                                      );               
               end if;     
               if ad4_istanze_tpk.EXISTS_ID(:new.ambiente||:new.ente||:new.gruppo_ling) = 0 then
                  ad4_istanze_tpk.ins ( p_istanza => :new.ambiente||:new.ente||:new.gruppo_ling
                                      , p_progetto => :new.ambiente
                                      , p_ente => :new.ente
                                      , p_descrizione => :new.descrizione
                                      , p_user_oracle => :new.user_oracle
                                      , p_password_oracle => :new.password
                                      , p_dislocazione => :new.dislocazione
                                      , p_versione => '3.0'
                                      );               
               end if;
            end if;
            
            if ad4_diritti_accesso_tpk.EXISTS_ID('AD4', '*', :new.ambiente||:new.ente||:new.gruppo_ling) = 0 then                                                              
               ad4_diritti_accesso_tpk.ins ( p_utente => 'AD4'
                                           , p_modulo => '*'
                                           , p_istanza => :new.ambiente||:new.ente||:new.gruppo_ling
                                           , p_ruolo => 'AMM'
                                           );                                                              
            end if;
         end if;
      end;
   end if;
   if UPDATING then      
      ad4_progetti_tpk.upd_column(:old.ambiente, 'PROGETTO', :new.ambiente);
      ad4_progetti_tpk.upd_column(:old.ambiente, 'DESCRIZIONE', :new.descrizione);
      
      ad4_istanze_tpk.upd_column(p_istanza => :old.ambiente||:old.ente||:old.gruppo_ling, p_column => 'ISTANZA', p_value => :new.ambiente||:new.ente||:new.gruppo_ling);
      ad4_istanze_tpk.upd_column(p_istanza => :new.ambiente||:new.ente||:new.gruppo_ling, p_column => 'PROGETTO', p_value => :new.ambiente);
      ad4_istanze_tpk.upd_column(p_istanza => :new.ambiente||:new.ente||:new.gruppo_ling, p_column => 'ENTE', p_value => :new.ente);
      ad4_istanze_tpk.upd_column(p_istanza => :new.ambiente||:new.ente||:new.gruppo_ling, p_column => 'DESCRIZIONE', p_value => :new.descrizione);    
      ad4_istanze_tpk.upd_column(p_istanza => :new.ambiente||:new.ente||:new.gruppo_ling, p_column => 'USER_ORACLE', p_value => :new.user_oracle);
      ad4_istanze_tpk.upd_column(p_istanza => :new.ambiente||:new.ente||:new.gruppo_ling, p_column => 'PASSWORD_ORACLE', p_value => :new.password); 
      ad4_istanze_tpk.upd_column(p_istanza => :new.ambiente||:new.ente||:new.gruppo_ling, p_column => 'DISLOCAZIONE', p_value => :new.dislocazione);     

      for diri in (select *
                     from ad4_diritti_accesso
                    where istanza = :old.ambiente||:old.ente||:old.gruppo_ling)
      loop
         ad4_diritti_accesso_tpk.upd_column(diri.utente, diri.modulo, diri.istanza, 'ISTANZA', :new.ambiente||:new.ente||:new.gruppo_ling);
       end loop;       
   end if;
end;
/* End Trigger: A_ISTANZE_AMBIENTE_AD4_TIU */
/ 
