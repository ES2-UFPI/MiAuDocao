const request = require('supertest');
const app = require('../src/app');

describe('Teste', () => {
  it('deve executar a rota principal', async () => {
    const res = await request(app).get('/')

    expect(res.body).toHaveProperty('title')
  });
});

