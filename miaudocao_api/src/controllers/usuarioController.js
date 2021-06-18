const { nanoid } = require('nanoid');
const { compressImage } = require('../utils/images');
const isBase64 = require('is-base64');
const bcrypt = require('bcrypt');
const pool = require('../configs/db');

exports.get = async (req, res, next) => {
  const email = req.params.email;

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

  const nameExceedsLimit = nome == undefined || nome.length > 50;
  const photoIsBase64 = isBase64(foto, { allowMime: true });
  const emailExceedsLimit = email == undefined || email.length > 100;
  const telefoneExceedsLimit = telefone == undefined || telefone.length > 11;
  const especieExceedsLimit = pref_especie == undefined || pref_especie.length > 20;
  const animalSizeExceedsLimit = pref_porte == undefined || pref_porte.length > 20;
  const sexIsValid = pref_sexo == undefined || pref_sexo.length > 20;
  const ageRangeIsValid = pref_faixa_etaria == undefined || pref_faixa_etaria.length > 20;
  const searchRadiusExceedsLimit = pref_raio_busca == undefined ||  pref_raio_busca < 1 || pref_raio_busca > 20;

  if (nameExceedsLimit || !photoIsBase64 || emailExceedsLimit
      || telefoneExceedsLimit || especieExceedsLimit || animalSizeExceedsLimit
      || sexIsValid || ageRangeIsValid || searchRadiusExceedsLimit)
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
                description: 'User created successfully.'
              });
            }
          });
        }
      }
    });
  });
}