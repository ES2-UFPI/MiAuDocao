const { nanoid } = require('nanoid');
const { compressImage } = require('../utils/images');
const isBase64 = require('is-base64');
const pool = require('../configs/db');

exports.get = async (req, res, next) => {
  const id = req.params.id;
  pool.getConnection((err, connection) => {
    if (err) {
      res.status(500).send({
        type: 'Database error',
        description: 'Something went wrong. Try again.'
      });
    }
    connection.query(`SELECT * FROM animal WHERE id = ?`, [
      id
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
            descricao: results[0].descricao,
            especie: results[0].especie,
            porte: results[0].porte,
            sexo: results[0].sexo,
            faixa_etaria: results[0].faixa_etaria,
            endereco: results[0].endereco,
            latitude: results[0].latitude,
            longitude: results[0].longitude,
            data_cadastro: results[0].data_cadastro,
            foto: results[0].foto.toString()
          }
          res.status(200).json(data);
        } else {
          res.status(404).send({
            type: 'Not found',
            description: 'The requested data was not found in database.'
          });
        }
      }
    });
  });

}

exports.post = async (req, res, next) => {
  const id = nanoid(20); // OK
  const user_id = req.body.user_id;
  const nome = req.body.nome;
  const descricao = req.body.descricao;
  const especie = req.body.especie;
  const porte = req.body.porte;
  const sexo = req.body.sexo;
  const faixaEtaria = req.body.faixa_etaria;
  const endereco = req.body.endereco;
  const latitude = req.body.latitude;
  const longitude = req.body.longitude;
  const data_cadastro = Date.now(); // OK
  const foto = req.body.foto;

  //console.log(id, nome, descricao, especie, porte, sexo, faixaEtaria, endereco, latitude, longitude, data_cadastro, foto);

  /*
    Validações

    OBS.: Os enums são efetivamente avaliados ao tentar entrar no BD, pois devem
    corresponder aos valores definidos lá. Aqui são feitas validações iniciais
    por tamanho para evitar que valores grandes passem para a fase de enviar a
    query.
  */
  const userIdExceedsLimit = user_id.length > 20;
  const nameExceedsLimit = nome.length > 50;
  const descriptionExceedsLimit = descricao.length > 300;
  const especieExceedsLimit = especie.length > 20;
  const animalSizeExceedsLimit = porte.length > 20;
  const sexIsValid = sexo.length > 20;
  const ageRangeIsValid = faixaEtaria.length > 20;
  const addressExceedsLimit = endereco.length > 100;
  const latitudeAndLongitudeAreNumbers = (isNaN(latitude) || isNaN(longitude));
  const photoIsBase64 = isBase64(foto, { allowMime: true });

  // console.log(nameExceedsLimit, descriptionExceedsLimit, especieExceedsLimit
  // , animalSizeExceedsLimit, sexIsValid, ageRangeIsValid
  // , addressExceedsLimit, latitudeAndLongitudeAreNumbers
  // , !photoIsBase64);

  if (userIdExceedsLimit || nameExceedsLimit || descriptionExceedsLimit
      || especieExceedsLimit|| animalSizeExceedsLimit || sexIsValid
      || ageRangeIsValid || addressExceedsLimit
      || latitudeAndLongitudeAreNumbers || !photoIsBase64)
  {
    res.status(400).send({
      type: 'Request error',
      description: "One or more parameters are invalid."
    });

    return;
  }

  // Compressão da imagem
  const compressedImage = await compressImage(foto);
  //console.log(compressedImage);

  /*
    Query para o banco de dados

    Aqui retorna 500 (Internal Server Error) caso falhe a conexão, 400 (Bad
    Request) caso algum valor esteja inválido (no caso dos enums) ou 201
    (Created) caso o animal tenha sido salvo com sucesso no banco de dados.
  */
  pool.getConnection((err, connection) => {
    if (err) {
      res.status(500).send({
        type: 'Database error',
        description: 'Something went wrong. Try again.'
      });
    }

    connection.query(`SELECT * FROM usuario WHERE id = ?`, [
      user_id
    ], function(error, results) {
      if (error) {
        connection.release();
        res.status(400).send({
          type: 'Database error',
          description: 'One or more values are invalid (validating user).'
        });
      } else {
        if (results[0]) {
          connection.query(`INSERT INTO animal VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`, [
            id,
            user_id,
            nome,
            descricao,
            especie,
            porte,
            sexo,
            faixaEtaria,
            endereco,
            latitude,
            longitude,
            data_cadastro,
            compressedImage
          ], function (error) {
            connection.release();
            if (error) {
              console.log(error)
              res.status(400).send({
                type: 'Database error',
                description: 'One or more values are invalid (creating animal).'
              });
            } else {
              res.status(201).send({
                type: 'Created',
                description: 'Animal added successfully.'
              });
            }
          });
        } else {
          res.status(404).send({
            type: 'Not found',
            description: 'The user (that supposed to be the animal owner) was not found in database.'
          });
        }
      }
    });
  });
}