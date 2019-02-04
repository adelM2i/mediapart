const express = require("express");
const router = express.Router();
const sha1 = require("sha-1");
const cookieParser = require("cookie-parser");
const session = require("express-session");
const fileUpload = require("express-fileupload");
// Importation du module de base de données
const db = require("./db-connection");
router.use(cookieParser());
router.use(session({
    secret: "chuuuut"
}));
router.use(fileUpload());
// Middleware de récuperation de la liste des articles
router.use("/", (req, res, next) => {
    db.query("select * from vue_articles", (err, data) => {
        if (err) {
            res.status(404).send(err);
        } else {
            req.articles = data;
            next();
        }
    });
});
router.post("^/article/:id([0-9]+)$", (req, res, next) => {
    let postedData = {
        email_id: req.body.email,
        texte: req.body.texte,
        article_id: req.params.id
    };
    db.query("INSERT INTO commentaires set ?", postedData, (err) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.redirect(req.url);
        }
    });
});
router.post("/inscription", (req, res, next) => {
    let postedData = {
        nom: req.body.nom,
        prenom: req.body.prenom,
        email: req.body.email,
        mot_de_passe: sha1(req.body.mot_de_passe)
    };
    db.query("insert into auteurs set ?", postedData,
        (err) => {
            if (err) {
                res.status(500).send(err);
            } else {
                res.redirect("/");
            }
        }
    );
});
// Middleware pour la récuperation des données d'un article
router.use("^/article/:id([0-9]+)$", (req, res, next) => {
    db.query("select * from vue_articles where id =?",
        [req.params.id],
        (err, data) => {
            if (err) {
                res.status(404).send(err);
            } else {
                req.article = data[0];
                next();
            }
        }
    );
});
// Middleware pour la récuperation les commentaires  d'un article
router.use("^/article/:id([0-9]+)$", (req, res, next) => {
    db.query("select email_id, texte ,date_format(date_creation, '%d/%m/%Y') as date_creation from commentaires where article_id =? order by date_creation",
        [req.params.id],
        (err, data) => {
            if (err) {
                res.status(404).send(err);
            } else {
                req.commentaires = data;
                next();
            }
        }
    );
});
// Middleware pour le login
router.use("/login", (req, res, next) => {
    if (req.method == "POST") {
        db.query("select * from auteurs where email=? and mot_de_passe=?",
            [req.body.email, sha1(req.body.mot_de_passe)],
            (err, data) => {
                console.log(req.session.loginTentative);
                if (err) {
                    res.status(500).send(err);
                } else if (data.length == 0 && req.session.loginTentative > 2) {
                    res.redirect("/inscription");
                } else if (data.length == 0) {

                    req.session.loginTentative ? req.session.loginTentative++ : req.session.loginTentative = 1;
                    req.session.errorMessage = "Tentative " + req.session.loginTentative + " Veuillez corriger";
                    res.redirect("/login");
                } else {
                    req.session.user = data[0];
                    req.session.loginTentative = 0;
                    res.redirect("/");
                }
            }
        );
    } else {
        next();
    }
});
//Création de route Home
router.get("/hello/:name/:age", helloRoute);
router.get("/", (titi, toto) => {
    params = {
        pageTitle: "Ma super Application",
        userName: "Express NodesJS",
        fruitList: [
            "fraise", "framboise", "banane", "pomme"
        ],
        personeList: [{
                id: 2,
                name: "Brahé",
                firstName: "Tyco"
            },
            {
                id: 3,
                name: "Truig",
                firstName: "Alin"
            }
        ],
        articleListe: titi.articles,

        user: titi.session.user
    }
    toto.render('home', params);
});

// Création de route contact
router.get("/contact", (req, res) => {
    res.render("contact", {
        pageTitle: "Page contact",
        user: req.session.user
    });
})
// Création route inscription
router.get("/inscription", (ins, res) => {
    res.render("inscription", {
        pageIscrip: "page inscrip",
        user: ins.session.user
    });
});
// Creation route pour details d'un article
router.get("^/article/:id([0-9]+)$", (req, res) => {
    console.log(req.article);
    res.render("article.pug", {
        article: req.article,
        commentaires: req.commentaires,
        user: req.session.user
    });
});
// Middleware pour authentification auteur pour écrire sur la base de données
router.use("^/novarticle$", (req, res, next) => {
    if (!req.session.user) {
        req.session.errorMessage = "Vous devez etre authentifié pour écrire un nouvel article";
        res.redirect("/login");
    } else {
        next();
    }
});
//  Middleware pour nouvel article
router.use("^/novarticle$", (req, res, next) => {
    db.query("select *from rubriques", (err, data) => {
        if (err) {
            res.status(500).send(err);
        } else {
            req.rubqListe = data;
            next();
        }
    });
});
// Creation de route nouvel article
router.get("^/novarticle$", (req, res) => {
    res.render("novarticle", {
        user: req.session.user,
        rubqListe: req.rubqListe
    });
});
// Poster les données saisies c.a.d l'integrer dans la table article
router.post("^/novarticle$", (req, res) => {
    // Traitement de l'upload
    let fileName = null;
    // Limitation de type de fichiers à ces trois cthegories suivantes
    let allowedTypes = {
        "image/png": "png",
        "image/jpeg": "jpg",
        "image/gif": "gif"
    };
    if (req.files.photo) {
        let imageType = req.files.photo.mimetype;
        if (imageType in allowedTypes) {
            let now = new Date();
            let currentTime = now.getTime();
            fileName = currentTime + allowedTypes[imageType];
            req.files.photo.mv("./public/" + fileName);
        }
    }
    let postedData = {
        titre: req.body.titre,
        texte: req.body.texte,
        chapo: req.body.chapo,
        rubrique_id: req.body.rubrique,
        date_publication: new Date(),
        auteur_id: req.session.user.id,
        photo: fileName
    }
    db.query("insert into articles set ?", postedData,
        (err) => {
            if (err) {
                res.status(500).send(err);
            } else {
                res.redirect("/");
            }
        });
});
// creation route login inscription
router.get("/login", (log, res) => {
    let params = {
        error: log.session.errorMessage,
        user: log.session.user
    };
    log.session.errorMessage = null;
    res.render("login", params);
});
// creation de route pour deconnection
router.get("/logout", (req, res) => {
    req.session.destroy();
    res.redirect("/");
});

function helloRoute(request, response) {
    let html = "<h1>HelloM2i " + request.params.name + "</h1>";
    if (request.params.age < 18) {
        html += "<p> Vous etes mineur</p>";
    } else {
        html += "<p>Vous etes majeur</p>";
    }
    response.status(200).send(html);
}
module.exports = router;