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

import javafx.scene.layout.Pane
import javax.inject.Inject
import javax.inject.Singleton
import org.eclipse.core.runtime.ListenerList
import org.eclipse.jface.viewers.ISelection
import org.eclipse.jface.viewers.ISelectionChangedListener
import org.eclipse.jface.viewers.ISelectionProvider
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.jface.viewers.SelectionChangedEvent
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.ui.ISelectionListener
import org.eclipse.ui.IWorkbenchPart
import org.eclipse.xtend.lib.annotations.Accessors
import javafx.scene.control.ScrollPane

@Singleton
class ESelectionManager extends SelectionManager<IFEAdaptable> implements ISelectionProvider, ISelectionListener {

	@Accessors(PUBLIC_SETTER)
	FXE owner

	val listeners = new ListenerList();
	var ISelection mySelection
	@Inject
	extension NodeUtils no
	var Diagram root = null;

	override addSelectionChangedListener(ISelectionChangedListener listener) {
		println("Registered " + listener)
		listeners.add(listener)
	}

	override getSelection() {
		println("getSelection " + mySelection)
		mySelection
	}

	override removeSelectionChangedListener(ISelectionChangedListener listener) {
		listeners.remove(listener)
	}

	override setSelection(ISelection selection) {
		mySelection = selection
		println("listener size" + listeners.listeners.size)
		for (l : listeners.listeners.filter(ISelectionChangedListener))
			l.selectionChanged(new SelectionChangedEvent(this, selection));

	}

	override selectionChanged(IWorkbenchPart part, ISelection selection) {
		println("Selection Changed" + selection + " : " + part + " : " + owner)
		if (owner === part) {
			return
		}
		clear
		val x = root.allChildren.filter(IDomainObjectReferrer)
		println("Adaptapbles" + x)
		if (selection instanceof IStructuredSelection) {

			val appl = x.filter[domainObjects.contains(selection.firstElement)].filter(IFEAdaptable).toList
			println("Match " + appl)
			selectAll(appl)

		}
	}

	def void setRoot(Diagram p) {
		root = p
	}

	def void updateSelection() {
		println("Y")
		println(selected.head)
		val domainObjects = selected.filter(IDomainObjectReferrer).map[domainObjects.toList].flatten.toList

		println(domainObjects);

		try {
			val s = new StructuredSelection(domainObjects.toArray)
			println("sel:" + s)
			selection = s

		} catch (Exception ex) {
			println(ex)
			ex.printStackTrace
		}

	}

	override select(IFEAdaptable ob) {
		println("+/")
		super.select(ob)
		updateSelection
		true
	}

	override clear() {
		super.clear()
		updateSelection

	}

}
