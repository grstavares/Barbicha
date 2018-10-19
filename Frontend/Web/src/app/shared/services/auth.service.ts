import { Injectable } from '@angular/core';
import { AngularFireAuth } from 'angularfire2/auth';
import { AngularFirestore } from 'angularfire2/firestore';
import { Subject, BehaviorSubject } from 'rxjs';

export interface UserProfile {
  userId: string;
  name?: string;
  alias?: string;
  email?: string;
  phone_number?: string;
  birth_date?: Date;
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

  public authUserId(): string { return this.loggedUserId; }

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
      .catch(error => { subject.error(error); });

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
      .catch(error => { subject.error(error); });

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
        const date = data.birth_date === undefined ? null : data.birth_date.toDate();

        const userData: UserProfile = {
          userId: snapshot.id,
          name: data.name,
          alias: data.alias,
          email: data.email,
          phone_number: data.phone_number,
          birth_date: date,
          imageUrl: data.imageUrl
        };

        subject.next(userData);

      })
      .catch(reason => { subject.error(reason); });

    } else { subject.error('Invalid UserId'); }

    return subject;

  }

  public updateProfile(userdata: UserProfile): Subject<boolean> {

    const subject = new Subject<boolean>();
    const userId = userdata.userId;
    delete userdata.userId;

    this.firedb
    .collection('persons')
    .doc(userId)
    .update(userdata)
    .then(() => { subject.complete(); })
    .catch(reason => { subject.error(reason); });

    return subject;

  }

  public isAuthenticated(): boolean { return this.userIsLogged; }

  public isLogged(): BehaviorSubject<boolean> { return this.authSubject; }

  private authSuccessfully() {
    this.userIsLogged = true;
    this.authSubject.next(this.userIsLogged);
  }

  private authNotLogged() {
    this.loggedUserId = null;
    this.userIsLogged = false;
    this.authSubject.next(this.userIsLogged);
  }

}
