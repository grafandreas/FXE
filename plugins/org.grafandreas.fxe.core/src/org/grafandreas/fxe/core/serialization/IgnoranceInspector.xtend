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

import com.fasterxml.jackson.databind.introspect.Annotated
import com.fasterxml.jackson.databind.introspect.AnnotatedMember
import com.fasterxml.jackson.databind.introspect.JacksonAnnotationIntrospector
import javafx.scene.Node
import javafx.scene.Parent

class IgnoranceInspector extends JacksonAnnotationIntrospector { 
	
	override hasIgnoreMarker(AnnotatedMember m) {
		println("Inspecting "+m)
		if(m.declaringClass == typeof(Node)) {
			return m.name != "translateX"
		}
		
		if(m.declaringClass == typeof(Parent)) {
			return m.name != "children"
		}
		
		if(m.name.contains("ssMetaData"))
			return true;
			
		return super.hasIgnoreMarker(m)
	}
	
	override findObjectIdInfo(Annotated ann) {
		super.findObjectIdInfo(ann)
	}
	
}