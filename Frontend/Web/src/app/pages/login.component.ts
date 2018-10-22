import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService, UiService } from '../shared/services';
import { NgForm } from '@angular/forms';

@Component({ selector: 'app-login', templateUrl: './login.component.html', styleUrls: ['./shared.scss'] })
export class LoginComponent implements OnInit {

    appTitle: string;

    constructor(private router: Router, private authService: AuthService, private uiService: UiService) {}

    ngOnInit() {
        this.appTitle = this.uiService.getAppName();
    }

    onLogin(form: NgForm) {

        const email = form.value.email;
        const senha = form.value.password;

        this.authService.login(email, senha)
        .subscribe({
          next: (value) => {if (value) {this.router.navigate(['/dashboard']); } },
          error: (error) => {this.uiService.showError(error); }
        });

    }

}
