import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material';
import { ProductOrService, ServiceType, EstabelecimentosService } from '../estabelecimentos.service';

@Component({ selector: 'app-product.service.dialog', templateUrl: './product.service.dialog.component.html', styleUrls: ['./product.service.dialog.component.scss'] })
export class ProductServiceDialogComponent implements OnInit {

  newItem = false;
  serviceTypes: ServiceType[] = [];
  constructor(
    public dialogRef: MatDialogRef<ProductServiceDialogComponent>,
     @Inject(MAT_DIALOG_DATA) public data: ProductOrService,
     private service: EstabelecimentosService) {}

  ngOnInit() {
    if (this.data === undefined) {this.newItem = true; }
    this.serviceTypes = this.service.getServiceTypes('natureza');
  }

  onNoClick(): void {
      this.dialogRef.close();
  }

}
