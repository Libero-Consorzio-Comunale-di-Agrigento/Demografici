package it.finmatica.de4gsdzk.elettorale

import ch.qos.logback.classic.db.names.ColumnName

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import javax.persistence.Table

@Entity
@Table(name = "ELELGAA_V")
class EleElettoreListaGeneraleAggiunta extends EleElettoreListaBaseDomain {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TIPO_LISTA", nullable = true)
    EleTipoLista tipoLista

}
