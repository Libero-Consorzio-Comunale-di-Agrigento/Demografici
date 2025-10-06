--liquibase formatted sql
--changeset amonopoli:202506181505 runOnChange:true stripComments:false
declare
w_not_exists_mi		number;

w_ID_CIVDMI		number;
w_TIPO_ATTO             number := 1;
w_COD_MI		number;
w_DESCRIZIONE		varchar2(40);
w_DESCRIZIONE_ESTESA	varchar2(2000);
w_ID_CIVCTA		number := 102;
w_TIPO_RICHIESTA        varchar2(255) := 'DIC';
w_COD_RIGA		number := 1;
w_RIGA_CLOB		clob; 

w_conta_mi		number := 0;

begin
  for i in 1..99 loop
      w_not_exists_mi := 0;
      begin
        select 1 into w_not_exists_mi
          from dual
         where not exists (select 1 from civdmi dmi
                            where tipo_atto = 1
                              and cod_mi    = i)
           and not exists (select 1 from civism ism
                            where tipo_atto = 1
                              and cod_mi    = i)
        ;
      exception
        when others then
             w_not_exists_mi := 0;
      end;

      if w_not_exists_mi = 1 then
         w_conta_mi  := w_conta_mi + 1;
         w_cod_mi    := i;
         w_id_civdmi := f_civdmi_nr('');

         if w_conta_mi = 3 then
            w_descrizione := '85 - RIACQUISTO (DL 36/2025)';
            w_descrizione_estesa := 'Formula 85 - Adattata per la dichiarazione resa da cittadino italiano che, avendo perduto la cittadinanza italiana, intende riacquistarla (art. 1-ter, comma 1, lettera b) del decreto-legge n. 36/2025, come convertito dalla legge n. 74/2025 che ha riformulato l''art. 17 della legge 5 febbraio 1992, n. 91), da presentarsi tra il 1  luglio 2025 e il 31 dicembre 2027.';
            w_riga_clob := 'Oggi <giorno_oggi> del mese di <mese_oggi> dell''anno duemila<anno_oggi> alle ore <ore_oggi> e <minuti_oggi> avanti a me <UFFICIALE_UTENTE>, Ufficiale dello stato civile del Comune di <COMUNE>,  (indicare se nella funzione di sindaco o di chi lo sostituisce o per delega avuta), e'' comparso/a <COGNOME_NOME>  nato/a a <COMUNE_NASCITA> il <DATA_NASCITA>, cittadino/a <NAZIONALITA> (indicare le complete generalita'') il/la quale mi ha esposto di aver perduto la cittadinanza italiana prima del 15 agosto 1992 (in applicazione dell''art. 8, n. 1 e n. 2, o dell''articolo 12 della legge n. 555 del 1912) per ... (specificare le ragioni della perdita: naturalizzazione in Paese straniero, rinuncia alla cittadinanza a seguito di involontario acquisto di cittadinanza straniera, figli minori conviventi di genitore che ha perso la cittadinanza) e ora dichiara di volerla riacquistare. 
