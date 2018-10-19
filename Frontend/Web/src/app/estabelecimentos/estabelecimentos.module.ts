import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
// import { TranslateModule, TranslateLoader } from '@ngx-translate/core';
import { FormsModule } from '@angular/forms';
import { FlexLayoutModule } from '@angular/flex-layout';

import { AngularMaterialModule } from '../angular-material/angular-material.module';
import { FirebaseModule } from '../firebase/firebase.module';

import { EstabelecimentoComponent } from './estabelecimento/estabelecimento.component';
import { EstabelecimentosStartComponent } from './estabelecimentos-start/estabelecimentos-start.component';
import { EstabelecimentosRoutingModule } from './estabelecimento.routing.module';
import { EstabelecimentosService } from './estabelecimentos.service';

@NgModule({
  imports: [
     CommonModule, FormsModule, FlexLayoutModule,
     AngularMaterialModule, FirebaseModule,
     EstabelecimentosRoutingModule
    ],
  declarations: [EstabelecimentosStartComponent, EstabelecimentoComponent],
  providers: [EstabelecimentosService]
})
export class EstabelecimentosModule { }
