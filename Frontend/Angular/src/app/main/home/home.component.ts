import { Component, OnInit, OnDestroy, AfterContentInit } from '@angular/core';
import { Router } from '@angular/router';
import { UiService } from 'src/app/services/ui.service';
import { Subscription } from 'rxjs';

interface NavigationItens {
  label: string;
  link: string;
  icon?: string;
}

const modules: NavigationItens[] = [
  {label: 'MOD_ESTABELEC', link: 'estabelecimentos', icon: 'store_mall_directory'},
  {label: 'MOD_CLIENTES', link: 'estabelecimentos/12345', icon: 'group'},
  {label: 'MOD_FINANC', link: '/notfound', icon: 'account_balance_wallet'},
  {label: 'MOD_VIZINA', link: '/notfound', icon: 'layers'},
  {label: 'MOD_SOCIAL', link: '/notfound', icon: 'question_answer'}
];

const defaultItens: NavigationItens[] = [
  {label: 'MAIN_ACTIVITIES', link: 'activities', icon: 'toc'},
  {label: 'MAIN_MESSAGES', link: 'messages', icon: 'speaker_notes'},
  {label: 'MAIN_PROFILE', link: 'userprofile', icon: 'folder_shared'},
  {label: 'MAIN_LOGOUT', link: 'logout', icon: 'exit_to_app'},
];

@Component({ selector: 'app-home', templateUrl: './home.component.html', styleUrls: ['./home.component.css'] })
export class HomeComponent implements OnInit, OnDestroy, AfterContentInit {

  isLoading = false;
  isLoadingSubscription: Subscription;
  navigationItens: NavigationItens[] = null;
  actionsItens: NavigationItens[] = null;

  constructor(private router: Router, private uiService: UiService) { }

  ngOnInit() {
    this.navigationItens = modules;
    this.actionsItens = defaultItens;
    // this.router.navigate(['welcome']);
  }

  ngAfterContentInit() {
    this.isLoadingSubscription = this.uiService.isLoading.subscribe(value => {this.isLoading = value; });
  }

  ngOnDestroy() {
    this.isLoadingSubscription.unsubscribe();
  }

}
