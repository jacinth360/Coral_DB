-- TEAM 9 CORAL META
-- INSERTING DATA SQL
USE Team_9;

-- Corals table
SHOW CREATE TABLE Coral;
-- Load 16S sampledata (must be done in bioed)
LOAD DATA LOCAL INFILE 'cah_16s_sampledata.csv'
IGNORE
INTO TABLE Coral
FIELDS TERMINATED BY ','
IGNORE 1 LINES
(Species, Individual, Location, MapsLink);
-- Load ITS2 sampledata
LOAD DATA LOCAL INFILE 'SymPortal_REAL_DATA.csv'
IGNORE
INTO TABLE Coral
FIELDS TERMINATED BY ','
ENCLOSED BY "\""
IGNORE 1 LINES 
(Species, Individual, Location, MapsLink);


INSERT INTO Photosymbiont (species, relative_abundance, sid)
VALUES ()

SHOW CREATE TABLE Sequences;

SELECT MAX(LENGTH(16s_sequence)) from T_16S;

SELECT MAX(LENGTH(16s_sequence)) from Tax_16S;

EXPLAIN SELECT s.fastq_file, ts.`16S_tax_id`, ts.`Order` from Sequences s 
JOIN Seq_16S ss ON s.seqid = ss.seqid 
JOIN Tax_16S ts ON ss.`16S_tax_id` = ts.`16S_tax_id` 
WHERE s.sequencing_type = '16S'
AND ts.Phylum LIKE 'Proteo%'
LIMIT 10;

SELECT DISTINCT ts.Kingdom from Tax_16S ts;

SELECT Individual, location, species, color, mapslink 
FROM Coral c join Observation o on c.cid = o.cid
WHERE location = 'Crook' AND species = 'PAST';

SELECT sid, cid, Sample_name, sequencing_type, fastq_file
FROM Coral c join Sample s using (cid)
join Sequences s2 using (sid)
ORDER BY sid;
