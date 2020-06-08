/*********************************************************************
* Copyright (c) 2017-2020 Andreas Graf
*
* This program and the accompanying materials are made
* available under the terms of the Eclipse Public License 2.0
* which is available at https://www.eclipse.org/legal/epl-2.0/
*
* SPDX-License-Identifier: EPL-2.0
**********************************************************************/
package org.grafandreas.fxe.core.labels

import javafx.beans.value.ChangeListener
import javafx.beans.value.ObservableValue
import org.eclipse.emf.common.notify.impl.AdapterImpl
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EObject
import org.eclipse.sphinx.emf.util.WorkspaceEditingDomainUtil
import org.grafandreas.fxe.core.IDomainObjectReferrer
import org.grafandreas.fxe.core.eel.EMFEditFXProperties

class SimpleLabeller implements ILabeller {
	
	
	
	EAttribute nameAttr

	
	ILabelled labelled
	
	IDomainObjectReferrer<EObject> owner
	
	
	
	new(IDomainObjectReferrer<EObject> owner, ILabelled labelled, EAttribute nameAttr) {
			this.owner  = owner
			this.nameAttr = nameAttr
			
			this.labelled = labelled
			
			owner.mainDomainObject.addListener(new ChangeListener() {

			override changed(ObservableValue arg0, Object arg1, Object arg2) {
				labelBind
			}

		})
			
	}
		
	def labelBind() {
	
		val eob = owner.mainDomainObject.value
		
		if(eob !== null) {
			val domain = WorkspaceEditingDomainUtil.getEditingDomain(eob)
			val nameBinding = EMFEditFXProperties.value(domain,eob,nameAttr)			
			labelled.displayLabel.textProperty.bind(nameBinding)			
		}			
	}
	
	/** Just a marker */
	public abstract static class TypeLabelAdapter extends AdapterImpl {}
	
}