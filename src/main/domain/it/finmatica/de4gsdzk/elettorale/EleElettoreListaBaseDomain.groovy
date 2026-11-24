package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.EStatoElettore

import javax.persistence.*

@MappedSuperclass
class EleElettoreListaBaseDomain extends GsdBaseDomain {

    @Id
    @Column(name = "MATRICOLA")
    Long id

    Long getMatricola() {
        return id
    }

    @Column(name = "PROGR_LISTA_GEN", nullable = true, updatable = false, insertable = false)
    Long progressivo

    @Column(name = "ANNO", nullable = true, updatable = false, insertable = false)
    Integer anno

    @Column(name = "FASCICOLO", nullable = true, updatable = false, insertable = false)
    Long fascicolo

    @Column(name = "SEZIONE", nullable = true, updatable = false, insertable = false)
    Integer sezione

    @Column(name = "COGNOME_NOME", nullable = true, updatable = false, insertable = false)
    String cognomeNome

    @Column(name = "LUOGO_DATA_NAS", nullable = true, updatable = false, insertable = false)
    String luogoDataNascita

    @Column(name = "ATTO", nullable = true, updatable = false, insertable = false)
    String atto

    @Column(name = "TRIBUNALE", nullable = true, updatable = false, insertable = false)
    String tribunale

    @Column(name = "INDIRIZZO", nullable = true, updatable = false, insertable = false)
    String indirizzo

    @Enumerated(EnumType.STRING)
    @Column(name = "STATO", nullable = false)
    EStatoElettore stato

    @Column(name = "EMIGRATO", nullable = true, updatable = false, insertable = false)
    String emigrato

    @Column(name = "MOTIVO_1", nullable = true, updatable = false, insertable = false)
    String motivo1

    @Column(name = "MOTIVO_2", nullable = true, updatable = false, insertable = false)
    String motivo2

    @Column(name = "VERBALE_1", nullable = true, updatable = false, insertable = false)
    String verbale1

    @Column(name = "VERBALE_2", nullable = true, updatable = false, insertable = false)
    String verbale2
}
