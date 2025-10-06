--liquibase formatted sql
--changeset amonopoli:202306211055_2 runOnChange:true stripComments:false
insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 1, 'avvocato 1', null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 1);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 2, 'avvocato 2', null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 2);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 3, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 3);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 4, 'numero dell''atto di conferma', null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 4);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 5, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 5);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 6, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 6);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 7, 'scioglimento/cessazione degli effetti civili', null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 7);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 8, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 8);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 9, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 9);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 10, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 10);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 11, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 11);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 12, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 12);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 13, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 13);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 14, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 14);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 15, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 15);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 16, null, null, null, null, null,  null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 16);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 17, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 17);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 18, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 18);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 19, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 19);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 20, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 20);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 21, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 21);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 22, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 22);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 23, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 23);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 24, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 24);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 25, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 25);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 26, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 26);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 27, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 27);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 28, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 28);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 29, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 29);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
select '175-SEXIES', 30, null, null, null, null, null, null, null
  from dual
 where not exists (select 'x' from civnfa b
                    where b.formula   = '175-SEXIES'
                      and b.variabile = 30);
