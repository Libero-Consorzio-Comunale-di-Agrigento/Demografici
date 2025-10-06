package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ISoggettoRecupero1
import it.finmatica.de4gsdzk.ISoggettoRecupero2
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeService
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import restrict.AbstractSelectViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class AbstractRecuperoSelectViewModel extends AbstractSelectViewModel{

    ETipoAtto tipoAttoEnum

    @WireVariable
    private ArcComuneBaseService arcComuneBaseService

    @WireVariable
    private AnaAnagrafeService anaAnagrafeService

    String checkAnagrafe1(ISoggettoRecupero1 sr){
        String s = ""
        if (sr.idAnagrafe1 == null){
            if (arcComuneBaseService.isComuneClienteOggi(sr.codiceComuneResidenza1, sr.codiceProvinciaResidenza1)){
                //Se il soggetto è residente, segnalo che la matricola è nulla e che quindi il soggetto dovrebbe essere ripescato
                switch (tipoAttoEnum) {
                    case ETipoAtto.MAT:
                        s = getEtichetta(EtichetteMessaggi.Warn_Matricola_Sposo_nulla) + "\n" + getEtichetta(EtichetteMessaggi.Warn_ricerca_in_anagrafe)
                        break
                    case ETipoAtto.UCI:
                        s = getEtichetta(EtichetteMessaggi.Warn_Matricola_Contraente_1_nulla) + "\n" + getEtichetta(EtichetteMessaggi.Warn_ricerca_in_anagrafe)
                        break
                    case ETipoAtto.CIT:
                        s = getEtichetta(EtichetteMessaggi.Warn_Matricola_Richiedente_nulla) + "\n" + getEtichetta(EtichetteMessaggi.Warn_ricerca_in_anagrafe)
                        break
                }
            } else {
                //Se il soggetto non è residente, ma in anagrafe ne esiste uno residente con le stesse generalità, lo segnalo
                List<AnaAnagrafe> l = anaAnagrafeService.listXDatiAnagraficiSuResidenti(sr.cognome1, sr.nome1, sr.dataNascita1, sr.sesso1)
                if (l.size() > 0){
                    switch (tipoAttoEnum) {
                        case ETipoAtto.MAT:
                            s = getEtichetta(EtichetteMessaggi.Warn_Matricola_Sposo_nulla_ma_soggetto_in_anagrafe) + "\n" + getEtichetta(EtichetteMessaggi.Warn_verifica_in_anagrafe)
                            break
                        case ETipoAtto.UCI:
                            s = getEtichetta(EtichetteMessaggi.Warn_Matricola_Contraente_1_nulla_ma_soggetto_in_anagrafe) + "\n" + getEtichetta(EtichetteMessaggi.Warn_verifica_in_anagrafe)
                            break
                        case ETipoAtto.CIT:
                            s = getEtichetta(EtichetteMessaggi.Warn_Matricola_Richiedente_nulla_ma_soggetto_in_anagrafe) + "\n" + getEtichetta(EtichetteMessaggi.Warn_verifica_in_anagrafe)
                            break
                    }
                }
            }
        } else {
            AnaAnagrafe ana = anaAnagrafeService.get(sr.idAnagrafe1)
            if ( ( (ana.comuneResidenza?.codice != null) && (sr.codiceComuneResidenza1 == null) ) ||
                 ( (ana.comuneResidenza?.codice == null) && (sr.codiceComuneResidenza1 != null) ) ||
                 ( (ana.comuneResidenza?.codice != null) && (sr.codiceComuneResidenza1 != null) && ( (ana.comuneResidenza?.codice?.compareTo(sr.codiceComuneResidenza1) != 0) || (ana.comuneResidenza?.codiceProvincia?.compareTo(sr.codiceProvinciaResidenza1) != 0) ) )
               ) {
                switch (tipoAttoEnum) {
                    case ETipoAtto.MAT:
                        s = getEtichetta(EtichetteMessaggi.Warn_Residenza_Sposo_Cambiata)
                        break
                    case ETipoAtto.UCI:
                        s = getEtichetta(EtichetteMessaggi.Warn_Residenza_Contraente_1_Cambiata)
                        break
                    case ETipoAtto.CIT:
                        s = getEtichetta(EtichetteMessaggi.Warn_Residenza_Richiedente_Cambiata)
                        break
                }
            }
        }
        return s
    }

    String checkAnagrafe2(ISoggettoRecupero2 sr){
        String s = ""
        if (sr.idAnagrafe2 == null) {
            if (arcComuneBaseService.isComuneClienteOggi(sr.codiceComuneResidenza2, sr.codiceProvinciaResidenza2)) {
                //Se il soggetto è residente, segnalo che la matricola è nulla e che quindi il soggetto dovrebbe essere ripescato
                s = ( (tipoAttoEnum == ETipoAtto.MAT)?getEtichetta(EtichetteMessaggi.Warn_Matricola_Sposa_nulla):getEtichetta(EtichetteMessaggi.Warn_Matricola_Contraente_2_nulla) ) + "\n" + getEtichetta(EtichetteMessaggi.Warn_ricerca_in_anagrafe)
            } else {
                List<AnaAnagrafe> l = anaAnagrafeService.listXDatiAnagraficiSuResidenti(sr.cognome2, sr.nome2, sr.dataNascita2, sr.sesso2)
                if (l.size() > 0){
                    s = ( (tipoAttoEnum == ETipoAtto.MAT)?getEtichetta(EtichetteMessaggi.Warn_Matricola_Sposa_nulla_ma_soggetto_in_anagrafe):getEtichetta(EtichetteMessaggi.Warn_Matricola_Contraente_2_nulla_ma_soggetto_in_anagrafe) ) + "\n" + getEtichetta(EtichetteMessaggi.Warn_verifica_in_anagrafe)
                }
            }
        } else {
            AnaAnagrafe ana = anaAnagrafeService.get(sr.idAnagrafe2)
            if ( ( (ana.comuneResidenza?.codice != null) && (sr.codiceComuneResidenza2 == null) ) ||
                 ( (ana.comuneResidenza?.codice == null) && (sr.codiceComuneResidenza2 != null) ) ||
                 ( (ana.comuneResidenza?.codice != null) && (sr.codiceComuneResidenza2 != null) && ( (ana.comuneResidenza?.codice?.compareTo(sr.codiceComuneResidenza2) != 0) || (ana.comuneResidenza?.codiceProvincia?.compareTo(sr.codiceProvinciaResidenza2) != 0) ) )
            ) {
                s = (tipoAttoEnum == ETipoAtto.MAT)?getEtichetta(EtichetteMessaggi.Warn_Residenza_Sposa_Cambiata):getEtichetta(EtichetteMessaggi.Warn_Residenza_Contraente_2_Cambiata)
            }
        }
        return s
    }

    static final List<Map<String, String>> etichetteRecuperoDefault = [EtichetteMessaggi.Warn_ricerca_in_anagrafe, EtichetteMessaggi.Warn_verifica_in_anagrafe,
                                                                       EtichetteMessaggi.Warn_Matricola_Sposo_nulla, EtichetteMessaggi.Warn_Matricola_Contraente_1_nulla,
                                                                       EtichetteMessaggi.Warn_Matricola_Sposa_nulla, EtichetteMessaggi.Warn_Matricola_Contraente_2_nulla,
                                                                       EtichetteMessaggi.Warn_Matricola_Sposo_nulla_ma_soggetto_in_anagrafe, EtichetteMessaggi.Warn_Matricola_Contraente_1_nulla_ma_soggetto_in_anagrafe,
                                                                       EtichetteMessaggi.Warn_Matricola_Sposa_nulla_ma_soggetto_in_anagrafe, EtichetteMessaggi.Warn_Matricola_Contraente_2_nulla_ma_soggetto_in_anagrafe,
                                                                       EtichetteMessaggi.Warn_Residenza_Sposo_Cambiata, EtichetteMessaggi.Warn_Residenza_Contraente_1_Cambiata,
                                                                       EtichetteMessaggi.Warn_Residenza_Sposa_Cambiata, EtichetteMessaggi.Warn_Residenza_Contraente_2_Cambiata,
                                                                       EtichetteMessaggi.Warn_Matricola_Richiedente_nulla, EtichetteMessaggi.Warn_Matricola_Richiedente_nulla_ma_soggetto_in_anagrafe, EtichetteMessaggi.Warn_Residenza_Richiedente_Cambiata]

}
