package it.finmatica.de4gsdzk.statocivile.embed

import javax.persistence.Column
import javax.persistence.Embeddable

@Embeddable
class Comune {

    @Column(name = "COD_COM", nullable = false)
    Integer codice
    @Column(name = "DES_COM", updatable = false, insertable = false)
    String descrizione
    @Column(name = "COD_PRO", nullable = false)
    Integer codiceProvincia
    @Column(name = "SIGLA_PRO", updatable = false, insertable = false)
    String siglaProvincia

    @Override
    boolean equals(Object obj) {
        if (this.is(obj)) return true
        if (obj == null || getClass() != obj.getClass()) return false
        Comune that = (Comune) obj;
        return Objects.equals(descrizione, that.descrizione) &&
                Objects.equals(siglaProvincia, that.siglaProvincia)
    }

}
