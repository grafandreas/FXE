/*********************************************************************
* Copyright (c) 2017-2020 Andreas Graf
*
* This program and the accompanying materials are made
* available under the terms of the Eclipse Public License 2.0
* which is available at https://www.eclipse.org/legal/epl-2.0/
*
* SPDX-License-Identifier: EPL-2.0
**********************************************************************/
package org.grafandreas.fxe.core

import com.google.common.io.CharStreams
import com.google.common.reflect.TypeToken
import com.google.inject.Guice
import com.google.inject.Injector
import com.google.inject.Module
import com.google.inject.util.Modules
import com.mrlonee.radialfx.moviemenu.RadialMovieMenu
import java.io.ByteArrayInputStream
import java.io.InputStreamReader
import java.util.function.Consumer
import javafx.embed.swt.FXCanvas
import javafx.event.EventHandler
import javafx.scene.Scene
import javafx.scene.control.Label
import javafx.scene.input.DragEvent
import javafx.scene.input.KeyCode
import javafx.scene.input.KeyEvent
import javafx.scene.input.MouseEvent
import javafx.scene.input.TransferMode
import javafx.scene.text.Font
import javax.inject.Inject
import org.apache.log4j.Logger
import org.eclipse.core.resources.IResource
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.jface.util.LocalSelectionTransfer
import org.eclipse.swt.SWT
import org.eclipse.swt.dnd.Clipboard
import org.eclipse.swt.dnd.TextTransfer
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.ui.IEditorInput
import org.eclipse.ui.IEditorPart
import org.eclipse.ui.IEditorSite
import org.eclipse.ui.PartInitException
import org.eclipse.ui.part.EditorPart
import org.eclipse.ui.part.FileEditorInput
import org.eclipse.ui.views.properties.IPropertySheetPage
import org.eclipse.ui.views.properties.tabbed.ITabbedPropertySheetPageContributor
import org.eclipse.ui.views.properties.tabbed.TabbedPropertySheetPage
import org.eclipse.xtend.lib.annotations.Accessors
import org.grafandreas.fxe.core.di.BasicFXEModule
import org.grafandreas.fxe.core.serialization.DiagramMemento
import org.grafandreas.fxe.core.serialization.LoaderSaver

public abstract class FXE extends EditorPart implements IFEAdaptable, ITabbedPropertySheetPageContributor {
	@Inject  protected Injector injector

	@Accessors(PUBLIC_GETTER)
	@Inject protected ESelectionManager selectionManager
	@Inject protected LoaderSaver loaderSaver = new LoaderSaver
	
	@Inject IEditingDomainLink editingDomainLink
	
	IPropertySheetPage propertySheetPage

	Scene scene

	Font bgFont
	
	RadialMovieMenu radialMenu
	
	val logger = Logger.getLogger(FXE)

	override void doSave(IProgressMonitor monitor) { // TODO Auto-generated method stub
	}

	override void doSaveAs() { // TODO Auto-generated method stub
	}

	override void init(IEditorSite site, IEditorInput input) throws PartInitException {

		var Injector oinjector = Guice::createInjector(Modules.override(basicModule).with(
			configureModule
		))

		oinjector.injectMembers(this)
		setSite(site)
		setInput(input)

	}

	override boolean isDirty() {
		val r = editingDomainLink?.from()?.commandStack?.mostRecentCommand != null
		 //firePropertyChange(IEditorPart.PROP_DIRTY);
		 r
	}

	override boolean isSaveAsAllowed() {
		// TODO Auto-generated method stub
		return false
	}
	
	

