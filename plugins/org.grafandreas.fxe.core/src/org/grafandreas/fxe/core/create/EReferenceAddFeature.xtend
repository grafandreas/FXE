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

import java.util.Collection
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.grafandreas.fxe.core.impl.Permission
import org.eclipse.xtend.lib.annotations.Accessors

abstract class EReferenceAddFeature implements IAddFeature<EObject> {
	
	@Accessors
	EReference ref
	
	new(EReference ref) {
		this.ref = ref
	}
	
	new(){
	}
	
	
	override canAdd(Collection<EObject> obs) {
		if(obs.forall[ref.EType.isInstance(it)])
			new Permission(true)
		else
			new Permission(false)
	}
	
	
	
}