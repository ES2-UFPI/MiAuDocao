const pool = require('../configs/db');

exports.get =async (req, res, next) => {
  const userId = req.params.id;

  pool.getConnection((err, connection) => {
    if (err) {
      res.status(500).send({
        type: 'Database error',
        description: 'Something went wrong. Try again.'
      });
      return;
    }
    connection.query(`SELECT * FROM notificacao WHERE user_id = ?`, [
      userId
    ], function (error, results) {
      connection.release();
      if (error) {
        connection.release();
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