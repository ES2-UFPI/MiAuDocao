const { nanoid } = require('nanoid');
const request = require('supertest');
const app = require('../src/app');

describe('Usuário POST', () => {
  it('deve cadastrar um usuário com sucesso', async () => {
    const res = await request(app).post('/usuario')
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
    
    expect(res.status).toBe(201);
  });

  it('deve recusar o cadastro de um usuário com nome vazio', async () => {
    const res = await request(app).post('/usuario')
      .send({
        'nome': '',
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
    
    expect(res.status).toBe(400);
  });

  it('deve recusar o cadastro de um usuário com foto que não é base64', async () => {
    const res = await request(app).post('/usuario')
      .send({
        'nome': 'Usuario',
        'foto': 'foto_aqui',
        'email': nanoid(20),
        'telefone': '1234',
        'password': '1234',
        'pref_especie': 'gato',
        'pref_porte': 'pequeno',
        'pref_sexo': 'macho',
        'pref_faixa_etaria': 'jovem',
        'pref_raio_busca': 2
      });
    
    expect(res.status).toBe(400);
  });

  it('deve recusar o cadastro de um usuário com email vazio', async () => {
    const res = await request(app).post('/usuario')
      .send({
        'nome': 'Usuario',
        'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII=',
        'email': '',
        'telefone': '1234',
        'password': '1234',
        'pref_especie': 'gato',
        'pref_porte': 'pequeno',
        'pref_sexo': 'macho',
        'pref_faixa_etaria': 'jovem',
        'pref_raio_busca': 2
      });
    
    expect(res.status).toBe(400);
  });

  it('deve recusar o cadastro de um usuário com telefone vazio', async () => {
    const res = await request(app).post('/usuario')
      .send({
        'nome': 'Usuario',
        'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII=',
        'email': nanoid(20),
        'telefone': '',
        'password': '1234',
        'pref_especie': 'gato',
        'pref_porte': 'pequeno',
        'pref_sexo': 'macho',
        'pref_faixa_etaria': 'jovem',
        'pref_raio_busca': 2
      });
    
    expect(res.status).toBe(400);
  });

  it('deve recusar o cadastro de um usuário com preferência de espécie inválida', async () => {
    const res = await request(app).post('/usuario')
      .send({
        'nome': 'Usuario',
        'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII=',
        'email': nanoid(20),
        'telefone': '1234',
        'password': '1234',
        'pref_especie': 'tartaruga',
        'pref_porte': 'pequeno',
        'pref_sexo': 'macho',
        'pref_faixa_etaria': 'jovem',
        'pref_raio_busca': 2
      });
    
    expect(res.status).toBe(400);
  });

  it('deve recusar o cadastro de um usuário com preferência de porte inválido', async () => {
    const res = await request(app).post('/usuario')
      .send({
        'nome': 'Usuario',
        'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII=',
        'email': nanoid(20),
        'telefone': '1234',
        'password': '1234',
        'pref_especie': 'gato',
        'pref_porte': 'grandão',
        'pref_sexo': 'macho',
        'pref_faixa_etaria': 'jovem',
        'pref_raio_busca': 2
      });
    
    expect(res.status).toBe(400);
  });

  it('deve recusar o cadastro de um usuário com preferência de sexo inválido', async () => {
    const res = await request(app).post('/usuario')
      .send({
        'nome': 'Usuario',
        'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII=',
        'email': nanoid(20),
        'telefone': '1234',
        'password': '1234',
        'pref_especie': 'gato',
        'pref_porte': 'pequeno',
        'pref_sexo': 'outros',
        'pref_faixa_etaria': 'jovem',
        'pref_raio_busca': 2
      });
    
    expect(res.status).toBe(400);
  });

  it('deve recusar o cadastro de um usuário com preferência de faixa etária inválida', async () => {
    const res = await request(app).post('/usuario')
      .send({
        'nome': 'Usuario',
        'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII=',
        'email': nanoid(20),
        'telefone': '1234',
        'password': '1234',
        'pref_especie': 'gato',
        'pref_porte': 'pequeno',
        'pref_sexo': 'macho',
        'pref_faixa_etaria': 'velhinho',
        'pref_raio_busca': 2
      });
    
    expect(res.status).toBe(400);
  });

  it('deve recusar o cadastro de um usuário com preferência de raio de busca inválido', async () => {
    const res = await request(app).post('/usuario')
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
        'pref_raio_busca': 25
      });
    
    expect(res.status).toBe(400);
  });
});

describe('Usuário GET', () => {
  let userId;
  beforeAll(async () => {
    const res = await request(app).post('/usuario')
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
    
    userId = res.body['id'];
  });

  it('deve requisitar um usuário com sucesso', async () => {
    const res = await request(app).get(`/usuario?email=${userId}`);
    expect(res.status).toBe(200);
  });

  it('deve requisitar um usuário com sucesso', async () => {
    const res = await request(app).get(`/usuario?email=id_aqui`);
    expect(res.status).toBe(404);
  }); 
});

// describe('Usuário GET (animais)', () => {

// });

// describe('Usuário GET (animais que tem interesse)', () => {

// });