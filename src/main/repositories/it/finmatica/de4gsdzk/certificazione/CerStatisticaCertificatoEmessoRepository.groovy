package it.finmatica.de4gsdzk.certificazione

import org.springframework.data.jpa.repository.JpaRepository

interface CerStatisticaCertificatoEmessoRepository extends JpaRepository<CerStatisticaCertificatoEmesso, Long>, CerStatisticaCertificatoEmessoCustomRepository {

}