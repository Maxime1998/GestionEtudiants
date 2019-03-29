CREATE DATABASE gestionEtudiant;

DROP TABLE IF EXISTS etudiant;
CREATE TABLE IF NOT EXISTS etudiant (
	numEtud integer,
 	nomEtud varchar(50) ,
 	prenomEtud varchar(50) ,
 	dateNaissance date,
 	sexe varchar(15),
 	adr1 varchar(75),
 	adr2 varchar(75),
 	telephone varchar(20),
 	email varchar(75),
 	typeBac varchar(75),
 	anneeBac integer,
 	noteS1 integer,
 	ResultatS1 varchar,
 	commentaireS1 varchar,
 	noteS2 integer,
 	ResultatS2 varchar,
 	commentaireS2 varchar,
 	noteS3 integer,
 	ResultatS3 varchar,
 	commentaireS3 varchar,
 	noteS4 integer,
 	ResultatS4 varchar,
 	commentaireS4 varchar ,
 	dut2ou3 smallint,
 	apresDUT varchar,
 	promo integer, 
	codeCouleur varchar,
 	constraint pk_etudiant PRIMARY KEY (numEtud)
 	
);

CREATE OR REPLACE FUNCTION verifNoteCorrect() RETURNS TRIGGER AS $$
begin
PERFORM  noteS1,noteS2,noteS3,noteS4 from etudiant where noteS1 < 0 or noteS1 > 20 or noteS2 < 0 or noteS2 > 20 or noteS3 < 0 or noteS3 > 20 or noteS4 < 0 or noteS4 > 20;
	if(FOUND) then 
		raise exception 'note incorrect';
	end if;
        return NEW;
	end;$$
	LANGUAGE 'plpgsql';

DROP TRIGGER if EXISTS trig_verifNoteCorrect ON etudiant;
	CREATE TRIGGER trig_verifNoteCorrect
	BEFORE INSERT OR UPDATE of noteS1,noteS2,noteS3,noteS4 ON etudiant
	FOR each ROW
	EXECUTE PROCEDURE verifNoteCorrect();
	
	
CREATE OR REPLACE FUNCTION verifDateNaissanceCorrect() RETURNS TRIGGER AS $$
begin
 
perform dateNaissance from etudiant where (age(CURRENT_DATE, dateNaissance) < '12');
		raise exception 'date incorrect';
	end if;
        return NEW;
	end;$$
	LANGUAGE 'plpgsql';

DROP TRIGGER if EXISTS trig_verifDateNaissanceCorrect ON etudiant;
	CREATE TRIGGER trig_verifDateNaissanceCorrect
	BEFORE INSERT OR UPDATE of dateNaissance ON etudiant
	FOR each ROW
	EXECUTE PROCEDURE verifDateNaissanceCorrect();
	
	



CREATE OR REPLACE FUNCTION verifNonNull() RETURNS TRIGGER AS $$
begin
perform nom,prenom,dateNaissance,telephone,email,typeBac,anneeBac from etudiant where nom=NULL or prenom=NULL or dateNaissance = NULL or telephone =NULL or email=NULL or typeBac = NULL or anneeBac = NULL; 
	if(FOUND) then 
		raise exception 'certains champs ne sont pas complèté ';
	end if;
        return NEW;
	end;$$
	LANGUAGE 'plpgsql';

DROP TRIGGER if EXISTS trig_verifNonNull ON etudiant;
	CREATE TRIGGER trig_verifNonNull
	BEFORE INSERT OR UPDATE of nom,prenom,dateNaissance,telephone,email,typeBac,anneBac ON etudiant
	FOR each ROW
	EXECUTE PROCEDURE verifDate();	



CREATE OR REPLACE FUNCTION verifDate() RETURNS TRIGGER AS $$
begin
perform anneeBac from etudiant where anneeBac > promo; 
	if(FOUND) then 
		raise exception 'Année du bac est incorrect';
	end if;
        return NEW;
	end;$$
	LANGUAGE 'plpgsql';

DROP TRIGGER if EXISTS trig_verifDateBacCorrect ON etudiant;
	CREATE TRIGGER trig_verifDateBacCorrect
	BEFORE INSERT OR UPDATE of anneeBac ON etudiant
	FOR each ROW
	EXECUTE PROCEDURE verifDate();	
