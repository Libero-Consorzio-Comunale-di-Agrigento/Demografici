package it.finmatica.de4gsdzk

import groovy.transform.CompileStatic

import javax.persistence.Entity
import javax.persistence.Table

@Entity
@Table(name = "ISTAT_LOG_V")
@CompileStatic
class LogIstat extends LogBaseDomain {}
