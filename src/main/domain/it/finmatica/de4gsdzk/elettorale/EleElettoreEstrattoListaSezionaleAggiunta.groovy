package it.finmatica.de4gsdzk.elettorale

import javax.persistence.*

@Entity
@Table(name = "ELESELA_V")
class EleElettoreEstrattoListaSezionaleAggiunta extends EleElettoreListaSezionaleBaseDomain {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TIPO_LISTA", nullable = true)
    EleTipoLista tipoLista
}
