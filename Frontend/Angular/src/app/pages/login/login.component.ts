import { DOCUMENT } from '@angular/common';
import { Component, OnInit, Inject, Renderer2, OnDestroy } from '@angular/core';
import { AuthService } from 'src/app/services/auth.service';
import { Router } from '@angular/router';
import { NgForm } from '@angular/forms';

@Component({ selector: 'app-login', templateUrl: './login.component.html', styleUrls: ['../pages-common.css'] })
export class LoginComponent implements OnInit, OnDestroy {

  constructor(private router: Router, private authService: AuthService, @Inject(DOCUMENT) private document: Document, private renderer: Renderer2) { }

  ngOnInit() {
    this.renderer.addClass(this.document.body, 'plazaz-splashscreen');
  }

  ngOnDestroy(): void {
    this.renderer.removeClass(this.document.body, 'plazaz-splashscreen');
}

  onLoginClicked(form: NgForm) {

    const email = form.value.email;
    const passwrd = form.value.password;

    this.authService.login(email, passwrd)
    .subscribe({
      next: (value) => {if (value) {this.router.navigate(['home']); } },
      error: (error) => {console.error(error); }
    });
  }

  onExternalLogin(provider: string) {
    console.log('start login using ' + provider);
  }

  navigate(route: string) {
    console.log(route);
    this.router.navigate([route]);
  }

}
