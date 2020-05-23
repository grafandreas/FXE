/*********************************************************************
* Copyright (c) 2017-2020 Andreas Graf
*
* This program and the accompanying materials are made
* available under the terms of the Eclipse Public License 2.0
* which is available at https://www.eclipse.org/legal/epl-2.0/
*
* SPDX-License-Identifier: EPL-2.0
**********************************************************************/
package org.grafandreas.fxe.core.di

import com.google.inject.Binder
import com.google.inject.Module
import com.google.inject.TypeLiteral
import com.google.inject.matcher.Matchers
import com.google.inject.spi.InjectionListener
import com.google.inject.spi.TypeEncounter
import com.google.inject.spi.TypeListener
import org.apache.log4j.Logger

class BasicFXEModule implements Module {
		val logger = Logger.getLogger(BasicFXEModule)
		
		override configure(Binder binder) {
			binder.bindListener(Matchers.any(), new TypeListener() {

				override <I> hear(TypeLiteral<I> type, TypeEncounter<I> encounter) {
					encounter.register(
						new InjectionListener<I>() {
							override afterInjection(I i) {
								logger.debug("After Injection "+i)
								if (i instanceof IInit)
									i.init()
							}

						}
					);
				}
			});
		}
}