@/* Generates the draft of a Petclinic application */;

@/* Clear the screen */;
clear ;

@/* This means less typing. If a script is automated, or is not meant to be interactive, use this command */;
set ACCEPT_DEFAULTS true ;

@/* Create a new project in the current directory */;
new-project --named agoncal-application-petclinic --topLevelPackage org.agoncal.application.petclinic --type war ;

@/* Setup JPA */;
persistence setup --provider ECLIPSELINK --container GLASSFISH_3 --named petclinicPU ;

@/* Setup Bean Validation */;
validation setup --provider HIBERNATE_VALIDATOR ;

@/* Create some JPA @Entities on which to base our application */;
@/* PetType */;
entity --named PetType ;
field string --named name ;

@/* Specialty */;
entity --named Specialty ;
field string --named name ;

@/* Vet */;
entity --named Vet ;
field string --named firstName ;
constraint NotNull --onProperty firstName ;
field string --named lastName ;
constraint NotNull --onProperty lastName ;
field manyToMany --named specialties --fieldType ~.model.Specialty.java ;

@/* Pet */;
entity --named Pet ;
field string --named name ;
field temporal --type DATE --named birthDate ;
constraint Past --onProperty birthDate ;
field manyToOne --named type --fieldType ~.model.PetType.java ;

@/* Owner */;
entity --named Owner ;
field string --named firstName ;
constraint NotNull --onProperty firstName ;
field string --named lastName ;
constraint NotNull --onProperty lastName ;
field string --named address ;
constraint NotNull --onProperty address ;
field string --named city ;
constraint NotNull --onProperty city ;
field string --named telephone ;
constraint NotNull --onProperty telephone ;
constraint Digits --onProperty telephone --integer 10 --fraction 0 ;
field oneToMany --named pets --fieldType ~.model.Pet.java ;

@/* Visit */;
entity --named Visit ;
field temporal --type DATE --named date ;
constraint Future --onProperty date ;
field string --named description ;
constraint NotNull --onProperty description ;
field manyToOne --named pet --fieldType ~.model.Pet.java ;

@/* Adding relationships to Pet */;
cd ../Pet.java ;
field manyToOne --named owner --fieldType ~.model.Owner.java ;
field oneToMany --named visits --fieldType ~.model.Visit.java ;

@/* Create some beans */;
@/* Vets */;
java new-class --named Vets --package ~.model ;
java new-field  'private List<Vet> vets' ;
java new-method '@XmlElement public List<Vet> getVetList() {if (vets == null) {vets = new ArrayList<Vet>();}return vets;}' ;

@/* Building */;
echo You need to manually import the classes to Vets. Go to your IDE and fix it before pressing enter ;
wait ;
wait ;
build --notest ;


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

