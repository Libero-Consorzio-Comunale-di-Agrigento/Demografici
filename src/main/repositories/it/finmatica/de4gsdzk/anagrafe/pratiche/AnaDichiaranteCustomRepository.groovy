package it.finmatica.de4gsdzk.anagrafe.pratiche


import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest

interface AnaDichiaranteCustomRepository {

    Page<AnaDichiarante>  listAllByRicercaPratica (RicercaPratica r, PageRequest p)

}