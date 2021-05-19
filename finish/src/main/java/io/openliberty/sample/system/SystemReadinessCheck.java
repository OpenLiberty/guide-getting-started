// tag::copyright[]
/*******************************************************************************
 * Copyright (c) 2018, 2021 IBM Corporation and others.
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
import org.eclipse.microprofile.health.Readiness;
import org.eclipse.microprofile.health.HealthCheck;
import org.eclipse.microprofile.health.HealthCheckResponse;

@Readiness
@ApplicationScoped
// tag::systemReadinessCheck[]
public class SystemReadinessCheck implements HealthCheck {

    private static final String READINESS_CHECK = SystemResource.class.getSimpleName()
                                                 + " Readiness Check";

    @Inject
    @ConfigProperty(name = "io_openliberty_guides_system_inMaintenance")
    Provider<String> inMaintenance;

    @Override
    public HealthCheckResponse call() {
        if (inMaintenance != null && inMaintenance.get().equalsIgnoreCase("true")) {
            return HealthCheckResponse.down(READINESS_CHECK);
        }
        return HealthCheckResponse.up(READINESS_CHECK);
    }

}
// end::systemReadinessCheck[]
