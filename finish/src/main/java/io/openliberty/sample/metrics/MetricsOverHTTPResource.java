// tag::copyright[]
/*******************************************************************************
 * Copyright (c) 2017, 2018 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - Initial implementation
 *******************************************************************************/
// end::copyright[]
package io.openliberty.sample.metrics;

import java.util.Base64;

import javax.enterprise.context.RequestScoped;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.UriInfo;

/**
 * This class exists to wrap the /metrics request and return the content over HTTP as /metrics is only accessible over HTTPS.
 * The purpose is to avoid the need for credentials and certs for this simple sample's front end.
 * The original metrics API remains available at /metrics with the credentials provided in the server.xml (default: admin/adminpwd)
 */
@RequestScoped
@Path("/{scope: .*}")
public class MetricsOverHTTPResource {
    
    private static final String METRICS_PATH = "/metrics/";

    @Context
    UriInfo uriInfo;

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getMetrics(@PathParam("scope") String scope) {
        String url = "https://" + uriInfo.getBaseUri().getHost() + ":" + 9443 + METRICS_PATH + scope;
        String credentials = "admin:adminpwd";
        String base64encoded = Base64.getEncoder().encodeToString(credentials.getBytes());
        
        Client client = ClientBuilder.newClient();
        Response response = client.target(url).request().header(HttpHeaders.AUTHORIZATION, "Basic " + base64encoded).get();
        return response;
    }
    
}
