package org.agoncal.application.petclinic.model;

import org.jboss.arquillian.container.test.api.Deployment;
import org.jboss.arquillian.junit.Arquillian;
import org.jboss.arquillian.transaction.api.annotation.Transactional;
import org.jboss.shrinkwrap.api.Archive;
import org.jboss.shrinkwrap.api.ShrinkWrap;
import org.jboss.shrinkwrap.api.asset.EmptyAsset;
import org.jboss.shrinkwrap.api.spec.JavaArchive;
import org.junit.Test;
import org.junit.runner.RunWith;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

/**
 * @author Antonio Goncalves
 */
@RunWith(Arquillian.class)
public class PetTypeIT {

    // ======================================
    // =             Attributes             =
    // ======================================

    @PersistenceContext
    EntityManager em;

    // ======================================
    // =          Lifecycle Methods         =
    // ======================================

    @Deployment
    public static Archive<?> createDeploymentPackage() {
        return ShrinkWrap.create(JavaArchive.class)
                .addPackage(PetType.class.getPackage())
                .addAsManifestResource(EmptyAsset.INSTANCE, "beans.xml")
                .addAsManifestResource("test-persistence.xml", "persistence.xml");
    }

    // ======================================
    // =              Methods               =
    // ======================================

    @Test
    @Transactional
    public void shouldCRUDAPetType() {

        // Creates an object
        PetType dog = new PetType("Dog");

        // Persists the object
        em.persist(dog);
        em.flush();
        assertNotNull(dog.getId());

        dog = em.find(PetType.class, dog.getId());

        assertEquals("Dog", dog.getName());
    }
}
