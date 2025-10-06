package it.finmatica.de4gsdzk.anagrafe


import it.finmatica.de4gsdzk.utils.ICodiceMovimentoEvento

import javax.persistence.*

@MappedSuperclass
abstract class CodiceMovimentoEvento implements ICodiceMovimentoEvento {

    @Convert(converter = EnumCodiceMovimentoToIntConverter.class)
    @Column(name = "COD_MOV", nullable = false)
    ECodiceMovimento codiceMovimento

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_EVE", nullable = false)
    AnaCodiceEvento codiceEvento

    @Converter
    static class EnumCodiceMovimentoToIntConverter implements AttributeConverter<ECodiceMovimento, Integer> {
        @Override
        Integer convertToDatabaseColumn(ECodiceMovimento ee) {
            return (ee != null) ? ee.id : null
        }

        @Override
        ECodiceMovimento convertToEntityAttribute(Integer value) {
            return (value != null) ? ECodiceMovimento.valueOfId(value) : null
        }
    }
}
