import { DOCUMENT } from '@angular/common';
import { Component, OnInit, Inject, Renderer2, OnDestroy } from '@angular/core';
import { AuthService, RegistrationData, UiService } from '../shared/services';
import { Router } from '@angular/router';
import { NgForm } from '@angular/forms';

@Component({ selector: 'app-register', templateUrl: './register.component.html', styleUrls: ['./shared.scss'] })
export class RegisterComponent implements OnInit {

  constructor(private router: Router, private authService: AuthService, private uiService: UiService) {}

  ngOnInit() {}

  onSignUpClicked(form: NgForm) {

    const email = form.value.email;
    const passwrd = form.value.password;
    const confirm = form.value.confirm;
    const phone = form.value.phone_number;

    if (passwrd !== confirm) {
      this.uiService.showError('PasswordConfirmNotMatch');
      return;
    }

    const registration: RegistrationData = { email: email, phone_number: phone };

    this.authService.register(registration, passwrd)
    .subscribe({
      next: (logged) => {if (logged) {this.router.navigate(['dashboard']); } },
      error: (errorAuth) => { this.uiService.showError(errorAuth); }
    });
  }

  onExternalSignUp(provider: string) {
    console.log('start signup using ' + provider);
  }

}
