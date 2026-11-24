package it.finmatica.de4gsdzk.utils

import groovy.util.logging.Slf4j
import org.springframework.data.domain.Sort

@Slf4j
class SortUtils {

    final static List<Sort.Order> estremiAttoDesc = [new Sort.Order(Sort.Direction.DESC, "anno"),
                                                     new Sort.Order(Sort.Direction.DESC, "parte"),
                                                     new Sort.Order(Sort.Direction.DESC, "serie"),
                                                     new Sort.Order(Sort.Direction.DESC, "atto"),
                                                     new Sort.Order(Sort.Direction.DESC, "ufficio")]

    final static List<Sort.Order> estremiAttoAsc = [new Sort.Order(Sort.Direction.ASC, "anno"),
                                                    new Sort.Order(Sort.Direction.ASC, "parte"),
                                                    new Sort.Order(Sort.Direction.ASC, "serie"),
                                                    new Sort.Order(Sort.Direction.ASC, "atto"),
                                                    new Sort.Order(Sort.Direction.ASC, "ufficio")]

    final static List<Sort.Order> annoAttoAsc = [new Sort.Order(Sort.Direction.ASC, "anno"),
                                                 new Sort.Order(Sort.Direction.ASC, "atto")]

    final static List<Sort.Order> dataRegistrazioneDesc = [new Sort.Order(Sort.Direction.DESC, "dataRegistrazione"), new Sort.Order("sequenza")]
    final static List<Sort.Order> dataRegistrazioneAsc = [new Sort.Order(Sort.Direction.ASC, "dataRegistrazione"), new Sort.Order("sequenza")]

    final static List<Sort.Order> dataRegistrazioneDescOnly = [new Sort.Order(Sort.Direction.DESC, "dataRegistrazione")]
    final static List<Sort.Order> dataRegistrazioneAscOnly = [new Sort.Order(Sort.Direction.ASC, "dataRegistrazione")]

    final static List<Sort.Order> cognomeNomeDesc = [new Sort.Order(Sort.Direction.DESC, "cognome"), new Sort.Order(Sort.Direction.DESC, "nome")]
    final static List<Sort.Order> cognomeNomeAsc = [new Sort.Order(Sort.Direction.ASC, "cognome"), new Sort.Order(Sort.Direction.ASC, "nome")]

    final static List<Sort.Order> sequenzaAsc = [new Sort.Order(Sort.Direction.ASC, "sequenza")]
    final static List<Sort.Order> sequenzaDesc = [new Sort.Order(Sort.Direction.DESC, "sequenza")]

    final static List<Sort.Order> cognomeNomeDataEventoListaDesc = [new Sort.Order(Sort.Direction.DESC, "cognome"),
                                                                    new Sort.Order(Sort.Direction.DESC, "nome"),
                                                                    new Sort.Order(Sort.Direction.DESC, "dataEventoLista")]
    final static List<Sort.Order> cognomeNomeDataEventoListaAsc = [new Sort.Order(Sort.Direction.ASC, "cognome"),
                                                                   new Sort.Order(Sort.Direction.ASC, "nome"),
                                                                   new Sort.Order(Sort.Direction.ASC, "dataEventoLista")]

    final static List<Sort.Order> cognomeNomeDecedutoDesc = [new Sort.Order(Sort.Direction.DESC, "cognome"),
                                                             new Sort.Order(Sort.Direction.DESC, "nome"),
                                                             new Sort.Order(Sort.Direction.DESC, "dataMorte")]
    final static List<Sort.Order> cognomeNomeDecedutoAsc = [new Sort.Order(Sort.Direction.ASC, "cognome"),
                                                            new Sort.Order(Sort.Direction.ASC, "nome"),
                                                            new Sort.Order(Sort.Direction.ASC, "dataMorte")]

    final static List<Sort.Order> cognomeNomeNatoDesc = [new Sort.Order(Sort.Direction.DESC, "cognome"),
                                                         new Sort.Order(Sort.Direction.DESC, "nome"),
                                                         new Sort.Order(Sort.Direction.DESC, "dataNascita")]
    final static List<Sort.Order> cognomeNomeNatoAsc = [new Sort.Order(Sort.Direction.ASC, "cognome"),
                                                        new Sort.Order(Sort.Direction.ASC, "nome"),
                                                        new Sort.Order(Sort.Direction.ASC, "dataNascita")]

