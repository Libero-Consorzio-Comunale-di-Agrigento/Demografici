--liquibase formatted sql
--changeset amonopoli:202402211720_3 runOnChange:true stripComments:false
delete civnfa
 where formula in ('MAT-TR1-AN','MAT-TR2-AN','MOR-TR1-AN','NAS-TR1-AN');

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('NAS-TR1-AN', 1, 'comune residenza', null, null, '<COMUNE_RESIDENZA>', null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('NAS-TR1-AN', 2, 'numero atto trascritto', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('NAS-TR1-AN', 4, 'serie atto trascritto', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('NAS-TR1-AN', 5, 'anno atto trascritto', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('NAS-TR1-AN', 6, 'data comunicazione', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('NAS-TR1-AN', 7, null, null, null, '<COMUNE_DATA>', null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MAT-TR1-AN', 1, 'comune residenza sposo', null, null, '<COMUNE_RESIDENZA_SPOSO>', null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MAT-TR1-AN', 2, 'numero atto trascritto', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MAT-TR1-AN', 4, 'serie atto trascritto', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MAT-TR1-AN', 5, 'anno atto trascritto', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MAT-TR1-AN', 6, 'data comunicazione', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MAT-TR1-AN', 7, 'numero comunicazione', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MAT-TR1-AN', 8, null, null, null, '<COMUNE_DATA>', null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MAT-TR2-AN', 1, 'comune residenza sposa', null, null, '<COMUNE_RESIDENZA_SPOSA>', null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MAT-TR2-AN', 2, 'numero atto trascritto', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MAT-TR2-AN', 4, 'serie atto trascritto', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MAT-TR2-AN', 5, 'anno atto trascritto', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MAT-TR2-AN', 6, 'data comunicazione', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MAT-TR2-AN', 7, 'numero comunicazione', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MAT-TR2-AN', 8, null, null, null, '<COMUNE_DATA>', null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MOR-TR1-AN', 1, 'comune residenza', null, null, '<COMUNE_RESIDENZA>', null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MOR-TR1-AN', 2, 'numero atto trascritto', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MOR-TR1-AN', 4, 'serie atto trascritto', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MOR-TR1-AN', 5, 'anno atto trascritto', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MOR-TR1-AN', 6, 'data comunicazione', null, null, null, null, null, null);

insert into civnfa (FORMULA, VARIABILE, NOTE, TESTO_M, TESTO_F, TESTO_VAR, ID, TESTO_AUTO, TESTO_VAR_AUTO)
values ('MOR-TR1-AN', 7, null, null, null, '<COMUNE_DATA>', null, null, null);
