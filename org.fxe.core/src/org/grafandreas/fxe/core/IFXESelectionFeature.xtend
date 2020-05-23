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

interface IFXESelectionFeature<T extends IFEAdaptable> {
	def boolean canBeSelected(T ob)
	def boolean select(T ob)
	def boolean deselect(T ob)
}