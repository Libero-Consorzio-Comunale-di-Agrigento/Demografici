package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoResidenteFamiglia
import it.finmatica.de4gsdzk.utils.IIndirizzo
import it.finmatica.de4gsdzk.utils.IIndirizzoNonResidente
import it.finmatica.de4gsdzk.utils.IIndirizzoResidente
import it.finmatica.de4gsdzk.utils.IIndirizzoResidenteEstero
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zul.Groupbox
import org.zkoss.zul.Row
import org.zkoss.zul.Rows

class GroupboxIndirizzo extends Groupbox {

    private Rows _tempRows = new Rows()

    private String label
    private IIndirizzo indirizzo
    private String tipoIndirizzo

    GroupboxIndirizzo() {
        super()
        setClosable(false)
    }

    void onCreate() {
        Executions.createComponents("/restrict/afc/groupboxIndirizzo.zul", this, [label: label, indirizzo: indirizzo, tipoIndirizzo: tipoIndirizzo])

        Component rows = Selectors.iterable(this, "rows").iterator().hasNext() ?
                Selectors.iterable(this, "rows").iterator().next() : null
        if (rows != null) {
            // Create a copy of the children to avoid concurrent modifications.
            def childrenCopy = new ArrayList(_tempRows.getChildren())
            childrenCopy.each { child ->
                rows.appendChild(child as Component)
            }
            _tempRows.getChildren().clear()
        }

        Selectors.wireVariables(this, this, null)
        Selectors.wireComponents(this, this, false)
        Selectors.wireEventListeners(this, this)
    }

    @Override
    boolean insertBefore(Component newChild, Component refChild) {
        if (newChild instanceof Row) {
            return _tempRows.insertBefore(newChild, refChild)
        } else {
            super.insertBefore(newChild, refChild)
        }
    }

    @Override
    boolean appendChild(Component child) {
        if (child instanceof Row) {
            _tempRows.appendChild(child)
            return true
        } else {
            super.appendChild(child)
        }
    }

    void setLabel(String label) {
        this.label = label
    }

    String getLabel() {
        return label
    }

    void setValue(IIndirizzo value) {
        if (value == null) {
            indirizzo = null
            tipoIndirizzo = getTipoIndirizzoFromValue(indirizzo)
            return
        }

        indirizzo = value as IIndirizzo
        tipoIndirizzo = getTipoIndirizzoFromValue(indirizzo)
    }

    IIndirizzo getValue() {
        return indirizzo
    }

    static String getTipoIndirizzoFromValue(IIndirizzo indirizzo) {
        if (indirizzo instanceof IIndirizzoResidente) {
            return (indirizzo instanceof IndirizzoResidenteFamiglia) ? ETipoVisualizzazioneIndirizzo.RESIDENTE_SENZA_COMUNE : ETipoVisualizzazioneIndirizzo.RESIDENTE
        } else if (indirizzo instanceof IIndirizzoNonResidente) {
            return ETipoVisualizzazioneIndirizzo.NON_RESIDENTE
        } else if (indirizzo instanceof IIndirizzoResidenteEstero) {
            return ETipoVisualizzazioneIndirizzo.RESIDENTE_ESTERO
        } else {
            return ETipoVisualizzazioneIndirizzo.NONE
        }
    }

    enum ETipoVisualizzazioneIndirizzo {
        RESIDENTE_SENZA_COMUNE,
        RESIDENTE,
        NON_RESIDENTE,
        RESIDENTE_ESTERO,
        NONE
    }
}