package it.finmatica.de4gsdzk.ansc


import it.finmatica.de4gsdzk.utils.ETipoArchivioAnsc

class AnscInfoAllegatoCdu implements IAnscOggettoInvio {

    static final String STATO_DA_FASCICOLARE = "DF"
    static final String STATO_FASCICOLATO = "FA"
    static final String STATO_DA_INVIARE = "DI"
    static final String STATO_INVIATO = "IN"

    private final AnscEndPointServizioArchivio servizioCdu
    private final String stato
    private final Long idAllegato
    private final Long idTipoDocumentoFascicolo
    private final String descrizioneTipoDocumentoFascicolo
    private final String nome
    private final Boolean flagObbligatorio
    private final List<AnscComunicazioneAllegato> comunicazioni
    private Boolean flagDaAttestareAnsc
    private Boolean flagFirmatoAttestazioneAnsc

    AnscInfoAllegatoCdu(AnscEndPointServizioArchivio servizioCdu, String stato, Long idAllegato,
                        Long idTipoDocumentoFascicolo, String descrizioneTipoDocumentoFascicolo,
                        String nome, Boolean flagObbligatorio, List<AnscComunicazioneAllegato> comunicazioni,
                        Boolean flagDaAttestareAnsc, Boolean flagFirmatoAttestazioneAnsc){
        this.servizioCdu = servizioCdu
        this.stato = stato
        this.idAllegato = idAllegato
        this.idTipoDocumentoFascicolo = idTipoDocumentoFascicolo
        this.descrizioneTipoDocumentoFascicolo = descrizioneTipoDocumentoFascicolo
        this.nome = nome
        this.flagObbligatorio = flagObbligatorio
        this.comunicazioni = comunicazioni
        this.flagDaAttestareAnsc = flagDaAttestareAnsc
        this.flagFirmatoAttestazioneAnsc = flagFirmatoAttestazioneAnsc
    }

    AnscEndPointServizioArchivio getServizioCdu() {
        return servizioCdu
    }

    ETipoArchivioAnsc getTipoArchivioComunicazione() {
        return ETipoArchivioAnsc.ALL
    }

    String getStato() {
        return stato
    }

    Boolean isDaFascicolare(){
        return (stato == STATO_DA_FASCICOLARE)
    }

    Boolean isFascicolato(){
        return (stato == STATO_FASCICOLATO)
    }

    Boolean isDaInviare(){
        return (stato == STATO_DA_INVIARE)
    }

    Boolean isInviato(){
        return (stato == STATO_INVIATO)
    }

    Long getIdAllegato() {
        return idAllegato
    }

    Long getIdDomain() {
        if (isDaInviare()){
            return idAllegato
        }
        return null
    }

    Long getIdTipoDocumentoFascicolo() {
        return idTipoDocumentoFascicolo
    }

    String getDescrizioneTipoDocumentoFascicolo() {
        return descrizioneTipoDocumentoFascicolo
    }

    String getNome() {
        return nome
    }

    Boolean getFlagObbligatorio() {
        return flagObbligatorio
    }

    List<AnscComunicazioneAllegato> getComunicazioni() {
        return comunicazioni
    }

    AnscComunicazioneAllegato getUltimaComunicazione(){
        AnscComunicazioneAllegato ultima = null
        if (comunicazioni?.size()>0){
            for (AnscComunicazioneAllegato cal:comunicazioni){
                if (cal.flagUltima) {
                    ultima = cal
                    break
                }
            }
        }
        return ultima
    }

    Boolean getFlagDaAttestareAnsc(){
        return this.flagDaAttestareAnsc
    }

    void setFlagDaAttestareAnsc(Boolean flagDaAttestareAnsc){
        this.flagDaAttestareAnsc = flagDaAttestareAnsc
    }

    Boolean getFlagFirmatoAttestazioneAnsc(){
        return this.flagFirmatoAttestazioneAnsc
    }

    Boolean isR006(){
        return this.servizioCdu.servizio.servizio.equals('R006')
    }
}
