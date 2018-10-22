import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { Product.Service.DialogComponent } from './product.service.dialog.component';

describe('Product.Service.DialogComponent', () => {
  let component: Product.Service.DialogComponent;
  let fixture: ComponentFixture<Product.Service.DialogComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ Product.Service.DialogComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(Product.Service.DialogComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
