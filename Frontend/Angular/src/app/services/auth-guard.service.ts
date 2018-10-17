import { Injectable } from '@angular/core';
import { Router, CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { Observer } from 'rxjs';
import { AuthService } from './auth.service';
import { UiService } from './ui.service';

@Injectable({ providedIn: 'root' })
export class AuthGuardService implements CanActivate {

  constructor(private router: Router, private authService: AuthService, private uiService: UiService) { }

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): boolean {

    console.log('guard executed');
    if (this.authService.isAuthenticated()) {
      return true;
    } else {
      this.uiService.showError('not auth');
      this.router.navigate(['/login']);
      return false;
    }

  }

}
