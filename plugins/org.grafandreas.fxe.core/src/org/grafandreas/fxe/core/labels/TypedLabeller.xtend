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

import javafx.beans.binding.Bindings
import javafx.scene.control.Label
import org.eclipse.emf.common.notify.Notification
import org.eclipse.emf.common.notify.impl.AdapterImpl
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.sphinx.emf.util.WorkspaceEditingDomainUtil
import org.grafandreas.fxe.core.IDomainObjectReferrer
import org.grafandreas.fxe.core.eel.EMFEditFXProperties
import org.grafandreas.fxe.core.labels.TypedLabeller.TypeLabelAdapter
import javafx.beans.property.SimpleObjectProperty
import javafx.beans.value.ChangeListener
import javafx.beans.value.ObservableValue

class TypedLabeller implements ILabeller {

	EAttribute nameAttr

	EReference typeRef

	EAttribute typeNameAttr

	ILabelled labelled

	IDomainObjectReferrer<EObject> owner
	
	TypeLabelAdapter adapter

	new(IDomainObjectReferrer<EObject> owner, ILabelled labelled, EAttribute nameAttr, EReference typeRef,
		EAttribute typeNameAttr) {
		this.owner = owner
		this.nameAttr = nameAttr
		this.typeRef = typeRef
		this.typeNameAttr = typeNameAttr
		this.labelled = labelled

		adapter = new TypeLabelAdapter() {
				override notifyChanged(Notification msg) {
					if(msg.eventType !== Notification.REMOVING_ADAPTER) {
						println("222" + msg)
						typeLabelBind()	
					}
				}
			}
			
		owner.mainDomainObject.addListener(new ChangeListener<EObject>() {

			override changed(ObservableValue<? extends EObject> arg0, EObject arg1, EObject arg2) {
				if(arg1 !== null)
					arg1.eAdapters.remove(adapter);
					
				if( arg2 !== null)
					arg2.eAdapters.add(adapter);
					
				typeLabelBind
			}

		})
	}

	def typeLabelBind() {
		println("*+#")
		val eob = owner.mainDomainObject.value
		val domain = WorkspaceEditingDomainUtil.getEditingDomain(eob)

		val nameBinding = EMFEditFXProperties.value(domain, eob, nameAttr)
		if (eob.eGet(typeRef) !== null) {
			val typeNameBinding = EMFEditFXProperties.value(domain, eob.eGet(typeRef) as EObject, typeNameAttr)
			labelled.displayLabel.textProperty.bind(Bindings.concat(nameBinding, " : ", typeNameBinding))
		} else {
			labelled.displayLabel.textProperty.bind(Bindings.concat(nameBinding," : ?"))

		}

		// Callback if type changes
		//
		
		
	

	}

	/** Just a marker */
	public abstract static class TypeLabelAdapter extends AdapterImpl {
	}

}
