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
import com.google.inject.Injector
import java.util.List
import javafx.scene.Node
import org.grafandreas.fxe.core.Diagram

class LoaderSaver {
		def public jsonSave(Diagram d) {
		println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		try {
			val f = new FXEMapperFactory
			val mapper = f.createSerializeMapper

		
//			mapper.setAnnotationIntrospector(new IgnoranceInspector());
//			val json = '''
//			«FOR c: symbolLayer.children»
//				«mapper.writeValueAsString(c)»
//			«ENDFOR»
//			''' 

			val memento = new DiagramMemento(d)
			val json = mapper.writeValueAsString(memento)
			println(json)
			println("+")
			return json
			
		} catch(Exception e) {
			println(e)
		}
		return "";
		
	}
	
	def public DiagramMemento jsonLoad(String content, ClassLoader classLoader, Injector injector) {
				val f = new FXEMapperFactory
			val mapper = f.createDeserializeMapper(injector,classLoader)
			println("##++##")
			try {
				val ob = mapper.readValue(content,Object) as DiagramMemento
				println("##++##"+ob)
				return ob
				} catch(Exception e) {
					e.printStackTrace
				}
			return null
	}
	
	@JsonIgnoreProperties(#[ "window" ])
	public static class SceneMI {
		
	}
	
	@JsonIgnoreProperties(#[ "scene" ])
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