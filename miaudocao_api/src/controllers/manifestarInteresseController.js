const pool = require('../configs/db');

exports.post = async (req, res, next) => {
  if (!req.query.user && !req.query.animal) {
    res.status(400).send({
      type: 'Database error',
      description: 'One of more values are invalid.'
    });

    return;
  }

  const userId = req.query.user;
  const animalId = req.query.animal;

  pool.getConnection((err, connection) => {
    if (err) {
      res.status(500).send({
        type: 'Database error',
        description: 'Something went wrong. Try again.'
      });
    }
    connection.query(`SELECT * FROM usuario WHERE id = ?`, [
      userId
    ], function (error, results) {
      if (error) {
        connection.release();
        res.status(400).send({
          type: 'Database error',
          description: 'One of more values are invalid.'
        });
      } else {
        if (results[0]) {
          connection.query(`SELECT * FROM animal WHERE id = ?`, [
            animalId
          ], function (error, results) {
            if (error) {
              connection.release();
              res.status(400).send({
                type: 'Database error',
                description: 'One of more values are invalid.'
              });
            } else {
              if (results[0]) {
                connection.query(`INSERT INTO interesse_animal VALUES (?, ?)`, [
                  userId,
                  animalId
                ], function (error) {
                  connection.release();
                  if (error) {
                    res.status(400).send({
                      type: 'Database error',
                      description: 'One of more values are invalid.'
                    });
                  } else {
                    res.status(201).send({
                      type: 'Registered',
                      description: 'Interest registered sucessfully'
                    });
                  }
                });
              } else {
                connection.release();
                res.status(404).send({
                  type: 'Not found',
                  description: 'The requested animal was not found in database.'
                });
              }
            }
          });
        } else {
          connection.release();
          res.status(404).send({
            type: 'Not found',
            description: 'The requested user was not found in database.'
          });
        }
      }
    });
  });
}