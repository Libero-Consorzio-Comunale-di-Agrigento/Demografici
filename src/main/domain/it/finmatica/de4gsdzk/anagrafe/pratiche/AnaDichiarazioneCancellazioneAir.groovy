package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.GsdBaseDomain

import javax.persistence.*

@Entity
@Table(name = "ANAC01_V_ZK")
class AnaDichiarazioneCancellazioneAir  extends GsdBaseDomain {

    @Id
    @Column(name = "ID")
    Long id

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANATPR")
    AnaPratica pratica

    @Embedded
    ModelloAireCancellazione modelloAireCancellazione

    ModelloAireCancellazione getModelloAireCancellazione() {
        if (modelloAireCancellazione == null) {
            modelloAireCancellazione = new ModelloAireCancellazione()
        }
        return modelloAireCancellazione
    }

    void setModelloAireCancellazione(ModelloAireCancellazione c) {
        this.modelloAireCancellazione = c
    }
    
    
}
