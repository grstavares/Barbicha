import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AngularFireModule } from '@angular/fire';
import { AngularFirestoreModule } from 'angularfire2/firestore';
import { AngularFireAuthModule } from 'angularfire2/auth';
import { FirebaseConfig } from './firebase.secrets';

@NgModule({
  imports: [ CommonModule, AngularFireModule.initializeApp(FirebaseConfig), AngularFirestoreModule, AngularFireAuthModule],
  exports: [ CommonModule, AngularFireModule, AngularFirestoreModule, AngularFireAuthModule],
  declarations: []
})

export class FirebaseModule {
  config = FirebaseConfig;
}
