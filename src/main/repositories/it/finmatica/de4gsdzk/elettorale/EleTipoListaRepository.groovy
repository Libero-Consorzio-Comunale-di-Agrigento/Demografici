package it.finmatica.de4gsdzk.elettorale

import org.springframework.data.jpa.repository.JpaRepository

interface EleTipoListaRepository extends JpaRepository<EleTipoLista, String> {

    EleTipoLista findById(String id)

}