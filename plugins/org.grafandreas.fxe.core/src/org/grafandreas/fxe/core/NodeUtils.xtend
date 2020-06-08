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

import com.google.common.collect.Sets
import java.util.Set
import javafx.scene.Group
import javafx.scene.Node
import javafx.scene.Parent
import javafx.scene.layout.Pane

class NodeUtils {
	def public allChildren(Node n) {
		val coll = Sets.<Node>newHashSet();
		allChildren(n,coll)
		coll
	}
	
	def protected dispatch void allChildren(Parent n, Set<Node> coll) {
		coll += n.childrenUnmodifiable
		n.childrenUnmodifiable.forEach[allChildren(coll)]
	
	}
	
	def protected dispatch void allChildren(Node n, Set<Node> coll) {
		
	
	}
	
	def protected dispatch void allChildren(Pane n, Set<Node> coll) {
		coll += n.childrenUnmodifiable
		n.childrenUnmodifiable.forEach[allChildren(coll)]
	}
	
	def public children(Parent n) {
		if(n instanceof Group)
			n.children
		else if (n instanceof Pane)
			n.children
		else
			throw new UnsupportedOperationException("helper not implemented for "+n.class)
	}
}