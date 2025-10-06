package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.ESesso
import org.hibernate.annotations.Immutable

import javax.persistence.*

@Entity
@Immutable
@Table(name = "CERANA_FILTRO")
class CerAnagrafeFiltro extends GsdBaseDomain {

    @Id
    @Column(name = "ID", nullable = false)
    String id

    @Column(name = "MATRICOLA", nullable = true)
    Integer matricola

    @Column(name = "COGNOME", nullable = false)
    String cognome

    @Column(name = "NOME", nullable = false)
    String nome

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO", nullable = false)
    ESesso sesso

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS", nullable = false)
    Date dataNascita

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "ID_CERCTC", nullable = false)
    CerCategoriaTipoCertificato categoriaTipoCertificato

    @Column(name = "TIPO_ARCHIVIO", nullable = true)
    Integer tipoArchivio

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "FILTRO", nullable = true)
    CerFiltro filtro

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_CONTROLLO", nullable = true)
    CerCodiceControllo codiceControllo

}
