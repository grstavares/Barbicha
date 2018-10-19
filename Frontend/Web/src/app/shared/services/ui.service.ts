import { Injectable, OnInit } from '@angular/core';
import { MatSnackBar, MatSnackBarRef, SimpleSnackBar } from '@angular/material';
import { BehaviorSubject } from 'rxjs';

import { FirebaseErrors } from './firebase.errors';

@Injectable({ providedIn: 'root' })
export class UiService implements OnInit {

  appName: string;
  isLoading = new BehaviorSubject<boolean>(false);

  firebaseErrors = new FirebaseErrors();

  constructor(public snackBar: MatSnackBar) {
    this.appName = 'Plazaz';
  }

  ngOnInit(): void { }

  getAppName(): string { return this.appName.slice(); }
  showError(errorMessage: any, actionName?: string, duration: number = 2000): MatSnackBarRef<SimpleSnackBar> {

    let message = '';
    if (errorMessage.code) {
      message = this.firebaseErrors.getMessage(errorMessage.code) || errorMessage;
    } else { message = errorMessage.toString(); }

    return this.snackBar.open(message, actionName, {duration: duration});

  }

  showMessage(message: string, actionName?: string, duration: number = 2000): MatSnackBarRef<SimpleSnackBar> {
    return this.snackBar.open(message, actionName, {duration: duration});
  }

  startLoading() { this.isLoading.next(true); }
  stopLoading() { this.isLoading.next(false); }

}
