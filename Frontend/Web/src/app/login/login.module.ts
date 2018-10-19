import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { FlexLayoutModule } from '@angular/flex-layout';
import { MatButtonModule, MatCheckboxModule, MatInputModule } from '@angular/material';

import { LoginRoutingModule } from './login-routing.module';
import { LoginComponent } from '../pages/login.component';
import { RegisterComponent } from '../pages/register.component';

@NgModule({
    imports: [
        CommonModule,
        LoginRoutingModule,
        FormsModule,
        MatInputModule,
        MatCheckboxModule,
        MatButtonModule,
        FlexLayoutModule
    ],
    declarations: [LoginComponent, RegisterComponent]
})
export class LoginModule {}
