import { Component, OnInit, OnDestroy, ViewChild } from '@angular/core';
import { NgForm } from '@angular/forms';
import { Subscription, Subject } from 'rxjs';
import { AuthService, UserProfile , UiService } from '../../shared/services';
import { AngularFireStorage } from 'angularfire2/storage';

@Component({ selector: 'app-userprofile', templateUrl: './userprofile.component.html', styleUrls: ['./userprofile.component.scss'] })
export class UserProfileComponent implements OnInit, OnDestroy {

  progressObservable = new Subject<number>();
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

  constructor(private authService: AuthService, private storage: AngularFireStorage, private uiService: UiService) { }

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

  onFileSelected(event: any) {

    const filename = this.userProfile.userId;
    if (filename === undefined || filename === null || filename === '') {
      this.uiService.showError('Você deve primeiro se registrar para Conseguir atualizar a Imagem!');
      return;

    } else {

      const filetype = event.target.files[0].name.split('.').pop();
      const filepath = 'userprofile/' + filename + '.' + filetype;
      const task = this.storage.ref(filepath).put(event.target.files[0]);
      task.percentageChanges().subscribe(value => {this.progressObservable.next(value); });
      task.then(uploadSnaphot => {

        uploadSnaphot.ref.getDownloadURL().then(imageUrl => {
          const userData = {...this.userProfile, imageUrl: imageUrl};
          this.authService.updateProfile(userData);
        });

      })
      .catch(reason => { this.uiService.showError(reason); });

    }

  }

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

    this.authService.updateProfile(userdata);

  }

}
