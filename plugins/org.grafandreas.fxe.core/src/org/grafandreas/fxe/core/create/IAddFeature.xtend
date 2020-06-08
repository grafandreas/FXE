/*********************************************************************
* Copyright (c) 2017-2020 Andreas Graf
*
* This program and the accompanying materials are made
* available under the terms of the Eclipse Public License 2.0
* which is available at https://www.eclipse.org/legal/epl-2.0/
*
* SPDX-License-Identifier: EPL-2.0
**********************************************************************/
package org.grafandreas.fxe.core.create

import java.util.Collection
import javafx.geometry.Point2D
import org.grafandreas.fxe.core.IPermission

interface IAddFeature<T> {
	def public IPermission canAdd(Collection<T> obs);
	def public void execute(Collection<? extends T> obs, Point2D position);
}