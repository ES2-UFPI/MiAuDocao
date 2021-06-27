const { nanoid } = require('nanoid');
const { compressImage } = require('../utils/images');
const isBase64 = require('is-base64');
const bcrypt = require('bcrypt');
const pool = require('../configs/db');

exports.get = async (req, res, next) => {
  const email = req.query.email;

  pool.getConnection((err, connection) => {
    if (err) {
      res.status(500).send({
        type: 'Database error',
        description: 'Something went wrong. Try again.'
      });
    }
    connection.query(`SELECT * FROM usuario WHERE email = ?`, [
      email
    ], function (error, results) {
      if (error) {
        connection.release();
        res.status(400).send({
          type: 'Database error',
          description: 'One or more values are invalid.'
        });
      } else {
        if (results[0]) {
          connection.release();
          let data = {
            id: results[0].id,
            nome: results[0].nome,
            foto: results[0].foto.toString(),
            email: results[0].email,
            telefone: results[0].telefone,
            data_cadastro: results[0].data_cadastro,
            pref_especie: results[0].pref_especie,
            pref_porte: results[0].pref_porte,
            pref_sexo: results[0].pref_sexo,
            pref_faixa_etaria: results[0].pref_faixa_etaria,
            pref_raio_busca: results[0].pref_raio_buca
          }
          res.status(200).json(data);
        } else {
          connection.query(`SELECT * FROM usuario WHERE id = ?`, [
            email
          ], function (error, results) {
            connection.release();
            if (error) {
              res.status(400).send({
                type: 'Database error',
                description: 'One or more values are invalid.'
              });
            } else {
              if (results[0]) {
                let data = {
                  id: results[0].id,
                  nome: results[0].nome,
                  foto: results[0].foto.toString(),
                  email: results[0].email,
                  telefone: results[0].telefone,
                  data_cadastro: results[0].data_cadastro,
                  pref_especie: results[0].pref_especie,
                  pref_porte: results[0].pref_porte,
                  pref_sexo: results[0].pref_sexo,
                  pref_faixa_etaria: results[0].pref_faixa_etaria,
                  pref_raio_busca: results[0].pref_raio_buca
                }
                res.status(200).json(data);
              } else {
                res.status(404).send({
                  type: 'Not found',
                  description: 'The requested user was not found in database.'
                });
              }
            }
          });
        }
      }
    });
  });
}

