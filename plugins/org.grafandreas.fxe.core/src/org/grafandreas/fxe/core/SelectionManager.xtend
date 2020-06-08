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

import com.google.common.collect.ImmutableList
import com.google.common.collect.Lists
import java.util.Collection
import java.util.List
import javax.inject.Singleton
import com.google.common.reflect.TypeToken

@Singleton
class SelectionManager<T extends IFEAdaptable> {
	
	val selected = Lists.<T>newArrayList
	
	def public clear() {
		println("clear")
		selected.forEach[
			val selFeat = it.getAdapter(TypeToken.of(IFXESelectionFeature))
			selFeat.deselect(it)
		]
		selected.clear
	}
	
	def public select(T ob) {
		val selFeat = ob.getAdapter(TypeToken.of(IFXESelectionFeature))
		if (selFeat.canBeSelected(ob)) {
			selFeat.select(ob)
			selected += ob	
		}
	}
	
	def public selectAll(Collection<? extends T> ob) {
		ob.forEach[
			val selFeat = it.getAdapter(TypeToken.of(IFXESelectionFeature))
				if (selFeat.canBeSelected(it)) {
					selFeat.select(it)
					selected += it	
				}
					
		]
	}
	
	def public deselect(T ob) {
		
	}
	
	def public deselectAll(Collection<? extends T> ob) {
		
	}
	
	def public List<T> selected() {
		ImmutableList.copyOf(selected);
	}
}