import { DOCUMENT } from '@angular/common';
import { Component, OnInit, Inject, Renderer2, OnDestroy } from '@angular/core';
import { AuthService } from 'src/app/services/auth.service';
import { Router } from '@angular/router';

@Component({ selector: 'app-login', templateUrl: './login.component.html', styleUrls: ['../pages-common.css'] })
export class LoginComponent implements OnInit, OnDestroy {

  constructor(private router: Router, private authService: AuthService, @Inject(DOCUMENT) private document: Document, private renderer: Renderer2) { }

  ngOnInit() {
    this.renderer.addClass(this.document.body, 'plazaz-splashscreen');
  }

  ngOnDestroy(): void {
    this.renderer.removeClass(this.document.body, 'plazaz-splashscreen');
}

  onLoginClicked() {
    this.authService.login('username', 'password');
  }

  navigate(route: string) {
    console.log(route);
    this.router.navigate([route]);
  }

}
