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
package it.io.openliberty.sample;

import static org.junit.Assert.assertEquals;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Response;

import org.apache.cxf.jaxrs.provider.jsrjsonp.JsrJsonpProvider;
import org.junit.Test;

public class HealthEndpointTest {

  @Test
  public void testHealth() {

    String port = System.getProperty("liberty.test.port");
    String baseUrl = "http://localhost:" + port + "/";
    String HEALTH_ENDPOINT = "health";
    String healthURL = baseUrl + HEALTH_ENDPOINT;

    Client client = ClientBuilder.newClient();
    client.register(JsrJsonpProvider.class);

    WebTarget target = client.target(healthURL);
    Response response = target.request().get();

    assertEquals("Incorrect response code from " + healthURL, 200, response.getStatus());

response.close();
  }

}
// end::HealthTest[]
