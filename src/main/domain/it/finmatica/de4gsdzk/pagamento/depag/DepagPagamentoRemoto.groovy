package it.finmatica.de4gsdzk.pagamento.depag

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "WS_PAGAMENTI_WRK_V")
class DepagPagamentoRemoto {
    @Id
    @Column(name = "IUV")
    String id

    @Column(name = "ESITO_OPERAZIONE")
    String esitoOperazione

    @Column(name = "CHIAVE")
    String chiave

    @Column(name = "TIPO_PAGATORE")
    String tipoPagatore

    @Column(name = "CODICE_PAGATORE")
    String codicePagatore

    @Column(name = "ANAGRAFICA_PAGATORE")
    String anagraficaPagatore

    @Column(name = "EMAIL_PAGATORE")
    String emailPagatore

    @Column(name = "TIPO_DOVUTO")
    String tipoDovuto

    @Column(name = "TIPO_VERSAMENTO")
    String tipoVersamento

    @Column(name = "CAUSALE_VERSAMENTO")
    String causaleVersamento

    @Column(name = "DATA_SCADENZA_DDMMYYYY")
    String dataScadenza

    @Column(name = "IMPORTO_TOTALE")
    String importoTotale

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// SINGOLO_SERVIZIO ////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "SV_SERVIZIO")
    String svServizio

    @Column(name = "SV_CAUSALE")
    String svCausale

    @Column(name = "SV_IMPORTO")
    String svImporto

    @Column(name = "SV_COMMISSIONE_CARICO_PA")
    String svCommissioneCaricoPA

    @Column(name = "SV_DATI_RISCOSSIONE")
    String svDatiRiscossione

    @Column(name = "SV_ACCERTAMENTO")
    String svAccertamento

    @Column(name = "SV_BILANCIO")
    String svBilancio

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// INFO_PAGAMENTO //////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "IP_IMPORTO_PAGATO")
    String ipImportoPagato

    @Column(name = "IP_DATA_PAGAMENTO_DDMMYYYY")
    String ipDataPagamento

    @Column(name = "IP_CODICE_VERSANTE")
    String ipCodiceVersante

    @Column(name = "IP_ANAGRAFICA_VERSANTE")
    String ipAnagraficaVersante

    @Column(name = "IP_IUR")
    String ipIur

    @Column(name = "IP_IUV_SPC")
    String ipIuvSpc

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Iuv, Etichette.Esito_operazione, Etichette.Chiave, Etichette.Tipo_pagatore, Etichette.Codice_pagatore,
                                              Etichette.Anagrafica_pagatore, Etichette.Email_pagatore, Etichette.Tipo_dovuto, Etichette.Tipo_versamento,
                                              Etichette.Causale_versamento, Etichette.Data_scadenza, Etichette.Importo_totale,
                                              Etichette.IP_importo_pagato, Etichette.IP_data_pagamento, Etichette.IP_codice_versante,
                                              Etichette.IP_anagrafica_versante, Etichette.IP_Iur, Etichette.IP_Iuv_Spc,
                                              Etichette.SV_servizio, Etichette.SV_causale, Etichette.SV_importo, Etichette.SV_commissione_carico_PA,
                                              Etichette.SV_dati_riscossione, Etichette.SV_accertamento, Etichette.SV_bilancio]

}
