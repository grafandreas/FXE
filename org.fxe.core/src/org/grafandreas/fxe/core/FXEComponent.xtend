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

import com.fasterxml.jackson.annotation.JsonProperty
import com.google.common.collect.Lists
import com.google.common.reflect.TypeToken
import com.google.inject.Injector
import java.util.List
import javafx.beans.property.SimpleObjectProperty
import javafx.collections.FXCollections
import javafx.collections.ListChangeListener
import javafx.geometry.Pos
import javafx.scene.Group
import javafx.scene.Node
import javafx.scene.control.Label
import javafx.scene.layout.BorderPane
import javafx.scene.layout.VBox
import javafx.scene.paint.Color
import javafx.scene.shape.Rectangle
import javax.inject.Inject
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.sphinx.emf.util.WorkspaceEditingDomainUtil
import org.eclipse.xtend.lib.annotations.Accessors
import org.grafandreas.fxe.core.di.IInit
import org.grafandreas.fxe.core.handles.IHandleProvider
import org.grafandreas.fxe.core.impl.DefaultSelectionFeature
import org.grafandreas.fxe.core.impl.SelectionHighlightBorderFeature
import org.grafandreas.fxe.core.labels.ILabelled
import org.grafandreas.fxe.core.labels.ILabeller
import org.grafandreas.fxe.core.moving.MoveManager
import org.grafandreas.fxe.core.moving.SelManager
import org.grafandreas.fxe.core.selection.ResizeHandles
import org.eclipse.sphinx.emf.util.EcorePlatformUtil

class FXEComponent extends Group implements IFEAdaptable, IDomainEObjectReferrer, ILabelled, IInit {

	@Inject
	protected Injector injector
	
	Group handle
	Rectangle border
	
	protected Label bla
	
	@Accessors(PUBLIC_GETTER)
	protected BorderPane bpane

	
	@Accessors(PUBLIC_GETTER)
	protected VBox lSide
	@Accessors(PUBLIC_GETTER)
	protected VBox rSide
	
	@JsonProperty
	@Accessors(PUBLIC_GETTER)
	val protected leftPorts = FXCollections.observableList(Lists.<Node>newArrayList)  => [
		it.addListener( new ListChangeListener() {
			override onChanged(Change c) {
				while(c.next) {
					if(c.wasAdded || c.wasRemoved) {
						lSide.children += c.addedSubList
						lSide.children -= c.removed
					}
				}
			}
			
		})
	]
	def public void setLeftPorts(List<Node> l) {
		leftPorts.clear
		leftPorts.addAll(l)
	}

	@JsonProperty
	@Accessors(PUBLIC_GETTER)
	val protected rightPorts = FXCollections.observableList(Lists.<Node>newArrayList)   => [
		it.addListener( new ListChangeListener() {
			override onChanged(Change c) {
				while(c.next) {
					if(c.wasAdded || c.wasRemoved) {
						rSide.children += c.addedSubList
						rSide.children -= c.removed	
					}
				}
			}
			
		})
	]
	
	def public void setRightPorts(List<Node> l) {
		rightPorts.clear
		rightPorts.addAll(l)
	}
	
	
	var IFXEShapeBorderCalc borderCache = null
	
	val protected domainObjects = initDomainObjects	
	val protected mainDomainObject = new SimpleObjectProperty<EObject>
	

	
	Object movemanager
	
	@Accessors(PUBLIC_GETTER)
	protected ILabeller labeller
	
	@Inject
	new( MoveManager movemananger, SelManager selManager) {
		
		this.movemanager = movemanager
		
		this.pickOnBounds = false
		
		movemananger.register(this)
		selManager.register(this)
		
		children += bpane =  new BorderPane => [
			
			
			top = bla = new Label("Bla")
			layoutX = 0
			layoutY = 0
			
			BorderPane.setAlignment(top,Pos.TOP_CENTER)
			
			center = new Rectangle => [
				width = 20
				height = 12
				fill = Color.TRANSPARENT
			]

		]
		
		bpane.setStyle("-fx-background-color: linear-gradient(from 25% 25% to 100% 100%, #00c6ff, #0072ff); -fx-border-color: black; -fx-stroke-width: 5;");
		

		children += border = new Rectangle => [
			widthProperty.bind(bpane.widthProperty)
			heightProperty.bind(bpane.heightProperty)
			fill = Color.TRANSPARENT
			stroke = Color.BLACK
			mouseTransparent = true
		]
		
		rSide = new VBox => [
			alignment = Pos.TOP_RIGHT
		]
		
		lSide = new VBox => [
			alignment = Pos.TOP_LEFT
		]
		bpane.right = rSide
		bpane.left = lSide
		
		
		
		

	
		
	}
	
	override <T> getAdapter(TypeToken<? extends T> tok, String role) {
		if(tok.isSupertypeOf(TypeToken.of(IFXESelectionFeature)))
			return new DefaultSelectionFeature<FXEComponent>() as T;
		
		if(tok.isSupertypeOf(TypeToken.of(IFXEShapeBorderCalc))) {
			borderCache = borderCache ?:  new IFXEShapeBorderCalc() {
				
				override get() {
					border
				}
				
			};
			
			return (borderCache as Object) as T;
		}
		
		if(tok.isSupertypeOf(TypeToken.of(IFXESelectionHighlightFeature)))
			return new SelectionHighlightBorderFeature(this) as T;
			
		val me = this
		if(tok.isSupertypeOf(TypeToken.of(IHandleProvider))) {
			val r = new IHandleProvider() {
				
				override createHandles() {
					Lists.newArrayList(new ResizeHandles(me));
				}
				
			} 
			return (r as Object) as T
		}
			
		return null;
	}
	
	override domainObjects() {
		domainObjects
	}

	override mainDomainObject() {
		mainDomainObject
	}
	

	
	override getDisplayLabel() {
		bla
	}
	
	override init() {
	
	}
	
	
	
}
