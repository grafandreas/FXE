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
import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty
import com.fasterxml.jackson.annotation.ObjectIdGenerators
import com.fasterxml.jackson.databind.MapperFeature
import com.fasterxml.jackson.databind.deser.std.StdDelegatingDeserializer
import com.fasterxml.jackson.databind.module.SimpleModule
import com.fasterxml.jackson.databind.ser.std.StdDelegatingSerializer
import com.fasterxml.jackson.databind.type.TypeFactory
import com.google.inject.Injector
import javafx.collections.ObservableList
import javafx.scene.Node
import javafx.scene.Parent
import org.eclipse.emf.ecore.EObject

class FXEMapperFactory {
	protected val delegate = new MapperFactory

	def createSerializeMapper() {
		val mapper = delegate.createSerializeMapper

		mapper.disable(MapperFeature.AUTO_DETECT_FIELDS, MapperFeature.AUTO_DETECT_GETTERS,
			MapperFeature.AUTO_DETECT_IS_GETTERS);

		mapper.addMixIn(Node, NodeMI)
		mapper.addMixIn(Parent, ParentMI)
		val module = new SimpleModule()
		module.addSerializer(EObject, new StdDelegatingSerializer(new EObjectConverter()));
		
//			module.addSerializer(Node, new NodeSerializer());
		mapper.registerModule(module)

		mapper

	}

	def createDeserializeMapper(Injector injector, ClassLoader classLoader) {
		val mapper = delegate.createDeSerializeMapper(injector)

		mapper.addMixIn(Node, NodeMI)
		mapper.addMixIn(Parent, ParentMI)
		
		mapper.typeFactory = TypeFactory.defaultInstance().withClassLoader(classLoader);
		val module = new SimpleModule()
		module.addDeserializer(org.grafandreas.fxe.core.serialization.EObjectConverter.EObjectP, new StdDelegatingDeserializer(new EObjectBackConverter()));
		mapper.registerModule(module)
		mapper
	}

	@JsonIgnoreProperties(#["window"])
	public static class SceneMI {
	}

	@JsonIgnoreProperties(#["scene"])
	public static class DiagramMI {
	}

	@JsonIdentityInfo(generator=ObjectIdGenerators.IntSequenceGenerator, property="@intId")
	public static abstract class NodeMI {
		@JsonProperty
		def double getTranslateX() ;

		@JsonProperty
		def double getLayoutX() ;

		@JsonProperty
		def double getLayoutY() ;
	}

	public static class ParentMI {
//		@JsonProperty
//		protected ObservableList<Node> children;
	}
}
