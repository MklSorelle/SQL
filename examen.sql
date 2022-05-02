CREATE DATABASE IF NOT EXISTS `db_aviation_exam`

USE db_aviation_exam ;
CREATE TABLE `compagnies` (
    `comp` CHAR(4),
    `street` VARCHAR(20),
    `city` VARCHAR(20) NULL,
    `name` VARCHAR(20) NOT NULL,
	`numstreet` INT UNSIGNED,
	`status` ENUM ('published', 'unpublished', 'draft') DEFAULT 'draft',
    CONSTRAINT pk_compagny PRIMARY KEY (`comp`)
    )
    ENGINE=InnoDB ;

CREATE TABLE `pilots` (
    `certificate` VARCHAR(6) NOT NULL,
    `numflying` DECIMAL(7,1) NULL,
    `compagny` CHAR(4) NULL,
    `name` VARCHAR(20) NOT NULL,
	`plane` ENUM('A380','A320','A340'),
	`created` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`birth_date` DATE,
	`next_flight` DATETIME,
	`num_jobs` SMALLINT DEFAULT 0,
	`bonus` SMALLINT DEFAULT 0,
    CONSTRAINT pk_compagny PRIMARY KEY (`certificate`)
    )
    ENGINE=InnoDB ;

ALTER TABLE pilots
ADD CONSTRAINT fk_pilots_compagny FOREIGN KEY (compagny) REFERENCES compagnies(`comp`);

ALTER TABLE pilots
ADD CONSTRAINT un_name UNIQUE (`name`);

INSERT INTO compagnies (comp, street, city, name, numstreet)
    VALUES
    ('AUS', 'sidney', 'Australie', 'AUSTRA Air', 19),
    ('CHI', 'chi', 'Chine', 'CHINA Air', NULL),
    ('FRE1', 'beaubourg', 'France', 'Air France', 17),
    ('FRE2', 'paris', 'France', 'Air Electric', 22),
    ('SIN', 'pasir', 'Singapour', 'SIN A', 15),
    ('ITA', 'mapoli', 'rome', 'Italia Air', 20);

INSERT INTO pilots (certificate, numflying, compagny, name, birth_date, next_flight, num_jobs, bonus, plane)
    VALUES
    ('ct-1', '90.0', 'AUS', 'Alan', '2001-03-04', '2022-04-04 07:50:52', 30, 1000, 'A380'),
    ('ct-10', '90.0', 'FRE1', 'Tom', '1978-02-04', '2022-12-04 09:50:52', 10, 500, 'A320'),
    ('ct-100', '200.0', 'SIN', 'Yi','1978-02-04', '2022-12-04 09:50:52', 10, 500, 'A320'),
    ('ct-11', '200.0', 'AUS', 'Sophie', '1978-10-17', '2022-06-11 12:00:52', 50, 1000, 'A320'),
    ('ct-12', '190.0', 'AUS', 'Albert', '1990-04-04', '2022-05-08 12:50:52', 10, 1000, 'A380'),
    ('ct-16', '190.0', 'SIN', 'Yan', '1998-01-04', '2022-05-08 12:50:52', 30, 500, 'A340'),
    ('ct-56', '300.0', 'AUS', 'Benoit', '2000-01-04', '2022-02-04 12:50:52', 7, 2000, 'A380'),
    ('ct-6', '20.0', 'FRE1', 'John', '2000-01-04', '2022-12-04 12:50:52', 13, 500, 'A380'),
    ('ct-7', '80.0', 'CHI', 'Pierre', '1977-01-04', '2022-05-04 12:50:52', 8, 500, 'A340');    

-- On va créer la table plane dans notre base de données

CREATE TABLE `planes` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `name` CHAR(5),
    `description` TEXT,
    `numFlying` DECIMAL(8,1),
    CONSTRAINT pk_planes PRIMARY KEY (`id`)
    )
    ENGINE=InnoDB ;

ALTER TABLE pilots
ADD COLUMN `plane_id` INT UNSIGNED,
ADD CONSTRAINT `fk_pilots_planes`
FOREIGN KEY (`plane_id`) REFERENCES `planes`(`id`);

INSERT INTO `planes` (`name`, `description`, `numFlying`)
VALUES
	('A320', 'Avion de ligne quadriréacteur', 17000.0),
	('A340', 'Moyen courier', 50000.0),
	('A380', 'Gros porteur', 12000.0);

UPDATE `pilots`
SET `plane_id` = 1
WHERE `plane` = 'A320';

UPDATE `pilots`
SET `plane_id` = 2
WHERE `plane` = 'A340';

UPDATE `pilots`
SET `plane_id` = 3
WHERE `plane` = 'A380';

-- Je supprime la colonne `plane` de la table `pilots`
ALTER TABLE pilots
DROP COLUMN plane;


------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 01 Exercice écrire les relations

-- 1 pilote peut être assigner à 0 ou N trips
-- 1 trip peut attribué 1 ou N pilots
-- Ici nous avons la relation N.N, ainsi nous aurons une table intermédiare pilot_trip qui va recevoir les deux clés étrangères certificate et trip_id

-- 02 Exercice schéma
                                            -- UML en piece jointe.jpg

-- 03 Exercice passer au code

CREATE TABLE `trips` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `name` VARCHAR(20),
    `departure` VARCHAR(20),
    `arrival` VARCHAR(20),
	`created` DATETIME,
    CONSTRAINT pk_trips PRIMARY KEY (`id`)
    )
    ENGINE=InnoDB ; 

INSERT INTO `trips` (`name`, `departure`, `arrival`, `created`)
VALUES
	('direct', 'Paris', 'Brest',  '2020-01-01 00:00:00'),
	('direct', 'Paris', 'Berlin',  '2020-02-01 00:00:00'),
	('direct', 'Paris', 'Barcelone',  '2020-08-01 00:00:00'),
	('direct', 'Amsterdan', 'Brest',  '2020-11-11 00:00:00'),
	('direct', 'Alger', 'Paris',  '2020-09-01 00:00:00'),
	('direct', 'Brest', 'Paris',  '2020-12-01 00:00:00');

CREATE TABLE `pilot_trip` (
    `pilot_certificate` VARCHAR(6),
    `trip_id` INT UNSIGNED,
    CONSTRAINT `pk_pilotTrip` PRIMARY KEY (`pilot_certificate`, `trip_id`)
    )
    ENGINE=InnoDB ;

ALTER TABLE `pilot_trip`
ADD CONSTRAINT `fk_pilotTrip_pilots` FOREIGN KEY (`pilot_certificate`) REFERENCES `pilots`(`certificate`),
ADD CONSTRAINT `fk_pilotTrip_trips` FOREIGN KEY (`trip_id`) REFERENCES `trips`(`id`);

INSERT INTO `pilot_trip` (`pilot_certificate`, `trip_id`)
VALUES
	('ct-10', 1),
	('ct-6', 2),
	('ct-100', 1),
	('ct-11', 3),
	('ct-12', 4),
	('ct-10', 4),
	('ct-12', 5);


-- 04 Exercice les pilotes sans trajet

SELECT name, certificate
FROM pilots
WHERE certificate NOT IN (SELECT pilot_certificate FROM pilot_trip);

-- 05 Exercice trajet des pilotes

SELECT pilot_certificate, trip_id, name, departure, arrival
FROM pilot_trip AS pt
INNER JOIN trips as t ON trip_id = id
GROUP BY pilot_certificate, trip_id;