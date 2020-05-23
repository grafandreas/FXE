/*********************************************************************
* Copyright (c) 2017-2020 Andreas Graf
*
* This program and the accompanying materials are made
* available under the terms of the Eclipse Public License 2.0
* which is available at https://www.eclipse.org/legal/epl-2.0/
*
* SPDX-License-Identifier: EPL-2.0
**********************************************************************/
package org.grafandreas.fxe.core.serialization

import org.eclipse.ui.IEditorInput
import org.eclipse.xtend.lib.annotations.Accessors

class StringEditorInput implements IEditorInput {
	
	@Accessors
	String contents
	
	new(String contents) {
		this.contents = contents
	}
	override exists() {
		true
	}
	
	override getImageDescriptor() {
		null
	}
	
	override getName() {
		"String Editor Input"
	}
	
	override getPersistable() {
		null
	}
	
	override getToolTipText() {
		null
	}
	
	override <T> getAdapter(Class<T> adapter) {
		null
	}
	
}