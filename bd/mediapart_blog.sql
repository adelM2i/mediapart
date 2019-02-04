/*************************************************************
********MEDIAPART-Blog
*************************************************************/
-- Supprimer la base de données si elle exist --
drop database Mediapart_blog;

-- creation de la base de données
create database if not exists Mediapart_blog 
-- activation de la base de données crée
DEFAULT CHARACTER SET = UTF8;
use Mediapart_blog;

-- désactivation des contraintes sur la base de données --
set foreign_key_checks  = 0;

-- creation de la table des articles --

CREATE TABLE articles (
    id INT UNSIGNED AUTO_INCREMENT,
    titre VARCHAR(80) NOT NULL,
    chapô TEXT NOT NULL,
    texte TEXT NOT NULL,
    date_publication DATE NOT NULL,
    photo VARCHAR(80),
    rubrique_id TINYINT UNSIGNED NOT NULL,
    auteur_id SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (id)
);

-- creation de la table rubriques--

CREATE TABLE rubriques (
    id TINYINT UNSIGNED AUTO_INCREMENT,
    rubrique VARCHAR(45) NOT NULL,
    PRIMARY KEY (id)
);

-- creation de la table auteurs --

CREATE TABLE auteurs (
    id SMALLINT UNSIGNED AUTO_INCREMENT,
    nom VARCHAR(45) NOT NULL,
    prenom VARCHAR(45),
    avatar VARCHAR(45),
    mot_de_passe varchar(45) not null,
    email varchar(60) not null,
    PRIMARY KEY (id)
);

-- Création de la table articles_categories --

CREATE TABLE articles_categories (
    article_id INT UNSIGNED,
    categorie_id TINYINT UNSIGNED,
    PRIMARY KEY (article_id , categorie_id)
);

-- Création de la table categories --

CREATE TABLE categories (
    id TINYINT UNSIGNED AUTO_INCREMENT,
    categorie VARCHAR(40) NOT NULL,
    PRIMARY KEY (id)
);

-- Création de la table commentaires --

CREATE TABLE commentaires (
    id SMALLINT UNSIGNED AUTO_INCREMENT,
    email_id VARCHAR(60) NOT NULL,
    date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- creation
    -- de la date automatiquement et elle ne peut pas etre null--
    texte TEXT,
    article_id INT UNSIGNED,
    PRIMARY KEY (id)
);

-- Création de la table Liens --

CREATE TABLE liens (
    id INT UNSIGNED AUTO_INCREMENT,
    libelle VARCHAR(50) NOT NULL,
    url VARCHAR(50) NOT NULL,
    PRIMARY KEY (id)
);

-- Création de la table articles_liens --

CREATE TABLE articles_liens (
    article_id INT UNSIGNED,
    lien_id INT UNSIGNED,
    PRIMARY KEY (article_id , lien_id)
);

-- Réactivation du conrôle de l'integrité référencielle --
set foreign_key_checks = 1;

-- Ajout des contraintes d'integrité referenielle --
alter table articles add constraint articles_to_rubriques
foreign key (rubrique_id) references rubriques(id);

-- Ajout des contraintes d'integrité referenielle --
alter table articles add constraint articles_to_auteurs
foreign key (auteur_id) references auteurs(id);

-- Ajout des contraintes d'integrité referenielle --
alter table articles_categories add constraint articles_categories_to_categories
foreign key (categorie_id) references categories(id);

-- Ajout des contraintes d'integrité referenielle --
alter table articles_categories add constraint articles_categories_to_articles
foreign key (article_id) references articles(id);

-- Ajout des contraintes d'integrité referenielle --
alter table articles_liens add constraint articles_liens_to_liens
foreign key (lien_id) references liens(id);

-- Ajout des contraintes d'integrité referenielle --
alter table articles_liens add constraint articles_liens_to_articles
foreign key (article_id) references articles(id);

