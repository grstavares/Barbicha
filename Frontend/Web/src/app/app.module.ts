import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { HttpClientModule, HttpClient } from '@angular/common/http';
import { TranslateModule, TranslateLoader } from '@ngx-translate/core';
import { TranslateHttpLoader } from '@ngx-translate/http-loader';

import { FormsModule } from '@angular/forms';
import { FlexLayoutModule } from '@angular/flex-layout';
import { AngularMaterialModule } from './angular-material/angular-material.module'
import { LayoutModule } from '@angular/cdk/layout';
import { OverlayModule } from '@angular/cdk/overlay';

import { FirebaseModule } from './firebase/firebase.module';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { LoginComponent } from './pages/login.component';
import { RegisterComponent } from './pages/register.component';
// AoT requires an exported function for factories
export const createTranslateLoader = (http: HttpClient) => {
    // for development
    /*return new TranslateHttpLoader(
        http,
        '/start-javascript/sb-admin-material/master/dist/assets/i18n/',
        '.json'
    );*/
    return new TranslateHttpLoader(http, './assets/i18n/', '.json');
};

@NgModule({
    declarations: [AppComponent, LoginComponent, RegisterComponent],
    imports: [
        BrowserModule,
        BrowserAnimationsModule,
        FirebaseModule,
        AppRoutingModule,
        LayoutModule,
        OverlayModule,
        FormsModule, FlexLayoutModule, AngularMaterialModule,
        HttpClientModule,
        TranslateModule.forRoot({
            loader: {
                provide: TranslateLoader,
                useFactory: createTranslateLoader,
                deps: [HttpClient]
            }
        })
    ],
    providers: [],
    bootstrap: [AppComponent]
})
export class AppModule {}
