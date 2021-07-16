const { nanoid } = require('nanoid');
const request = require('supertest');
const app = require('../src/app');

describe('Favorito POST', () => {
  let userId;
  let animalId;
  let userId2;

  beforeAll(async () => {
    const userRes = await request(app).post('/usuario')
      .send({
        'nome': 'Usuario',
        'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII=',
        'email': nanoid(20),
        'telefone': '1234',
        'password': '1234',
        'pref_especie': 'gato',
        'pref_porte': 'pequeno',
        'pref_sexo': 'macho',
        'pref_faixa_etaria': 'jovem',
        'pref_raio_busca': 2
      });
    userId = userRes.body['id'];

    const animalRes = await request(app).post('/animais')
      .send({
        'user_id': userId,
        'nome': 'Animal',
        'descricao': 'Um animal',
        'especie': 'gato',
        'porte': 'pequeno',
        'sexo': 'macho',
        'faixa_etaria': 'jovem',
        'endereco': 'rua x',
        'latitude': '10',
        'longitude': '10',
        'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII='
      });
    animalId = animalRes.body['id'];

    const userRes2 = await request(app).post('/usuario')
      .send({
        'nome': 'Usuario2',
        'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII=',
        'email': nanoid(20),
        'telefone': '1234',
        'password': '1234',
        'pref_especie': 'gato',
        'pref_porte': 'pequeno',
        'pref_sexo': 'macho',
        'pref_faixa_etaria': 'jovem',
        'pref_raio_busca': 2
      });
    userId2 = userRes2.body['id'];
  });

  it('deve favoritar um animal com sucesso', async () => {
    const res = await request(app).post(`/favorito`)
      .send({
        'user_id': userId2,
        'animal_id': animalId
      });
    expect(res.statusCode).toBe(201);
  });

  it('deve falhar ao favoritar um animal já favorito', async () => {
    const res = await request(app).post(`/favorito`)
      .send({
        'user_id': userId2,
        'animal_id': animalId
      });
    expect(res.statusCode).toBe(400);
  });

  it('deve falhar ao favoritar um animal a partir de um usuário inexistente', async () => {
    const res = await request(app).post(`/favorito`)
      .send({
        'user_id': 'um_id_aqui',
        'animal_id': animalId
      });
    expect(res.statusCode).toBe(404);
  });

  it('deve falhar ao favoritar um animal inexistente', async () => {
    const res = await request(app).post(`/favorito`)
      .send({
        'user_id': userId2,
        'animal_id': 'um_id_aqui'
      });
    expect(res.statusCode).toBe(404);
  });
});

describe('Favorito GET', () => {
  let userId;
  let animalId;
  let userId2;

  beforeAll(async () => {
    const userRes = await request(app).post('/usuario')
      .send({
        'nome': 'Usuario',
        'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII=',
        'email': nanoid(20),
        'telefone': '1234',
        'password': '1234',
        'pref_especie': 'gato',
        'pref_porte': 'pequeno',
        'pref_sexo': 'macho',
        'pref_faixa_etaria': 'jovem',
        'pref_raio_busca': 2
      });
    userId = userRes.body['id'];

    const animalRes = await request(app).post('/animais')
      .send({
        'user_id': userId,
        'nome': 'Animal',
        'descricao': 'Um animal',
        'especie': 'gato',
        'porte': 'pequeno',
        'sexo': 'macho',
        'faixa_etaria': 'jovem',
        'endereco': 'rua x',
        'latitude': '10',
        'longitude': '10',
        'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII='
      });
    animalId = animalRes.body['id'];

    const userRes2 = await request(app).post('/usuario')
      .send({
        'nome': 'Usuario2',
        'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII=',
        'email': nanoid(20),
        'telefone': '1234',
        'password': '1234',
        'pref_especie': 'gato',
        'pref_porte': 'pequeno',
        'pref_sexo': 'macho',
        'pref_faixa_etaria': 'jovem',
        'pref_raio_busca': 2
      });
    userId2 = userRes2.body['id'];
    
    await request(app).post(`/favorito`).send({
      'user_id': userId2,
      'animal_id': animalId
    });
  });

  it('deve requisitar os favoritos de um usuário', async () => {
    const res = await request(app).get(`/favorito/${userId2}/all`)
    expect(res.body.length).toBe(1);
  });

  it('deve retornar uma lista vazia de favoritos de um usuário inexistente', async () => {
    const res = await request(app).get(`/favorito/um_id_aqui/all`)
    expect(res.body.length).toBe(0);
  });
});