-- Ajout des contraintes d'integrité referenielle --
alter table commentaires add constraint commentaires_to_articles
foreign key (article_id) references articles(id);


/**************************************************************************
*****Isertion des données**************************************************
***************************************************************************/

-- Les constantes --


insert into rubriques (rubrique) values ('Le journal'),('Studio'),('Le club'),('A propos');

insert into categories (categorie) values ('International'), ('France'), ('Economie'),('Culture'),
('Dossiers'), ('Fil actualités'), ('Journal imprimé'),('Vidéos'), ('Podcasts'), ('Documentaires'), 
('Port Folios'),('Panoramiques'), ('Depuis 48 heures'), ('Les blogs'), ('Les editions'),('Agenda'),
('La charte'), ('Particper'), ('Qui somme nous'),('Besoin aide'),('Nous contacter'), ('Plan du site'),
('Recrutement'),('Frenchleaks');

insert into auteurs (nom, prenom, avatar,mot_de_passe,email) values ('MAGNAUDEIX', 'Mathieu', 'Bomby','mag123','magnaudei@gmail.com'), 
('SALVI', 'eLLEN', 'Fleur','sal123','salvvi@yahoo.com'),('BONNET', 'Francois', 'Poupay','bon123','bonnet@hotmail.com'),('GOANEC', 'Mathilde', 'Charlotte','goa123','goanec@gmail.com');


 
 insert into articles (titre, chapô, texte, date_publication, photo, rubrique_id, auteur_id) values 
 ('Mélenchon et les perquisitions', ' Nombreux sont ceux qui s’indignent ',  ' La meilleure défense, c’est l’attaque.',
 '2018-10-17', 'photo elephant',2,1),
 ('Mélenchon et les perquisitions', ' Nombreux sont ceux qui s’indignent ', 
 ' La meilleure défense, c’est l’attaque.','2018-10-17','photo elephant',1,3),
 ('Mélenchon et les perquisitions', 
 ' Nombreux sont ceux qui s’indignent ',' La meilleure défense, c’est l’attaque.','2018-10-17','photo elephant',2,2),
 ('Mélenchon et les perquisitions',' Nombreux sont ceux qui s’indignent ', ' La meilleure défense, c’est l’attaque.',
 '2018-10-17','photo elephant',1,1),
('Mélenchon et les perquisitions', ' Nombreux sont ceux qui s’indignent ',  ' La meilleure défense, c’est l’attaque.',
 '2018-10-17', 'photo elephant',4,1),
 ('Mélenchon et les perquisitions', ' Nombreux sont ceux qui s’indignent ', 
 ' La meilleure défense, c’est l’attaque.','2018-10-17','photo elephant',1,4),
 ('Mélenchon et les perquisitions', 
 ' Nombreux sont ceux qui s’indignent ',' La meilleure défense, c’est l’attaque.','2018-10-17','photo elephant',4,4),
 ('Mélenchon et les perquisitions',' Nombreux sont ceux qui s’indignent ', ' La meilleure défense, c’est l’attaque.',
 '2018-10-17','photo elephant',1,1),
 ('Mélenchon et les perquisitions', ' Nombreux sont ceux qui s’indignent ',  ' La meilleure défense, c’est l’attaque.',
 '2018-10-17', 'photo elephant',2,1),
 ('Mélenchon et les perquisitions', ' Nombreux sont ceux qui s’indignent ', 
 ' La meilleure défense, c’est l’attaque.','2018-10-17','photo elephant',1,3),
 ('Mélenchon et les perquisitions', 
 ' Nombreux sont ceux qui s’indignent ',' La meilleure défense, c’est l’attaque.','2018-10-17','photo elephant',2,2),
 ('Mélenchon et les perquisitions',' Nombreux sont ceux qui s’indignent ', ' La meilleure défense, c’est l’attaque.',
 '2018-10-17','photo elephant',1,1),
