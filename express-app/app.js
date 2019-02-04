// Importation de la biliotheque express
const express = require('express');
// Importation du module body-parser
const bodyParser = require("body-parser");

// Initialisation de l'application Express
const app = express();

// Importation des routes
const apiRouter = require("./modules/api-routes");
const appRouter = require("./modules/app-routes");
// Définition du dossier contenant les vues
app.set("views", "./views");
//Définition du moteur de rendu des vues
app.set("view engine", "pug");
// Traitement des données postées par des vues
app.use(bodyParser.json());
// Traitement des données postées par un formulaire web
app.use(bodyParser.urlencoded({
    extended: true
}));
// Affichage à la console de la date 
// et l'heure pour chaque requette
app.use((req, res, next) => {
    console.log(new Date() + "" + req.url);
    next();
});
// Gestion des ressources statiques
app.use(express.static(__dirname + '/public'));

//  Utilisation des routes importées
app.use("/api", apiRouter);
app.use(appRouter);

//Lacement de l'application
app.listen(3000);