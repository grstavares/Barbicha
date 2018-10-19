const errorCodes = {
    'auth/weak-password': 'Senha Inválida! Deve possuir ao menos 6 caracteres!',
    'auth/email-already-in-use': 'E-mail Já cadastrado!'
};

export class FirebaseErrors {

    getMessage(code: string): string {
        return errorCodes[code];
    }

}
