import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { FlexLayoutModule } from '@angular/flex-layout';
import { FormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';

import { AngularFireModule } from '@angular/fire';
import { AngularFirestoreModule } from 'angularfire2/firestore';
import { AngularFireAuthModule } from 'angularfire2/auth';
import { FirebaseConfig } from './providers/firebase.secrets';

import { AngularMaterialModule } from './angular-material/angular-material.module';
import { AppRoutingModule } from './app.routing.module';

import { AppComponent } from './app.component';
import { LoginComponent } from './pages/login/login.component';
import { RegisterComponent } from './pages/register/register.component';
import { NotFoundComponent } from './pages/notfound/notfound.component';
import { LockedComponent } from './pages/locked/locked.component';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    RegisterComponent,
    NotFoundComponent,
    LockedComponent
  ],
  imports: [
    BrowserModule, BrowserAnimationsModule, FlexLayoutModule,
    FormsModule,
    AngularFireModule.initializeApp(FirebaseConfig), AngularFirestoreModule, AngularFireAuthModule,
    AngularMaterialModule, AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