A tal fine mi ha prodotto (ovvero: e/o ho acquisito; ovvero: e/o ho visionato) i seguenti documenti:
(elencarli: l''atto di nascita, gli atti relativi alla perdita della cittadinanza, ecc.). 
Poiche'' quanto mi e'' stato esposto risulta dai documenti suindicati, ho ricevuto tale dichiarazione. I documenti prodotti (e/o acquisiti), muniti del mio visto, inserisco nel volume degli allegati a questo registro.
Il presente atto viene letto all''intervenuto, il quale insieme con me lo sottoscrive.
Il/Ia dichiarante ______________________________
L''Ufficiale dello stato civile ______________________________';

         elsif w_conta_mi = 2 then
            w_descrizione := '79 - ACQUISTO (DL 36/2025 - All. B)';
            w_descrizione_estesa := 'Formula 79 - Adattata per la dichiarazione di volonta'' d''acquisto della cittadinanza italiana presentata dai genitori o dal tutore di minore alla data di entrata in vigore della legge di conversione n. 74/2025 del decreto legge n. 36/2025, figlio di cittadini italiani per nascita di cui all''art. 3-bis, comma 1, lett. a), a-bis) e b) della legge 5 febbraio 1992, n. 91 (art. 1, comma 1-ter, del decreto-legge n. 36/2025, come convertito dalla legge n. 74/2025) da presentarsi entro il 31 maggio 2026 ';
            w_riga_clob := 'Oggi <giorno_oggi> del mese di <mese_oggi> dell''anno duemila<anno_oggi> alle ore <ore_oggi> e <minuti_oggi> avanti a me <UFFICIALE_UTENTE> Ufficiale dello stato civile del Comune di <COMUNE>, (indicare se nella funzione di sindaco o di chi lo sostituisce o per delega avuta), sono/e'' comparsi/o/a <COGNOME_RICHIEDENTE>  (indicare le complete generalita'' dei/l dichiaranti/e) i/il/la quali/e mi hanno/ha esposto di essere <COGNOME_PADRE> <NOME_PADRE> nato il <DATA_NASCITA_PADRE> a <COMUNE_NASCITA_PADRE> <COGNOME_MADRE> (genitori/e o tutori/e) del minore <COGNOME_NOME>  nato/a a <COMUNE_NASCITA> il <DATA_NASCITA>, cittadino/a <NAZIONALITA> (cittadinanza straniera posseduta dal minore), che ______________________________ (nome e cognome, data e luogo di nascita), genitori/e del suddetto minore, sono/e'' cittadini/o italiani/o per nascita e si trovano/trova in una delle condizioni di cui all''art. 3-bis, comma 1, lett.a), a-bis) e b) della legge 5 febbraio 1992, n. 91 e dichiarano/dichiara la volonta'' che il predetto minore acquisti la cittadinanza italiana.
Al tal fine mi hanno/ha prodotto (alternative: ho acquisito e/o ho visionato) i seguenti documenti:
l''atto di nascita del minore; 
il certificato di cittadinanza straniera o il riconoscimento dello status di apolide del minore; 
l''atto di nascita dei/l genitori/e cittadini/o per nascita (oppure il certificato di cittadinanza italiana per nascita dei/l genitori/e); 
(eventuale) documentazione aggiuntiva comprovante che i genitori/uno dei genitori sono/e'' cittadini/o italiani/o ai sensi dell''articolo 3-bis, comma 1 lettere a), a-bis) o b), della legge 5 febbraio 1992, n. 91; 
(eventuale)  documentazione aggiuntiva relativa al riconoscimento in cui e'' stabilita la filiazione;
(eventuale) documentazione comprovante la qualita'' di tutore o la condizione di unico genitore del minore.
Poiche'' quanto mi e'' stato esposto risulta dai documenti suindicati, ho ricevuto tale dichiarazione.
I documenti prodotti (e/o acquisiti), muniti del mio visto, inserisco nel volume degli allegati a questo registro.
I/il/la dichiaranti/e ____________________________
L''Ufficiale dello stato civile ____________________________';

         elsif w_conta_mi = 1 then
            w_descrizione := '79 - ACQUISTO - (DL 36/2025 - All. A)';
            w_descrizione_estesa := 'Formula 79 - Adattata per la dichiarazione di volonta'' d''acquisto della cittadinanza italiana presentata dai genitori o dal tutore di minore straniero o apolide, che successivamente risiede legalmente per almeno due anni continuativi in Italia, e per la dichiarazione di volonta'' d''acquisto della cittadinanza italiana presentata dai genitori o dal tutore di minore straniero o apolide entro un anno dalla nascita del minore o dalla data successiva in cui e'' stabilita la filiazione, anche adottiva, da cittadino italiano per nascita (articolo 4, comma 1-bis, lettere a) e b), della legge n. 91/1992)';
            w_riga_clob := 'Oggi <giorno_oggi> del mese di <mese_oggi> dell''anno duemila<anno_oggi> alle ore <ore_oggi> e <minuti_oggi> avanti a me <UFFICIALE_UTENTE> Ufficiale dello stato civile del Comune di <COMUNE>, (indicare se nella funzione di sindaco o di chi lo sostituisce o per delega avuta), sono/e'' comparsi/o/a <COGNOME_RICHIEDENTE>, (indicare le complete generalita'' dei/l ichiaranti/e) i/il/la quali/e mi hanno/ha esposto di essere <COGNOME_PADRE> <NOME_PADRE> nato il <DATA_NASCITA_PADRE> a <COMUNE_NASCITA_PADRE> <COGNOME_MADRE>(genitori/e o tutori/e) del minore <COGNOME_NOME>  nato/a a <COMUNE_NASCITA> il <DATA_NASCITA>, cittadino/a <NAZIONALITA>  (cittadinanza straniera posseduta dal minore), che <COGNOME_PADRE> <COGNOME_PADRE> <NOME_PADRE> nato il <DATA_NASCITA_PADRE> a <COMUNE_NASCITA_PADRE> <COGNOME_MADRE> <NOME_MADRE> nata il <DATA_NASCITA_MADRE> a <COMUNE_NASCITA_MADRE> (nome e cognome, data e luogo di nascita), genitori/e del suddetto minore, sono/e'' cittadini/o italiani/o per nascita, che la filiazione del suddetto minore da genitori/e cittadini/o italiani/o e'' stata stabilita in data ______________________________ mediante (dichiarazione di nascita, riconoscimento di filiazione, dichiarazione giudiziale di filiazione, adozione durante la minore eta''), e dichiarano/dichiara la volonta'' che il predetto minore acquisti la cittadinanza italiana.
