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
import org.grafandreas.fxe.core.IFEAdaptable
import org.grafandreas.fxe.core.IFXESelectionHighlightFeature
import org.grafandreas.fxe.core.IFXEShapeBorderCalc

class SelectionHighlightBorderFeature implements IFXESelectionHighlightFeature {
	
	IFEAdaptable target
	
	new(IFEAdaptable x) {
		this.target = x
	}
	override activate() {
		println("Activate!")
		val sborderA = target.getAdapter(TypeToken.of(IFXEShapeBorderCalc))
		val border = sborderA.get
		println(border)
		 val cssDefault = '''
		 	-fx-stroke: black;
		 	-fx-stroke-width: 3;
		 	    -fx-stroke-dash-array: 12 2 4 2;
		 	    -fx-stroke-dash-offset: 6;
		 	    -fx-stroke-line-cap: butt;
		 '''
//        border.style = cssDefault
        border.styleClass.add("selected")
      
		true
	}
	
	override deactivate() {
		
		val sborderA = target.getAdapter(TypeToken.of(IFXEShapeBorderCalc))
		val border = sborderA.get
		
		if(border === null) {
			println('''FCK �sborderA�''')
			return false
		}
		 border.styleClass.remove("selected")
		 val cssDefault = '''
		 	-fx-stroke: black;
		 	    -fx-stroke-width: 1;
		 	    -fx-stroke-line-cap: butt;
		 '''
//		  border.style = cssDefault
		true 
	}
	
}