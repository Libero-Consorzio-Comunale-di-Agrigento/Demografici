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

    static List<Map> etichetteCbDesc = [Etichette.back_tooltip,
                                        Etichette.filtro_ricerca_placeholder, Etichette.filtro_ricerca_tooltip, Etichette.ricerca_tooltip,
                                        Etichette.salva_tooltip, Etichette.modifica_tooltip, Etichette.inserisci_tooltip, Etichette.elimina_tooltip, Etichette.seleziona_tooltip,
                                        Etichette.print_tooltip, Etichette.csv_export_tooltip, Etichette.xls_export_tooltip, Etichette.filtri_extra_tooltip,
                                        Etichette.filtro_ricerca_placeholder, Etichette.ricerca_tooltip, Etichette.filtro_ricerca_tooltip]
}
