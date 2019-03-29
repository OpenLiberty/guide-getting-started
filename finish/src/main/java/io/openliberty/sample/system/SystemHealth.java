// tag::copyright[]
/*******************************************************************************
 * Copyright (c) 2018, 2019  IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - Initial implementation
 *******************************************************************************/
// end::copyright[]
package io.openliberty.sample.system;

import javax.enterprise.context.ApplicationScoped;

import javax.inject.Inject;
import javax.inject.Provider;

import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.eclipse.microprofile.health.Health;
import org.eclipse.microprofile.health.HealthCheck;
import org.eclipse.microprofile.health.HealthCheckResponse;
import org.eclipse.microprofile.health.HealthCheckResponseBuilder;

@Health
@ApplicationScoped
public class SystemHealth implements HealthCheck {

    @Inject
    @ConfigProperty(name = "io_openliberty_guides_system_inMaintenance")
    Provider<String> inMaintenance;
	
    @Override
    public HealthCheckResponse call() {
        HealthCheckResponseBuilder builder = HealthCheckResponse.named(
		SystemResource.class.getSimpleName());
        if (inMaintenance != null && inMaintenance.get().equalsIgnoreCase("true")) {
            return builder.withData("services", "not available").down().build();
        }
        return builder.withData("services", "available").up().build();
    }
    
}
