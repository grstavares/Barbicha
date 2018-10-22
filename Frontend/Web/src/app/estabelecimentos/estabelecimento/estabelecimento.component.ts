import { Component, OnInit, OnDestroy, ViewChild } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { Subscription } from 'rxjs';

import { MatPaginator, MatSort, MatTableDataSource } from '@angular/material';
import { EstabelecimentosService, Estabelecimento, ProductOrService, SpecialTimes, ExceptionTimes } from '../estabelecimentos.service';

import { NgForm } from '@angular/forms';

@Component({ selector: 'app-estabelecimento', templateUrl: './estabelecimento.component.html', styleUrls: ['./estabelecimento.component.scss'] })
export class EstabelecimentoComponent implements OnInit, OnDestroy {

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

  constructor(private service: EstabelecimentosService, private router: Router, private route: ActivatedRoute) { }

  ngOnInit() {

    const estabelecimentoId = this.route.snapshot.paramMap.get('id');

    this.estabelecimentoSubscription =  this.service
    .getEstabelecimento(estabelecimentoId)
    .subscribe(value => { this.estabelecimento = value; });

    this.productsSubscription = this.service
    .productsAndServices
    .subscribe(value => {this.dataSourceProducts.data = value; });

    this.specialTimesSubscription = this.service
    .specialTimes
    .subscribe(value => { if (value) {this.dataSourceSpecialTime.data = value; } });

    // this.exceptionTimesSunscription = this.service
    // .exceptionTimes
    // .subscribe(value => { if (value) {this.dataSourceExceptionTime.data = value; } });

    this.service.getProdutcsAndServices(estabelecimentoId);
    this.service.getSpecialTimes(estabelecimentoId);
    this.service.getExceptionTimes(estabelecimentoId);

  }

  ngOnDestroy() {
    this.estabelecimentoSubscription.unsubscribe();
    this.productsSubscription.unsubscribe();
    this.specialTimesSubscription.unsubscribe();
    this.exceptionTimesSunscription.unsubscribe();
  }

  onMapMark(event: any) {
    console.log(event);
    this.estabelecimento.latitude = event.coords.lat;
    this.estabelecimento.longitude = event.coords.lng;
  }

  saveEstabelecimento(form: NgForm) { console.log(form); }

  showProduct(item: any) {
    this.selectedProductRowIndex = item.id;
    const itemId = item.productId;
    console.log('Must Show Product ' + itemId);
    // this.router.navigate([itemId], {relativeTo: this.route});
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
