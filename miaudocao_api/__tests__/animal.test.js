// const request = require('supertest');
// const app = require('../src/app');
// const pool = require('../src/configs/db');
// const { createUser, deleteAll } = require('../src/utils/dbTestUtils');

// describe('Animal POST', () => {
//   afterAll(async () => {
//     pool.end();
//   });

//   /*it('should register an animal successfully', async () => {
//     const id = await createUser(); // criando um usuário e recebendo de volta o id que foi dado a ele

//     const res = await request(app).post('/animais')
//       .send({
//         'user_id': id, // mesmo id do usuário recém criado
//         'nome': 'Animal Teste',
//         'descricao': 'Uma descrição do animal',
//         'especie': 'gato',
//         'porte': 'pequeno',
//         'sexo': 'fêmea',
//         'faixa_etaria': 'filhote',
//         'endereco': 'rua x',
//         'latitude': '-5.021160',
//         'longitude': '-42.781343',
//         'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII='
//       });

//       expect(res.status).toBe(201);
//   });*/

//   it('should refuse an animal register due to inexistent user', async () => {
//     await createUser(); // cria um usuário qualquer

//     const res = await request(app).post('/animais')
//       .send({
//         'user_id': 'outroUsuario', // este usuário certamente é diferente
//         'nome': 'Animal Teste',
//         'descricao': 'Uma descrição do animal',
//         'especie': 'gato',
//         'porte': 'pequeno',
//         'sexo': 'fêmea',
//         'faixa_etaria': 'filhote',
//         'endereco': 'rua x',
//         'latitude': '-5.021160',
//         'longitude': '-42.781343',
//         'foto': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/h/kg8ABKEB16zW65EAAAAASUVORK5CYII='
//       });

//       expect(res.status).toBe(404);
//   });
// });
