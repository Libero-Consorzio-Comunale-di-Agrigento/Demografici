package it.finmatica.de4gsdzk

import groovy.transform.CompileStatic

import javax.persistence.Entity
import javax.persistence.Table

@Entity
@Table(name = "FIRMAREMOTA_LOG_V")
@CompileStatic
class LogFirmaRemota extends LogBaseDomain {}
