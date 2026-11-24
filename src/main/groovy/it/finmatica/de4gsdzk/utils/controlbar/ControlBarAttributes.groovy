package it.finmatica.de4gsdzk.utils.controlbar

import it.finmatica.de4gsdzk.utils.Etichette

class ControlBarAttributes {
    boolean backEnabled = true

    boolean pagingEnabled = true
    boolean searchEnabled = false
    boolean searchPopupEnabled = false

    String additionalSearchFilter = ""
    String additionalSearchFilter2 = ""

    boolean saveEnabled = false
    boolean modifyEnabled = true
    boolean addEnabled = true
    boolean addPlusEnabled = false
    boolean addCustomEnabled = false
    boolean deleteEnabled = false

    boolean excelExportEnabled = false
    boolean csvExportEnabled = false
    boolean pdfExportEnabled = false
    boolean xmlExportEnabled = false

    boolean filtriExtraEnabled = false

    boolean printEnabled = false
    boolean printPlusEnabled = false

    String additionalToolbarbutton = null
    String additionalToolbarbutton2 = null
    String additionalToolbarbutton3 = null

    static List<Map> etichetteCbDesc = [Etichette.getEtichetta("back_tooltip"),
                                        Etichette.getEtichetta("filtro_ricerca_placeholder"), Etichette.getEtichetta("filtro_ricerca_tooltip"), Etichette.getEtichetta("ricerca_tooltip"),
                                        Etichette.getEtichetta("salva_tooltip"), Etichette.getEtichetta("modifica_tooltip"), Etichette.getEtichetta("inserisci_tooltip"), Etichette.getEtichetta("elimina_tooltip"), Etichette.getEtichetta("seleziona_tooltip"),
                                        Etichette.getEtichetta("print_tooltip"), Etichette.getEtichetta("csv_export_tooltip"), Etichette.getEtichetta("xls_export_tooltip"), Etichette.getEtichetta("filtri_extra_tooltip"),
                                        Etichette.getEtichetta("filtro_ricerca_placeholder"), Etichette.getEtichetta("ricerca_tooltip"), Etichette.getEtichetta("filtro_ricerca_tooltip")]
}
