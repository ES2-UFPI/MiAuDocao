const { nanoid } = require('nanoid');
const request = require('supertest');
const app = require('../src/app');
// const { createUser, createAnimal, deleteAll, disableForeignCheck } = require('../src/utils/dbTestUtils');

describe('Animal POST', () => {
  let userId;
  // Antes de testar o cadastro de animais, crie um usuário válido
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
  });

  it('deve cadastrar um animal com sucesso', async () => {
    const res = await request(app).post('/animais')
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

    expect(res.status).toBe(201);
  });

  it('deve falhar no cadastro de um animal pois o usuário não existe', async () => {
    const res = await request(app).post('/animais')
      .send({
        'user_id': 'id_inexistente', // id que não existe no banco de dados
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

    expect(res.status).toBe(404);
  });

  it('deve falhar no cadastro de um animal pois o nome do animal não foi fornecido', async () => {
    const res = await request(app).post('/animais')
      .send({
        'user_id': userId,
        'nome': '', // nome vazio
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

    expect(res.status).toBe(400);
  });

  it('deve falhar no cadastro de um animal pois a descrição do animal não foi fornecida', async () => {
    const res = await request(app).post('/animais')
      .send({
        'user_id': userId,
        'nome': 'Animal',
        'descricao': '', // descrição vazia
        'especie': 'gato',
        'porte': 'pequeno',
        'sexo': 'macho',
        'faixa_etaria': 'jovem',
        'endereco': 'rua x',
        'latitude': '10',
        'longitude': '10',
        'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII='
      });

    expect(res.status).toBe(400);
  });

  it('deve falhar no cadastro de um animal pois a espécie não está no enum', async () => {
    const res = await request(app).post('/animais')
      .send({
        'user_id': userId,
        'nome': 'Animal',
        'descricao': 'Um animal',
        'especie': 'tartaruga', // espécie inexistente no banco de dados
        'porte': 'pequeno',
        'sexo': 'macho',
        'faixa_etaria': 'jovem',
        'endereco': 'rua x',
        'latitude': '10',
        'longitude': '10',
        'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII='
      });

    expect(res.status).toBe(400);
  });

  it('deve falhar no cadastro de um animal pois o porte não está no enum', async () => {
    const res = await request(app).post('/animais')
      .send({
        'user_id': userId,
        'nome': 'Animal',
        'descricao': 'Um animal',
        'especie': 'gato',
        'porte': 'grandão', // porte inexistente no banco de dados
        'sexo': 'macho',
        'faixa_etaria': 'jovem',
        'endereco': 'rua x',
        'latitude': '10',
        'longitude': '10',
        'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII='
      });

    expect(res.status).toBe(400);
  });

  it('deve falhar no cadastro de um animal pois o sexo não está no enum', async () => {
    const res = await request(app).post('/animais')
      .send({
        'user_id': userId,
        'nome': 'Animal',
        'descricao': 'Um animal',
        'especie': 'gato',
        'porte': 'pequeno',
        'sexo': 'outros', // sexo inexistente no banco de dados
        'faixa_etaria': 'jovem',
        'endereco': 'rua x',
        'latitude': '10',
        'longitude': '10',
        'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII='
      });

    expect(res.status).toBe(400);
  });

  it('deve falhar no cadastro de um animal pois a faixa etária não está no enum', async () => {
    const res = await request(app).post('/animais')
      .send({
        'user_id': userId,
        'nome': 'Animal',
        'descricao': 'Um animal',
        'especie': 'gato',
        'porte': 'pequeno',
        'sexo': 'macho',
        'faixa_etaria': 'velhinho', // faixa etária inexistente no banco de dados
        'endereco': 'rua x',
        'latitude': '10',
        'longitude': '10',
        'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII='
      });

    expect(res.status).toBe(400);
  });

  it('deve falhar no cadastro de um animal pois o endereço está vazio', async () => {
    const res = await request(app).post('/animais')
      .send({
        'user_id': userId,
        'nome': 'Animal',
        'descricao': 'Um animal',
        'especie': 'gato',
        'porte': 'pequeno',
        'sexo': 'macho',
        'faixa_etaria': 'jovem',
        'endereco': '', // endereço vazio
        'latitude': '10',
        'longitude': '10',
        'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII='
      });

    expect(res.status).toBe(400);
  });

  it('deve falhar no cadastro de um animal pois a imagem não está em base64', async () => {
    const res = await request(app).post('/animais')
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
        'foto': 'imagem' // faixa etária inexistente no banco de dados
      });

    expect(res.status).toBe(400);
  });
});

describe('Animal GET', () => {
  let userId;
  let animalId;
  // Cria um usuário e um animal pra este usuário antes dos testes
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
  });

  it('deve requisitar um animal com sucesso', async () => {
    const res = await request(app).get(`/animais?id=${animalId}`);
    expect(res.status).toBe(200);
  });

  it('deve falhar ao requisitar um animal pois o animal não existe', async () => {
    const res = await request(app).get(`/animais?id=id_aqui`);
    expect(res.status).toBe(404);
  });
});

describe('Animal GET (interessados)', () => {
  let userId;
  let animalId;
  let userId2;
  let animalId2;
  // Cria um usuário e um animal pra este usuário antes dos testes
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

    await request(app).post(`/manifestar_interesse?user=${userId2}&animal=${animalId}`);

    const animalRes2 = await request(app).post('/animais')
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
    animalId2 = animalRes2.body['id'];
  });

  it('deve retornar uma lista de usuários com interesse em um animal', async () => {
    const res = await request(app).get(`/animais/interessados?id=${animalId}`);
    expect(res.body.length).toBe(1);
  });

  it('deve retornar uma lista de usuários com interesse em um animal', async () => {
    const res = await request(app).get(`/animais/interessados?id=${animalId2}`);
    expect(res.body.length).toBe(0);
  });
});