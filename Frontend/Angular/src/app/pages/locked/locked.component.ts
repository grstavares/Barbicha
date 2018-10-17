import { Component, OnInit } from '@angular/core';
import { AuthService } from 'src/app/services/auth.service';

@Component({ selector: 'app-locked', templateUrl: './locked.component.html', styleUrls: ['../pages-common.css'] })
export class LockedComponent implements OnInit {

  constructor(private authService: AuthService) { }

  ngOnInit() { }

  onLoginClicked() {
    this.authService.login('username', 'password');
  }

}
