const { nanoid } = require('nanoid');

exports.post = (req, res, next) => {
  const id = nanoid(20);
  const nome = req.body.nome;
  const descricao = req.body.descricao;
  const especie = req.body.especie;
  const porte = req.body.porte;
  const sexo = req.body.sexo;
  const faixaEtaria = req.body.faixa_etaria;
  const endereco = req.body.endereco;
  const latitude = req.body.latitude;
  const longitude = req.body.longitude;
  const data_cadastro = Date.now();
  const foto = req.body.foto;

  console.log(id, nome, descricao);

  res.sendStatus(200);
}