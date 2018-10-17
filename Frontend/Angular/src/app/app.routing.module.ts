import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { LoginComponent } from './pages/login/login.component';
import { RegisterComponent } from './pages/register/register.component';
import { NotFoundComponent } from './pages/notfound/notfound.component';
import { LockedComponent } from './pages/locked/locked.component';
import { AuthGuardService } from './services/auth-guard.service';

const appRoutes: Routes = [
    { path: '', redirectTo: '/home', pathMatch: 'full' },
    { path: 'home', loadChildren: './main/main.module#MainModule', canActivate: [AuthGuardService] },
    { path: 'login', component: LoginComponent },
    { path: 'signup', component: RegisterComponent },
    { path: 'locked', component: LockedComponent },
    { path: 'notfound', component: NotFoundComponent },
    { path: '**', redirectTo: '/notfound', pathMatch: 'full' }
];

@NgModule({ imports: [ RouterModule.forRoot(appRoutes) ], exports: [ RouterModule] })
export class AppRoutingModule { }
