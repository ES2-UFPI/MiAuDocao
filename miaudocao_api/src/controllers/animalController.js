const { nanoid } = require('nanoid');
const isBase64 = require('is-base64');

exports.post = (req, res, next) => {
  const id = nanoid(20); // OK
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

  if (nameExceedsLimit || descriptionExceedsLimit || especieExceedsLimit
      || animalSizeExceedsLimit || sexIsValid || ageRangeIsValid
      || addressExceedsLimit || latitudeAndLongitudeAreNumbers
      || !photoIsBase64)
  {
    res.status(400).send({
      type: 'Error',
      description: "One or more parameters are invalid."
    });

    return;
  }

  res.sendStatus(200);
}