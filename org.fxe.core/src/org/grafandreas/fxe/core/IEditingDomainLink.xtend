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
import org.eclipse.core.resources.IProject
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.transaction.TransactionalEditingDomain

interface IEditingDomainLink {
	def TransactionalEditingDomain from(URI uri)
	def TransactionalEditingDomain from(IProject proj)
	def TransactionalEditingDomain from(EObject uri)
	def TransactionalEditingDomain from();
}