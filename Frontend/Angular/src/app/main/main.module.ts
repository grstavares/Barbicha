import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { UserProfileComponent } from './userprofile/userprofile.component';
import { MessagesComponent } from './messages/messages.component';
import { ActivitiesComponent } from './activities/activities.component';
import { HomeComponent } from './home/home.component';
import { MainRoutingModule } from './main.routing.module';
import { AngularMaterialModule } from '../angular-material/angular-material.module';
import { FlexLayoutModule } from '@angular/flex-layout';
import { WelcomeComponent } from './welcome/welcome.component';

@NgModule({
    imports: [CommonModule, MainRoutingModule, AngularMaterialModule,  FormsModule, FlexLayoutModule ],
    declarations: [UserProfileComponent, MessagesComponent, ActivitiesComponent, HomeComponent, WelcomeComponent]
})
export class MainModule { }
