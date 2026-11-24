package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.utils.EFiltroCognome
import it.finmatica.de4gsdzk.utils.ETipoFirma
import it.finmatica.de4gsdzk.utils.Etichette

class SpecificheListaSezionale {

    EleTipoLista tipoLista

    Integer sezioneDa
    Integer sezioneA
    Long progressivoDa
    Long progressivoA

    Boolean stampaChiusura
    Boolean stampaVisto
    Boolean stampaSeggi

    EleElezione elezione

    Boolean alfabetico
    Boolean storico
    Boolean depennati
    EFiltroCognome filtroCognome

    Boolean politiche
    Boolean amministrative
    String descrizioneAmministrative
    Boolean referendum

    String verbale
    Date dataVerbale

    Boolean timbroUffcioComunale1Check
    Boolean timbroUffcioComunale2Check
    Boolean timbroUffcioComunale3Check
    Boolean timbroUffcioComunaleALCheck
    Boolean timbroUffcioComunaleMZCheck

    EleTimbro timbroUffcioComunale1
    EleTimbro timbroUffcioComunale2
    EleTimbro timbroUffcioComunale3
    EleTimbro timbroUffcioComunaleAL
    EleTimbro timbroUffcioComunaleMZ

    EleRevisioneElettorale revisione

    ETipoFirma tipoFirma
    String componente
    Boolean firmaInStampa

    Boolean timbroCommissioneCircondariale1Check
    Boolean timbroCommissioneCircondariale2Check
    Boolean timbroCommissioneCircondariale3Check
    Boolean timbroCommissioneCircondarialeALCheck
    Boolean timbroCommissioneCircondarialeMZCheck

    EleTimbro timbroCommissioneCircondariale1
    EleTimbro timbroCommissioneCircondariale2
    EleTimbro timbroCommissioneCircondariale3
    EleTimbro timbroCommissioneCircondarialeAL
    EleTimbro timbroCommissioneCircondarialeMZ

    String verbaleCommissioneCircondariale1
    Date dataVerbaleCommissioneCircondariale1

    String verbaleCommissioneCircondariale2
    Date dataVerbaleCommissioneCircondariale2

    Date dataCommissioneCircondariale3

    Integer paginaIniziale


    SpecificheListaSezionale(EleTimbro timbroUffcioComunale1, EleTimbro timbroUffcioComunale2, EleTimbro timbroUffcioComunale3,
                             EleTimbro timbroCommissioneCircondariale1, EleTimbro timbroCommissioneCircondariale2, EleTimbro timbroCommissioneCircondariale3,
                             String componente, EleTipoLista tipoLista){
        this.stampaChiusura = false
        this.stampaVisto = false
        this.timbroUffcioComunale1 = timbroUffcioComunale1
        this.timbroUffcioComunale2 = timbroUffcioComunale2
        this.timbroUffcioComunale3 = timbroUffcioComunale3

        this.timbroCommissioneCircondariale1 = timbroCommissioneCircondariale1
        this.timbroCommissioneCircondariale2 = timbroCommissioneCircondariale2
        this.timbroCommissioneCircondariale3 = timbroCommissioneCircondariale3

        this.timbroUffcioComunale1Check = false
        this.timbroUffcioComunale2Check = false
        this.timbroUffcioComunale3Check = false
        this.timbroUffcioComunaleALCheck = false
        this.timbroUffcioComunaleMZCheck = false

        this.timbroCommissioneCircondariale1Check = false
        this.timbroCommissioneCircondariale2Check = false
        this.timbroCommissioneCircondariale3Check = false
        this.timbroCommissioneCircondarialeALCheck = false
        this.timbroCommissioneCircondarialeMZCheck = false

        this.tipoFirma = ETipoFirma.CEC
        this.componente = componente

        this.tipoLista = tipoLista
    }

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Dati_Generali"), Etichette.getEtichetta("Sezione"), Etichette.getEtichetta("Progressivo"), Etichette.getEtichetta("Da"), Etichette.getEtichetta("A"),
                                              Etichette.getEtichetta("Stampa_Chiusura"), Etichette.getEtichetta("Stampa_Visto"), Etichette.getEtichetta("Stampa_Seggi"),
                                              Etichette.getEtichetta("Verbale"), Etichette.getEtichetta("Data_Verbale"), Etichette.getEtichetta("Tipo_Lista"),
                                              Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Elezione"), Etichette.getEtichetta("Timbri_UE"), Etichette.getEtichetta("Timbri_CE"),
                                              Etichette.getEtichetta("Tipo_firma"), Etichette.getEtichetta("Firma"), Etichette.getEtichetta("In_Stampa"), Etichette.getEtichetta("Alla_Data_Del"),
                                              Etichette.getEtichetta("Alfabetico"), Etichette.getEtichetta("Storico"), Etichette.getEtichetta("Cognomi"), Etichette.getEtichetta("Politiche"),
                                              Etichette.getEtichetta("Amministrative"), Etichette.getEtichetta("Referendum"), Etichette.getEtichetta("Depennati"),
                                              Etichette.getEtichetta("Compilare_Correttamente_Sezione"), Etichette.getEtichetta("Compilare_Correttamente_Progressivo")]


}
