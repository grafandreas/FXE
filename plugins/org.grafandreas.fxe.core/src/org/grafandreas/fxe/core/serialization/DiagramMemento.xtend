/*********************************************************************
* Copyright (c) 2017-2020 Andreas Graf
*
* This program and the accompanying materials are made
* available under the terms of the Eclipse Public License 2.0
* which is available at https://www.eclipse.org/legal/epl-2.0/
*
* SPDX-License-Identifier: EPL-2.0
**********************************************************************/
package org.grafandreas.fxe.core.serialization

import com.fasterxml.jackson.annotation.JsonProperty
import com.google.common.collect.Lists
import java.util.List
import javafx.scene.Node
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtend.lib.annotations.Accessors
import org.grafandreas.fxe.core.Diagram

/**
 * A simple class to store the state of a diagram
 * 
 */
class DiagramMemento  {
	@JsonProperty
	@Accessors
	protected var String name;
	
	@JsonProperty
	@Accessors
	protected var String type;
	
	@JsonProperty
	@Accessors
	protected var List<EObject> domainObjects;
	
	@JsonProperty
	@Accessors
	protected var List<Node> symbols;
	
	
	def public void getState(Diagram d) {
		name = d.name
		type = d.type
		domainObjects = Lists.newArrayList(d.domainObjects)
		symbols =  Lists.newArrayList(d.symbolLayer.children)
	}
	
	def public void restore(Diagram d) {
		d.name = name
		d.type = type
		d.domainObjects.clear
		d.domainObjects.addAll(domainObjects)
		
		d.symbolLayer.children.clear
		d.symbolLayer.children.addAll(symbols)
	}
	
	public new(Diagram d) {
		getState(d)
	}
	
	// Default constructor required e.g. for Json
	//
	public new() {
		
	}
	
	
	
	
}