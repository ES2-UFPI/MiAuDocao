const pool = require('../configs/db');

exports.get = async (req, res, next) => {
    let query = 'SELECT * FROM animal ';
    let geoQuery = '';
    let first = false;
    let dados = [];

    if (req.query.especie) {
        query += !first ? 'WHERE especie = ? ' : ' AND especie = ? ';
        if (first == false) first = true;
        dados.push(req.query.especie);
    }

    if (req.query.porte) {
        query += !first ? 'WHERE porte = ? ' : ' AND porte = ? ';
        if (first == false) first = true;
        dados.push(req.query.porte);
    }

    if (req.query.sexo) {
        query += !first ? 'WHERE sexo = ? ' : ' AND sexo = ? ';
        if (first == false) first = true;
        dados.push(req.query.sexo);
    }

    if (req.query.faixa) {
        query += !first ? 'WHERE faixa_etaria = ? ' : ' AND faixa_etaria = ? ';
        if (first == false) first = true;
        dados.push(req.query.faixa);
    }

    if (req.query.raio && req.query.lat && req.query.lng) {
        geoQuery = `
            SELECT *, (6371 *
                acos(
                    cos(radians(?)) *
                    cos(radians(latitude)) *
                    cos(radians(?) - radians(longitude)) +
                    sin(radians(?)) *
                    sin(radians(latitude))
                )) AS distance
            FROM (${query}) as params HAVING distance <= ?
        `;

        dados.unshift(req.query.lat);
        dados.unshift(req.query.lng);
        dados.unshift(req.query.lat);
        dados.push(req.query.raio);
    }

    pool.getConnection((err, connection) => {
        if (err) {
            res.status(500).send({
                type: 'Database error',
                description: 'Something went wrong. Try again.'
            });
        }
        connection.query(geoQuery ? geoQuery : query,
            dados,
            function (error, results) {
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
            }
        );
    });
}