Al tal fine mi hanno/ha prodotto (alternative: ho acquisito e/o ho visionato) i seguenti documenti: 
l''atto di nascita del minore; 
il certificato di cittadinanza straniera o il riconoscimento dello status di apolide del minore; 
l''atto di nascita dei/l genitori/e cittadini/o per nascita (oppure il certificato di cittadinanza italiana per nascita dei/l genitori/e); 
(eventuale) documentazione aggiuntiva relativa al riconoscimento in cui e'' stabilita la filiazione o il provvedimento di adozione; 
(eventuale) documentazione comprovante la qualita'' di tutore o la condizione di unico genitore del minore.
Poiche'' quanto mi e'' stato esposto risulta dai documenti suindicati, ho ricevuto tale dichiarazione. 
I documenti prodotti (e/o acquisiti), muniti del mio visto, inserisco nel volume degli allegati a questo registro.
I/il/la dichiaranti/e ______________________________
L''Ufficiale dello stato civile ______________________________';

         else
            exit;
         end if; --if w_conta_mi = 3 then

         begin
           insert into civism
                  (ID, TIPO_ATTO, COD_MI, COD_RIGA, RIGA_CLOB, ID_CIVDMI)
           select to_number(null), w_tipo_atto, w_cod_mi, w_cod_riga, w_riga_clob, w_id_civdmi
             from dual
            where not exists (select 1 from civdmi b
                               where b.tipo_atto = w_tipo_atto
                                 and b.descrizione = w_descrizione)
           ;
           insert into civdmi
                  (ID, TIPO_ATTO, COD_MI, DESCRIZIONE, DESCRIZIONE_ESTESA, ID_CIVCTA, TIPO_RICHIESTA)
           select w_id_civdmi, w_tipo_atto, w_cod_mi, w_descrizione, w_descrizione_estesa, w_id_civcta, w_tipo_richiesta
             from dual
            where not exists (select 1 from civdmi b
                               where b.tipo_atto = w_tipo_atto
                                 and b.descrizione = w_descrizione)
           ;
         exception
           when others then
                null;
         end;
      end if; --if w_not_exists_mi = 1 then
  end loop;
end;
/

