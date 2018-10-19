import { NgModule } from '@angular/core';
import { APP_DATE_FORMATS, AppDateAdapter } from './date-adapter';


import {
  MatToolbarModule, MatSidenavModule, MatSnackBarModule, MatTabsModule,
  MatTableModule,
  MatButtonModule, MatCheckboxModule, MatCardModule,
  MatInputModule, MatFormFieldModule, MatListModule,
  MatDatepickerModule, MatNativeDateModule, DateAdapter, MAT_DATE_FORMATS,
  MatIconModule, MatProgressSpinnerModule
} from '@angular/material';

@NgModule({
  imports: [
    MatToolbarModule, MatSidenavModule, MatSnackBarModule, MatCardModule, MatTabsModule,
    MatTableModule,
    MatFormFieldModule, MatListModule, MatInputModule, MatButtonModule, MatCheckboxModule, MatDatepickerModule,
    MatNativeDateModule,
    MatIconModule, MatProgressSpinnerModule
  ],
  exports: [
    MatToolbarModule, MatSidenavModule, MatSnackBarModule, MatCardModule, MatTabsModule,
    MatTableModule,
    MatFormFieldModule, MatListModule, MatInputModule, MatButtonModule, MatCheckboxModule, MatDatepickerModule,
    MatNativeDateModule,
    MatIconModule, MatProgressSpinnerModule
  ],
  declarations: [],
  providers: [
    { provide: DateAdapter, useClass: AppDateAdapter },
    { provide: MAT_DATE_FORMATS, useValue: APP_DATE_FORMATS }
]
})
export class AngularMaterialModule { }
