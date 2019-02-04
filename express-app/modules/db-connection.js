// Importation du module mysql
const mysql = require("mysql");
// Creation de la connection 
var connection = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: ""
});
// Ouverture de la base de données
connection.query("use mediapart_blog");
// Exportation du module
module.exports = connection;