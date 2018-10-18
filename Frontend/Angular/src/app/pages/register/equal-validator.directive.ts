// equal-validator.directive.ts

import { Directive, forwardRef, Attribute } from '@angular/core';
import { Validator, AbstractControl, NG_VALIDATORS } from '@angular/forms';

@Directive({
    selector: '[app-validateEqual][formControlName],[app-validateEqual][formControl],[app-validateEqual][ngModel]',
    providers: [ { provide: NG_VALIDATORS, useExisting: forwardRef(() => EqualValidator), multi: true } ]
})

export class EqualValidator implements Validator {

    constructor( @Attribute('app-validateEqual') public validateEqual: string, @Attribute('reverse') public reverse: string) {}

    private get isReverse() {
        if (!this.reverse) {return false; }
        return this.reverse === 'true' ? true : false;
    }

    validate(c: AbstractControl): { [key: string]: any } {

        let result = null;

        // self value
        const v = c.value;

        // control vlaue
        const e = c.root.get(this.validateEqual);

        console.log('will compare ' + e + ' with ' + v);

        // value not equal
        if (e && v !== e.value && !this.isReverse) {result = {validateEqual: false}; }

        // value equal and reverse
        if (e && v === e.value && this.isReverse) {
            delete e.errors['app-validateEqual'];
            if (!Object.keys(e.errors).length) {e.setErrors(null); }
        }

        // value not equal and reverse
        if (e && v !== e.value && this.isReverse) {
            e.setErrors({ validateEqual: false });
        }

        console.log('returning ' + result);
        return result;
    }
}