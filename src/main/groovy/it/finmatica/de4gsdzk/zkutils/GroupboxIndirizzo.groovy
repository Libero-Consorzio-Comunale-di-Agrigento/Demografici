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

class GroupboxIndirizzo extends Groupbox {

    private List<Row> _extraRows = []
    private boolean _rendered = false

    private String label
    private IIndirizzo indirizzo
    private String tipoIndirizzo
    private Boolean showAnp
    private IIndirizzo indirizzoComparison

    GroupboxIndirizzo() {
        super()
        setClosable(false)
    }

    void onCreate() {
        render()
    }

    // Ricostruisce il contenuto interno: richiamato sia alla creazione sia ad ogni
    // successiva modifica di value/showAnp/indirizzoComparison (es. dopo un refreshUi()
    // del ViewModel), perche' onCreate() da solo viene invocato una sola volta da ZK.
    private void render() {
        new ArrayList(getChildren()).each { it.detach() }

        Executions.createComponents("/restrict/afc/groupboxIndirizzo.zul", this, [label: label, indirizzo: indirizzo, tipoIndirizzo: tipoIndirizzo, showAnp: showAnp, indirizzoComparison: indirizzoComparison, groupbox: this])

        Component rows = Selectors.iterable(this, "rows").iterator().hasNext() ?
                Selectors.iterable(this, "rows").iterator().next() : null
        if (rows != null) {
            new ArrayList(_extraRows).each { row ->
                rows.appendChild(row)
            }
        }

        Selectors.wireVariables(this, this, null)
        Selectors.wireComponents(this, this, false)
        Selectors.wireEventListeners(this, this)

        _rendered = true
    }

    @Override
    boolean insertBefore(Component newChild, Component refChild) {
        if (newChild instanceof Row) {
            _extraRows.add(newChild as Row)
            return true
        } else {
            return super.insertBefore(newChild, refChild)
        }
    }

    @Override
    boolean appendChild(Component child) {
        if (child instanceof Row) {
            _extraRows.add(child as Row)
            return true
        } else {
            return super.appendChild(child)
        }
    }

    void setLabel(String label) {
        this.label = label
        if (_rendered) render()
    }

    String getLabel() {
        return label
    }

    void setValue(IIndirizzo value) {
        indirizzo = value as IIndirizzo
        tipoIndirizzo = getTipoIndirizzoFromValue(indirizzo)
        if (_rendered) render()
    }

    IIndirizzo getValue() {
        return indirizzo
    }

    void setShowAnp(Boolean showAnp) {
        this.showAnp = showAnp
        if (_rendered) render()
    }

    Boolean getShowAnp() {
        return showAnp
    }

    void setIndirizzoComparison(IIndirizzo indirizzoComparison) {
        this.indirizzoComparison = indirizzoComparison
        if (_rendered) render()
    }

    IIndirizzo getIndirizzoComparison() {
        return indirizzoComparison
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


    String getSclassViaFormatted() {
        if (showAnp != true || indirizzoComparison == null) return ''
        try {
            def value1 = indirizzo?.hasProperty('viaFormatted') ? indirizzo.viaFormatted : (indirizzo?.hasProperty('via') ? indirizzo.via : null)
            def value2 = indirizzoComparison?.hasProperty('viaFormatted') ? indirizzoComparison.viaFormatted : (indirizzoComparison?.hasProperty('via') ? indirizzoComparison.via : null)
            return value1 != value2 ? 'redText' : ''
        } catch (Exception e) {
            return ''
        }
    }

    String getSclassVia() {
        if (showAnp != true || indirizzoComparison == null) return ''
        try {
            def value1 = indirizzo?.hasProperty('via') ? indirizzo.via : (indirizzo?.hasProperty('viaFormatted') ? indirizzo.viaFormatted : null)
            def value2 = indirizzoComparison?.hasProperty('via') ? indirizzoComparison.via : (indirizzoComparison?.hasProperty('viaFormatted') ? indirizzoComparison.viaFormatted : null)
            return value1 != value2 ? 'redText' : ''
        } catch (Exception e) {
            return ''
        }
    }

    String getSclassComune() {
        if (showAnp != true || indirizzoComparison == null) return ''
        try {
            def codice1 = indirizzo?.hasProperty('comune') ? indirizzo.comune?.codice : null
            def codice2 = indirizzoComparison?.hasProperty('comune') ? indirizzoComparison.comune?.codice : null
            return codice1 != codice2 ? 'redText' : ''
        } catch (Exception e) {
            return ''
        }
    }

    String getSclassZipcode() {
        if (showAnp != true || indirizzoComparison == null) return ''
        if (!(indirizzo instanceof IIndirizzoResidenteEstero) || !(indirizzoComparison instanceof IIndirizzoResidenteEstero)) return 'redText'
        try {
            return indirizzo.zipcode != indirizzoComparison.zipcode ? 'redText' : ''
        } catch (Exception e) {
            return ''
        }
    }

    String getSclassProvinciaContea() {
        if (showAnp != true || indirizzoComparison == null) return ''
        if (!(indirizzo instanceof IIndirizzoResidenteEstero) || !(indirizzoComparison instanceof IIndirizzoResidenteEstero)) return 'redText'
        try {
            return indirizzo.provinciaContea != indirizzoComparison.provinciaContea ? 'redText' : ''
        } catch (Exception e) {
            return ''
        }
    }

    String getSclassPresso() {
        if (showAnp != true || indirizzoComparison == null) return ''
        if (!(indirizzo instanceof IIndirizzoResidenteEstero) || !(indirizzoComparison instanceof IIndirizzoResidenteEstero)) return 'redText'
        try {
            return indirizzo.presso != indirizzoComparison.presso ? 'redText' : ''
        } catch (Exception e) {
            return ''
        }
    }


    String getSclassConsolato() {
        if (showAnp != true || indirizzoComparison == null) return ''
        if (!(indirizzo instanceof IIndirizzoResidenteEstero) || !(indirizzoComparison instanceof IIndirizzoResidenteEstero)) return 'redText'
        try {
            return "${indirizzo.codiceConsolato} - ${indirizzo.sedeConsolato}" != "${indirizzoComparison.codiceConsolato} -  ${indirizzoComparison.sedeConsolato}" ? 'redText' : ''
        } catch (Exception e) {
            return ''
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