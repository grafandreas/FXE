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

import java.util.List
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.sphinx.emf.util.EcorePlatformUtil
import org.eclipse.sphinx.emf.util.WorkspaceEditingDomainUtil

interface IDomainEObjectReferrer extends IDomainObjectReferrer<EObject> {
	
	
	def public void setDomainObjects(List<String> l) {
		domainObjects.clear
		for(u : l ) {
			println("--."+u)
			println("--. "+WorkspaceEditingDomainUtil.getEditingDomain(URI.createURI(u)))
			
			// We must use loadEObject to make sure the model is actually loaded
			//
			println(EcorePlatformUtil.loadEObject(URI.createURI(u)))
			
		}
		domainObjects.addAll(l.map[u|EcorePlatformUtil.loadEObject(URI.createURI(u))])
		println(mainDomainObject.get)
	}
}