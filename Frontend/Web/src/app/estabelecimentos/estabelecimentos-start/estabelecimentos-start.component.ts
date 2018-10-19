import { Component, OnInit, OnDestroy, ViewChild } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { Subscription } from 'rxjs';
import { MatPaginator, MatSort, MatTableDataSource } from '@angular/material';
import { EstabelecimentosService, Estabelecimento } from '../estabelecimentos.service';

@Component({ selector: 'app-estabelecimentos-start', templateUrl: './estabelecimentos-start.component.html', styleUrls: ['./estabelecimentos-start.component.scss'] })
export class EstabelecimentosStartComponent implements OnInit, OnDestroy {

  selectedRowIndex = -1;
  serviceSubscription: Subscription;
  displayedColumns = ['name', 'alias', 'natureza'];
  dataSource = new MatTableDataSource<Estabelecimento>([]);

  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;

  constructor(private service: EstabelecimentosService, private router: Router, private route: ActivatedRoute) { }

  ngOnInit() {
    this.serviceSubscription = this.service.estabelecimentos.subscribe(values => {
      this.dataSource.data = values;
    });

    this.service.getEstabelecimentos();

  }

  ngOnDestroy() {
    this.serviceSubscription.unsubscribe();
  }

  showItem(item: any) {
    this.selectedRowIndex = item.id;
    const itemId = item.companyId;
    this.router.navigate([itemId], {relativeTo: this.route});
  }

  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // Datasource defaults to lowercase matches
    this.dataSource.filter = filterValue;
    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

}
