import { TestBed, inject } from '@angular/core/testing';

import { EstabelecimentosService } from './estabelecimentos.service';

describe('EstabelecimentosService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [EstabelecimentosService]
    });
  });

  it('should be created', inject([EstabelecimentosService], (service: EstabelecimentosService) => {
    expect(service).toBeTruthy();
  }));
});
