/*********************************************************************
* Copyright (c) 2017-2020 Andreas Graf
*
* This program and the accompanying materials are made
* available under the terms of the Eclipse Public License 2.0
* which is available at https://www.eclipse.org/legal/epl-2.0/
*
* SPDX-License-Identifier: EPL-2.0
**********************************************************************/
package org.grafandreas.fxe.core.selection

import org.eclipse.ui.navigator.ILinkHelper
import org.eclipse.ui.IWorkbenchPage
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.ui.IEditorInput
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.ui.PlatformUI
import org.grafandreas.fxe.core.FXE

class BasicLinkHelper implements ILinkHelper {

	override activateEditor(IWorkbenchPage aPage, IStructuredSelection aSelection) {
		println("Link helper activate")
	}

	override findSelection(IEditorInput anInput) {
		println("Link helper seelection")

		val wb = PlatformUI.getWorkbench();
		val window = wb.getActiveWorkbenchWindow();
		val page = window.getActivePage();
		val editor = page.getActiveEditor();
		println("------------------------------"+editor)
		if(editor instanceof FXE) {
			println(editor.selectionManager)
			return editor.selectionManager.selection as StructuredSelection
		}
		return StructuredSelection.EMPTY;
	}

}
