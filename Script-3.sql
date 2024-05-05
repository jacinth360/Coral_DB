USE Team_9;

DROP TABLE IF EXISTS ITS2;
DROP TABLE IF EXISTS Tax_ITS2;
DROP TABLE IF EXISTS Seq_ITS2;
DROP TABLE IF EXISTS T_16S;
DROP TABLE IF EXISTS Tax_16S;
DROP TABLE IF EXISTS Seq_16S;
DROP TABLE IF EXISTS Sequences;
DROP TABLE IF EXISTS Photosymbiont;
DROP TABLE IF EXISTS Sample;
DROP TABLE IF EXISTS Observation;
DROP TABLE IF EXISTS Coral;



CREATE TABLE Coral (
    cid INT NOT NULL AUTO_INCREMENT,
--    oid INT NOT NULL,
    Species VARCHAR(500),
    Individual VARCHAR(500),
    Location VARCHAR(500),
    MapsLink VARCHAR(3000),
    Primary Key (cid)
--    FOREIGN KEY (oid) REFERENCES Observation(oid)
) ENGINE = INNODB;

CREATE UNIQUE INDEX IF NOT EXISTS Individual on Coral(Individual);

CREATE TABLE Observation (
    oid INT NOT NULL AUTO_INCREMENT,
    Size Float,
    Color CHAR(7),
    Photo VARCHAR(3000),
    cid INT NOT NULL,
    Primary Key (oid),
    Foreign Key (cid) REFERENCES Coral(cid)
    ON UPDATE NO ACTION
	ON DELETE NO ACTION
) ENGINE = INNODB;

ALTER TABLE Team_9.Observation ADD CONSTRAINT Observation_UNIQUE UNIQUE KEY (Photo,cid);
-- ALTER TABLE Team_9.Observation ADD Red INTEGER NULL;
-- ALTER TABLE Team_9.Observation ADD Green INTEGER NULL;
-- ALTER TABLE Team_9.Observation ADD Blue INTEGER NULL;


CREATE TABLE Sample(
	sid INT NOT NULL AUTO_INCREMENT,
	cid INT NOT NULL,
	Sample_name VARCHAR(30),
	Collected_date DATE,
	Primary Key (sid),
	Foreign Key (cid) REFERENCES Coral(cid)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION
) ENGINE = INNODB;

CREATE TABLE Sequences(
	seqid INT NOT NULL AUTO_INCREMENT,
	sid INT NOT NULL,
	sequencing_type ENUM('16S','ITS2'),
	fastq_file VARCHAR(100),
	fastq_rev_file VARCHAR(100),
	Primary Key (seqid),
	Foreign Key (sid) REFERENCES Sample(sid)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION
) ENGINE = INNODB;

CREATE TABLE T_16S (
    16S_ID INT NOT NULL AUTO_INCREMENT,
    seqid INT NOT NULL,
    16S_sequence varchar(300),
    Kingdom VARCHAR(300),
    Phylum VARCHAR(300),
    Class VARCHAR(300),
    `Order` VARCHAR(300),
    Family VARCHAR(300),
    Genus VARCHAR(300),
    Species VARCHAR(300),
    Relative_Abundance DOUBLE,
    Primary Key (16S_ID),
    FOREIGN KEY (seqid) REFERENCES Sequences(seqid)
    ON UPDATE CASCADE
	ON DELETE NO ACTION
) ENGINE = INNODB;

-- CREATE NEW 16S TABLE STRUCTURE
CREATE TABLE Tax_16S (
    16S_tax_id INT NOT NULL AUTO_INCREMENT,
    ASV char(8),
    16S_sequence varchar(300),
    Kingdom VARCHAR(300),
    Phylum VARCHAR(300),
    Class VARCHAR(300),
    `Order` VARCHAR(300),
    Family VARCHAR(300),
    Genus VARCHAR(300),
    Species VARCHAR(300),
    Primary Key (16S_tax_id)
) ENGINE = INNODB;

CREATE TABLE Seq_16S (
    16S_Seq_ID INT NOT NULL AUTO_INCREMENT,
    Relative_Abundance DOUBLE,
    16S_tax_id INT NOT NULL,
    seqid INT NOT NULL,
    Primary Key (16S_Seq_ID),
    FOREIGN KEY (16S_tax_id) REFERENCES Tax_16S(16S_tax_id)
    ON UPDATE CASCADE
    ON DELETE NO ACTION,
    FOREIGN KEY (seqid) REFERENCES Sequences(seqid)
    ON UPDATE CASCADE
	ON DELETE NO ACTION
) ENGINE = INNODB;

CREATE INDEX IF NOT EXISTS Phylogeny_16S
ON Tax_16S(Kingdom, Phylum, Class, `Order`, Family, Genus, Species);


CREATE TABLE Tax_ITS2 (
	ITS2_ID INT NOT NULL AUTO_INCREMENT,
    ITS2_sequence varchar (300),
    Kingdom VARCHAR(300),
    Phylum VARCHAR(300),
    Class VARCHAR(300),
    `Order` VARCHAR(300),
    Family VARCHAR(300),
    Genus VARCHAR(300),
    Species VARCHAR(300),
    Primary Key (ITS2_ID)
)ENGINE = INNODB;

CREATE TABLE Seq_ITS2 (
	ITS2_ID INT NOT NULL,
	seqid INT NOT NULL,
    Relative_Abundance DOUBLE,
    Foreign Key (ITS2_ID) REFERENCES Tax_ITS2(ITS2_ID)
    ON UPDATE CASCADE
    ON DELETE NO ACTION,
    FOREIGN KEY (seqid) REFERENCES Sequences(seqid)
    ON UPDATE CASCADE
	ON DELETE NO ACTION
)ENGINE = INNODB;

CREATE INDEX IF NOT EXISTS Phylogeny_ITS2
ON Tax_ITS2(Kingdom, Phylum, Class, `Order`, Family, Genus, Species);

CREATE TABLE Photosymbiont(
	phid INT NOT NULL AUTO_INCREMENT,
	species VARCHAR(100),
	relative_abundance DOUBLE,
	sid INT NOT NULL,
	Primary Key (phid),
	Foreign Key (sid) REFERENCES Sample (sid)
	ON UPDATE NO ACTION
	ON DELETE NO ACTION
) ENGINE = INNODB;
