package restrict.statocivile

import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.event.InputEvent

/**
 * Lista di stringhe generica, con filtro istantaneo
 *
 * TODO: trasformare in componente
 */
trait TraitTemplateListaStringhe {

    List<String> listaStringhe

    String labelCercaStringhe

    int listaStringheSize = 8

    private final List<String> listaOriginale = new LinkedList<>()

    /**
     * Imposta la lista
     *
     * @param lista la lista di stringhe
     * @param labelPlaceholder il testo del placeholder per il filtro
     */
    void setListaStringhe(List<String> lista, String labelPlaceholder, int size=0) {
        labelCercaStringhe = labelPlaceholder
        listaStringhe = lista
        listaOriginale.clear()
        listaOriginale.addAll(lista)
        if (size) {
            listaStringheSize = size
        }
        BindUtils.postNotifyChange(null, null, this, "listaStringhe")
    }

    @Command void onChanging(@ContextParam(ContextType.TRIGGER_EVENT) InputEvent event) {
        listaStringhe.clear()
        String val = event.getValue().toUpperCase()
        for (String var : listaOriginale)
            if (var.toUpperCase().contains(val))
                listaStringhe.add(var)
        BindUtils.postNotifyChange(null, null, this, "listaStringhe")
    }

}