exports.post = async (req, res, next) => {
  const id = nanoid(20);
  const nome = req.body.nome;
  const foto = req.body.foto;
  const email = req.body.email;
  const telefone = req.body.telefone;
  const password = req.body.password;
  const data_cadastro = Date.now();
  const pref_especie = req.body.pref_especie;
  const pref_porte = req.body.pref_porte;
  const pref_sexo = req.body.pref_sexo;
  const pref_faixa_etaria = req.body.pref_faixa_etaria;
  const pref_raio_busca = req.body.pref_raio_busca;

  const nameExceedsLimit = nome == undefined || nome.length == 0 || nome.length > 50;
  const photoIsBase64 = isBase64(foto, { allowMime: true });
  const emailExceedsLimit = email == undefined || email.length == 0 || email.length > 100;
  const telefoneExceedsLimit = telefone == undefined || telefone.length == 0 || telefone.length > 11;
  const especieExceedsLimit = pref_especie == undefined || pref_especie.length > 20;
  const especieInvalida = pref_especie != 'cachorro' && pref_especie != 'gato' && pref_especie != 'coelho';
  const animalSizeExceedsLimit = pref_porte == undefined || pref_porte.length > 20;
  const animalSizeInvalido = pref_porte != 'pequeno' && pref_porte != 'médio' && pref_porte != 'grande';
  const sexIsValid = pref_sexo == undefined || pref_sexo.length > 20;
  const sexInvalido = pref_sexo != 'macho' && pref_sexo != 'fêmea';
  const ageRangeIsValid = pref_faixa_etaria == undefined || pref_faixa_etaria.length > 20;
  const ageRangeInvalido = pref_faixa_etaria != 'filhote' && pref_faixa_etaria != 'jovem' && pref_faixa_etaria != 'adulto' && pref_faixa_etaria != 'idoso';
  const searchRadiusExceedsLimit = pref_raio_busca == undefined ||  pref_raio_busca < 1 || pref_raio_busca > 20;

  if (nameExceedsLimit || !photoIsBase64 || emailExceedsLimit
      || telefoneExceedsLimit || especieExceedsLimit || animalSizeExceedsLimit
      || sexIsValid || ageRangeIsValid || searchRadiusExceedsLimit
      || especieInvalida || animalSizeInvalido || sexInvalido || ageRangeInvalido)
  {
    res.status(400).send({
      type: 'Request error',
      description: "One or more parameters are invalid."
    });

    return;
  }

  const compressedImage = await compressImage(foto);
  const salt = bcrypt.genSaltSync(10)
  const hashedPassword = bcrypt.hashSync(password, salt);

  pool.getConnection((err, connection) => {
    if (err) {
      res.status(500).send({
        type: 'Database error',
        description: 'Something went wrong. Try again.'
      });
    }

    connection.query(`SELECT * FROM usuario WHERE email = ?`, [
      email
    ], function (error, results) {
      if (error) {
        connection.release();
        res.status(400).send({
          type: 'Database error',
          description: 'One or more values are invalid (validating user).'
        });
      } else {
        if (results[0]) {
          connection.release();
          res.status(409).send({
            type: 'Email already taken',
            description: 'This email address is already taken'
          });
        } else {
          connection.query(`INSERT INTO usuario VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`, [
            id,
            nome,
            compressedImage,
            email,
            telefone,
            hashedPassword,
            data_cadastro,
            pref_especie,
            pref_porte,
            pref_sexo,
            pref_faixa_etaria,
            pref_raio_busca
          ], function (error) {
            connection.release();
            if (error) {
              res.status(400).send({
                type: 'Database error',
                description: 'One or more values are invalid (creating user).'
              });
            } else {
              res.status(201).send({
                type: 'Created',
                description: 'User created successfully.',
                id: id
              });
            }
          });
        }
      }
    });
  });
}

exports.getAnimais = async (req, res, next) => {
  if (!req.query.user) {
    res.status(400).send({
      type: 'Database error',
      description: 'One of more values are invalid.'
    });

    return;
  }

  const userId = req.query.user;

  pool.getConnection((err, connection) => {
    if (err) {
      res.status(500).send({
        type: 'Database error',
        description: 'Something went wrong. Try again.'
      });
    }
    connection.query(`SELECT * FROM animal WHERE user_id = ?`, [
      userId
    ], function (error, results) {
      connection.release();
      if (error) {
        res.status(400).send({
          type: 'Database error',
          description: 'One of more values are invalid.'
        });
      } else {
        results.forEach((element, index) => {
          results[index].foto = element.foto.toString();
        });
        res.status(200).send(results);
      }
    })
  });
}

exports.getTenhoInteresse = (req, res, next) => {
  const id = req.query.id;
  pool.getConnection((err, connection) => {
    if (err) {
      res.status(500).send({
        type: 'Database error',
        description: 'Something went wrong. Try again.'
      });
    }
    
    connection.query(`SELECT * FROM (
        SELECT a.id, i.user_id, a.foto, a.nome, a.descricao
        FROM animal a
          INNER JOIN interesse_animal i
          ON a.id = i.animal_id
      ) AS r WHERE r.user_id = ?;
      `, [
      id
    ], function (error, results) {
      connection.release();
      if (error) {
        res.status(400).send({
          type: 'Database error',
          description: 'The animal does not exist.'
        });
      } else {
        results.forEach((element, index) => {
          results[index].foto = element.foto.toString();
        });
        res.status(200).send(results);
      }
    })
  });
}