	override void createPartControl(Composite parent) {


		var FXCanvas fxCanvas = new FXCanvas(parent, SWT::NONE)
	  
		var Label label = new Label("X") 
		label.setOnDragOver(([ DragEvent arg0 |
			System::out.println(arg0)
			System::out.println(arg0.getGestureSource())
			System::out.println(arg0.getAcceptingObject())
			System::out.println(arg0.getDragboard().getTransferModes())
			System::out.println(arg0.getDragboard().getString())
			System::out.println(arg0.getDragboard().getUrl())
			var Display display = Display::getCurrent()
			System::out.println(display)
			val Clipboard cb = new Clipboard(display)
			System::out.println(cb)
			var TextTransfer transfer = TextTransfer::getInstance()
			System::out.println(transfer)
			var String data = (cb.getContents(LocalSelectionTransfer::getTransfer()) as String)
			System::out.println(LocalSelectionTransfer::getTransfer().getSelection())
			System::out.println(data)
			System::out.println(cb.getAvailableTypeNames().get(0))
			arg0.acceptTransferModes(TransferMode::COPY_OR_MOVE)
		] as EventHandler<DragEvent>))

	    diagram = injector.getInstance(Diagram)
		println("DIAGRAMMMMMMMMMMMMMMMMM" + diagram)

		val input = editorInput
		println(input)
		
//		val stackP = new StackPane()
//		stackP.children.add(new Group())
//		stackP.children.add(scrollP)
		scene = new Scene(diagram)
		fxCanvas.setScene(scene)
		
		scene.addEventHandler(KeyEvent.KEY_PRESSED, [
			logger.debug(it)
			if(it.code == KeyCode.F3 ) {
				logger.debug(it.text)
				try {
					logger.debug("J")
					val content = loaderSaver.jsonSave(diagram)
					val ip = editorInput
					println(ip)
					if(ip instanceof FileEditorInput) {
						val f = ip.file
						val is = new ByteArrayInputStream(content.bytes)
						f.setContents( is, IResource.NONE, new NullProgressMonitor)
					}
					
				
				} catch(Exception ex ) {
					ex.printStackTrace
				}
			}
		])
		

		val fontStream = FXE.getResourceAsStream("/fonts/fonts/fontawesome-webfont.ttf");
		if (fontStream != null) {
			bgFont = Font.loadFont(fontStream, 36);
			fontStream.close();
			println(bgFont.name)
		}

		scene.addEventFilter(MouseEvent.MOUSE_PRESSED,[x|println("+!+"+x)])
		println("URL:" + FXE.getResource("/css/resize.css"))
		scene.stylesheets.add(FXE.getResource("/css/resize.css").toExternalForm)
		scene.getStylesheets().add(FXE.getResource("/fonts/fontstyle.css").toExternalForm());
//		scene.getStylesheets().add(FXE.getResource("/fonts/fonts/font-awesome-4.7.0/css/font-awesome.css").toExternalForm());
		selectionManager.owner = this
		selectionManager.root = diagram
		getSite().getWorkbenchWindow().getSelectionService().addPostSelectionListener(selectionManager)
		getSite().selectionProvider = selectionManager
		
		
			val double itemInnerRadius = 60;
	val double itemRadius = 95;
	val double centerClosedRadius = 8;
	val double centerOpenedRadius = 12;
 
	val  menus = #[ "Layout", "Remove", "Delete", "Edit"]
			radialMenu = new RadialMovieMenu(menus, itemInnerRadius, itemRadius,
		centerClosedRadius, centerOpenedRadius, new Consumer<String> () {
			
		
			
			override accept(String arg0) {
				println("99999999999 "+arg0)
				popUpCallback(arg0)
			}
			
		});

	radialMenu.setTranslateX(0);
	radialMenu.setTranslateY(200);
	diagram.handleLayer.getChildren().addAll(radialMenu);

	if(input instanceof FileEditorInput) {
		logger.debug("initing editing domain link "+input.file.project)
		editingDomainLink.from(input.file.project)
		logger.debug(editingDomainLink.from)
		val jsonC = CharStreams.toString( new InputStreamReader(input.file.contents) )
		
			println("!+ "+injector)
			loaded = loaderSaver.jsonLoad(jsonC,classLoader4Deserialization,injector)   
			logger.debug("Loaded "+loaded)
			
		
		
	}
		
	if(loaded !== null) {
		loaded.restore(diagram)
	}
		

	}

	def abstract void popUpCallback(String s);
	override void setFocus() { // TODO Auto-generated method stub
	}

	override <T> T getAdapter(TypeToken<? extends T> tok, String role) {
		// TODO Auto-generated method stub
		return null
	}

	override <T> getAdapter(Class<T> adapter) {
		println("Get Adapter " + adapter)
		if (IPropertySheetPage.equals(adapter)) {
			if (propertySheetPage == null)
				propertySheetPage = new TabbedPropertySheetPage(this);
			println(propertySheetPage)
			return propertySheetPage as T;

		}
		super.<T>getAdapter(adapter)
	}

	override getContributorId() {
		return "org.artop.aal.examples.explorer.views.autosarExplorer"
	}

	def abstract public Module configureModule();

//	def public IPropertySheetPage getPropertySheetPage() {
//		if (propertySheetPage == null) {
//			val epsp = new ExtendedPropertySheetPage(null);
//			propertySheetPage = epsp
//			epsp.setPropertySourceProvider(
//				new AdapterFactoryContentProvider(
//					new ComposedAdapterFactory(ComposedAdapterFactory.Descriptor.Registry.INSTANCE)
//				)
//			)
//		}
//		return propertySheetPage;
//	}
	val protected basicModule = new BasicFXEModule() 
	
	@Accessors(PUBLIC_GETTER)
	Diagram diagram
	
	DiagramMemento loaded = null;
	
	override protected setInput(IEditorInput input) {
		super.setInput(input)
	
	}
	
	def abstract ClassLoader classLoader4Deserialization() 
}
