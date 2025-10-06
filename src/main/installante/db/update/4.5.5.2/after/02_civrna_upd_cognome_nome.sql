--liquibase formatted sql
--changeset snocca:202211181343
update civrna
   set cognome    = nvl(cognome,f_cognome(cognome_nome))
     , nome       = nvl(nome,f_nome(cognome_nome))
     , cognome_pd = nvl(cognome_pd,f_cognome_pd('',paternita,cognome_nome))
     , nome_pd    = nvl(nome_pd,f_nome_pd('',paternita,cognome_nome))
     , cognome_md = nvl(cognome_md,f_cognome_md('',maternita))
     , nome_md    = nvl(nome_md,f_nome_md('',maternita))
/