    final static List<Sort.Order> cognomeNomeConiuge1Desc = [new Sort.Order(Sort.Direction.DESC, "cognome1"), new Sort.Order(Sort.Direction.DESC, "nome1")]
    final static List<Sort.Order> cognomeNomeConiuge1Asc = [new Sort.Order(Sort.Direction.ASC, "cognome1"), new Sort.Order(Sort.Direction.ASC, "nome1")]

    final static List<Sort.Order> cognomeNomeConiuge2Desc = [new Sort.Order(Sort.Direction.DESC, "cognome2"), new Sort.Order(Sort.Direction.DESC, "nome2")]
    final static List<Sort.Order> cognomeNomeConiuge2Asc = [new Sort.Order(Sort.Direction.ASC, "cognome2"), new Sort.Order(Sort.Direction.ASC, "nome2")]

    final static List<Sort.Order> cognomeNome1ListaAsc = [new Sort.Order(Sort.Direction.ASC, "cognome1Lista"),
                                                          new Sort.Order(Sort.Direction.ASC, "nome1Lista")]

    final static List<Sort.Order> cognomeNome2ListaAsc = [new Sort.Order(Sort.Direction.ASC, "cognome2Lista"),
                                                          new Sort.Order(Sort.Direction.ASC, "nome2Lista")]

    final static List<Sort.Order> formulaAsc = [new Sort.Order(Sort.Direction.ASC, "id")]
    final static List<Sort.Order> formulaDesc = [new Sort.Order(Sort.Direction.DESC, "id")]

    final static List<Sort.Order> idAsc = [new Sort.Order(Sort.Direction.ASC, "id")]
    final static List<Sort.Order> idDesc = [new Sort.Order(Sort.Direction.DESC, "id")]

    final static List<Sort.Order> descrizioneComuneAsc = [new Sort.Order(Sort.Direction.ASC, "descrizioneComune")]

    final static List<Sort.Order> denominazioneOrdinamentoAsc = [new Sort.Order(Sort.Direction.ASC, "denominazioneOrdinamento")]

    final static List<Sort.Order> numeroUnicoAsc = [new Sort.Order(Sort.Direction.ASC, "numeroUnico")]
    final static List<Sort.Order> numeroUnicoDesc = [new Sort.Order(Sort.Direction.DESC, "numeroUnico")]

    final static List<Sort.Order> descrizioneAsc = [new Sort.Order(Sort.Direction.ASC, "descrizione")]
    final static List<Sort.Order> descrizioneDesc = [new Sort.Order(Sort.Direction.DESC, "descrizione")]

    final static List<Sort.Order> descrizioneEstesaAsc = [new Sort.Order(Sort.Direction.ASC, "descrizioneEstesa")]
    final static List<Sort.Order> descrizioneEstesaDesc = [new Sort.Order(Sort.Direction.DESC, "descrizioneEstesa")]

    final static List<Sort.Order> descrizioneUseCaseAsc = [new Sort.Order(Sort.Direction.ASC, "descrizioneUseCase")]

    final static List<Sort.Order> dataNascitaAsc = [new Sort.Order(Sort.Direction.ASC, "dataNascita")]
    final static List<Sort.Order> dataNascitaDesc = [new Sort.Order(Sort.Direction.DESC, "dataNascita")]

    final static List<Sort.Order> richiamoProgressivoAsc = [new Sort.Order(Sort.Direction.ASC, "richiamo"), new Sort.Order(Sort.Direction.ASC, "progressivo")]
    final static List<Sort.Order> richiamoProgressivoDesc = [new Sort.Order(Sort.Direction.DESC, "richiamo"), new Sort.Order(Sort.Direction.DESC, "progressivo")]

    final static List<Sort.Order> tipoDocumentoFascicoloAsc = [new Sort.Order(Sort.Direction.ASC, "tipoDocumentoFascicolo.descrizione")]
    final static List<Sort.Order> tipoDocumentoFascicoloDesc = [new Sort.Order(Sort.Direction.DESC, "tipoDocumentoFascicolo.descrizione")]

    final static List<Sort.Order> dataEventoAsc = [new Sort.Order(Sort.Direction.ASC, "dataEventoLista")]
    final static List<Sort.Order> dataEventoDesc = [new Sort.Order(Sort.Direction.DESC, "dataEventoLista")]

