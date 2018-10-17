import { Component, OnInit, OnDestroy, ViewChild } from '@angular/core';
import { NgForm } from '@angular/forms';
import { Subscription } from 'rxjs';
import { AuthService, UserProfile  } from 'src/app/services/auth.service';

@Component({ selector: 'app-userprofile', templateUrl: './userprofile.component.html', styleUrls: ['./userprofile.component.css'] })
export class UserProfileComponent implements OnInit, OnDestroy {

  isLoading = true;
  userSubcription: Subscription;
  userProfile: UserProfile = {
    userId: '',
    alias: '',
    name: '',
    email: '',
    phone: '',
    birth: '',
    imageUrl: ''
  };

  @ViewChild('form') form: NgForm;

  constructor(private authService: AuthService) { }

  ngOnInit() {

    this.isLoading = true;
    this.userSubcription = this.authService.userProfile('').subscribe({
      next: (value) => {
        this.userProfile = value;
        this.form.controls['nome'].updateValueAndValidity();
        this.form.controls['apelido'].updateValueAndValidity();
        this.form.controls['nascimento'].updateValueAndValidity();
        this.form.controls['email'].updateValueAndValidity();
        this.isLoading = false;
      },
      error: (value) => {
        console.log(value);
        this.isLoading = false;
      }
    });

  }

  ngOnDestroy() { this.userSubcription.unsubscribe(); }

  saveUserProfile(form: NgForm) {

    this.isLoading = true;

    const name = form.value.nome;
    const alias = form.value.apelido;
    const birth = form.value.nascimento;
    const email = form.value.email;
    const phone = form.value.phone;

    const userdata = { userId: this.userProfile.userId };
    if (name !== undefined) {userdata['name'] = name; }
    if (alias !== undefined) {userdata['alias'] = alias; }
    if (birth !== undefined) {userdata['birth'] = birth; }
    if (email !== undefined) {userdata['email'] = email; }
    if (phone !== undefined) {userdata['phone'] = phone; }

    this.authService.updateProfile(userdata).subscribe({
      complete: () => {
        console.log('ok');
        this.isLoading = false;
      },
      error: reason => {
        console.log(reason);
        this.isLoading = false;
      }
    });

  }

}
