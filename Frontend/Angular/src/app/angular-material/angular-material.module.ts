import { NgModule } from '@angular/core';

import {
  MatToolbarModule, MatSidenavModule,
  MatButtonModule, MatCheckboxModule, MatCardModule,
  MatInputModule, MatFormFieldModule,
  MatDatepickerModule, MatNativeDateModule,
  MatIconModule, MatProgressSpinnerModule
} from '@angular/material';

@NgModule({
  imports: [ MatToolbarModule, MatButtonModule, MatCheckboxModule, MatSidenavModule, MatCardModule, MatInputModule, MatFormFieldModule, MatDatepickerModule,
    MatNativeDateModule, MatIconModule, MatProgressSpinnerModule ],
  exports: [ MatToolbarModule, MatButtonModule, MatCheckboxModule, MatSidenavModule, MatCardModule, MatInputModule, MatFormFieldModule, MatDatepickerModule,
    MatNativeDateModule, MatIconModule, MatProgressSpinnerModule ],
  declarations: []
})
export class AngularMaterialModule { }
