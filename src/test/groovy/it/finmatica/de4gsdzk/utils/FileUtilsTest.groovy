package it.finmatica.de4gsdzk.utils

import spock.lang.Specification

class FileUtilsTest extends Specification {
    def "Dovrebbe rimuovere i caratteri non consentiti"() {
        when:
        String sanitized = FileUtils.sanitizeFilename(original)

        then:
        sanitized == expected

        where:
        original | expected
        "XYZ"     | "XYZ"
        "XYZ XYZ" | "XYZXYZ"
        "XYZ/XYZ" | "XYZXYZ"
    }
}
