package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.TipoAttoUtils
import org.hibernate.annotations.Immutable

import javax.persistence.*

@Entity
@Immutable
@Table(name = "CERCIV_FILTRO")
@IdClass(CerStatoCivileFiltroCompositeId.class)
class CerStatoCivileFiltro {

    @Id
    @Column(name = "TIPO_ARCHIVIO")
    Integer tipoArchivio

    @Id
    @Column(name = "ID")
    Long id

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "FILTRO", nullable = true)
    CerFiltro filtro

    ETipoAtto getTipoAttoEnum() {
        return TipoAttoUtils.fromValoreDefault(this.tipoArchivio.intValue())
    }

    @Column(name = "ID_ATTO")
    String idAtto

    @Column(name = "COGNOME")
    String cognome

    @Column(name = "NOME")
    String nome

    @Column(name = "D_DATA_NAS")
    Date dataNascita

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO")
    ESesso sesso

    @Column(name = "COD_REC")
    Boolean codRec

    @Column(name = "ANNO")
    Short anno

    @Column(name = "ATTO")
    Short atto

    @Column(name = "PARTE")
    Boolean parte

    @Column(name = "SERIE")
    String serie

    @Column(name = "ID_ATTO_ANSC")
    String idAttoAnsc

    @Column(name = "NUMERO_UNICO")
    Long numeroUnico


}