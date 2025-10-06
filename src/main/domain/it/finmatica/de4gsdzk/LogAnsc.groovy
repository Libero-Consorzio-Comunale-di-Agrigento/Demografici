package it.finmatica.de4gsdzk

import groovy.transform.CompileStatic

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Table

@Entity
@Table(name = "ANSC_LOG_V")
@CompileStatic
class LogAnsc extends LogBaseDomain {

    @Column(name = "SERVIZIO")
    String servizio

    @Column(name = "ID_ATTO", nullable = true)
    String idAtto

    @Column(name = "NOTE_ASSISTENZA", nullable = true)
    String noteAssistenza
}
