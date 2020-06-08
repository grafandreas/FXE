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

import com.fasterxml.jackson.annotation.JsonProperty
import com.fasterxml.jackson.databind.util.StdConverter
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil
import org.grafandreas.fxe.core.serialization.EObjectConverter.EObjectP

class EObjectConverter extends StdConverter<EObject, String> {
	
	override convert(EObject value) {
		EcoreUtil.getURI(value).toString
//		new EObjectP(	EcoreUtil.getURI(value).toString)
	}
	
	
	public static class EObjectP {
		@JsonProperty
		public var String uri
		
		new(String u)  {
			uri = u
		}
	}
}

class EObjectBackConverter extends StdConverter<EObjectConverter.EObjectP,EObject> {
	
	override convert(EObjectP value) {
		return null;
	}
	
}

class DomainObjectConverter extends StdConverter<List<org.grafandreas.fxe.core.serialization.EObjectConverter.EObjectP>,List<EObject>> {
	
	override convert(List<org.grafandreas.fxe.core.serialization.EObjectConverter.EObjectP> value) {
		println("##!!" +value)
		return null;
	}
	
}