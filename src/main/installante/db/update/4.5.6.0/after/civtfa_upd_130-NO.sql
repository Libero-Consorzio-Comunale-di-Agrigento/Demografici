--liquibase formatted sql
--changeset amonopoli:202305261455 runOnChange:true stripComments:false
update civtfa tfa
   set testo_4000 = '#1 #2 e'' stata #3 con sentenza del #4 in data #5 #6'
 where formula           = '130-NO-MT'
   and riga              = 1
   and rtrim(testo_4000) = '#1 e'' #2 #3 con sentenza del #4 in data #5 #6'
   and exists (select 1 from civnfa nfa
                where nfa.formula = tfa.formula
                  and nfa.variabile = 1
                  and nfa.testo_var = '<COGNOME_MADRE>')
/
update civtfa tfa
   set testo_4000 = '#1 #2 e'' stato #3 con sentenza del #4 in data #5 #6'
 where formula           = '130-NO-PT'
   and riga              = 1
   and rtrim(testo_4000) = '#1 e'' #2 #3 con sentenza del #4 in data #5 #6'
   and exists (select 1 from civnfa nfa
                where nfa.formula = tfa.formula
                  and nfa.variabile = 1
                  and nfa.testo_var = '<COGNOME_PADRE>')
/
