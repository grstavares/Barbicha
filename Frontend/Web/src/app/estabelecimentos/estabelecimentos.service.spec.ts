import { TestBed } from '@angular/core/testing';

import { EstabelecimentosService } from './estabelecimentos.service';

describe('EstabelecimentoService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: EstabelecimentosService = TestBed.get(EstabelecimentosService);
    expect(service).toBeTruthy();
  });
});
