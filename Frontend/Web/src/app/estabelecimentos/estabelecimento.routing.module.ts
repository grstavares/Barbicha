import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { EstabelecimentosStartComponent } from './estabelecimentos-start/estabelecimentos-start.component';
import { AuthGuard } from '../shared/guard';
import { EstabelecimentoComponent } from './estabelecimento/estabelecimento.component';

const routes: Routes = [
    { path: '', component: EstabelecimentosStartComponent, canActivate: [AuthGuard] },
    { path: ':id', component: EstabelecimentoComponent, canActivate: [AuthGuard] }
];

@NgModule({ imports: [RouterModule.forChild(routes)], exports: [RouterModule] })
export class EstabelecimentosRoutingModule {}
