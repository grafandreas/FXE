/*********************************************************************
* Copyright (c) 2017-2020 Andreas Graf
*
* This program and the accompanying materials are made
* available under the terms of the Eclipse Public License 2.0
* which is available at https://www.eclipse.org/legal/epl-2.0/
*
* SPDX-License-Identifier: EPL-2.0
**********************************************************************/
package org.grafandreas.fxe.core.impl

import com.google.common.reflect.TypeToken
import javafx.scene.Node
import javafx.scene.Scene
import javax.inject.Inject
import org.grafandreas.fxe.core.IFEAdaptable
import org.grafandreas.fxe.core.IFXESelectionFeature
import org.grafandreas.fxe.core.IFXESelectionHighlightFeature

class DefaultSelectionFeature<T extends IFEAdaptable> implements IFXESelectionFeature<T> {
	
	@Inject
	Scene scene
	
	override canBeSelected(T ob) {
		true
	}
	
	override select(T ob) {
		println("Select!")
		println(ob)
		val highlight = ob.getAdapter(TypeToken.of(IFXESelectionHighlightFeature))
		highlight.activate
		if(ob instanceof Node) 
			ob.requestFocus 
			
		
		true
	}
	
	override deselect(T ob) {
		
		val highlight = ob.getAdapter(TypeToken.of(IFXESelectionHighlightFeature))
		highlight.deactivate
		
		true
	}
	
}