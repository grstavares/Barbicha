import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { AgmCoreModule } from '@agm/core';
import { AgmConfig } from './agm.secrets';

@NgModule({
  imports: [ CommonModule,  AgmCoreModule.forRoot(AgmConfig)],
  declarations: []
})
export class AgmModule { }
