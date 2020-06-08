/*********************************************************************
* Copyright (c) 2017-2020 Andreas Graf
*
* This program and the accompanying materials are made
* available under the terms of the Eclipse Public License 2.0
* which is available at https://www.eclipse.org/legal/epl-2.0/
*
* SPDX-License-Identifier: EPL-2.0
**********************************************************************/
package org.grafandreas.fxe.core.symbols

import com.google.common.collect.Lists
import java.util.List
import javafx.collections.FXCollections
import javafx.collections.ListChangeListener
import javafx.collections.ListChangeListener.Change
import javafx.scene.Node

class FEXUtil {
	def public semanticList4(List<? extends Node> list){
		FXCollections.observableList(Lists.<Node>newArrayList)   => [
		it.addListener( new ListChangeListener() {
			override onChanged(Change c) {
				while(c.next) {
					if(c.wasAdded || c.wasRemoved) {
						list += c.addedSubList
						list -= c.removed	
					}
				}
			}
			
		})
	]
	
	}
}