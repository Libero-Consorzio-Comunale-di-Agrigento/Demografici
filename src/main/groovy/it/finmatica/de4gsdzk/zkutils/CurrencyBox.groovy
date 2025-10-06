package it.finmatica.de4gsdzk.zkutils


import org.zkoss.zk.ui.sys.ContentRenderer
import org.zkoss.zul.Decimalbox

class CurrencyBox extends Decimalbox {

    private static final String DEFAULT_STYLE = "text-align: right"
    static final String DEFAULT_FORMAT = "€ #,##0.00"

    CurrencyBox() {
        super()
        setStyle(DEFAULT_STYLE)
        setFormat(DEFAULT_FORMAT)
    }

    @Override
    protected void renderProperties(ContentRenderer renderer) throws IOException {
        super.renderProperties(renderer)
        renderer.render("mold", "rounded")
        renderer.render("sclass", DEFAULT_STYLE)
        renderer.render("format", getFormat())
    }
}