import { EstabelecimentosModule } from './estabelecimentos.module';

describe('EstabelecimentosModule', () => {
  let estabelecimentosModule: EstabelecimentosModule;

  beforeEach(() => {
    estabelecimentosModule = new EstabelecimentosModule();
  });

  it('should create an instance', () => {
    expect(estabelecimentosModule).toBeTruthy();
  });
});
