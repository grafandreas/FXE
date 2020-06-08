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

import com.fasterxml.jackson.annotation.JsonIdentityInfo
import com.fasterxml.jackson.annotation.JsonTypeInfo.As
import com.fasterxml.jackson.annotation.ObjectIdGenerators
import com.fasterxml.jackson.databind.InjectableValues
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.ObjectMapper.DefaultTyping
import com.fasterxml.jackson.databind.SerializationFeature
import com.fasterxml.jackson.databind.module.SimpleModule
import com.fasterxml.jackson.databind.ser.std.StdDelegatingSerializer
import com.google.inject.Injector
import javafx.collections.ObservableList

class MapperFactory {
	public def createDefault() {
		val mapper = new ObjectMapper

		mapper.enableDefaultTyping(DefaultTyping.NON_FINAL);
		mapper.enableDefaultTyping(DefaultTyping.NON_FINAL, As.WRAPPER_ARRAY);

		mapper
	}

	public def createSerializeMapper() {
		val mapper = createDefault
		mapper.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
		mapper.enable(SerializationFeature.INDENT_OUTPUT);
		val module = new SimpleModule()
		module.addSerializer(ObservableList, new StdDelegatingSerializer(new ObservableListConverter()));
		mapper.registerModule(module)
		mapper
	}

	public def createDeSerializeMapper(Injector injector) {
		val mapper = createDefault
		mapper.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
		mapper.enable(SerializationFeature.INDENT_OUTPUT);

		val injectableValues = new InjectableValues.Std();
		injectableValues.addValue("injector", injector)
		mapper.injectableValues = injectableValues
		mapper
	}

	@JsonIdentityInfo(generator=ObjectIdGenerators.IntSequenceGenerator, property="@intId")
	public static abstract class ListMI {
	}
}
