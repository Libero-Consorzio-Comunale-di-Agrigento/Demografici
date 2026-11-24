package it.finmatica.de4gsdzk

import groovy.transform.CompileStatic

import javax.persistence.Entity
import javax.persistence.Table

@Entity
@Table(name = "WS_MININT_LOG_V")
@CompileStatic
class LogWsMinisteroInterno extends LogBaseDomain {}
