import { Component, OnInit, OnDestroy } from '@angular/core';
import { EstabelecimentosService, Estabelecimento } from '../estabelecimentos.service';
import { Subscription } from 'rxjs';
import { MatTableDataSource } from '@angular/material';
import { Router, ActivatedRoute } from '@angular/router';

@Component({ selector: 'app-estabelecimentos', templateUrl: './estabelecimentos.component.html', styleUrls: ['./estabelecimentos.component.scss'] })
export class EstabelecimentosComponent implements OnInit, OnDestroy {

  serviceSubscription: Subscription;
  displayedColumns: string[];
  dataSource = new MatTableDataSource<Estabelecimento>([]);

  constructor(private service: EstabelecimentosService, private router: Router, private route: ActivatedRoute) { }

  ngOnInit() {
    this.displayedColumns = ['name', 'alias', 'natureza'];
    this.serviceSubscription = this.service.estabelecimentos.subscribe(values => {
      this.dataSource.data = values;
    });

    this.service.getEstabelecimentos();

  }

  ngOnDestroy() {
    this.serviceSubscription.unsubscribe();
  }

  showItem(item: any) {
    const itemId = item.companyId;
    this.router.navigate([itemId], {relativeTo: this.route});
  }

}
