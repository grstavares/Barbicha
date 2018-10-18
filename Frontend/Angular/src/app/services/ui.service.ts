import { Injectable } from '@angular/core';
import { MatSnackBar, MatSnackBarRef, SimpleSnackBar } from '@angular/material';
import { Subject, BehaviorSubject } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class UiService {

  isLoading = new BehaviorSubject<boolean>(false);
  constructor(public snackBar: MatSnackBar) { }

  showError(errorMessage: string) {
    console.log(errorMessage);
    this.stopLoading();
  }

  showToast(message: string, actionName?: string, duration: number = 2000): MatSnackBarRef<SimpleSnackBar> {
    return this.snackBar.open(message, actionName, {duration: duration});
  }

  startLoading() { this.isLoading.next(true); }
  stopLoading() { this.isLoading.next(false); }

}
