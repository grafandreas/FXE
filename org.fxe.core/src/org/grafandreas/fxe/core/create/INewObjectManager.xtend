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

import javafx.geometry.Point2D
import javafx.scene.Parent

public interface INewObjectManager {
	/**
	 * layer: Where to invoke UI
	 * Point2D: coordinates where to display menu
	 */
	def public void invoke(Parent layer, ICreateFeatureProvider featureProvider, Point2D coord);
	
}