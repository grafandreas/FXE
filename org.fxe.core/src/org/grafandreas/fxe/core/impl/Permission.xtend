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

import org.grafandreas.fxe.core.IPermission

class Permission implements IPermission {

	val boolean permitted
	val String feedBack

	new(boolean permitted) {
		this.permitted = permitted
		feedBack = null
	}
	
	new(boolean permitted, String feedBack) {
		this.permitted = permitted
		this.feedBack = feedBack
	}

	new(String feedBack) {
		this.feedBack = feedBack;
		permitted = false
	}

	override permitted() {
		permitted
	}

	override feedBack() {
		feedBack
	}

}
