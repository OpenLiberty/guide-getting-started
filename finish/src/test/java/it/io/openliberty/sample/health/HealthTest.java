// tag::comment[]
/*******************************************************************************
 * Copyright (c) 2018 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - Initial implementation
 *******************************************************************************/
// end::comment[]
// tag::HealthTest[]
package it.io.openliberty.sample.health;

import static org.junit.Assert.assertEquals;

import java.util.HashMap;
import javax.json.JsonArray;
import org.junit.Test;

public class HealthTest {

  private JsonArray servicesStates;
  private static HashMap<String, String> dataWhenServicesUP, dataWhenServicesDown;

  static {
    dataWhenServicesUP = new HashMap<String, String>();
    dataWhenServicesDown = new HashMap<String, String>();
    

    dataWhenServicesUP.put("SystemResource", "UP");
    

    dataWhenServicesDown.put("SystemResource", "DOWN");
    
  }

  @Test
  public void testIfServicesAreUp() {
    servicesStates = HealthTestUtil.connectToHealthEnpoint(200);
    checkServicesStates(dataWhenServicesUP, servicesStates);
  }


  private void checkServicesStates(HashMap<String, String> testData, JsonArray servicesStates) {
    testData.forEach((service, expectedState) -> {
      assertEquals("The state of " + service + " service is not matching the ", expectedState,
                   HealthTestUtil.getActualState(service, servicesStates));
    });

  }

}
// end::HealthTest[]
