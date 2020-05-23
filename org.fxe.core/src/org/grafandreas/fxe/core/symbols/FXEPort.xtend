/*********************************************************************
* Copyright (c) 2017-2020 Andreas Graf
*
* This program and the accompanying materials are made
* available under the terms of the Eclipse Public License 2.0
* which is available at https://www.eclipse.org/legal/epl-2.0/
*
* SPDX-License-Identifier: EPL-2.0
**********************************************************************/
package org.grafandreas.fxe.core.symbols

import com.google.common.collect.Lists
import com.google.common.reflect.TypeToken
import java.util.List
import javafx.beans.binding.Bindings
import javafx.beans.property.SimpleObjectProperty
import javafx.beans.value.ChangeListener
import javafx.beans.value.ObservableValue
import javafx.collections.FXCollections
import javafx.collections.ListChangeListener
import javafx.geometry.Pos
import javafx.scene.Group
import javafx.scene.control.Label
import javafx.scene.layout.HBox
import javafx.scene.layout.Pane
import javafx.scene.paint.Color
import javafx.scene.shape.Polygon
import javafx.scene.shape.Rectangle
import javax.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtend.lib.annotations.Accessors
import org.grafandreas.fxe.core.FXEComponent
import org.grafandreas.fxe.core.IDomainObjectReferrer
import org.grafandreas.fxe.core.IFEAdaptable
import org.grafandreas.fxe.core.IFXESelectionFeature
import org.grafandreas.fxe.core.IFXESelectionHighlightFeature
import org.grafandreas.fxe.core.IFXEShapeBorderCalc
import org.grafandreas.fxe.core.anchor.AbstractAnchor
import org.grafandreas.fxe.core.anchor.IAnchor
import org.grafandreas.fxe.core.di.IInit
import org.grafandreas.fxe.core.impl.DefaultSelectionFeature
import org.grafandreas.fxe.core.impl.SelectionHighlightBorderFeature
import org.grafandreas.fxe.core.labels.ILabelled
import org.grafandreas.fxe.core.labels.ILabeller
import org.grafandreas.fxe.core.moving.MoveManager
import org.grafandreas.fxe.core.moving.SelManager

class FXEPort  extends Group implements IFEAdaptable, IDomainObjectReferrer<EObject>, IInit, ILabelled {

	
	

	
	
	protected Label bla
	
	protected Pane box

	val protected domainObjects = initDomainObjects
	

	
	
	def public void setDomainObjects(List<String> l) {
		domainObjects.clear
	
	}
	
	
	val protected mainDomainObject = new SimpleObjectProperty<EObject>
		
	
	
	Object movemanager
	
	Rectangle portRect
	
	Polygon poly
	
	protected ILabeller labeller
	protected IAnchor anchor = null
	
	@Accessors(PUBLIC_GETTER)
	Group pg
	
	
	@Inject
	new(MoveManager movemananger, SelManager selManager) {
		
		this.movemanager = movemanager
		
		movemananger.register(this)
		selManager.register(this)
		
		children += box =  new HBox => [
			alignment = Pos.CENTER_RIGHT
			style="-fx-spacing : 5;"

			children += bla = new Label("Bla") => [
				alignment = Pos.CENTER_RIGHT
			]
			portRect =  new Rectangle => [
			
				
				widthProperty.bind(Bindings.multiply(0.7,bla.heightProperty))
				heightProperty.bind(Bindings.multiply(0.7,bla.heightProperty))
				bla.heightProperty.addListener(new ChangeListener() {
					
					override changed(ObservableValue observable, Object oldValue, Object newValue) {
						calcPoly
					}
					
				})
				
				stroke = Color.BLACK
				fill = Color.TRANSPARENT
				
			]
			children += pg = new Group => [
				children += portRect
				children += poly = new Polygon(#[5.0,5.0,20.0,10.0,5.0,20.0])
			]
			calcPoly
		
		]
	}
	
	def calcPoly() {
		poly.points.set(2,portRect.width -5 )
		poly.points.set(5,portRect.width -5 )
			poly.points.set(3,(portRect.width -5)/2+2 )
	}
	override <T> getAdapter(TypeToken<? extends T> tok, String role) {
		if(tok.isSupertypeOf(TypeToken.of(IFXESelectionFeature)))
			return new DefaultSelectionFeature<FXEComponent>() as T;
		
		if(tok.isSupertypeOf(TypeToken.of(IFXEShapeBorderCalc))) {
			val r =  new IFXEShapeBorderCalc() {
				
				override get() {
					portRect
				}
				
			};
			
			return (r as Object) as T;
		}
		
		if(tok.isSupertypeOf(TypeToken.of(IFXESelectionHighlightFeature)))
			return new SelectionHighlightBorderFeature(this) as T;
			
		if(tok.isSupertypeOf(TypeToken.of(IAnchor))) {
			if(anchor === null)
				anchor = new AbstractAnchor() {
					
					override anchorNode() {
						box
					}
					
				}
			return anchor as T
		}
			
		return null;
	}
	
	override domainObjects() {
		domainObjects
	}
	
	override mainDomainObject() {
	 	mainDomainObject
	}

	
	override init() {
		println("## INIT")
		mainDomainObject.addListener(
			new ChangeListener() {
				
				override changed(ObservableValue arg0, Object arg1, Object arg2) {
					println("'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"+portIsOnRight)
					val index = box.children.indexOf(bla);
					println(index)
					box.children.remove(index);

					if (!portIsOnRight) {
						box.children.add(bla)
					} else {
						box.children.add(0, bla)
					}
				}

			}
		)

	}
	
	override getDisplayLabel() {
		bla
	}
	
	def public portIsOnRight() {
		true
	}
	

	
}