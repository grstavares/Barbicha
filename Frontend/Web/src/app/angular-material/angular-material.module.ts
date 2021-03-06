import { NgModule } from '@angular/core';
import { APP_DATE_FORMATS, AppDateAdapter } from './date-adapter';


import {
  MatToolbarModule, MatSidenavModule, MatSnackBarModule, MatTabsModule, MatMenuModule,
  MatTableModule, MatPaginatorModule,
  MatDialogModule, MatProgressBarModule,
  MatButtonModule, MatCheckboxModule, MatCardModule,
  MatInputModule, MatFormFieldModule, MatListModule, MatSelectModule,
  MatDatepickerModule, MatNativeDateModule, DateAdapter, MAT_DATE_FORMATS,
  MatIconModule, MatProgressSpinnerModule
} from '@angular/material';

@NgModule({
  imports: [
    MatToolbarModule, MatSidenavModule, MatSnackBarModule, MatCardModule, MatTabsModule, MatMenuModule,
    MatTableModule, MatPaginatorModule,
    MatDialogModule, MatProgressBarModule,
    MatFormFieldModule, MatListModule, MatInputModule, MatButtonModule, MatCheckboxModule, MatDatepickerModule, MatSelectModule,
    MatNativeDateModule,
    MatIconModule, MatProgressSpinnerModule
  ],
  exports: [
    MatToolbarModule, MatSidenavModule, MatSnackBarModule, MatCardModule, MatTabsModule, MatMenuModule,
    MatTableModule, MatPaginatorModule,
    MatDialogModule, MatProgressBarModule,
    MatFormFieldModule, MatListModule, MatInputModule, MatButtonModule, MatCheckboxModule, MatDatepickerModule, MatSelectModule,
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
