import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { TranslateModule } from '@ngx-translate/core';
import { FlexLayoutModule } from '@angular/flex-layout';
import { FormsModule } from '@angular/forms';
import { AngularMaterialModule } from '../angular-material/angular-material.module';
import { SidebarComponent } from './components/sidebar/sidebar.component';
import { TopnavComponent } from './components/topnav/topnav.component';
import { LayoutRoutingModule } from './layout-routing.module';
import { LayoutComponent } from './layout.component';
import { NavComponent } from './nav/nav.component';
import { UserProfileComponent } from './userprofile/userprofile.component';

@NgModule({
    imports: [
        CommonModule,
        FlexLayoutModule,
        FormsModule,
        AngularMaterialModule,
        LayoutRoutingModule,
        TranslateModule
    ],
    declarations: [LayoutComponent, NavComponent, TopnavComponent, SidebarComponent, UserProfileComponent]
})
export class LayoutModule {}
