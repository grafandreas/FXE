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
import javafx.collections.FXCollections
import org.eclipse.xtend.lib.annotations.Accessors

abstract class AbstractAnchor implements IAnchor {
	
	@Accessors(PUBLIC_GETTER)
	val incoming = FXCollections.observableList(Lists.<IConnection>newArrayList)
	@Accessors(PUBLIC_GETTER)
	val outgoing = FXCollections.observableList(Lists.<IConnection>newArrayList)
}