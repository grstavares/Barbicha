import { Injectable } from '@angular/core';
import { AuthService } from '../services';
import { AngularFirestore } from 'angularfire2/firestore';
import { Subject, pipe, of, Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { UiService } from '../services/ui.service';

export interface Estabelecimento {
  companyId: string;
  name: string;
  alias?: string;
  natureza?: string;
  latitude?: number;
  longitude?: number;
  imageUrl?: string;
}

@Injectable()
export class EstabelecimentosService {

  estabelecimentos = new Subject<Estabelecimento[]>();

  constructor(private authService: AuthService, private firedb: AngularFirestore, private uiService: UiService) { }

  getEstabelecimentos() {

    const userId = this.authService.authUserId();
    if (userId !== undefined) {

      this.uiService.startLoading();
      this.firedb
      .collection('persons')
      .doc(userId)
      .collection('companies')
      .get()
      .pipe(map(snapshots => {

        const values: Estabelecimento[] = [];
        snapshots.forEach(snapshot => {
          const data = snapshot.data();
          const parsed = {
            companyId: snapshot.id,
            name: data.name,
            alias: data.alias,
            natureza: data.natureza
          };
          values.push(parsed);
        });

        return values;

      }))
      .toPromise()
      .then(values => { this.estabelecimentos.next(values); this.uiService.stopLoading(); })
      .catch(reason => { this.uiService.showError(reason); });

    } else { this.estabelecimentos.error('user not logged!'); }

  }

  getEstabelecimento(id: string): Observable<Estabelecimento> {

    if (id !== undefined) {

      const docPath = 'companies/' + id;
      return this.firedb
      .doc(docPath)
      .snapshotChanges()
      .pipe(map(snapshot => {
        const data = snapshot.payload.data();
        const parsed = {
          companyId: snapshot.payload.id,
          name: data['name'],
          alias: data['alias'],
          natureza: data['natureza'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          imageUrl: data['imageUrl']
        };
        return parsed;
      }));

    } else { return of(null); }

  }

}
