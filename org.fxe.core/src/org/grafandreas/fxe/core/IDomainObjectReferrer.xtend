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

import com.fasterxml.jackson.annotation.JsonProperty
import com.google.common.collect.Lists
import javafx.beans.property.ObjectProperty
import javafx.collections.FXCollections
import javafx.collections.ListChangeListener
import javafx.collections.ObservableList

/**
 * Interface for objects that referr to one ore more domain objects.
 * 
 */
interface IDomainObjectReferrer<T> {
	
	
	@JsonProperty()
	def public ObservableList<T> domainObjects();

	def public ObjectProperty<T> mainDomainObject();

	def initDomainObjects() {
		FXCollections.observableList(Lists.<T>newArrayList) => [
			it.addListener(new ListChangeListener() {
				override onChanged(Change c) {
					mainDomainObject.set(c.list.head)
				}

			})
		]
	}

}
