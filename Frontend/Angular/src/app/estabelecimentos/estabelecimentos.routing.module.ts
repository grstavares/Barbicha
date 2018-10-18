import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AuthGuardService } from '../services';
import { EstabelecimentosComponent } from './estabelecimentos/estabelecimentos.component';
import { EstabelecimentoComponent } from './estabelecimento/estabelecimento.component';

const routes: Routes = [
  { path: '', component: EstabelecimentosComponent, canActivate: [AuthGuardService], children: [
    { path: 'teste', component: EstabelecimentoComponent, canActivate: [AuthGuardService] },
  ] },
  { path: 'teste', component: EstabelecimentoComponent, canActivate: [AuthGuardService] },
  { path: ':id', component: EstabelecimentoComponent, canActivate: [AuthGuardService] },
];

@NgModule({ imports: [RouterModule.forChild(routes)], exports: [RouterModule] })
export class EstabelecimentosRoutingModule { }
