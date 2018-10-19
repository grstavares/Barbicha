import { Component, OnInit, OnDestroy, ViewChild } from '@angular/core';
import { NgForm } from '@angular/forms';
import { Subscription } from 'rxjs';
import { AuthService, UserProfile , UiService } from '../../shared/services';

@Component({ selector: 'app-userprofile', templateUrl: './userprofile.component.html', styleUrls: ['./userprofile.component.scss'] })
export class UserProfileComponent implements OnInit, OnDestroy {

  userSubcription: Subscription;
  userProfile: UserProfile = {
    userId: '',
    alias: '',
    name: '',
    email: '',
    phone_number: '',
    birth_date: null,
    imageUrl: ''
  };

  @ViewChild('form') form: NgForm;

  constructor(private authService: AuthService, private uiService: UiService) { }

  ngOnInit() {

    this.uiService.startLoading();
    this.userSubcription = this.authService.userProfile('').subscribe({
      next: (value) => {
        this.userProfile = value;
        this.uiService.stopLoading();
      },
      error: (value) => {
        console.log(value);
        this.uiService.stopLoading();
      }
    });

  }

  ngOnDestroy() { this.userSubcription.unsubscribe(); }

  saveUserProfile(form: NgForm) {

    this.uiService.startLoading();

    const name = form.value.nome;
    const alias = form.value.apelido;
    const birth = form.value.nascimento;
    const email = form.value.email;
    const phone = form.value.phone;

    const userdata = { userId: this.userProfile.userId };
    if (name !== undefined) {userdata['name'] = name; }
    if (alias !== undefined) {userdata['alias'] = alias; }
    if (birth !== undefined) {userdata['birth_date'] = birth; }
    if (email !== undefined) {userdata['email'] = email; }
    if (phone !== undefined) {userdata['phone_number'] = phone; }

    this.authService.updateProfile(userdata).subscribe({
      complete: () => {
        this.uiService.showMessage('Perfil do usuário Salvo!');
        this.uiService.stopLoading();
      },
      error: reason => {
        console.log(reason);
        this.uiService.stopLoading();
      }
    });

  }

}