    final static List<Sort.Order> dataAnaEventoAsc = [new Sort.Order(Sort.Direction.ASC, "dataEvento")]

    final static List<Sort.Order> protocolloAsc = [new Sort.Order(Sort.Direction.ASC, "annoProtocollo"), new Sort.Order(Sort.Direction.ASC, "numeroProtocollo")]
    final static List<Sort.Order> protocolloDesc = [new Sort.Order(Sort.Direction.DESC, "annoProtocollo"), new Sort.Order(Sort.Direction.DESC, "numeroProtocollo")]

    final static List<Sort.Order> dirittoFasciaTariffariaAsc = [new Sort.Order(Sort.Direction.ASC, "diritto"), new Sort.Order(Sort.Direction.ASC, "fasciaTariffaria")]

    final static List<Sort.Order> tariffaDirittoAsc = [new Sort.Order(Sort.Direction.ASC, "tariffaDiritto.diritto"), new Sort.Order(Sort.Direction.ASC, "tariffaDiritto.fasciaTariffaria")]

    final static List<Sort.Order> dataEmissioneDesc = [new Sort.Order(Sort.Direction.DESC, "dataEmissione"), new Sort.Order(Sort.Direction.DESC, "annoEmissione"), new Sort.Order(Sort.Direction.DESC, "progressivoEmissione")]
    final static List<Sort.Order> dataEmissioneAsc = [new Sort.Order(Sort.Direction.ASC, "dataEmissione"), new Sort.Order(Sort.Direction.ASC, "annoEmissione"), new Sort.Order(Sort.Direction.ASC, "progressivoEmissione")]

    final static List<Sort.Order> dataEmissioneDocumentoDesc = [new Sort.Order(Sort.Direction.DESC, "dataEmissione")]
    final static List<Sort.Order> dataEmissioneDocumentoAsc = [new Sort.Order(Sort.Direction.ASC, "dataEmissione")]

    final static List<Sort.Order> certificatoDataEmissioneDesc = [new Sort.Order(Sort.Direction.DESC, "certificatoEmesso.dataEmissione"), new Sort.Order(Sort.Direction.DESC, "certificatoEmesso.annoEmissione"), new Sort.Order(Sort.Direction.DESC, "certificatoEmesso.progressivoEmissione")]
    final static List<Sort.Order> certificatoDataEmissioneAsc = [new Sort.Order(Sort.Direction.ASC, "certificatoEmesso.dataEmissione"), new Sort.Order(Sort.Direction.ASC, "certificatoEmesso.annoEmissione"), new Sort.Order(Sort.Direction.ASC, "certificatoEmesso.progressivoEmissione")]

    final static List<Sort.Order> dataPagamentoDesc = [new Sort.Order(Sort.Direction.DESC, "dataInvio"), new Sort.Order(Sort.Direction.DESC, "anno"), new Sort.Order(Sort.Direction.DESC, "progressivo")]
    final static List<Sort.Order> dataPagamentoAsc = [new Sort.Order(Sort.Direction.ASC, "dataInvio"), new Sort.Order(Sort.Direction.ASC, "anno"), new Sort.Order(Sort.Direction.ASC, "progressivo")]

    final static List<Sort.Order> variabileDesc = [new Sort.Order(Sort.Direction.DESC, "variabile")]

    final static List<Sort.Order> validoDalIdDesc = [new Sort.Order(Sort.Direction.DESC, "validoDal"), new Sort.Order(Sort.Direction.DESC, "id")]
    final static List<Sort.Order> validoDalIdAsc = [new Sort.Order(Sort.Direction.ASC, "validoDal"), new Sort.Order(Sort.Direction.ASC, "id")]

    final static List<Sort.Order> modalitaRilascioAsc = [new Sort.Order(Sort.Direction.ASC, "categoriaTipoCertificato.id"), new Sort.Order(Sort.Direction.ASC, "descrizione")]

    final static List<Sort.Order> categoriaTipoCertificatoAsc = [new Sort.Order(Sort.Direction.ASC, "categoriaTipoCertificato.sequenza"), new Sort.Order(Sort.Direction.ASC, "categoriaTipoCertificato.descrizione")]

    final static List<Sort.Order> anagrafeSoggettoFamiliareAsc = [new Sort.Order(Sort.Direction.ASC, "fascia"), new Sort.Order(Sort.Direction.ASC, "sequenzaParentela"), new Sort.Order(Sort.Direction.ASC, "dataNascita"), new Sort.Order(Sort.Direction.ASC, "cognome"), new Sort.Order(Sort.Direction.ASC, "nome")]

