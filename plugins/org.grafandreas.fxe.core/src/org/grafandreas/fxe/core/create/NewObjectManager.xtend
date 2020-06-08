/*********************************************************************
* Copyright (c) 2017-2020 Andreas Graf
*
* This program and the accompanying materials are made
* available under the terms of the Eclipse Public License 2.0
* which is available at https://www.eclipse.org/legal/epl-2.0/
*
* SPDX-License-Identifier: EPL-2.0
**********************************************************************/
package org.grafandreas.fxe.core.create

import javafx.beans.value.ChangeListener
import javafx.beans.value.ObservableValue
import javafx.geometry.Point2D
import javafx.scene.Parent
import javafx.scene.input.ScrollEvent
import javafx.scene.layout.StackPane
import javax.inject.Inject
import org.apache.log4j.Logger
import org.eclipse.emf.edit.provider.ComposedAdapterFactory
import org.eclipse.emf.edit.provider.ReflectiveItemProviderAdapterFactory
import org.eclipse.emf.edit.provider.resource.ResourceItemProviderAdapterFactory
import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider
import org.eclipse.swt.graphics.Image
import org.grafandreas.fxe.core.NodeUtils
import javafx.scene.control.Label
import javafx.geometry.Insets
import javafx.scene.input.MouseEvent
import org.eclipse.emf.ecore.provider.EcoreItemProviderAdapterFactory
import javafx.embed.swt.SWTFXUtils
import javafx.scene.image.WritableImage
import javafx.scene.Node
import javafx.scene.layout.Region
import javafx.scene.image.ImageView

class NewObjectManager implements INewObjectManager {
	val logger = Logger.getLogger(NewObjectManager)
	
	StackPane stackPane = null
	@Inject
	extension NodeUtils
	override invoke(Parent layer, ICreateFeatureProvider featureProvider, Point2D coord) {
		
		logger.debug("Invoke")
		if(stackPane !== null)
			layer.children.remove(stackPane)
			
		stackPane = new StackPane();
		stackPane.setStyle("-fx-background-color:white; -fx-border-color: white; -fx-effect: dropshadow(three-pass-box, rgba(0,0,0,0.8), 10, 0, 0, 0);");
		
		val changeListener = new ChangeListener() {
			
			override changed(ObservableValue arg0, Object arg1, Object arg2) {
				if(arg2 == false) {
					logger.debug("Out of focus")
					layer.children.remove(stackPane)
					logger.debug("Out of focus -")
				}
			}
			
		}
		
		
			var ComposedAdapterFactory adapterFactory = new
			ComposedAdapterFactory(ComposedAdapterFactory.Descriptor.Registry.INSTANCE);
			adapterFactory.addAdapterFactory(new ResourceItemProviderAdapterFactory());
			adapterFactory.addAdapterFactory(new EcoreItemProviderAdapterFactory());
			adapterFactory.addAdapterFactory(new
			ReflectiveItemProviderAdapterFactory());
			val labelProvider = new AdapterFactoryLabelProvider(adapterFactory);
			
			featureProvider.provideCreateFeature.forEach[p|
			var Node added = null ; 
			
			if(p instanceof EClassBasedCreateFeature) {
				println("!!!!!!!!!")
				println(labelProvider.getText(p.EClass))
				println(labelProvider.getImage(p.EClass))
				
				val dummy = p.EClass.EPackage.EFactoryInstance.create(p.EClass)
				println(labelProvider.getImage(dummy))
				val img  = labelProvider.getImage(dummy);
				var limg = new WritableImage(img.imageData.width,img.imageData.height)
				SWTFXUtils.toFXImage(img.imageData,limg)
				var imgview = new ImageView();
				imgview.image = limg;
				imgview.setStyle("-fx-background-color:white");
				stackPane.children.add(imgview)
				added = imgview
				
			} else {
				val label = new Label(p.label);
		        label.setStyle("-fx-background-color:white");
		        label.setPadding(new Insets(5,5,5,5));   
		        stackPane.getChildren().add(label);
		        added = label
	        }
	        added.addEventFilter(MouseEvent.MOUSE_PRESSED, [
	       
	        	logger.debug("Jo")
	        	try {
        		stackPane.hoverProperty.removeListener(changeListener)
	        	layer.children.remove(stackPane)
	       		p.execute(coord)
				logger.debug("Creating new "+p.label)
				} catch(Exception ex) {
					ex.printStackTrace
					throw ex
				}
			
				
		
			])
		
		]
	
//		stackPane.children.tail.forEach[visible = false]
//  		stackPane.children.head.visible = true
        
       
        logger.debug("Blub")
        layer.children.forEach[println(it)]
//       	layer.children.clear
       	
       	layer.children.add(stackPane);
      	stackPane.layout
       	stackPane.setTranslateX(coord.x-20);
		stackPane.setTranslateY(coord.y-20);
		
        
      
   		stackPane.visible = true
   		logger.debug("& "+stackPane.boundsInParent.width/2)
   		
   		stackPane.addEventFilter(ScrollEvent.SCROLL, [
			println("SCROLL "+it)
			if(it.deltaY > 0) {
				stackPane.children.last.toBack
			} else if(it.deltaY < 0 ) {
				stackPane.children.head.toFront
			}
			
//			stackPane.children.tail.forEach[visible = false]
//  			stackPane.children.head.visible = true
        
		])
		
//		stackPane.addEventFilter(MouseEvent.MOUSE_PRESSED, [
//			logger.debug("Creating new")
//			
//		
//		])
		
		stackPane.hoverProperty.addListener(changeListener)
	}
}