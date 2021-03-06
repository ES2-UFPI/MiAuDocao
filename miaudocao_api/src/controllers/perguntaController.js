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
          const animalOwnerId = results[0].user_id;
          const animalName = results[0].nome;
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
                  if (error) {
                    connection.release();
                    res.status(400).send({
                      type: 'Database error',
                      description: 'One or more values are invalid (creating question).'
                    });
                  } else {
                    connection.query(`INSERT INTO notificacao VALUES (?, ?, ?, ?, ?, ?, ?)`, [
                      nanoid(20),
                      animalOwnerId,
                      'Nova pergunta',
                      `Nova pergunta sobre o animal ${animalName}. Confira!`,
                      data_cadastro,
                      'pergunta',
                      animalId
                    ], function (error) {
                      connection.release();
                      if (error) {
                        res.status(400).send({
                          type: 'Database error',
                          description: 'One or more values are invalid (creating notification).'
                        });
                      } else {
                        res.status(201).send({
                          type: 'Created',
                          description: 'Question created successfully.',
                          id: id
                        });
                      }
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
  const animalId = req.params.id;
  const perguntaId = req.params.id_pergunta;
  const resposta = req.body.resposta;

  const animalIdIsInvalid = animalId == undefined || animalId.length != 20;
  const perguntaIsInvalid = perguntaId == undefined || perguntaId.length != 20;
  const respostaIsInvalid = resposta == undefined || resposta.length == 0 || resposta.length > 200;

  if (animalIdIsInvalid || perguntaIsInvalid || respostaIsInvalid) {
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

    connection.query(`SELECT * FROM pergunta WHERE id = ?`, [
      perguntaId
    ], function (error, results) {
      if (error) {
        connection.release();
        res.status(400).send({
          type: 'Database error',
          description: 'One or more values are invalid.'
        });
      } else {
        if (results[0]) {
          const questionAuthor = results[0].id_autor;
          connection.query(`UPDATE pergunta SET resposta = ? WHERE id_animal = ? AND id = ?`, [
            resposta,
            animalId,
            perguntaId
          ], function (error, results) {
            if (error) {
              connection.release();
              console.log(error);
              res.status(400).send({
                type: 'Database error',
                description: 'One or more values are invalid.'
              });
            } else if (results.affectedRows == 1) {
              connection.query(`SELECT * FROM animal WHERE id = ?`, [
                animalId
              ], function(error, results) {
                if (error) {
                  connection.release();
                  res.status(400).send({
                    type: 'Database error',
                    description: 'One or more values are invalid.'
                  });
                } else if (results[0]) {
                  connection.query(`INSERT INTO notificacao VALUES (?, ?, ?, ?, ?, ?, ?)`, [
                    nanoid(20),
                    questionAuthor,
                    'Resposta para sua pergunta',
                    `Sua pergunta para o animal ${results[0].nome} foi respondida.`,
                    Date.now(),
                    'pergunta',
                    animalId
                  ], function (error) {
                    connection.release();
                    if (error) {
                      res.status(400).send({
                        type: 'Database error',
                        description: 'One or more values are invalid.'
                      });
                    } else {
                      res.status(200).send({
                        type: 'Answered',
                        description: 'The question was answered successfully.'
                      });
                    }
                  });
                }
              });
            } else {
              res.status(400).send({
                type: 'Not answered',
                description: 'Something went wrong. Verify the animal id or question id and try again.'
              });
            }
          });
        } else {
          connection.release();
          res.status(404).send({
            type: 'Not found',
            description: 'The question does not exist.'
          });
        }
      }
    });
  }); 
}