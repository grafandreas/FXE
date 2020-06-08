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

import com.google.common.reflect.TypeToken
import com.google.inject.Injector
import javafx.beans.property.SimpleObjectProperty
import javafx.event.EventHandler
import javafx.geometry.Point2D
import javafx.scene.Group
import javafx.scene.Node
import javafx.scene.control.ScrollPane
import javafx.scene.input.DragEvent
import javafx.scene.input.MouseButton
import javafx.scene.input.MouseEvent
import javafx.scene.input.ScrollEvent
import javafx.scene.input.TransferMode
import javafx.scene.layout.Pane
import javafx.scene.layout.StackPane
import javafx.scene.shape.Rectangle
import javax.inject.Inject
import org.apache.log4j.Logger
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.transaction.RecordingCommand
import org.eclipse.jface.util.LocalSelectionTransfer
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.xtend.lib.annotations.Accessors
import org.grafandreas.fxe.core.create.IAddFeature
import org.grafandreas.fxe.core.create.ICreateFeatureProvider
import org.grafandreas.fxe.core.create.NewObjectManager

abstract class Diagram extends StackPane implements IDomainEObjectReferrer, IFEAdaptable, ICreateFeatureProvider {
	
	
	val logger = Logger.getLogger(Diagram)
	@Inject
	protected transient  Injector injector
	
	@Accessors(PUBLIC_GETTER) 
	protected transient  Group rootGroup
	
	@Accessors(PUBLIC_GETTER)
	protected transient Group zoomGroup
	
	@Accessors(PUBLIC_GETTER)
	protected transient Pane symbolLayer
	
	@Accessors(PUBLIC_GETTER)
	protected transient Group inspectionLayer
	
	@Accessors(PUBLIC_GETTER)
	protected transient Pane handleLayer
	
	protected transient ScrollPane scrollPane
	
	 @Inject protected transient  ESelectionManager selectionManager
	 
	 @Inject protected transient  NewObjectManager newObjectManager
	 
	 
	 @Inject protected IEditingDomainLink editingDomainLink
	val protected domainObjects = initDomainObjects	
	val protected mainDomainObject = new SimpleObjectProperty<EObject>
	
	@Accessors
	protected String name;
	@Accessors
	protected String type;	
	
	new()  {
		
		rootGroup = new Group
		scrollPane = new ScrollPane() => [
			pannable = true
			content = rootGroup
		]
	    this.styleClass.add("root")
		symbolLayer = new Pane
		inspectionLayer = new Group
		
		handleLayer = new Pane => [
			pickOnBounds = false
			background = null
		]
		
		// The layers that should be affected by zoom
		//
		zoomGroup = new Group => [
			children += symbolLayer
			children += inspectionLayer
		]
		
		rootGroup.children += zoomGroup ;
		
		this.children.add(scrollPane)
		this.children.add(handleLayer)
		//
		//		rootGroup.children += handleLayer
		
		
		setOnDragOver([ DragEvent arg0 |
			
			println("("+arg0.getX+":"+arg0.getY+") @"+arg0.target)
			System::out.println(LocalSelectionTransfer::getTransfer().getSelection())
		
			arg0.acceptTransferModes(TransferMode::COPY_OR_MOVE)
		] )
		
		setOnDragDropped(([ DragEvent arg0 |
			System::out.println("Added!")
			println(injector)
			try {
				
				val addFeature = this.getAdapter(TypeToken.of(IAddFeature));
				val sel = LocalSelectionTransfer::getTransfer().getSelection();
				if (sel instanceof IStructuredSelection) {
					val dos = sel.toList
					
					val ed = editingDomainLink.from(dos.head as EObject)
					val rc = new RecordingCommand(ed) {
						
						override protected doExecute() {
							addFeature.execute(dos, new Point2D(arg0.x,arg0.y))
						}
						
						override canUndo() {
							true
						}
						
					}
					logger.debug("Executing in "+ed)
					ed.commandStack.execute(rc)

				}
				
			
				
			
			

			} catch (Exception ex) {
				println(ex);
				ex.printStackTrace
				throw ex;
			}

		] as EventHandler<DragEvent>)) 
		
//		symbolLayer.addEventHandler(MouseEvent.MOUSE_CLICKED,[
//			println("#?!")
//			selectionManager.clear
//		])
//		
//		symbolLayer.addEventFilter(MouseEvent.MOUSE_CLICKED,[
//			println("#?!+"+it)
//		])
		
		this.addEventFilter(MouseEvent.MOUSE_PRESSED,[	
			println("#?!"+it) 
		
			println(it.pickResult.intersectedNode)
			if(!(it.target instanceof Rectangle) && !it.secondaryButtonDown )
				selectionManager.clear
			])
		
		
		this.addEventFilter(ScrollEvent.SCROLL, [
			println("SCROLL "+it)
			if(it.controlDown) {
				val scaleFactor = it.deltaY / 100
				zoomGroup.scaleX = Math.max(0,zoomGroup.scaleX + scaleFactor)
				zoomGroup.scaleY =  Math.max(0,zoomGroup.scaleY + scaleFactor)
				println(zoomGroup.scaleX)
				it.consume
			}
		])
		
		this.addEventHandler(MouseEvent.MOUSE_PRESSED, [
			println("HARRYB"+it.button)
			if(it.button === MouseButton.SECONDARY) {
				newObjectManager.invoke(handleLayer,this, new Point2D(it.sceneX,it.sceneY));
			}
		])
		
	
	}
	
	def scrollPane() {
		scrollPane as ScrollPane
	}
	
	def root() {
		this as Node
	}
	
	
	override domainObjects() {
		domainObjects
	}
	
	override <T> getAdapter(TypeToken<? extends T> tok, String role) {
		null
	}
	
	override mainDomainObject() {
		mainDomainObject
	}
	

}