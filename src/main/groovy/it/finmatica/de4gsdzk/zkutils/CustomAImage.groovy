package it.finmatica.de4gsdzk.zkutils

import org.zkoss.image.AImage

class CustomAImage extends AImage{

    private final String customWidth

    public CustomAImage(String name, byte[] data, String customWidth) throws IOException {
        super(name, data)
        this.customWidth = customWidth
    }

    String getCustomWidth() {
        return customWidth
    }
}
