/*********************************************************************
* Copyright (c) 2017-2020 Andreas Graf
*
* This program and the accompanying materials are made
* available under the terms of the Eclipse Public License 2.0
* which is available at https://www.eclipse.org/legal/epl-2.0/
*
* SPDX-License-Identifier: EPL-2.0
**********************************************************************/
package org.grafandreas.fxe.core.moving

import javafx.scene.Node
import javafx.scene.input.MouseEvent
import javax.inject.Inject
import javax.inject.Singleton
import org.grafandreas.fxe.core.ESelectionManager
import org.grafandreas.fxe.core.IFEAdaptable

@Singleton
class SelManager {
	
	@Inject
	ESelectionManager selectionManager
	
	def public void register(Node nm) {
		println("//!"+nm)
		nm.addEventHandler(MouseEvent.MOUSE_PRESSED, [
			
			println("/!")
			println(it)
			println(it.target)
			var n = pickResult.intersectedNode
			println("/!" + n)
			while (n !== null && !(n instanceof IFEAdaptable)) {
				n = n.parent
				println("!" + n)
			}
			println("=" + n)

			if (n instanceof IFEAdaptable) {
				println("++++++++++++++++++++" + selectionManager)
				if(!it.controlDown)
					selectionManager.clear();
					
				selectionManager.select(n)
	
			}
			return
		])
	}
}