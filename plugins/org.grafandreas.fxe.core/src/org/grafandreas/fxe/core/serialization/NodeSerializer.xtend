/*********************************************************************
* Copyright (c) 2017-2020 Andreas Graf
*
* This program and the accompanying materials are made
* available under the terms of the Eclipse Public License 2.0
* which is available at https://www.eclipse.org/legal/epl-2.0/
*
* SPDX-License-Identifier: EPL-2.0
**********************************************************************/
package org.grafandreas.fxe.core.serialization

import com.fasterxml.jackson.core.JsonGenerator
import com.fasterxml.jackson.databind.SerializerProvider
import com.fasterxml.jackson.databind.ser.std.StdSerializer
import java.io.IOException
import javafx.scene.Node

class NodeSerializer extends StdSerializer<Node> {
     
   new() {
   		this(null)
   }
   
   new(Class<Node> t) {
        super(t);
    }
 
  
				
				override serialize(Node value, JsonGenerator gen, SerializerProvider provider) throws IOException {
					println("Serialize")
					gen.writeStartObject
					gen.writeStringField("class",value.class.name)
					gen.writeNumberField("node", value.translateX)
					gen.writeEndObject
				}
				
}