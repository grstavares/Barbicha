import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { EstabelecimentosStartComponent } from './estabelecimentos-start.component';

describe('EstabelecimentosStartComponent', () => {
  let component: EstabelecimentosStartComponent;
  let fixture: ComponentFixture<EstabelecimentosStartComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ EstabelecimentosStartComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(EstabelecimentosStartComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
