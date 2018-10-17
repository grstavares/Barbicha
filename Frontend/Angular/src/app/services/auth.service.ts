import { Injectable } from '@angular/core';
import { AngularFireAuth } from 'angularfire2/auth';
import { Subject, BehaviorSubject } from 'rxjs';
import { AngularFirestore } from 'angularfire2/firestore';
import { parse } from 'url';

export interface UserProfile {
  userId: string;
  name?: string;
  alias?: string;
  email?: string;
  phone?: string;
  birth?: string;
  imageUrl?: string;
}

export interface RegistrationData {
  email: string;
  phone_number: string;
}

@Injectable({ providedIn: 'root' })
export class AuthService {

  private isNewUser = false;
  private loggedUserId: string;
  private userIsLogged = false;
  private authSubject: BehaviorSubject<boolean> = new BehaviorSubject(false);

  constructor(private fireauth: AngularFireAuth, private firedb: AngularFirestore) { }

  public register(data: RegistrationData, password: string): Subject<boolean>  {

    const subject = new Subject<boolean>();

    this.fireauth.auth
      .createUserWithEmailAndPassword(data.email, password)
      .then(result => {

        const userId = result.user.uid;
        const newUser = result.additionalUserInfo.isNewUser;

        this.loggedUserId = userId;
        this.isNewUser = newUser;

        this.firedb.collection('persons').doc(userId).set({
          name: data.email,
          email: data.email,
          phone_number: data.phone_number
        });

        this.authSuccessfully();
        subject.next(true);
      })
      .catch(error => {
        this.signalError(error);
        subject.error(error);
      });

    return subject;

  }

  public login(email: string, password: string): Subject<boolean> {

    const subject = new Subject<boolean>();

    this.fireauth.auth
      .signInWithEmailAndPassword(email, password)
      .then(result => {
        this.loggedUserId = result.user.uid;
        this.authSuccessfully();
        subject.next(true);
      })
      .catch(error => {
        this.signalError(error);
        subject.error(error);
      });

    return subject;

  }

  public logout(): void {
    this.fireauth.auth.signOut();
    this.authNotLogged();
  }

  public userProfile(userId: string): Subject<UserProfile> {

    const subject = new Subject<UserProfile>();

    if (userId === undefined || userId === '') {userId = this.loggedUserId; }
    if (userId !== undefined) {

      this.firedb
      .collection('persons')
      .doc(userId).get()
      .toPromise().then(snapshot => {

        const data = snapshot.data();

        const userData: UserProfile = {
          userId: snapshot.id,
          name: data.name,
          alias: data.alias,
          email: data.email,
          phone: data.phone_number,
          birth: data.birth,
          imageUrl: data.imageUrl
        };

        subject.next(userData);

      })
      .catch(reason => {
        this.signalError(reason);
        subject.error(reason);
      });

    } else { subject.error('Invalid UserId'); }

    return subject;

  }

  public updateProfile(userdata: UserProfile): Subject<boolean> {

    const subject = new Subject<boolean>();
    const userId = userdata.userId;

    const docdata = {
      name: userdata.name,
      alias: userdata.alias,
      email: userdata.email,
      phone_number: userdata.phone,
      birthDate: userdata.birth
    };

    this.firedb
    .collection('persons')
    .doc(userId)
    .update(docdata)
    .then(() => { subject.complete(); })
    .catch(reason => { subject.error(reason); });

    return subject;

  }

  public isAuthenticated(): boolean { return this.userIsLogged; }

  public isLogged(): BehaviorSubject<boolean> {

      return this.authSubject;

  }

  private signalError(error: Error) {
    console.log(error);
  }

  private authSuccessfully() {
    this.userIsLogged = true;
    this.authSubject.next(this.userIsLogged);
  }

  private authNotLogged() {
    this.userIsLogged = false;
    this.authSubject.next(this.userIsLogged);
  }

}
