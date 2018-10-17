import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { UserProfileComponent } from './userprofile/userprofile.component';
import { MessagesComponent } from './messages/messages.component';
import { ActivitiesComponent } from './activities/activities.component';
import { HomeComponent } from './home/home.component';
import { MainRoutingModule } from './main.routing.module';
import { AngularMaterialModule } from '../angular-material/angular-material.module';

@NgModule({
    imports: [CommonModule, MainRoutingModule, AngularMaterialModule ],
    declarations: [UserProfileComponent, MessagesComponent, ActivitiesComponent, HomeComponent]
})
export class MainModule { }
