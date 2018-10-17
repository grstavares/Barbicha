import { Component, OnInit } from '@angular/core';
import { AuthService } from 'src/app/services/auth.service';

@Component({ selector: 'app-register', templateUrl: './register.component.html', styleUrls: ['../pages-common.css'] })
export class RegisterComponent implements OnInit {

  constructor(private authService: AuthService) { }

  ngOnInit() { }

  onLoginClicked() {
    this.authService.login('username', 'password');
  }

}
