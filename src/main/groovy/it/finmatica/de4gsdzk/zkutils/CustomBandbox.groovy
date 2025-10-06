package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.zk.ui.IdSpace
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.EventListener
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.event.InputEvent
import org.zkoss.zk.ui.select.annotation.Listen
import org.zkoss.zk.ui.select.annotation.Wire
import org.zkoss.zul.*

abstract class CustomBandbox extends Bandbox implements IdSpace {

	@Wire("listbox")
	protected Listbox listbox
	@Wire("paging")
	protected Paging paging
	@Wire("textbox")
	protected Textbox textbox
	@Wire("image")
	protected Image image
	@Wire("label")
	protected Label label

	long totalSize = 0
	
	private def selectedItem

	Boolean selectedFromList = Boolean.FALSE
	protected Boolean onChangePreventDefault = Boolean.FALSE

	Map<String, String> etichette = [:]

	protected String errorTitle = "Validazione"
	protected String errorMsg = "Dato non valido"

	protected String attributoDaLeggere

	static {
		addClientEvent(CustomBandbox.class, CustomEvents.ON_CHANGE_PREVENT_DEFAULT, CE_IMPORTANT);
	}

	public CustomBandbox() {

		setWidgetListener('onOpen', '''
			var listbox = zk.Widget.$(jq("@listbox", this));
			if (event.open) {
				listbox.setSelectedIndex(-1);
			} else {
				listbox.fireOnSelect(listbox);
			}
			''')

		setWidgetListener('onKeyUp', '''
			if (!this.isOpen()) {
				return;
			}
			var listbox = zk.Widget.$(jq("@listbox", this));
			if (listbox.lastItem === undefined) { // la listbox non ha figli, non faccio nulla
				return;
			}
			if (event.data.keyCode === 38) { // freccia su
				if (listbox.getSelectedIndex() > 0) {
					listbox.setSelectedIndex(listbox.getSelectedIndex()-1);
				} else {
					listbox.setSelectedIndex(listbox.lastItem.getChildIndex()-1);
				}
			} else if (event.data.keyCode === 40) { // freccia giu
				if ((listbox.getSelectedIndex() + 1) < listbox.lastItem.getChildIndex()) {
					listbox.setSelectedIndex(listbox.getSelectedIndex()+1);
				} else {
					listbox.setSelectedIndex(0);
				}
			}''')

		this.addEventListener(Events.ON_CHANGE, new org.zkoss.zk.ui.event.EventListener() {
			public void onEvent(Event event) {
				textbox?.setValue(getValue())
				if (getValue()){
					if (selectedFromList){
						selectedFromList = Boolean.FALSE
						return
					}
					if (onChangePreventDefault){
						Events.sendEvent(CustomEvents.ON_CHANGE_PREVENT_DEFAULT, CustomBandbox.this, getValue())
						return
					}
					paging.setActivePage(0)
					loadData(getValue(), Boolean.TRUE)
					if (listbox.getModel()?.size() == 0 || listbox.getModel()?.size() > 1){
						Messagebox.show(errorMsg, errorTitle, Messagebox.OK, Messagebox.ERROR)
						setSelectedItem(null)
					} else
					if (listbox.getModel()?.size() == 1){
						autoFill()
					}
				} else {
					setSelectedItem(null)
					selectedFromList = Boolean.FALSE
				}
			}
		});
		
		this.addEventListener(Events.ON_CHANGING, new org.zkoss.zk.ui.event.EventListener() {
			public void onEvent(Event event) {
				selectedFromList = Boolean.FALSE
				textbox?.setValue(event.getValue())
				if (event.getTarget().isOpen() || ((!event.getTarget().isOpen()) && (!this.isAutodrop()))){
					paging.setActivePage(0)
					loadData(event.getValue())
				}
				autoFill()
			}
		});

		this.addEventListener(Events.ON_OPEN, new org.zkoss.zk.ui.event.EventListener() {
			public void onEvent(Event event) {
				if (event.open) {
					textbox?.setValue(event.getValue())
					paging.setActivePage(0)
					loadData(event.getValue())
				}
			}
		});

		setAutodrop(true)
		setMold("rounded")
	}

	void setOnChangePreventDefaultListener(EventListener listener) {
		addEventListener(CustomEvents.ON_CHANGE_PREVENT_DEFAULT, listener as EventListener<? extends Event>)
	}
	
	protected abstract void loadData(String filtro, Boolean searchEqual=Boolean.FALSE);
	
	def getSelectedItem(){
		return this.selectedItem
	}
	
	void setSelectedItem(def item) {
		this.selectedItem = item
		if (item){
			if (((attributoDaLeggere?:"") == "") && (item instanceof String)){
				setValue(item)
				textbox?.setValue(item)
			} else {
				setValue(item."$attributoDaLeggere")
				textbox?.setValue(item."$attributoDaLeggere")
			}
		} else {
			setValue(null)
			textbox?.setValue("")
			listbox.setSelectedItem(null)
			paging.setActivePage(0)
			if (isOpen()){
				loadData(null)
			}
		}
		Events.sendEvent(Events.ON_SELECT, this, item)
	}
	
	void autoFill(){
		if (listbox.getModel()?.size() == 1){
			setSelectedItem(listbox.getModel()[0])
			if (isOpen()){
				close()
			}
		}
	}
	
	@Listen("onSelect = listbox")
	public void selectData() {
		if (listbox.getSelectedItem()){
			selectedFromList = Boolean.TRUE
			setSelectedItem(listbox.getSelectedItem().getValue())
			if (isOpen()){
				close()
			}
		}
	}
	
	@Listen("onPaging = paging")
	public void onPaging () {
		//FIXME
		loadData(textbox?.getValue())
	}
	
	@Listen("onClick = image")
	public void onImgClick () {
		// Altrimenti non svuota
		setValue(textbox.getValue())
		setSelectedItem(null)
	}
	
	@Listen("onOK = textbox")
	public void onTxbOk () {
		paging.setActivePage(0)
		loadData(textbox.getValue())
		autoFill()
	}
	
	@Listen("onChanging = textbox")
	public void onTxbChanging (InputEvent event) {
		paging.setActivePage(0)
		loadData(event.getValue())
		autoFill()
	}

	static final List<Map> etichetteBB = [Etichette.ricerca_tooltip, Etichette.filtro_ricerca_placeholder, Etichette.Numero_record_trovati,
										  Etichette.Validazione, Etichette.Dato_non_valido]
	
}
