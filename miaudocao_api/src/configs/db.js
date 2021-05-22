const mysql = require('mysql');

module.exports = mysql.createPool({
  host    : 'localhost',
  port    : '3306',
  user    : 'root',
  password: 'root',
  database: 'miaudocao'
});