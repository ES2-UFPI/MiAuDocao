const { nanoid } = require('nanoid');
const pool = require('../configs/db');

exports.post = async (req, res, next) => {
  const id = nanoid(20);
  const animalId = req.params.id;
  const autorId = req.body.autor_id;
  const pergunta = req.body.pergunta;
  const resposta = "";
  const data_cadastro = Date.now();

  const animalIdIsInvalid = animalId == undefined || animalId.length != 20;
  const autorIdIsInvalid = autorId == undefined || autorId.length != 20;
  const perguntaIsInvalid = pergunta == undefined || pergunta.length == 0 || pergunta.length > 200;

  if (animalIdIsInvalid || autorIdIsInvalid || perguntaIsInvalid) {
    res.status(400).send({
      type: 'Request error',
      description: "One or more parameters are invalid."
    });

    return;
  }

  pool.getConnection((err, connection) => {
    if (err) {
      res.status(500).send({
        type: 'Database error',
        description: 'Something went wrong. Try again.'
      });

      return;
    }

    connection.query(`SELECT * FROM animal WHERE id = ?`, [
      animalId
    ], function (error, results) {
      if (error) {
        connection.release();
        res.status(400).send({
          type: 'Database error',
          description: 'One or more values are invalid (validating animal).'
        });
      } else {
        if (results[0]) {
          connection.query(`SELECT * FROM usuario WHERE id = ?`, [
            autorId
          ], function (error, results) {
            if (error) {
              connection.release();
              res.status(400).send({
                type: 'Database error',
                description: 'One or more values are invalid (validating author).'
              });
            } else {
              if (results[0]) {
                connection.query(`INSERT INTO pergunta VALUES (?, ?, ?, ?, ?, ?)`, [
                  id,
                  autorId,
                  animalId,
                  pergunta,
                  resposta,
                  data_cadastro
                ], function (error) {
                  connection.release();
                  if (error) {
                    res.status(400).send({
                      type: 'Database error',
                      description: 'One or more values are invalid (validating author).'
                    });
                  } else {
                    res.status(201).send({
                      type: 'Created',
                      description: 'Question created successfully.',
                      id: id
                    });
                  }
                });
              } else {
                connection.release();
                res.status(400).send({
                  type: 'Request error',
                  description: 'This user does not exist.'
                });
              }
            }
          });
        } else {
          connection.release();
          res.status(400).send({
            type: 'Request error',
            description: 'This animal does not exist.'
          });
        }
      }
    });
  });
}

exports.getAll = async (req, res, next) => {
  const animalId = req.params.id;
  
  pool.getConnection((err, connection) => {
    if (err) {
      res.status(500).send({
        type: 'Database error',
        description: 'Something went wrong. Try again.'
      });

      return;
    }

    connection.query(`SELECT * FROM pergunta WHERE id_animal = ?`, [
      animalId
    ], function (error, results) {
      connection.release();
      if (error) {
        res.status(400).send({
          type: 'Database error',
          description: 'One or more values are invalid.'
        });
      } else {
        res.status(200).json(results);
      }
    });
  });
}

exports.get = async (req, res, next) => {
  const animalId = req.params.id;
  const perguntaId = req.params.id_pergunta;
  
  pool.getConnection((err, connection) => {
    if (err) {
      res.status(500).send({
        type: 'Database error',
        description: 'Something went wrong. Try again.'
      });

      return;
    }

    connection.query(`SELECT * FROM pergunta WHERE id = ? and id_animal = ?`, [
      perguntaId,
      animalId
    ], function (error, results) {
      connection.release();
      if (error) {
        res.status(400).send({
          type: 'Database error',
          description: 'One or more values are invalid.'
        });
      } else {
        if (results[0]) {
          res.status(200).json(results[0]);
        } else {
          res.status(404).send({
            type: 'Not found',
            description: 'The requested question does not exist.'
          });
        }
      }
    });
  });
}

exports.put = async (req, res, next) => {
  res.status(200).json({ mensagem: 'responder pergunta' })
  
}