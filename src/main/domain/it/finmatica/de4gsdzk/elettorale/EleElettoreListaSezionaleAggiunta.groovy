package it.finmatica.de4gsdzk.elettorale

import javax.persistence.*

@Entity
@Table(name = "ELELSAA_V")
class EleElettoreListaSezionaleAggiunta extends EleElettoreListaSezionaleBaseDomain {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TIPO_LISTA", nullable = true)
    EleTipoLista tipoLista
}
