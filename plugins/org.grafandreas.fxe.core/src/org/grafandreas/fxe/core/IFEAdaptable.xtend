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

import com.google.common.reflect.TypeToken

interface IFEAdaptable {
	def <T>  T getAdapter(TypeToken<? extends T> tok) { getAdapter(tok,"")}
	def <T>  T getAdapter(TypeToken<? extends T> tok, String role );
}