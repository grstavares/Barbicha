import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class AuthService {

  private isAuth: boolean;

  constructor() { }

  isAuthenticated(): boolean {
    console.log('checking and returning ' + this.isAuth);
    return this.isAuth;
  }

  login(username: string, password: string): Observable<boolean> {
    this.isAuth = true;
    return of(this.isAuth);
  }

}
