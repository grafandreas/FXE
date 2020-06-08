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
import javafx.scene.Parent
import javafx.scene.input.MouseEvent
import javax.inject.Inject
import javax.inject.Singleton
import org.apache.log4j.Logger
import org.grafandreas.fxe.core.NodeUtils
import org.grafandreas.fxe.core.anchor.Connection

@Singleton
class MoveManager {

	val logger = Logger.getLogger(MoveManager)
	
	Point2D mouseS
	
	@Inject
	extension NodeUtils

	def public register(Node n) {
		
		
		n.addEventHandler(MouseEvent.MOUSE_PRESSED,[ event |
			val ref = n.parent
			println("lkdjdljdlgjlkgj")
			n.cursor = Cursor.CLOSED_HAND
			  mouseS = ref.sceneToLocal(event.getSceneX(),event.getSceneY() );
			  println(ref)
			  println(mouseS)
			  event.consume
		])

		n.addEventHandler(MouseEvent.MOUSE_RELEASED, [ event |
			n.cursor = Cursor.OPEN_HAND
			
		
			n.allChildren.filter(Connection).forEach[updateEndpoints]
		])

		n.addEventHandler(MouseEvent.MOUSE_DRAGGED, [ event |
			event.consume
			val ref = n.parent
			println("ipoipipipio")
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
           
           	n.layoutX = n.layoutX+delta.x
           	n.layoutY = n.layoutY+delta.y
           	
            println(n.layoutX)
            println(n.translateX)
            
            logger.debug(n.layoutX)
            logger.debug(n.translateX)
            println("+++")
            if(ref instanceof Group) {
				println(ref.boundsInLocal)
				println(ref.boundsInParent)
			}
			if(ref instanceof Parent) {
				if(n.translateX < 0) {
					val dX = n.translateX
					ref.children.filter[!(it instanceof Connection)].forEach[it.translateX = it.translateX-dX]
				}
			}
			
            mouseS = ref.sceneToLocal(event.getSceneX(),event.getSceneY() );
            println(mouseS)
            println("*************************************************************************")
            	
            n.parent.allChildren.filter(Connection).forEach[updateEndpoints]
		])
	}

}
