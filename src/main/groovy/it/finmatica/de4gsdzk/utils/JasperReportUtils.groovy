package it.finmatica.de4gsdzk.utils

class JasperReportUtils {

    // opzioni
    final static String OPTION_MIRROR_LAYOUT        = "mirrorLayout"
    final static String OPTION_MIRROR_MARGINS       = "mirrorMargins"
    final static String OPTION_CHECK_SINGLE_PAGE    = "checkSinglePage"
    final static String OPTION_DATASOURCE           = "dataSource"
    final static String OPTION_MIRROR_EXCLUDED      = "mirrorExcluded"

    static String sanitizeXml(String value) {
        if (!value) return value
        return value.replaceAll(/[^\u0009\u000A\u000D\u0020-\uD7FF\uE000-\uFFFD]/, '')
    }
}
