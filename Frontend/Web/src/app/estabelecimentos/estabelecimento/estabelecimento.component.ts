import { Component, OnInit, OnDestroy, ViewChild, Inject } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { Subscription } from 'rxjs';

import { MatPaginator, MatSort, MatTableDataSource, MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { EstabelecimentosService, Estabelecimento, ProductOrService, SpecialTimes, ExceptionTimes } from '../estabelecimentos.service';

import { NgForm } from '@angular/forms';
import { ProductServiceDialogComponent } from '../product.service.dialog/product.service.dialog.component';

@Component({ selector: 'app-estabelecimento', templateUrl: './estabelecimento.component.html', styleUrls: ['./estabelecimento.component.scss'] })
export class EstabelecimentoComponent implements OnInit, OnDestroy {

  newItem = false;

  estabelecimentoSubscription: Subscription;
  productsSubscription: Subscription;
  specialTimesSubscription: Subscription;
  exceptionTimesSunscription: Subscription;

  zoom = 15;
  estabelecimento: Estabelecimento = this.service.emptyEstabelecimento();

  selectedProductRowIndex = -1;
  displayedColumnsProducts = ['label', 'type', 'duration', 'price'];
  dataSourceProducts = new MatTableDataSource<ProductOrService>([]);

  displayedColumnsSpecialTime = ['definicao', 'horario'];
  dataSourceSpecialTime = new MatTableDataSource<SpecialTimes>([]);

  displayedColumnsExceptionTime = ['inicio', 'encerramento'];
  dataSourceExceptionTime = new MatTableDataSource<ExceptionTimes>([]);

  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;

  constructor(
    private service: EstabelecimentosService,
    private router: Router,
    private route: ActivatedRoute,
    public dialog: MatDialog) { }

  ngOnInit() {

    const estabelecimentoId = this.route.snapshot.paramMap.get('id');

    if (estabelecimentoId !== 'NewItem') {

      this.estabelecimentoSubscription = this.service
        .getEstabelecimento(estabelecimentoId)
        .subscribe(value => { this.estabelecimento = value; });

      this.productsSubscription = this.service
        .productsAndServices
        .subscribe(value => { if (value) { this.dataSourceProducts.data = value; } });

      this.specialTimesSubscription = this.service
        .specialTimes
        .subscribe(value => { if (value) { this.dataSourceSpecialTime.data = value; } });

      this.exceptionTimesSunscription = this.service
      .exceptionTimes
      .subscribe(value => { if (value) {this.dataSourceExceptionTime.data = value; } });

      this.service.getProdutcsAndServices(estabelecimentoId);
      this.service.getSpecialTimes(estabelecimentoId);
      this.service.getExceptionTimes(estabelecimentoId);

    } else { this.newItem = true; }

  }

  ngOnDestroy() {

    if (!this.newItem) {
      this.estabelecimentoSubscription.unsubscribe();
      this.productsSubscription.unsubscribe();
      this.specialTimesSubscription.unsubscribe();
      // this.exceptionTimesSunscription.unsubscribe();
    }

  }

  onMapMark(event: any) {
    this.estabelecimento.latitude = event.coords.lat;
    this.estabelecimento.longitude = event.coords.lng;
  }

  saveEstabelecimento(form: NgForm) {

    const itemValue = { ...form.value, natureza: 'temporario' };

    if (this.newItem) {
      this.service.addEstabelecimento(itemValue);
    } else { this.service.updateEstabelecimento(this.estabelecimento.companyId, itemValue); }

  }

  showProduct(item?: ProductOrService) {

    const itemId = item !== undefined ? item.productId : null;
    const dialogRef = this.dialog.open(ProductServiceDialogComponent, {
      width: '600px',
      data: item !== undefined ? item : {}
    });

    dialogRef.afterClosed().subscribe(result => {

      if (result === undefined) {return; }

      if (itemId !== undefined && itemId !== null) { this.service.updateProductOrService(this.estabelecimento.companyId, itemId, result.value);
      } else { this.service.addProductOrService(this.estabelecimento.companyId, result.value); }

    });

  }

  showProductService() {

  }

  filterProducts(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // Datasource defaults to lowercase matches
    this.dataSourceProducts.filter = filterValue;
    if (this.dataSourceProducts.paginator) {
      this.dataSourceProducts.paginator.firstPage();
    }
  }

}