('Mélenchon et les perquisitions', ' Nombreux sont ceux qui s’indignent ',  ' La meilleure défense, c’est l’attaque.',
 '2018-10-17', 'photo elephant',4,1),
 ('Mélenchon et les perquisitions', ' Nombreux sont ceux qui s’indignent ', 
 ' La meilleure défense, c’est l’attaque.','2018-10-17','photo elephant',1,4),
 ('Mélenchon et les perquisitions', 
 ' Nombreux sont ceux qui s’indignent ',' La meilleure défense, c’est l’attaque.','2018-10-17','photo elephant',4,4),
 ('Mélenchon et les perquisitions',' Nombreux sont ceux qui s’indignent ', ' La meilleure défense, c’est l’attaque.',
 '2018-10-17','photo elephant',1,1);
 


insert into commentaires (email_id, texte, article_id) values ('Mediapartcelebrated@gmail.com',
'n contrast, however, our battle-cry after a decade in existence could well be: “Ten years, its not enough!”. For ther
 is so much to do, so many battles to be ',3), ('You can downloa@yahoo.fr','Antiféministe, homophobe, pro-armes,
 climato-sceptique, pro-Netanyahou, ultralibéral le vice-président américain Mike Pence incarne un espoir pour la droite',2),
 ('journalistes@hotmail.com','Les agressions à caractère politique se multiplient à l’approche du deuxième tour de
 la présidentielle au Brésil, où le candidat d extrême droite Jair Bolsonaro est donné grand favori. Les militants du PT,
 les journalistes, les minorités sexuelles ou encore les activistes sans-terre sont les premiers visés. La haine nourrit
 la campagne de Bolsonaro, qui multiplie les références à la dictature brésilienne.',2),('Mona Chollet@gmail.com',
 'Publié par La Découverte, Sexe, Race & Colonies a bénéficié d’armes de promotion massive. Les arguments de vente contenus
 dans son introduction (nombre d’auteurs, nombre d’images, échelle mondiale) servent en fait à couvrir l’obscénité d’un zoo
 humain d’un nouveau genre, imprimé sur papier glacé. Car l’obscène s’exhibe et n’existe que lorsqu’il y a, comme ici,
 volonté – commerciale - de montrer.',1);
 
 
  insert into liens (libelle, url) values ('politique','www.mediapart.fr/journal/mot-cle/politique'),
  ('Enquetes','www.mediapart.fr/journal/international'),('Reportages','www.mediapart.fr/journal/type-darticles/reportage'),
 ('google', 'https://wwww.google.fr'),('mediaprt', 'https//:www.mediapart.fr');
 
  
 
insert into articles_liens (article_id , lien_id) values (2,1),(2,2),(3,2),(10,3),(11,3),(12,1),(14,3);

insert into articles_categories (article_id , categorie_id) values (3,1),(1,2),(1,4),(13,3),(9,1);

/**************************************************************************************************
*****Création des vues
**************************************************************************************************/

create or replace view vue_articles as 
SELECT 
    a.id,
    a.titre,
    DATE_FORMAT(a.date_publication, '%d/%M/%Y') AS date_publication,
    -- convertir la date en format française y l'année 2 chiffres Y 4 chiffres
    au.nom AS nom_auteur,
    r.rubrique,
    COUNT(c.id) AS nb_commentaires,
    GROUP_CONCAT(DISTINCT cat.categorie) AS liste_categorie,
    auteur_id, rubrique_id
FROM
    articles AS a
        INNER JOIN
    auteurs AS au ON au.id = a.auteur_id
        INNER JOIN
    rubriques AS r ON r.id = a.rubrique_id
        LEFT JOIN
    commentaires AS c ON a.id = c.article_id
        LEFT JOIN
    articles_categories AS ac ON a.id = ac.article_id
        LEFT JOIN
    categories AS cat ON cat.id = ac.categorie_id
GROUP BY a.id
;
 
 
 
 

