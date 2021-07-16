const { nanoid } = require('nanoid');
const pool = require('../configs/db');

exports.post = (req, res, next) => {
  const id = nanoid(20);
  const userId = req.body.user_id;
  const animalId = req.body.animal_id;

  pool.getConnection((err, connection) => {
    if (err) {
      res.status(500).send({
        type: 'Database error',
        description: 'Something went wrong. Try again.'
      });

      return;
    }

    connection.query(`SELECT * FROM usuario WHERE id = ?`, [
      userId
    ], function (error, results) {
      if (error) {
        connection.release();
        res.status(400).send({
          type: 'Database error',
          description: 'One or more values are invalid (validating user).'
        });
      } else if (results[0]) {
        connection.query(`SELECT * FROM animal WHERE id = ?`, [
          animalId
        ], function (error, results) {
          if (error) {
            connection.release();
            res.status(400).send({
              type: 'Database error',
              description: 'One or more values are invalid (validating user).'
            });
          } else if (results[0]) {
            connection.query(`SELECT * FROM favorito WHERE usuario_id = ? AND animal_id = ?`, [
              userId,
              animalId
            ], function (error, results) {
              if (error) {
                connection.release();
                res.status(400).send({
                  type: 'Database error',
                  description: 'One or more values are invalid (validating user).'
                });
              } else if (results[0]) {
                res.status(400).send({
                  type: 'Database error',
                  description: 'This favorite entry already exists.'
                });
              } else {
                connection.query(`INSERT INTO favorito VALUES (?, ?, ?)`, [
                  id,
                  userId,
                  animalId
                ], function (error) {
                  connection.release();
                  if (error) {
                    res.status(400).send({
                      type: 'Database error',
                      description: 'One or more values are invalid (validating user).'
                    });
                  } else {
                    res.status(201).send({
                      type: 'Created',
                      description: 'Favorite added successfully.',
                      id: id
                    });
                  }
                });
              }
            });
          } else {
            connection.release();
            res.status(404).send({
              type: 'Not found',
              description: 'This animal does not exist.'
            });
          }
        });
      } else {
        connection.release();
        res.status(404).send({
          type: 'Not found',
          description: 'This user does not exist.'
        });
      }
    });
  });
}

exports.get = (req, res, next) => {
  const userId = req.params.user_id;

  pool.getConnection((err, connection) => {
    if (err) {
      res.status(500).send({
        type: 'Database error',
        description: 'Something went wrong. Try again.'
      });

      return;
    }

    connection.query(`SELECT * FROM (
        SELECT a.id, i.usuario_id, a.foto, a.nome, a.descricao
        FROM animal a
          INNER JOIN favorito i
          ON a.id = i.animal_id
      ) AS r WHERE r.usuario_id = ?`, [
      userId
    ], function (error, results) {
      connection.release();
      if (error) {
        res.status(400).send({
          type: 'Database error',
          description: 'One or more values are invalid (validating user).'
        });
      } else {
        results.forEach((element, index) => {
          results[index].foto = element.foto.toString();
        });
        res.status(200).send(results);
      }
    });
  });
}