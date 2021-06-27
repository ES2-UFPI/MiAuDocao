const mysql = require('mysql');
const { nanoid } = require('nanoid');

function createConnection() {
  return mysql.createConnection({
    host    : process.env.DB_HOST,
    port    : process.env.DB_PORT,
    user    : process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
  });
}

async function createUser() {
  let connection = createConnection();
  const id = nanoid(20);
  connection.query(`INSERT INTO usuario VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`, [
    id,
    'Pessoa',
    'a',
    'pessoa@pessoa.com',
    '12345',
    'pessoa123',
    '2021',
    'gato',
    'pequeno',
    'macho',
    'filhote',
    10
  ], function (error) {
    if (error) console.log(error);
  });
  connection.end();
  return id;
}

async function deleteAll() {
  let connection = createConnection();
  connection.query(`SET FOREIGN_KEY_CHECKS = 0`, function (error) {
    if (error) console.log(error);
  });
  connection.query(`TRUNCATE TABLE animal`, function (error) {
    if (error) console.log(error);
  });
  connection.query(`TRUNCATE TABLE usuario`, function (error) {
    if (error) console.log(error);
  });
  connection.query(`SET FOREIGN_KEY_CHECKS = 1`, function (error) {
    if (error) console.log(error);
  });
  connection.end();
}

module.exports = {
  createUser,
  deleteAll
}