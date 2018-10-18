import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FlexLayoutModule } from '@angular/flex-layout';
import { AngularMaterialModule } from '../angular-material/angular-material.module';
import { EstabelecimentosComponent } from './estabelecimentos/estabelecimentos.component';
import { EstabelecimentoComponent } from './estabelecimento/estabelecimento.component';
import { EstabelecimentosRoutingModule } from './estabelecimentos.routing.module';
import { EstabelecimentosService } from './estabelecimentos.service';

@NgModule({
  imports: [CommonModule, EstabelecimentosRoutingModule, AngularMaterialModule, FlexLayoutModule],
  declarations: [EstabelecimentosComponent, EstabelecimentoComponent],
  providers: [EstabelecimentosService]
})
export class EstabelecimentosModule {

  constructor() {
    console.log('module loaded');
  }

 }
