/*********************************************************************
* Copyright (c) 2017-2020 Andreas Graf
*
* This program and the accompanying materials are made
* available under the terms of the Eclipse Public License 2.0
* which is available at https://www.eclipse.org/legal/epl-2.0/
*
* SPDX-License-Identifier: EPL-2.0
**********************************************************************/
package org.grafandreas.fxe.core.anchor

import com.google.common.collect.Lists
import java.util.List
import javafx.geometry.Point2D
import javafx.scene.Group
import javafx.scene.Node
import javafx.scene.shape.Polyline
import javax.inject.Inject
import org.eclipse.xtend.lib.annotations.Accessors
import org.grafandreas.fxe.core.di.IInit
import org.grafandreas.fxe.core.moving.ConnectionMoveManager

class Connection extends Group implements IConnection, IInit {
	
	
	@Accessors
	val Polyline line = new Polyline
	@Accessors
	val Polyline hitLine =new Polyline
	@Accessors
	var Node fromNode
	@Accessors
	var Node toNode
	@Accessors
	var protected IAnchor fromNodeAnchor
	@Accessors
	var protected IAnchor toNodeAnchor
	@Accessors
	var List<Point2D> bendpoints = Lists.<Point2D>newArrayList
	
	var Point2D start
	var Point2D end
	
	ConnectionMoveManager connectionMoveManager
	
	@Inject
	new(ConnectionMoveManager lmm) {
		this.connectionMoveManager = lmm
	
	}
	
	def public updateEndpoints() {
		val startC = parent.sceneToLocal(fromNodeAnchor.anchorNode.localToScene(fromNodeAnchor.anchorNode.boundsInLocal.width,fromNodeAnchor.anchorNode.boundsInLocal.height/2))
		val endC = parent.sceneToLocal(toNodeAnchor.anchorNode.localToScene(0,toNodeAnchor.anchorNode.boundsInLocal.height/2))
		
		
//		println("!#")
//		println(fromNodeAnchor.anchorNode.boundsInLocal.height/2)
//		println(toNodeAnchor.anchorNode.boundsInLocal.height/2)
//		
//		println(fromNodeAnchor.anchorNode.localToScene(fromNodeAnchor.anchorNode.boundsInLocal.width,fromNodeAnchor.anchorNode.boundsInLocal.height/2))
//	    println(toNodeAnchor.anchorNode.localToScene(0,toNodeAnchor.anchorNode.boundsInLocal.height/2))
//	    
//	    println("**")
	    var  s =  fromNodeAnchor.anchorNode
	    while(s !== null) {
//	    	println(s+" : "+s.localToScene(0,0))
	    	s = s.parent
	    }
	    
	    s =  toNodeAnchor.anchorNode
	    while(s !== null) {
//	    	println(s+" : "+s.localToScene(0,0))
	    	s = s.parent
	    }
			
//		println(fromNodeAnchor.anchorNode)
//		println(toNodeAnchor.anchorNode)
//		
//		println(fromNodeAnchor.anchorNode.localToParent(0,0))
//		println(toNodeAnchor.anchorNode.localToParent(0,0)) 
//		
//		println(startC)
//		println(endC)
		
		line.points.clear
		line.points.addAll(#[startC.x,startC.y]);
		line.points += bendpoints.map[#[it.x,it.y]].flatten.toList
		line.points.addAll(#[endC.x,endC.y])
		
		hitLine.points.clear
		hitLine.points.addAll(#[startC.x,startC.y]);
		hitLine.points += bendpoints.map[#[it.x,it.y]].flatten.toList
		hitLine.points.addAll(#[endC.x,endC.y])
		
//		println(endX)
//		println(endY)
	}
	
	def setBendpoints(List<Point2D> bp) {
		val dummypoints = bp.map[#[it.x,it.y]].flatten.toList
		this.bendpoints = bp
		line.points.clear
		line.points+= dummypoints
		
		hitLine.points.clear
		hitLine.points+= dummypoints
	}
	
	override init() {

		children += line
		hitLine => [
			opacity = 0
			strokeWidth = 10
		]
		children += hitLine
		connectionMoveManager.register(hitLine)
			
		
	}
	
	def public void setPoints(List<Double> l) {
		line.points.clear
		hitLine.points.clear
		line.points.addAll(l)
		hitLine.points.addAll(l)
	}
	
}