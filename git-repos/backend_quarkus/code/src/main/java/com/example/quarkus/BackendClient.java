package com.example.quarkus;

import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.eclipse.microprofile.rest.client.annotation.RegisterClientHeaders;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;

@RegisterRestClient
@RegisterClientHeaders(BackendClientHeaderFactory.class)
public interface BackendClient {

    @GET
    @Consumes(MediaType.TEXT_PLAIN)
    Response sendMessage();
}
