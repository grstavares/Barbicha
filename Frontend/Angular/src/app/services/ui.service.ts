import { Injectable } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class UiService {

  constructor() { }

  showError(errorMessage: string) { console.log(errorMessage); }

}
