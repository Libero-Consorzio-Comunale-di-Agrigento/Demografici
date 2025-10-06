package it.finmatica.de4gsdzk.ansc

class AnscInfoStepInvio {

    static final String TIPO_BASE = "B"
    static final String TIPO_ALLEGATO = "A"
    static final String TIPO_FIRMATARIO = "F"

    private final String tipo
    private final int sequenza
    private final AnscEndPointServizioArchivio servizioCdu
    private final List<IAnscOggettoInvio> oggettiInvio

    AnscInfoStepInvio(String tipo, int sequenza, AnscEndPointServizioArchivio servizioCdu, List<IAnscOggettoInvio> oggettiInvio){
        this.tipo = tipo
        this.sequenza = sequenza
        this.servizioCdu = servizioCdu
        this.oggettiInvio = oggettiInvio
    }

    AnscEndPointServizioArchivio getServizioCdu() {
        return servizioCdu
    }

    List<IAnscOggettoInvio> getOggettiInvio(){
        return oggettiInvio
    }

    Boolean isTipoBase(){
        return (tipo == TIPO_BASE)
    }

    Boolean isTipoAllegato(){
        return (tipo == TIPO_ALLEGATO)
    }

    int getSequenza() {
        return sequenza
    }

}
