--liquibase formatted sql
--changeset amonopoli:202309141000 runOnChange:true stripComments:false
update civtfa tfa
   set testo_4000 = 'Il bambino medesimo e'' gemello con altri <PARTO_PLURIMO_ALTRI_GEMELLI> ai quali si riferiscono <PARTO_PLURIMO_ATTI_PREC> ed e'' il <PARTO_PLURIMO_ORDINALE> ed ultimo nato, come mi ha attestato il dichiarante'
 where formula           = '39'
   and riga              = 1
/
