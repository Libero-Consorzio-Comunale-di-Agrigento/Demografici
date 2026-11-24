package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.utils.ETipoFirma
import it.finmatica.de4gsdzk.utils.Etichette

class SpecificheListaGenerale {

    EleTipoLista tipoLista

    Long progressivoDa
    Long progressivoA
    Boolean stampaChiusura

    String verbale
    Date dataVerbale
    EleElezione elezione

    Boolean timbroUffcioComunale1Check
    Boolean timbroUffcioComunale2Check
    Boolean timbroUffcioComunale3Check

    EleTimbro timbroUffcioComunale1
    EleTimbro timbroUffcioComunale2
    EleTimbro timbroUffcioComunale3

    EleRevisioneElettorale revisione

    ETipoFirma tipoFirma
    String componente
    Boolean firmaInStampa

    Boolean timbroCommissioneCircondariale1Check
    Boolean timbroCommissioneCircondariale2Check
    Boolean timbroCommissioneCircondariale3Check

    EleTimbro timbroCommissioneCircondariale1
    EleTimbro timbroCommissioneCircondariale2
    EleTimbro timbroCommissioneCircondariale3

    String verbaleCommissioneCircondariale1
    Date dataVerbaleCommissioneCircondariale1

    String verbaleCommissioneCircondariale2
    Date dataVerbaleCommissioneCircondariale2

    Date dataCommissioneCircondariale3


    SpecificheListaGenerale(EleTimbro timbroUffcioComunale1, EleTimbro timbroUffcioComunale2, EleTimbro timbroUffcioComunale3,
                            EleTimbro timbroCommissioneCircondariale1, EleTimbro timbroCommissioneCircondariale2, EleTimbro timbroCommissioneCircondariale3,
                            String componente, EleTipoLista tipoLista){
        this.stampaChiusura = false
        this.timbroUffcioComunale1 = timbroUffcioComunale1
        this.timbroUffcioComunale2 = timbroUffcioComunale2
        this.timbroUffcioComunale3 = timbroUffcioComunale3

        this.timbroCommissioneCircondariale1 = timbroCommissioneCircondariale1
        this.timbroCommissioneCircondariale2 = timbroCommissioneCircondariale2
        this.timbroCommissioneCircondariale3 = timbroCommissioneCircondariale3

        this.timbroUffcioComunale1Check = false
        this.timbroUffcioComunale2Check = false
        this.timbroUffcioComunale3Check = false

        this.timbroCommissioneCircondariale1Check = false
        this.timbroCommissioneCircondariale2Check = false
        this.timbroCommissioneCircondariale3Check = false

        this.tipoFirma = ETipoFirma.CEC
        this.componente = componente

        this.tipoLista = tipoLista
    }

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Dati_Generali"), Etichette.getEtichetta("Progressivo"), Etichette.getEtichetta("Da"), Etichette.getEtichetta("A"),
                                              Etichette.getEtichetta("Stampa_Chiusura"),
                                              Etichette.getEtichetta("Verbale"), Etichette.getEtichetta("Data_Verbale"),
                                              Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Elezione"), Etichette.getEtichetta("Timbri_UE"), Etichette.getEtichetta("Timbri_CE"),
                                              Etichette.getEtichetta("Tipo_firma"), Etichette.getEtichetta("Firma"), Etichette.getEtichetta("In_Stampa"), Etichette.getEtichetta("Alla_Data_Del"),
                                              Etichette.getEtichetta("Compilare_Correttamente_Progressivo"), Etichette.getEtichetta("Tipo_Lista")]


}
