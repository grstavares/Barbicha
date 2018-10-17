import { DOCUMENT } from '@angular/common';
import { Component, OnInit, Inject, Renderer2, OnDestroy } from '@angular/core';
import { AuthService, RegistrationData } from 'src/app/services/auth.service';
import { Router } from '@angular/router';
import { NgForm } from '@angular/forms';

@Component({ selector: 'app-register', templateUrl: './register.component.html', styleUrls: ['../pages-common.css'] })
export class RegisterComponent implements OnInit, OnDestroy {

  constructor(private router: Router, private authService: AuthService, @Inject(DOCUMENT) private document: Document, private renderer: Renderer2) { }

  ngOnInit() {
    this.renderer.addClass(this.document.body, 'plazaz-splashscreen');
  }

  ngOnDestroy(): void {
    this.renderer.removeClass(this.document.body, 'plazaz-splashscreen');
}

  onSignUpClicked(form: NgForm) {

    const email = form.value.email;
    const passwrd = form.value.password;
    const confirm = form.value.confirm;
    const phone = form.value.phone;

    if (passwrd !== confirm) {
      console.log('Password confirmation does not match!');
      return;
    }

    const registration: RegistrationData = { email: email, phone_number: phone };

    this.authService.register(registration, passwrd)
    .subscribe({
      next: (logged) => {if (logged) {this.router.navigate(['home']); } },
      error: (errorAuth) => { console.log(errorAuth); }
    });
  }

  onExternalSignUp(provider: string) {
    console.log('start signup using ' + provider);
  }

  navigate(route: string) {
    console.log(route);
    this.router.navigate([route]);
  }

}
