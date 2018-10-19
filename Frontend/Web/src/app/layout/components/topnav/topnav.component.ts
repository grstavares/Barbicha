import { Component, OnInit, OnDestroy } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { TranslateService } from '@ngx-translate/core';
import { Subscription } from 'rxjs';
import { UiService, AuthService } from '../../../shared/services';

@Component({ selector: 'app-topnav', templateUrl: './topnav.component.html', styleUrls: ['./topnav.component.scss'] })
export class TopnavComponent implements OnInit, OnDestroy {

    isLoading = false;
    isLoadingSubscription: Subscription;
    pushRightClass = 'push-right';

    constructor(public router: Router, private translate: TranslateService, private authService: AuthService, private uiService: UiService) {
        this.router.events.subscribe(val => {
            if (val instanceof NavigationEnd && window.innerWidth <= 992 && this.isToggled()) {
                this.toggleSidebar();
            }
        });
    }

    ngOnInit() {
        this.isLoadingSubscription = this.uiService.isLoading.subscribe(value => {this.isLoading = value; });
    }

    isToggled(): boolean {
        const dom: Element = document.querySelector('body');
        return dom.classList.contains(this.pushRightClass);
    }

    toggleSidebar() {
        const dom: any = document.querySelector('body');
        dom.classList.toggle(this.pushRightClass);
    }

    onLoggedout() {
        this.authService.logout();
        this.router.navigate(['/login']);
    }

    changeLang(language: string) {
        this.translate.use(language);
    }

    ngOnDestroy() {
        this.isLoadingSubscription.unsubscribe();
    }
}
