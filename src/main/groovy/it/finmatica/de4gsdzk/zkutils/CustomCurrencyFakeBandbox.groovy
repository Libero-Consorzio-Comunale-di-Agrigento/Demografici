package it.finmatica.de4gsdzk.zkutils

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.zkoss.xel.fn.CommonFns
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.EventListener
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.Listen
import org.zkoss.zk.ui.select.annotation.Wire
import org.zkoss.zul.Label
import org.zkoss.zul.Listbox
import org.zkoss.zul.Paging

@Slf4j
abstract class CustomCurrencyFakeBandbox extends DecimalFakeBandbox {

    @Wire("listbox")
    protected Listbox listbox
    @Wire("paging")
    protected Paging paging
    @Wire("label")
    protected Label label

    long totalSize = 0

    private def selectedItem

    Boolean selectedFromList = Boolean.FALSE

    Map<String, String> etichette = [:]

    protected String errorTitle = "Validazione"
    protected String errorMsg = "Dato non valido"

    protected String attributoDaLeggere

    static {
        addClientEvent(CustomCurrencyFakeBandbox.class, CustomEvents.ON_CHANGE_PREVENT_DEFAULT, CE_IMPORTANT);
    }

    CustomCurrencyFakeBandbox() {
        super()

        setFormat(CurrencyBox.DEFAULT_FORMAT)

        this.addEventListener(Events.ON_CHANGING, new EventListener() {
            void onEvent(Event event) {
                selectedFromList = Boolean.FALSE
                paging.setActivePage(0)

                String typed = event.getValue() as String

                if (TestoUtils.isVuoto(typed)) {
                    loadData(null)
                    return
                }

                if (isStringFormatted(typed)) {
                    loadData(typed)
                    return
                }

                try {
                    BigDecimal typedDecimal = new BigDecimal(typed)
                    String typedFormatted = CommonFns.formatNumber(typedDecimal, getFormat())
                    loadData(typedFormatted)
                } catch (NumberFormatException ex) {
                    log.debug(ex.getMessage(), ex)
                    loadData(typed)
                }
            }

        });

        this.addEventListener(Events.ON_OPEN, new EventListener() {
            void onEvent(Event event) {
                paging.setActivePage(0)
                String value = getValue() != null ? CommonFns.formatNumber(getValue(), getFormat()) : ''
                loadData(value)
            }
        })
    }

    private boolean isStringFormatted(String value) {
        try {
            CommonFns.parseNumber(value, CurrencyBox.DEFAULT_FORMAT)
            return true
        } catch (Exception ex) {
            log.debug(ex.getMessage(), ex)
            return false
        }
    }

    protected abstract void loadData(String filtro, Boolean searchEqual = Boolean.FALSE)

    def getSelectedItem() {
        return this.selectedItem
    }

    void setSelectedItem(def item) {
        this.selectedItem = item
        if (item) {
            if (((attributoDaLeggere ?: "") == "") && (item instanceof BigDecimal)) {
                setValue(item)
            } else {
                setValue(item."$attributoDaLeggere" as BigDecimal)
            }
        } else {
            setValue(null)
            listbox.setSelectedItem(null)
            paging.setActivePage(0)
            if (isOpen()) {
                loadData(null)
            }
        }
        Events.sendEvent(Events.ON_SELECT, this, item)
    }

    @Listen("onSelect = listbox")
    void selectData() {
        if (listbox.getSelectedItem()) {
            selectedFromList = Boolean.TRUE
            setSelectedItem(listbox.getSelectedItem().getValue())
            if (isOpen()) {
                closePopup()
            }
        }
    }

    @Listen("onPaging = paging")
    void onPaging() {
        String value = CommonFns.formatNumber(getValue(), getFormat())
        loadData(value)
    }

    static final List<Map> etichetteBB = [Etichette.getEtichetta("ricerca_tooltip"), Etichette.getEtichetta("filtro_ricerca_placeholder"), Etichette.getEtichetta("Numero_record_trovati"),
                                          Etichette.getEtichetta("Validazione"), Etichette.getEtichetta("Dato_non_valido")]

}
