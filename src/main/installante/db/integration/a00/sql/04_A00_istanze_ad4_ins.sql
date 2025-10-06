--liquibase formatted sql
--changeset amonopoli:202503251155_4 runOnChangefalse stripCommentsfalse
DECLARE
cursor c_amb is
      select ambiente,
             ente,
             gruppo_ling,
             descrizione,
             user_oracle,
             password,
             dislocazione
        from A_ISTANZE_AMBIENTE
      ;
cursor c_usr is
      select utente,
             nominativo
        from A_UTENTI
     ;
cursor c_ver_inst (var_usr varchar2, var_prog varchar2) is
      select versione, installazione
        from ad4_istanze
       where user_oracle = var_usr
         and progetto = var_prog
      ;
v_max_progetto varchar2(8);
v_ver_inst     c_ver_inst%rowtype;
BEGIN
   insert into ad4_progetti(progetto, descrizione)
   select 'SI4','Sistema Informativo Versione 4'
     from dual
    where not exists (select 1
                        from ad4_progetti
                       where progetto = 'SI4')
   ;
   insert into ad4_istanze (istanza, progetto, ente, descrizione, user_oracle, password_oracle,
                            dislocazione, versione)
   select 'SI3', 'SI4', 'ENTE', 'Istanza Sistema Informativo V3', isam.user_oracle, isam.password,
          'C:\SI4\AD4', max(versione)
     from a_istanze_ambiente isam
    where isam.user_oracle = 'A00'
      and not exists (select 1
                        from ad4_istanze
                       where istanza = 'SI3')
    group by isam.user_oracle,isam.password
   ;
   insert into ad4_moduli (modulo, descrizione, progetto)
   select 'SI4_V3','Sistema Informativo V4 Serie3','SI4'
     from dual
    where not exists ( select 'x'
                         from ad4_moduli
                        where modulo = 'SI4_V3'
                     )
   ;
/* Insert into AD4_DIRITTI_ACCESSO */
   for v_usr in c_usr loop
      insert into ad4_diritti_accesso (UTENTE, MODULO, ISTANZA, RUOLO)
      select v_usr.utente,'SI4_V3','SI3','AMM'
        from dual
       where not exists ( select 'x'
                            from ad4_diritti_accesso 
                           where utente  = v_usr.utente
                             and modulo  = 'SI4_V3'
                             and istanza = 'SI3')
         and exists ( select 'x'
                        from ad4_utenti
                       where utente = v_usr.utente
                         and nominativo = v_usr.nominativo)
       ;
   end loop;
/* Insert into AD4_ISTANZE */
   for v_amb in c_amb loop
	/* Insert into AD4_ENTI */
      insert into ad4_enti (ente, descrizione)
      select ente,descrizione
        from a_enti
       where ente = v_amb.ente
         and not exists (select 'x'
                              from ad4_enti
                             where ente = v_amb.ente
                           )
      ;
      insert into ad4_progetti (progetto,descrizione)
      select v_amb.ambiente,v_amb.descrizione
        from dual
       where not exists (select 'x'
                           from ad4_progetti
                          where progetto = v_amb.ambiente)
      ;
      insert into ad4_istanze ( istanza, progetto, ente, descrizione, user_oracle, password_oracle
                              , dislocazione,versione)
      select v_amb.ambiente||v_amb.ente||v_amb.gruppo_ling, v_amb.ambiente, v_amb.ente,
             v_amb.descrizione,v_amb.user_oracle, v_amb.password, v_amb.dislocazione, '3.0'
        from dual
       where not exists (select 'x'
                           from ad4_istanze
                          where istanza = v_amb.ambiente||v_amb.ente||v_amb.gruppo_ling
                        )
      ;
/* Insert into AD4_DIRITTI_ACCESSO */
      insert into ad4_diritti_accesso (utente, modulo, istanza,ruolo)
      select 'AD4', '*', v_amb.ambiente||v_amb.ente||v_amb.gruppo_ling,'AMM'
        from dual
       where not exists (select 'x' from ad4_diritti_accesso
                          where utente = 'AD4'
                            and istanza = v_amb.ambiente||v_amb.ente||v_amb.gruppo_ling)
      ;
   end loop;
commit;
 EXCEPTION
  WHEN OTHERS THEN
   rollback;
   raise;
END;
/
