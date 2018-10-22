import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
// import { TranslateModule, TranslateLoader } from '@ngx-translate/core';
import { FormsModule } from '@angular/forms';
import { FlexLayoutModule } from '@angular/flex-layout';

// import { AgmModule } from '../agm/agm.module';
import { AgmCoreModule, MarkerManager, GoogleMapsAPIWrapper } from '@agm/core';
import { AgmConfig } from '../agm/agm.secrets';

import { AngularMaterialModule } from '../angular-material/angular-material.module';
import { FirebaseModule } from '../firebase/firebase.module';

import { EstabelecimentoComponent } from './estabelecimento/estabelecimento.component';
import { EstabelecimentosStartComponent } from './estabelecimentos-start/estabelecimentos-start.component';
import { EstabelecimentosRoutingModule } from './estabelecimento.routing.module';
import { EstabelecimentosService } from './estabelecimentos.service';
import { ProductServiceDialogComponent } from './product.service.dialog/product.service.dialog.component';

@NgModule({
  imports: [
     CommonModule, FormsModule, FlexLayoutModule,
     AngularMaterialModule, FirebaseModule, AgmCoreModule.forRoot(AgmConfig),
     EstabelecimentosRoutingModule
    ],
  declarations: [EstabelecimentosStartComponent, EstabelecimentoComponent, ProductServiceDialogComponent],
  entryComponents: [ProductServiceDialogComponent],
  providers: [EstabelecimentosService, MarkerManager, GoogleMapsAPIWrapper]
})
export class EstabelecimentosModule { }
