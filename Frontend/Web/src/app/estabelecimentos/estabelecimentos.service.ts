import { Injectable } from '@angular/core';
import { AuthService, UiService } from '../shared/services';
import { AngularFirestore } from 'angularfire2/firestore';
import { Subject, of, Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { interceptingHandler } from '@angular/common/http/src/module';

export interface Estabelecimento {
  companyId: string;
  name: string;
  alias?: string;
  natureza?: string;
  latitude?: number;
  longitude?: number;
  fouding_date?: Date;
  imageUrl?: string;
  serviceHours?: {
    start: string;
    end: string;
  };
  users?: [UserAssociation];
}

export interface ProductOrService {
  productId: string;
  type: string;
  label: string;
  durationInMinutes: number;
  price: number;
}

export interface SpecialTimes { id: string; selector: string; start: string; end: string; }
export interface ExceptionTimes { id: string; start: Date; end: Date; }
export interface UserAssociation { id: string; role: string; }
export interface ServiceType {value: string; label: string; }

@Injectable()
export class EstabelecimentosService {

  estabelecimentos = new Subject<Estabelecimento[]>();
  specialTimes = new Subject<SpecialTimes[]>();
  exceptionTimes = new Subject<ExceptionTimes[]>();
  productsAndServices = new Subject<ProductOrService[]>();

  constructor(private authService: AuthService, private firedb: AngularFirestore, private uiService: UiService) { }

  getServiceTypes(natureza: string): ServiceType[] {

    const types = [
      {value: 'PROD_PERECIVEL', label: 'Produto Perecível'},
      {value: 'PROD_ENCOMENDA', label: 'Produto sob Encomenta'},
      {value: 'PROD_REVENDA', label: 'Produto de Revenda'},
      {value: 'SERV_ENCOMENDA', label: 'Serviço sob Encomenda'},
      {value: 'SERV_AGENDADO', label: 'Serviço Agendado'}
    ];

    return types;

  }

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
        .catch(reason => { this.estabelecimentos.error(reason); this.uiService.stopLoading(); });

    } else { this.estabelecimentos.error('user not logged!'); }

  }

  getEstabelecimento(id: string): Observable<Estabelecimento> {

    if (id !== undefined) {

      this.uiService.startLoading();
      const docPath = 'companies/' + id;
      return this.firedb
        .doc(docPath)
        .snapshotChanges()
        .pipe(map(snapshot => {

          const data = snapshot.payload.data();
          const founded = data['foudation_date'] === undefined ? null : data['foudation_date'].toDate();
          const hours =  data['serviceHours'] ?  data['serviceHours'] : [];

          const parsed = {
            companyId: snapshot.payload.id,
            name: data['name'],
            alias: data['alias'],
            natureza: data['natureza'],
            latitude: data['latitude'],
            longitude: data['longitude'],
            imageUrl: data['imageUrl'],
            foudation_date: founded,
            serviceHours: hours
          };
          this.uiService.stopLoading();
          return parsed;
        }));

    } else { return of(null); }

  }

  getProdutcsAndServices(id: string) {

    this.uiService.startLoading();
    this.firedb
      .collection('companies')
      .doc(id)
      .collection('productAndServices')
      .get()
      .pipe(map(snapshots => {

        const values: ProductOrService[] = [];
        snapshots.forEach(snapshot => {
          const data = snapshot.data();
          const parsed = {
            productId: snapshot.id,
            type: data.type,
            label: data.label,
            durationInMinutes: data.durationInMinutes,
            price: data.price,
          };
          values.push(parsed);
        });

        return values;

      }))
      .toPromise()
      .then(values => { this.productsAndServices.next(values); this.uiService.stopLoading(); })
      .catch(reason => { this.productsAndServices.error(reason); this.uiService.stopLoading(); });

  }

  getSpecialTimes(id: string) {

    this.uiService.startLoading();
    this.firedb
      .collection('companies')
      .doc(id)
      .collection('specialTimes')
      .get()
      .pipe(map(snapshots => {

        const values: SpecialTimes[] = [];
        snapshots.forEach(snapshot => {
          const data = snapshot.data();
          const parsed = {
            id: snapshot.id,
            selector: data.selector,
            start: data.start,
            end: data.end
          };
          values.push(parsed);
        });

        return values;

      }))
      .toPromise()
      .then(values => { this.specialTimes.next(values); this.uiService.stopLoading(); })
      .catch(reason => { this.specialTimes.error(reason); this.uiService.stopLoading(); });

  }

  getExceptionTimes(id: string) {

    this.uiService.startLoading();
    this.firedb
      .collection('companies')
      .doc(id)
      .collection('exceptionTimes')
      .get()
      .pipe(map(snapshots => {

        const values: ExceptionTimes[] = [];
        snapshots.forEach(snapshot => {
          const data = snapshot.data();
          const start = data.start === undefined ? null : data.start.toDate();
          const end = data.end === undefined ? null : data.end.toDate();
          const parsed = {
            id: snapshot.id,
            selector: data.selector,
            start: start,
            end: end
          };
          values.push(parsed);
        });

        return values;

      }))
      .toPromise()
      .then(values => { this.exceptionTimes.next(values); this.uiService.stopLoading(); })
      .catch(reason => { this.exceptionTimes.error(reason); this.uiService.stopLoading(); });

  }

  addEstabelecimento(newItem: Estabelecimento) {

    const userId = this.authService.authUserId();
    const roles: [UserAssociation] = [{id: userId, role: 'owner'}];
    newItem.users = roles;

    this.uiService.startLoading();
    this.firedb.collection('companies').add(newItem)
    .then(value => {

      const companiesPath = 'persons/' + userId + '/companies';
      this.firedb
      .collection(companiesPath)
      .doc(value.id)
      .set({name: newItem.name, alias: newItem.alias, natureza: newItem.natureza})
      .then(() => {
        this.uiService.showMessage('Estabelecimento Cadastrado!');
        this.uiService.stopLoading();
      })
      .catch(reason => {
        this.uiService.showError(reason);
        this.uiService.stopLoading();
      });

    });

  }

  updateEstabelecimento(companyId: string, updatedValues: Estabelecimento) {

    const docPath = 'companies/' + companyId;
    this.uiService.startLoading();
    this.firedb.doc(docPath).update(updatedValues)
    .then(() => {

      this.uiService.showMessage('Estabelecimento Atualizado!');
      this.uiService.stopLoading();
    })
    .catch(reason => {
      this.uiService.showError(reason);
      this.uiService.stopLoading();
    });

  }

  addProductOrService(companyId: string, newItem: ProductOrService) {

    this.uiService.startLoading();
    const collectionPath = 'companies/' + companyId + '/productAndServices';
    this.firedb.collection(collectionPath).add(newItem)
    .then(value => {
      this.uiService.showMessage('Produto Adicionado!');
      this.uiService.stopLoading();
    })
    .catch(reason => {
        this.uiService.showError(reason);
        this.uiService.stopLoading();
    });

  }

  updateProductOrService(companyId: string, productId: string, newItem: ProductOrService) {

    this.uiService.startLoading();
    const docPath = 'companies/' + companyId + '/productAndServices/' + productId;
    this.firedb.
    doc(docPath)
    .update(newItem)
    .then(() => {
      this.uiService.showMessage('Produto Atualizado!');
      this.uiService.stopLoading();
    })
    .catch(reason => {
        this.uiService.showError(reason);
        this.uiService.stopLoading();
    });

  }

  private returnUserCompanies(userId: string): Observable<any[]> {

    return new Observable<any[]>(observer => {

      const docPath = 'persons/' + userId;
      this.firedb.doc(docPath)
      .collection('companies')
      .get()
      .subscribe(values => {
        const itens = [];
        values.forEach(doc => { itens.push(doc.data()); });
        observer.next(itens);
      }, reason => {
        this.uiService.showError(reason);
        observer.error(reason);
      });

    });

  }

  emptyEstabelecimento(): Estabelecimento {
    return {
      companyId: '',
      name: '',
      alias: '',
      latitude: -15.8372017,
      longitude: -48.0345595,
      imageUrl: null,
      serviceHours: {
        start: '09:00',
        end: '21:00'
      }
    };
  }


}
