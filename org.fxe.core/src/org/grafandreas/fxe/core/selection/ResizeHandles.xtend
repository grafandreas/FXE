/*********************************************************************
* Copyright (c) 2017-2020 Andreas Graf
*
* This program and the accompanying materials are made
* available under the terms of the Eclipse Public License 2.0
* which is available at https://www.eclipse.org/legal/epl-2.0/
*
* SPDX-License-Identifier: EPL-2.0
**********************************************************************/
package org.grafandreas.fxe.core.selection

import com.google.common.reflect.TypeToken
import javafx.beans.binding.Bindings
import javafx.scene.Group
import javafx.scene.Node
import javafx.scene.shape.Rectangle
import org.grafandreas.fxe.core.IFEAdaptable
import org.grafandreas.fxe.core.IFXEShapeBorderCalc

class ResizeHandles extends Group {
	
	
	Rectangle nw
	
	Rectangle n
	
	new(IFEAdaptable owner) {
		val sborderA = owner.getAdapter(TypeToken.of(IFXEShapeBorderCalc))
		val border = sborderA.get
		
		val onode = owner as Node
		
		val wProp = switch(border) {
			Rectangle : border.widthProperty
			default: null
		}
		if(wProp !== null) {
			val halfWidth = Bindings.divide(wProp,2)
			children += nw = new Rectangle => [
				width = 10
				height = 10
				
				layoutXProperty.bind(Bindings.add(-width, (owner as Node).layoutXProperty))
				
				layoutYProperty.bind(Bindings.add(-height, (owner as Node).layoutYProperty))
				
				styleClass += "resize-handle"
			]
			
			children += n = new Rectangle => [
				width = 10
				height = 10
				
				layoutXProperty.bind(Bindings.add(Bindings.add(-width/2, halfWidth),onode.layoutXProperty))
				layoutYProperty.bind(Bindings.add(-height, (owner as Node).layoutYProperty))
				
				styleClass += "resize-handle"
			]
			
		}
	}
}