import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { UserProfileComponent } from './userprofile/userprofile.component';
import { MessagesComponent } from './messages/messages.component';
import { ActivitiesComponent } from './activities/activities.component';
import { AuthGuardService } from '../services/auth-guard.service';

const routes: Routes = [
  { path: '', component: HomeComponent, canActivate: [AuthGuardService], children: [
    { path: 'userprofile', component: UserProfileComponent, canActivate: [AuthGuardService] },
    { path: 'messages', component: MessagesComponent, canActivate: [AuthGuardService]},
    { path: 'activities', component: ActivitiesComponent, canActivate: [AuthGuardService]}
  ] },
];

@NgModule({ imports: [RouterModule.forChild(routes)], exports: [RouterModule] })
export class MainRoutingModule { }
