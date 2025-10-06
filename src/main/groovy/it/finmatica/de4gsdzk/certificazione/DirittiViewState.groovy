package it.finmatica.de4gsdzk.certificazione

class DirittiViewState {

    DirittoViewState segreteria
    DirittoViewState statoCivile
    DirittoViewState cartaIdentita
    DirittoViewState rimborsoStampati
    DirittoViewState bollo

    DirittiViewState() {
        segreteria = new DirittoViewState(EDiritto.SEGRETERIA)
        statoCivile = new DirittoViewState(EDiritto.STATO_CIVILE)
        cartaIdentita = new DirittoViewState(EDiritto.CARTA_IDENTITA)
        rimborsoStampati = new DirittoViewState(EDiritto.RIMBORSO_STAMPATI)
        bollo = new DirittoViewState(EDiritto.BOLLO)
    }

    void switchEditable(EDiritto diritto) {
        switch (diritto) {
            case EDiritto.SEGRETERIA:
                segreteria.switchEditable()
                break
            case EDiritto.STATO_CIVILE:
                statoCivile.switchEditable()
                break
            case EDiritto.CARTA_IDENTITA:
                cartaIdentita.switchEditable()
                break
            case EDiritto.RIMBORSO_STAMPATI:
                rimborsoStampati.switchEditable()
                break
            case EDiritto.BOLLO:
                bollo.switchEditable()
                break
            default:
                throw new IllegalArgumentException("Diritto ${diritto} non gestito")
        }
    }

    void setImporto(EDiritto diritto, BigDecimal importo) {
        switch (diritto) {
            case EDiritto.SEGRETERIA:
                segreteria.importo = importo
                break
            case EDiritto.STATO_CIVILE:
                statoCivile.importo = importo
                break
            case EDiritto.CARTA_IDENTITA:
                cartaIdentita.importo = importo
                break
            case EDiritto.RIMBORSO_STAMPATI:
                rimborsoStampati.importo = importo
                break
            case EDiritto.BOLLO:
                bollo.importo = importo
                break
            default:
                throw new IllegalArgumentException("Diritto ${diritto} non gestito")
        }
    }

    @Deprecated
    void setDescrizioneFromTariffaDirittoMap(Map<EDiritto, CerTariffaDiritto> diritti) {
        segreteria.setDescrizione(diritti[EDiritto.SEGRETERIA]?.descrizione)
        statoCivile.setDescrizione(diritti[EDiritto.STATO_CIVILE]?.descrizione)
        cartaIdentita.setDescrizione(diritti[EDiritto.CARTA_IDENTITA]?.descrizione)
        rimborsoStampati.setDescrizione(diritti[EDiritto.RIMBORSO_STAMPATI]?.descrizione)
        bollo.setDescrizione(diritti[EDiritto.BOLLO]?.descrizione)
    }

    void resetImporto(){
        segreteria.resetImporto()
        statoCivile.resetImporto()
        cartaIdentita.resetImporto()
        rimborsoStampati.resetImporto()
        bollo.resetImporto()
    }

    class DirittoViewState {
        private EDiritto diritto
        private Boolean editable
        private String descrizione
        private BigDecimal importo

        DirittoViewState(EDiritto diritto) {
            this.diritto = diritto
            this.editable = Boolean.FALSE
        }

        void switchEditable() {
            this.editable = !this.editable
        }

        Boolean isEditable() {
            return editable
        }

        void setDescrizione(String descrizione) {
            this.descrizione = descrizione
        }

        String getDescrizione() {
            return descrizione
        }

        void setImporto(BigDecimal importo) {
            this.importo = importo
        }

        BigDecimal getImporto() {
            return importo
        }

        void resetImporto(){
            this.importo = null
        }

    }
}
