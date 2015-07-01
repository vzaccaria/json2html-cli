---
title: soluzioni prova scritta del 29 Giugno
date: 2015-06-30 17:01:55

layout: post
category : infob
tags : ['esame']
---

Esercizio numero 1 - Linguaggio C
===================================

Si considerino i seguenti tipi di dato in C. Essi servono a contenere le
informazioni relative ad una carta di credito, incluse le transazioni
eseguite.

``` c
#define N 100
typedef char Stringa[N];
typedef enum {falso, vero} bool;

typedef struct // descrizione della transazione
{
    float importo;
    Stringa nazione;
    int timestamp; // tempo dell'acquisto espresso in secondi dal 1/1/1970.
    // Ad es. le ore 9:00:00 del il 2015.06.29 corrispondono al 1435561200 secondo
    //        le ore 9:01:00 del il 2015.06.29 corrispondono al 1435561260 secondo
    bool usato_pin; // determina se la transazione è avvenuta richiedendo il pin all'utente
} Acquisto;

typedef struct
{
    int card_number; // numero della carta
    Acquisto trans[N];
    int n_trans; // numero delle transazioni eseguite
} Carta;
```

Domanda 1
---------

Si definisca un nuovo tipo di struttura `Persona` atta a contenere le
informazioni relative al proprietario della carta e si modifichi la
definizione del tipo `Carta` in modo che contenga un campo
`proprietario` di tipo `Persona`.

``` c
typedef struct
{
    Stringa nome;
    Stringa cognome;
} Persona;

typedef struct
{
    int card_number;      // numero della carta
    Acquisto trans[N];    // acquisti effettuati con la carta
    Persona proprietario; // 
    int n_trans;          // numero delle transazioni eseguite
} Carta;
```

Domanda 2
---------

Si scriva un frammento di codice in linguaggio C per rilevare le carte
che possono aver subito una frode. Una carta può aver subito una frode
se:

a.  riporta due transazioni consecutive in meno di 1 minuto, oppure
b.  riporta due transazioni consecutive con PIN in nazioni diverse in meno di
    un'ora.

In particolare:

1.  Il codice deve contenere una variabile `cards` che memorizzi 1
    milione di carte di credito

2.  Assumendo che la variabile `cards` sia stata riempita
    precedentemente:

    -   si stampino i numeri delle carte che possono aver subito una
        frode. Si tenga presente che le transazioni registrate in
        `Acquisto trans[N]` sono ordinate cronologicamente.

    -   si copino le informazioni di tutte le persone frodate nell'array
        `persone_frodate` (senza lasciare buchi)

<!-- -->
``` c
#define M 1000000
int main()
{
    Carta cards[M];
    int i, j, k, frodata;
    Persona persone_frodate[M];
    for(i = 0; i < M; i++) {
        frodata = 0; 
        k = 0;
        for(j = 0; (j < cards[i].n_trans - 1) && frodata == 0; j++) {
            if(cards[i].trans[j+1].timestamp - cards[i].trans[j].timestamp < 60) {
                frodata = 1;
            }
            else {
                if(cards[i].trans[j+1].usato_pin == vero && 
                   cards[i].trans[j].usato_pin == vero &&
                   cards[i].trans[j+1].timestamp - cards[i].trans[j].timestamp < 60 * 60 &&
                   strcmp(cards[i].trans[j+1].nazione, cards[i].trans[j].nazione) != 0) {
                    frodata = 1;
                }
            }
        }
        if (frodata) {
            printf("\nla carta %d è stata frodata ", cards[i].card_number);
            persone_frodate[k] = cards[i].proprietario;
            k++;
        }
    }
}
```

\newpage

Esercizio numero 2 - Matlab
=============================

Si sviluppino in Matlab le seguenti funzioni:

Funzione n. 1
-------------

Si definisca la funzione `rimuovi(A,v)` tale che, dato un vettore `A` ed
un valore `v` in ingresso, ritorni il vettore `A` privato di `v` (se
contenuto in esso), altrimenti restituisce `A`.


-   `rimuovi([ 5, 6, 7 ], 5)` ritorna `[6, 7]`
-   `rimuovi([ 5, 6, 7 ], 9)` ritorna `[5, 6, 7]`

Spazio soluzione

``` octave
function B = rimuovi(A, v)
  B = A(find(A~=v));
end
```

Funzione n. 2
-------------

Si definisca la funzione `aggiungi(Q,v)` che prende in ingresso una
matrice `Q` ed un valore `v`, e restituisce una matrice corrispondente a
`Q` a cui è stato aggiunto `v` come primo elemento di ogni riga.

Esempio:

