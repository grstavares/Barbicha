import { Component, OnInit, OnDestroy } from '@angular/core';
import { EstabelecimentosService, Estabelecimento } from '../estabelecimentos.service';
import { Subscription, Observable } from 'rxjs';
import { MatTableDataSource } from '@angular/material';
import { Router, ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-estabelecimento',
  templateUrl: './estabelecimento.component.html',
  styleUrls: ['./estabelecimento.component.css']
})
export class EstabelecimentoComponent implements OnInit, OnDestroy {

  estabelecimento: Estabelecimento = {companyId: '', name: '', alias: '', latitude: null, longitude: null, imageUrl: null};
  estabelecimentoSubscription: Subscription;

  constructor(private service: EstabelecimentosService, private router: Router, private route: ActivatedRoute) { }

  ngOnInit() {

    const estabelecimentoId = this.route.snapshot.paramMap.get('id');
    this.estabelecimentoSubscription =  this.service
    .getEstabelecimento(estabelecimentoId)
    .subscribe(value => { this.estabelecimento = value; });

  }

  ngOnDestroy() { this.estabelecimentoSubscription.unsubscribe(); }

}
