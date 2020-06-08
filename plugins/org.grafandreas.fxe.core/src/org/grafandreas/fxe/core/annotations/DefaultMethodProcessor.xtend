/*********************************************************************
* Copyright (c) 2017-2020 Andreas Graf
*
* This program and the accompanying materials are made
* available under the terms of the Eclipse Public License 2.0
* which is available at https://www.eclipse.org/legal/epl-2.0/
*
* SPDX-License-Identifier: EPL-2.0
**********************************************************************/
package org.grafandreas.fxe.core.annotations

import org.eclipse.xtend.lib.macro.AbstractMethodProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.declaration.MutableMethodDeclaration
import org.eclipse.xtend.lib.macro.TransformationContext

@Active(DefaultMethodProcessor)
annotation DefaultMethod {}
    
class DefaultMethodProcessor extends AbstractMethodProcessor {
	
	override doTransform(MutableMethodDeclaration annotatedMethod, extension TransformationContext context) {
		super.doTransform(annotatedMethod, context)
		annotatedMethod.^default = true
	}
	
}