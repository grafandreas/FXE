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

import javafx.geometry.Point2D
import javafx.scene.Cursor
import javafx.scene.Group
import javafx.scene.Node
import javafx.scene.input.MouseEvent
import javax.inject.Singleton

@Singleton
class ConnectionMoveManager {

	
	Point2D mouseS
	
	

	def public register(Node n) {
		
		
		n.addEventHandler(MouseEvent.MOUSE_PRESSED,[ event |
			val ref = n.parent
			println("mewnr,ewnr,rm,mnr,mrn,mrn,rmwnrw,rm")
			n.cursor = Cursor.CLOSED_HAND
			  mouseS = ref.sceneToLocal(event.getSceneX(),event.getSceneY() );
			  println(ref)
			  println(mouseS)
		])

		n.addEventHandler(MouseEvent.MOUSE_RELEASED, [ event |
			n.cursor = Cursor.OPEN_HAND
			
		])

		n.addEventHandler(MouseEvent.MOUSE_DRAGGED, [ event |
			val ref = n.parent
			println("poyivovypoicpovcpocpovcpoc")
			println(ref)
			if(ref instanceof Group) {
				println(ref.boundsInLocal)
				println(ref.boundsInParent)
			}
			val mouseN = ref.sceneToLocal(event.getSceneX(),event.getSceneY() );
			println(mouseN)
			
			 val delta = mouseN.subtract(mouseS)
           	println(delta)
           	println(n)
           	println(n.getLayoutX)
           	println(delta.x)
           	println(n.getLayoutX() + delta.x)
           
           	n.translateX = n.translateX+delta.x
           	n.translateY = n.translateY+delta.y
           	
            println(n.layoutX)
            println(n.translateX)
            println("+++")
            if(ref instanceof Group) {
				println(ref.boundsInLocal)
				println(ref.boundsInParent)
			}
			
            mouseS = ref.sceneToLocal(event.getSceneX(),event.getSceneY() );
            println(mouseS)
            println("*************************************************************************")
            
            event.consume
		])
	}

}
