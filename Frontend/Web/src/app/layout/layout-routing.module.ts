import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { LayoutComponent } from './layout.component';
import { UserProfileComponent } from './userprofile/userprofile.component';
import { AuthGuard } from '../shared/guard';

const routes: Routes = [
    {
        path: '',
        component: LayoutComponent,
        children: [
            { path: '', redirectTo: 'dashboard' },
            { path: 'dashboard', loadChildren: './dashboard/dashboard.module#DashboardModule' },
            { path: 'userprofile', component: UserProfileComponent, canActivate: [AuthGuard] },
            { path: 'estabelecimento', loadChildren: '../estabelecimentos/estabelecimentos.module#EstabelecimentosModule', canActivate: [AuthGuard] },
            { path: 'charts', loadChildren: './charts/charts.module#ChartsModule' },
            { path: 'components', loadChildren: './material-components/material-components.module#MaterialComponentsModule' },
            { path: 'forms', loadChildren: './forms/forms.module#FormsModule' },
            { path: 'grid', loadChildren: './grid/grid.module#GridModule' },
            { path: 'tables', loadChildren: './tables/tables.module#TablesModule' },
            { path: 'blank-page', loadChildren: './blank-page/blank-page.module#BlankPageModule' }
        ]
    }
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class LayoutRoutingModule {}