-   `aggiungi([ 5, 4; 6, 8; 7, 9 ], 3)` ritorna
    `[ 3, 5, 4; 3, 6, 8; 3, 7, 9 ]`

Spazio soluzione

``` octave
function T = aggiungi(Q, e)
    T = [(ones(rows(Q), 1) .* e) Q];
end 
```

Funzione n. 3
-------------

Si supponga di avere un array `S` di `n` numeri distinti

    S = [5,8,1]

Una **disposizione semplice** di lunghezza `k` di tale insieme (con `k`
≤ `n`), è rappresentabile da una matrice di k colonne che contiene, in
ogni riga, un sottoinsieme ordinato di k elementi di S.

Le righe della matrice sono tutte distinte e all’interno di ogni riga
non si possono trovare ripetizioni di uno stesso elemento. Due righe
possono contenere gli stessi elementi purché in ordine differente.

Ad esempio, una disposizione semplice di `S` con `k=2` è la matrice
seguente[^1]

    [ 5, 8;  5, 1;  8, 5;  8, 1;  1, 5;  1, 8 ]

Il vostro compito e quello di scrivere in Matlab una funzione
**ricorsiva** `disposizioni(S,k)` che implementa il calcolo delle
disposizioni semplici `k` di un insieme `S`, ad esempio

``` octave
octave> disposizioni([5,8,1],2)

ans =

    5   8
    5   1
    8   5
    8   1
    1   5
    1   8
```

Osservazioni utili per l'implementazione
----------------------------------------

Per `k=1`, l'elenco delle disposizioni semplici di `S` corrisponde ad
`S` *trasposto*; nel nostro esempio

``` octave
octave> disposizioni([5,8,1],1)

    5
    8
    1
```

Quando `k>1,` le disposizioni si possono calcolare sfruttando le
funzioni n. 1 e 2 definite ai punti precedenti nel modo seguente

1.  si rimuove un elemento `v` di `S`,
2.  si aggiunge `v` a tutte le disposizioni di `k-1` elementi di `S - v`
    (ovvero il vettore `S` a cui è stato rimosso v).

la procedura sopra deve essere ripetuta per tutti gli elementi `v` di `S`

Nel nostro esempio, per k = 2

|  **S**  | **v** | **S - v** | **disposizioni(S-v,1)** | **Disposizioni risultanti** |
|:-------:|:-----:|:---------:|:-----------------------:| :---------------------------:|
| [5,8,1] |   5   |   [8, 1]  |          [8; 1]         |        [ 5, 8; 5, 1 ]       |
| [5,8,1] |   8   |   [5, 1]  |          [5; 1]         |         [ 8, 5; 8, 1 ]       |
| [5,8,1] |   1   |   [5, 8]  |          [5; 8]         |        [ 1, 5; 1, 8 ]       |

Il risultato finale e' la fusione delle **disposizioni risultanti** in un'unica
matrice:

``` octave
[ [5, 8]; [5, 1] ; [8, 5]; [8, 1]; [1, 5]; [1, 8] ]
```

Spazio soluzione

``` octave
function P = disposizioni(s,k)
  n = length(s);
    if k == 1
      P = s';
    else
        P = [];
        for x = 1:n
            e = s(x);
            t = rimuovi(s, e);
            Q = disposizioni(t, k-1);
            T = aggiungi(Q, e);
            P = [P; T];
        end
    end
end
```

\newpage

Esercizio numero 3 --- C con tabelle verità
===========================================

Sia dato il seguente programma:

``` c
if(!a) {
    if (b) {
        if((a && c) || (!b && !c)) {
            printf("Nooo!");
        } else {
            printf("Yes!");
        }
	}
}
```

dove `a`, `b` e `c` sono variabili inizializzate in precedenza ad un
valore che può essere 0 oppure 1.

Domanda 1
---------

Si compili la seguente tabella per ogni combinazione dei valori delle
tre variabili

| **a** | **b** | **c** | **Messaggio stampato** |
|:-----:|:-----:|:-----:|:----------------------:|
|   0   |   0   |   0   |                        |
|   0   |   0   |   1   |                        |
|   0   |   1   |   0   |          Yes!          |
|   0   |   1   |   1   |          Yes!          |
|   1   |   0   |   0   |                        |
|   1   |   0   |   1   |                        |
|   1   |   1   |   0   |                        |
|   1   |   1   |   1   |                        |

Domanda 2
---------

Si riscriva il frammento di codice utilizzando un solo `if`, ove la
condizione deve essere la più ridotta possibile in termini di operatori
e variabili utilizzate.

``` c
if(!a && b) {
    printf("Yes!");
}
```

[^1]: Ricordate che in una matrice Matlab/Octave, il punto e virgola
    separa le righe.