    final static List<Sort.Order> anagrafeSoggettoFamiliareStoricoAsc = [new Sort.Order(Sort.Direction.ASC, "anagrafe.fascia"), new Sort.Order(Sort.Direction.ASC, "sequenzaParentela"), new Sort.Order(Sort.Direction.ASC, "anagrafe.dataNascita"), new Sort.Order(Sort.Direction.ASC, "anagrafe.cognome"), new Sort.Order(Sort.Direction.ASC, "anagrafe.nome")]

    final static List<Sort.Order> dataPraticaDesc = [new Sort.Order(Sort.Direction.DESC, "pratica.data")]

    final static List<Sort.Order> dataPraticaAsc = [new Sort.Order(Sort.Direction.ASC, "pratica.data")]

    final static List<Sort.Order> giorniMonitoraggio = [new Sort.Order(Sort.Direction.DESC, "pratica.giorniMonitoraggio")]

    final static List<Sort.Order> annoNumeroPraticaDesc = [new Sort.Order(Sort.Direction.DESC, "pratica.anno"), new Sort.Order(Sort.Direction.DESC, "pratica.numero")]

    final static List<Sort.Order> annoNumeroPraticaAsc = [new Sort.Order(Sort.Direction.ASC, "pratica.anno"), new Sort.Order(Sort.Direction.ASC, "pratica.numero")]

    final static List<Sort.Order> codiceAsc = [new Sort.Order(Sort.Direction.ASC, "codice")]

    final static List<Sort.Order> codiceDesc = [new Sort.Order(Sort.Direction.DESC, "codice")]

    final static List<Sort.Order> dataDecorrenzaAsc = [new Sort.Order(Sort.Direction.ASC, "dataDecorrenza")]

    final static List<Sort.Order> dataDecorrenzaDesc = [new Sort.Order(Sort.Direction.DESC, "dataDecorrenza")]

    final static List<Sort.Order> ordineLista = [new Sort.Order(Sort.Direction.ASC, "ordLista")]

    final static List<Sort.Order> dataInoltroDesc = [new Sort.Order(Sort.Direction.DESC, "dataInoltro")]

    final static List<Sort.Order> dataInoltroAsc = [new Sort.Order(Sort.Direction.ASC, "dataInoltro")]

    final static List<Sort.Order> dataEsitoDesc = [new Sort.Order(Sort.Direction.DESC, "dataEsito")]

    final static List<Sort.Order> dataEsitoAsc = [new Sort.Order(Sort.Direction.ASC, "dataEsito")]


    final static List<Sort.Order> civicoEsternoInternoTutteAsc = [new Sort.Order(Sort.Direction.ASC, "via.id"),
                                                                  new Sort.Order(Sort.Direction.ASC, "flagEsterno"),
                                                                  new Sort.Order(Sort.Direction.ASC, "flagInterno"),
                                                                  new Sort.Order(Sort.Direction.ASC, "sequenza")]

    final static List<Sort.Order> civicoInternoEsternoTutteAsc = [new Sort.Order(Sort.Direction.ASC, "via.id"),
                                                                  new Sort.Order(Sort.Direction.ASC, "flagInterno"),
                                                                  new Sort.Order(Sort.Direction.ASC, "flagEsterno"),
                                                                  new Sort.Order(Sort.Direction.ASC, "sequenza")]

    final static List<Sort.Order> operazioneComuneAsc = [new Sort.Order(Sort.Direction.ASC, "operazioneComune")]

    final static List<Sort.Order> operazioneComuneDesc = [new Sort.Order(Sort.Direction.DESC, "operazioneComune")]

    final static List<Sort.Order> operazioneANPRAsc = [new Sort.Order(Sort.Direction.ASC, "operazioneAnpr")]

    final static List<Sort.Order> operazioneANPRDesc = [new Sort.Order(Sort.Direction.DESC, "operazioneAnpr")]

    final static List<Sort.Order> dataRichiestaDesc = [new Sort.Order(Sort.Direction.DESC, "dataRichiesta")]

    final static List<Sort.Order> dataRichiestaAsc = [new Sort.Order(Sort.Direction.ASC, "dataRichiesta")]

}
