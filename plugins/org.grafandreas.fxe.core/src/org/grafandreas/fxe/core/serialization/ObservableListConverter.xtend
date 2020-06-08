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

import com.fasterxml.jackson.databind.util.StdConverter
import com.google.common.collect.Lists
import java.util.List
import javafx.collections.ObservableList

class ObservableListConverter extends StdConverter<ObservableList<? extends Object>, List<? extends Object>> {
	
	override convert(ObservableList<? extends Object> value) {
		Lists.newArrayList(value)
	}
	
}