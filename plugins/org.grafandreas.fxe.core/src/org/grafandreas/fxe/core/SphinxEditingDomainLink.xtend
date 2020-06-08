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

import java.net.URI
import javax.inject.Singleton
import org.apache.log4j.Logger
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.transaction.TransactionalEditingDomain
import org.eclipse.sphinx.emf.util.WorkspaceEditingDomainUtil
import org.eclipse.sphinx.emf.workspace.loading.ModelLoadManager
import org.eclipse.core.runtime.NullProgressMonitor

@Singleton
class SphinxEditingDomainLink implements IEditingDomainLink {
	val logger = Logger.getLogger(SphinxEditingDomainLink)
	TransactionalEditingDomain last
	
	override from(URI uri) {
		val root =   ResourcesPlugin.getWorkspace().getRoot();
		val candidates = root.findContainersForLocationURI(uri)
		if(candidates.empty)
			throw new IllegalArgumentException
			
		val proj = candidates.get(0).project 
		from(proj)
		
	}
	
	override from(EObject object) {
		last = WorkspaceEditingDomainUtil.getEditingDomain(object)
		last
	}
	
	override from() {
		last
	}
	
	override from(IProject proj) {
		ModelLoadManager.INSTANCE.loadProject(proj,true,false, new NullProgressMonitor)
		last = WorkspaceEditingDomainUtil.allEditingDomains.head
		logger.debug(last)
		last
	}
	
}