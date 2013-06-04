@/* Generates the draft of a Petclinic application */;

@/* Clear the screen */;
clear;

@/* This means less typing. If a script is automated, or is not meant to be interactive, use this command */;
set ACCEPT_DEFAULTS true;

@/* Create a new project in the current directory */;
 new-project --named agoncal-application-petclinic --topLevelPackage org.agoncal.application.petclinic --type war ;

@/* Customize Maven */;
maven set-groupid org.agoncal.application

@/* Setup JPA */;
persistence setup --provider ECLIPSELINK --container GLASSFISH_3 ;

@/* Create some JPA @Entities on which to base our application */;
@/* PetType */;
entity --named PetType --package ~.model;
field string --named name;

@/* Specialty */;
entity --named Specialty --package ~.model;
field string --named name;

@/* Vet */;
entity --named Vet --package ~.model;
field string --named firstName;
field string --named lastName;
 field manyToMany --named specialties --fieldType ~.model.Specialty.java

@/* Pet */;
entity --named Pet --package ~.model;
field string --named name;
field temporal --type DATE --named birthDate;
field manyToOne --named type --fieldType ~.model.PetType.java

@/* Owner */;
entity --named Owner --package ~.model;
field string --named firstName;
field string --named lastName;
field string --named address;
field string --named city;
field string --named telephone;
field oneToMany --named pets --fieldType ~.model.Pet.java

@/* Visit */;
entity --named Visit --package ~.model;
field temporal --type DATE --named birthDate;
field string --named description;
field manyToOne --named pet --fieldType ~.model.Pet.java

@/* Create some beans */;
@/* Vets */;
java new-class --named Vets --package ~.model;
java new-field  'private List<Vet> vets'
java new-method '@XmlElement public List<Vet> getVetList() {if (vets == null) {vets = new ArrayList<Vet>();}return vets;}'

@/* Turn our Java project into a Web project with JSF, CDI, EJB, and JPA */;
scaffold setup --scaffoldType faces;

@/* Enable CDI if not already done */;
beans setup;

@/* Generate the UI for all of our @Entities at once */;
scaffold from-entity ~.domain.* --scaffoldType faces --overwrite;
cd ~~;

@/* Setup JAX-RS, and create CRUD endpoints */;
rest setup;
rest endpoint-from-entity ~.domain.*;

@/* Build the project and disable ACCEPT_DEFAULTS */;
build;
set ACCEPT_DEFAULTS false;

@/* Return to the project root directory and leave it in your hands */;
cd ~~;

