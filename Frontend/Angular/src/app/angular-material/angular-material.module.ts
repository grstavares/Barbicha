import { NgModule } from '@angular/core';

import {MatButtonModule, MatCheckboxModule, MatSidenavModule, MatCardModule, MatInputModule, MatFormFieldModule,
MatIconModule } from '@angular/material';

@NgModule({
  imports: [ MatButtonModule, MatCheckboxModule, MatSidenavModule, MatCardModule, MatInputModule, MatFormFieldModule, MatIconModule ],
  exports: [MatButtonModule, MatCheckboxModule, MatSidenavModule, MatCardModule, MatInputModule, MatFormFieldModule, MatIconModule ],
  declarations: []
})
export class AngularMaterialModule { }
