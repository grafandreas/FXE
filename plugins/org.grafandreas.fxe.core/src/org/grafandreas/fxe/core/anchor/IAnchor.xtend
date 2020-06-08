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

import java.util.List
import javafx.scene.Node

interface IAnchor {
	def public Node anchorNode();
	def public List<IConnection> getIncoming();
	def public List<IConnection> getOutgoing();
}