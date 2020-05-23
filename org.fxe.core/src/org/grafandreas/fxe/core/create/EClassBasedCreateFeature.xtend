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

import javafx.geometry.Point2D
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EFactory
import org.eclipse.emf.ecore.EObject

class EClassBasedCreateFeature implements ICreateFeature<EObject> {
	
	EClass eclass
	
	EFactory factory
	
	new(EFactory factory, EClass eclass) {
		this.factory = factory
		this.eclass = eclass
	}
	override label() {
		return eclass.name
	}
	
	def public getEClass() {
		eclass
	}
	
	override execute(Point2D position) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	def createEObject() {
		factory.create(eclass)
	}
	
}