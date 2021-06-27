const { nanoid } = require('nanoid');
const request = require('supertest');
const app = require('../src/app');
const { createUser, createAnimal, deleteAll, disableForeignCheck } = require('../src/utils/dbTestUtils');

describe('Animal POST', () => {
  it('should register an animal successfully', async () => {
    const res1 = await request(app).post('/usuario')
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

    const userId = res1.body['id'];

    const res2 = await request(app).post('/animais')
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

      expect(res2.status).toBe(201);
  });

  it('should register an animal successfully', async () => {
    const res1 = await request(app).post('/animais')
      .send({
        'user_id': 'id_inexistente',
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

      expect(res1.status).toBe(404);
  });
});