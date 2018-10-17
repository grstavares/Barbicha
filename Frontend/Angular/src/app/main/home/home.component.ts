import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

interface NavigationItens {
  label: string;
  link: string;
  icon?: string;
}

const defaultItens: NavigationItens[] = [
  {label: 'Estabelecimento', link: 'messages', icon: ''},
  {label: 'Clientes', link: 'userprofile', icon: ''},
  {label: 'Finanças', link: '/notfound', icon: ''},
  {label: 'Vizinhança', link: '/notfound', icon: ''},
  {label: 'Redes Sociais', link: '/notfound', icon: ''},
];

@Component({ selector: 'app-home', templateUrl: './home.component.html', styleUrls: ['./home.component.css'] })
export class HomeComponent implements OnInit {

  navigationItens: NavigationItens[] = null;

  constructor(private router: Router) { }

  ngOnInit() {
    this.navigationItens = defaultItens;
  }

}
