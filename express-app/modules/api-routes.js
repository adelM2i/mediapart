const express = require("express");
const router = express.Router();
// Importation du module de base de données
const db = require("./db-connection");
// Securisation des routes /api
router.use("/*", (request, response, next) => {
    let key = request.query.key;
    if (key != "123") {
        response.send(403, "Accès interdit");
    }
    //Appel au prochain middleware
    next();
});
router.get("/articles", (req, res) => {
    db.query("select * from vue_articles", (err, data) => {
        if (err) {
            res.statut(404).send(err);
        } else {
            res.json(data);
        }
    });
});
router.get("/article/:id", (req, res) => {
    db.query("select * from vue_articles where id=?", [req.params.id],
        (err, data) => {
            if (err) {
                res.status(404).send(err);
            } else {
                res.json(data);
            }
        });
});

module.exports = router;