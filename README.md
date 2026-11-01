# _Projet a rendre Programmation en C_

## Groupe Noé Ferre--Zekry, Mickael Longché, Anas Hamdi

### Rapport :
#### **exercice 1**

- *1.a :* Dans le fichier matrice.c nous avons ajouté les lignes :

```c
    case MAT_ERR_DIMENSIONS:  return "dimensions incompatibles";
    case MAT_ERR_DEPASSEMENT: return "hors de l'intervale des int";
```
avec description du cas de dépassement de mémoire

- *1.b :* Nous avons ajouté un return afin de renvoyer le resultat de toutes les conditions
```c
              return m != NULL &&
              m->coef != NULL &&   
              m->nb_lignes >= 1 && m->nb_lignes <= MAT_DIM_MAX &&
              m->nb_colonnes >= 1 && m->nb_colonnes <= MAT_DIM_MAX; 
```
Nous avons mis en commentaire les ligne provisoire :
```c
    (void)m;      
    return 0;
```
- *1.c :*
```c
    if ((((nb_lignes < 1) || (nb_lignes > MAT_DIM_MAX)))||(((nb_colonnes < 1) || (nb_colonnes > MAT_DIM_MAX)))){
        return MAT_ERR_ARGUMENT;
    }
```

- *1.d :*
```c
        for (int i = 0; i < nb_lignes; i++) {
            coef[i] = mat_calloc((size_t)nb_colonnes,sizeof*coef[i]);    
            if (coef[i] == NULL) {
                for (int k = i - 1; k >= 0; k--)  
                    free(coef[k]);               
                free(coef);                       
                return MAT_ERR_ALLOCATION;
            }
        }  
```
- *1.e :*
```c
        res->coef = coef;
        res->nb_lignes = nb_lignes;
        res->nb_colonnes = nb_colonnes;
        return MAT_OK;
```
Nous avons commenté ces lignes provisoire :
```c    
    free(coef);                  
    return MAT_ERR_LECTURE;
```
- *1.f:*
```c
    if (m->coef != NULL) 
    {
        for (int i = 0; i < m->nb_lignes; i++) {
            free(m->coef[i]); 
            }               
            free(m->coef);                                   
    } 
```
retour de test_ex1 :
```bash
==6321== Memcheck, a memory error detector
==6321== Copyright (C) 2002-2024, and GNU GPL'd, by Julian Seward et al.
==6321== Using Valgrind-3.26.0 and LibVEX; rerun with -h for copyright info
==6321== Command: ./teste_ex1
==6321== 
=== Exercice 1 : matrice.c ===
[OK]    (1.a) message pour MAT_ERR_DIMENSIONS
[OK]    (1.a) message pour MAT_ERR_DEPASSEMENT
[OK]    (1.b) une matrice 1 x 2 est valide
[OK]    (1.b) NULL n'est pas valide
[OK]    (1.b) MATRICE_VIDE n'est pas valide
[OK]    (1.b) une matrice de 0 ligne n'est pas valide
=== Exercice 1 : matrice_alloc.c ===
[OK]    (1.c) mat_allouer refuse 0 ligne
[OK]    (1.c) mat_allouer refuse -2 colonnes
[OK]    (1.c) mat_allouer refuse une dimension > MAT_DIM_MAX
[OK]    (1.e) mat_allouer(&m, 3, 4) renvoie MAT_OK
[OK]    (1.e) m a 3 lignes et 4 colonnes
[OK]    (1.d) tous les coefficients valent 0
[OK]    (1.f) apres mat_detruire, m est vide
[OK]    (1.f) un second mat_detruire est sans danger
[OK]    (1.f) mat_detruire(NULL) ne plante pas
=== Exercice 1 : echecs d'allocation simules ===
[OK]    (1.d) chaque echec renvoie MAT_ERR_ALLOCATION et laisse *res vide

Bilan : 16 / 16 verifications reussies.
Pensez a verifier l'absence de fuite : valgrind --leak-check=full ./test_ex1
==6321== 
==6321== HEAP SUMMARY:
==6321==     in use at exit: 0 bytes in 0 blocks
==6321==   total heap usage: 11 allocs, 11 frees, 1,228 bytes allocated
==6321== 
==6321== All heap blocks were freed -- no leaks are possible
==6321== 
==6321== For lists of detected and suppressed errors, rerun with: -s
==6321== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
```
####  Q3.1  
*Pourquoi mat_detruire prend-elle un Matrice * et non un Matrice ? Que se passerait-il,pour l'appelant, avec un passage par valeur ?*

**Reponse :**
mat_detruire est une fonction qui sert a libérer l'emplacement mémoire d'une matrice vide qui est formé de tableau dynamique. En prenant juste Matrice on travaillerais une une variable locale qui ce qui ne changerait pas la matrice original qu'on cherche a libéré. Par valeur, l'appelant garde un coef qui pointe vers de la memoire liberée

#### Q3.2 
*Combien d'appels à calloc et à free faut-il pour une matrice n x p ? Si la k-ième allocation échoue, combien de libérations mat_allouer doit-elle effectuer ?*

**Reponse :** On doit faire autant de free que de calloc soit n + 1 (1 pour le tableau de taille p qui regroupe les autre tableu et n autre tableau a défini)
Dans le cas ou l'allocation échoue(coef[i] == NULL)  mat_allouer doit free i-1 fois

#### Q3.3 
*Appeler deux fois free sur la même adresse est un comportement indéfini. Pourquoi appeler
deux fois mat_detruire sur la même matrice est-il sans danger ? Est-ce encore vrai si l'on a fait une copie Matrice b = a; puis appele mat_detruire (&a) et mat_detruire (&b) ?*

**Reponse :**
La fonction mat_detruire prend un pointeur vers une structure. En premier il teste si ce pointeur n'est pas null. Puis vérifie si la matrice est vide. Une fois fait l'état du pointeur est alors remis dans un etat vide. Dans le cas d'un second appel m est dans l'etat vide donc pas d'erreur.

Matrice b = a
Le pointeur interne b.coef pointe vers exactement la meme zone memoire que
a.coef. Les deux matrices partagent le même tableau de données.
donc au Premier appel mat_detruire(&a) libérera la tableau ensuite il y aura une erreur  car mat_detruire(&b) pointera encore vers une zone memoire déjà désallouée il y aura un comportement indefini.

#### Q3.4 
*Pourquoi mat_allouer commence-t-elle par l'affectation* *res =MATRICE_VIDE, avant même de vérifier les dimensions ?*

**Reponse :**
Dans le but de faire un code robuste on affecte avant toute action une matrice vide afin de permettre un retour exploitable, stable et déterminé en cas d'erreur.


#### **exercice 2**
- *2.a :*
```c
    for (int i = 0; i < m->nb_lignes; i++) {
     for (int j = 0; j < m->nb_colonnes; j++){
      printf(" %8d", m->coef[i][j]);
    }
    putchar('\n');
    }

```
- *2.b :*
```c
    for (int i = 0; i < m->nb_lignes; i++) {
        for (int j = 0; j < m->nb_colonnes; j++){
      if (fprintf(f, j==0 ? "%d" : " %d", m->coef[i][j]) < 0){
        return MAT_ERR_ECRITURE;
      }
     }
     if (fputc('\n',f) == EOF){
        return MAT_ERR_ECRITURE;
    }
}
```
- *2.c :*
```c
     if(nb_lignes<1 || nb_lignes > MAT_DIM_MAX || nb_colonnes<1 || nb_colonnes > MAT_DIM_MAX) {
        return MAT_ERR_FORMAT;
    }
```
- *2.d :*
```c
   Matrice tmp;
   err = mat_allouer(&tmp, nb_lignes, nb_colonnes);
   if (err != MAT_OK) 
   return err;
```
- *2.e :*
```c
         for (int i = 0; i < nb_lignes; i++) {
     for (int j = 0; j < nb_colonnes; j++){
            err=lire_entier(f, &tmp.coef[i][j]);
            if (err != MAT_OK){
              mat_detruire(&tmp);  
               return err;   
            } 
        }
    } 
```
- *2.f :*
```c
      *res = tmp; 
      return MAT_OK; 
```
Nous avons suprimé 
```c
return MAT_ERR_LECTURE;
```

Test final avec Valgrind:
```bash
==1042== Memcheck, a memory error detector
==1042== Copyright (C) 2002-2024, and GNU GPL'd, by Julian Seward et al.
==1042== Using Valgrind-3.26.0 and LibVEX; rerun with -h for copyright info
==1042== Command: ./test_ex2
==1042== 
=== Exercice 2 : affichage (verification visuelle) ===
M (4 x 3) :
        1        2        3
        4        5        6
        7        8        9
       10       11       12
(2.a) Vous devez voir ci-dessus 4 lignes : 1 2 3 / 4 5 6 / 7 8 9 / 10 11 12
=== Exercice 2 : ecriture ===
[OK]    ouverture de test_ex2_sortie.txt en ecriture
[OK]    (2.b) mat_ecrire renvoie MAT_OK
[OK]    (2.b) le fichier contient exactement le format attendu
[OK]    (2.b) mat_ecrire refuse une matrice vide
=== Exercice 2 : relecture ===
[OK]    (2.f) mat_lire relit le fichier : MAT_OK
[OK]    (2.e) la matrice relue est identique
[OK]    (2.e) espaces et sauts de ligne en trop sont toleres
=== Exercice 2 : fichiers incorrects ===
[OK]    (2.c) fichier vide
[OK]    (2.c) dimension nulle
[OK]    (2.c) dimension negative
[OK]    (2.e) coefficient manquant
[OK]    (2.e) donnee non numerique
[OK]    (2.e) entier trop grand pour un int
=== Exercice 2 : echec d'allocation simule ===
[OK]    (2.d) mat_lire renvoie MAT_ERR_ALLOCATION proprement

Bilan : 14 / 14 verifications reussies.
Pensez a verifier l'absence de fuite : valgrind --leak-check=full ./test_ex2
==1042== 
==1042== HEAP SUMMARY:
==1042==     in use at exit: 0 bytes in 0 blocks
==1042==   total heap usage: 51 allocs, 51 frees, 60,728 bytes allocated
==1042== 
==1042== All heap blocks were freed -- no leaks are possible
==1042== 
==1042== For lists of detected and suppressed errors, rerun with: -s
==1042== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
```

#### Q4.1 
*Pourquoi mat_lire remplit-elle d'abord une matrice locale avant de l'affecter à* *res ?*

**Reponse :**

Pour garantir qu'en cas d'echec *res reste dans l'état vide. Avec tmp, on peut la détruire proprement mat_detruire(&tmp) en cas d'erreur, et on n'affecte *res = tmp qu'une fois que tout a réussi. On evite alors des erreur comme une erreur au milieu du fichier ou un oublie de liberation 

#### Q4.2
 *La lecture vérifie-t-elle que chaque ligne de la matrice est sur sa propre ligne de texte ? Est-ce gênant ? Justifiez le principe « tolérant en lecture, strict en écriture ».*

**Reponse :**

Non lire_entier utilise fscanf("%31s") qui lit des chaines de caratère de longeur maximale de 31 séparé par des espaces et les tabulation \n 
Donc il ne vérifie pas chaque ligne 

Ce n'est pas génant car on vérifie les mots en entrée,

Selon le principe de tolérant en lecture, strict en écriture : On veux un format canonique définie en écriture et on accepte des variations sans importance en lecture car la tolérance ne porte que sur la forme et non le contenu ce qui permet une meilleur flexibilité en lecture mais une rigeure en écriture ce qui rend le code plus robuste.

#### Q4.3
*Après l'appel mat_lire(f, &m), le flux f est positionné après le dernier coefficient. Comment exploiter cette propriété pour stocker deux matrices dans un même fichier ?*

**Reponse :**

mat_lire déplace le curseur du fichier exactement apres les dimensions et les coefficients le flux est positionné apres le dernier coefficient.Donc en appelant la fonction une nouvelle fois sur le meme FILE* il continura a lire si une autre matrice se trouve apres.
Pour utiliser mat_ecrire sur le meme FILE * le principe est le meme écrire sur le meme fichier car le flux est bien positionné a la fin de la première execution  

#### Q4.4 
*Pourquoi mat_ecrire appelle-t-elle fflush avant de renvoyer MAT_OK ? Cela dispense-t-il

l'appelant de tester fclose ?*

**Reponse :**
fflush va forcer l'écriture du tampon, fprintf et fputc écrive sur des buffer avant d'enregistré en mémoire on pourrais avoir une erreur entre l'écriture sur le disque et le buffer. Donc fflush permet de ce premunir de cette erreur afin d'etre sur qu'on a pas l'état MAT_ERR_ECRITURE a la place de MAT_OK. Enfin ça ne dispense pas de faire un fclose. fclose ferme le flux alors que fflush force juste l'écriture


#### **exercice 3**
- *3.a :*
```c
    if ((a->nb_lignes!=b->nb_lignes) || (a->nb_colonnes!=b->nb_colonnes)){
        return MAT_ERR_DIMENSIONS;
    }
```
- *3.b :*
```c
    Matrice r = MATRICE_VIDE;
    err = mat_allouer(&r,a->nb_lignes, a->nb_colonnes);
    if (err != MAT_OK) 
        return err;                          
    
```
- *3.c :*
```c
    long long s = (long long)a->coef[i][j] + b->coef[i][j];
```
- *3.d :*
```c
    *res = r; 
    return MAT_OK; 
```
```bash
=== Exercice 3 : addition ===
[OK]    (3.a) (2 x 3) + (3 x 2) : MAT_ERR_DIMENSIONS
[OK]    (3.d) (2 x 3) + (2 x 3) : MAT_OK
[OK]    (3.c) a + b est correct
[OK]    a et b n'ont pas ete modifiees
[OK]    (3.b) le resultat possede sa propre memoire
[OK]    (3.c) INT_MAX + 1 : MAT_ERR_DEPASSEMENT
```
On a bien toute la partie addition qui est valide
- *3.e :*
```c
if (a->nb_colonnes != b->nb_lignes){
        return MAT_ERR_DIMENSIONS;
    }
```
- *3.f :*
```c
    Matrice r = MATRICE_VIDE;
    err = mat_allouer(&r,a->nb_lignes, b->nb_colonnes);
    if (err != MAT_OK) 
     return err;
```
- *3.g :*
```c
for (int k = 0; k < a->nb_colonnes; k++) {
                long long p = (long long)a->coef[i][k] * b->coef[k][j];
                if ((p > 0 && s > LLONG_MAX - p)
                    || (p < 0 && s < LLONG_MIN - p)) {
                        mat_detruire(&r);
                        return MAT_ERR_DEPASSEMENT;
                    }
                s += p;
               }            
```
- *3.h :*
```c
    *res = r; 
    return MAT_OK;
```
```bash
Test Final  avec Valgrind
==1514== Memcheck, a memory error detector
==1514== Copyright (C) 2002-2024, and GNU GPL'd, by Julian Seward et al.
==1514== Using Valgrind-3.26.0 and LibVEX; rerun with -h for copyright info
==1514== Command: ./test_ex3
==1514== 
=== Exercice 3 : addition ===
[OK]    (3.a) (2 x 3) + (3 x 2) : MAT_ERR_DIMENSIONS
[OK]    (3.d) (2 x 3) + (2 x 3) : MAT_OK
[OK]    (3.c) a + b est correct
[OK]    a et b n ont pas ete modifiees
[OK]    (3.b) le resultat possede sa propre memoire
[OK]    (3.c) INT_MAX + 1 : MAT_ERR_DEPASSEMENT
=== Exercice 3 : multiplication ===
[OK]    (3.e) (2 x 3) x (2 x 3) : MAT_ERR_DIMENSIONS
[OK]    (3.h) (2 x 3) x (3 x 2) : MAT_OK
[OK]    (3.g) a x c = (58 64 / 139 154)
[OK]    (3.f) (3 x 2) x (2 x 3) donne une matrice 3 x 3
[OK]    a et c nont pas ete modifiees
[OK]    (3.g) 2 x 10^10 depasse INT_MAX : MAT_ERR_DEPASSEMENT
=== Exercice 3 : cas particuliers ===
[OK]    resultat = entree refuse, a reste intacte
[OK]    (3.f) echec d allocation : MAT_ERR_ALLOCATION, r vide

Bilan : 14 / 14 verifications reussies.
Pensez a verifier l absence de fuite : valgrind --leak-check=full ./test_ex3
==1514== 
==1514== HEAP SUMMARY:
==1514==     in use at exit: 0 bytes in 0 blocks
==1514==   total heap usage: 37 allocs, 37 frees, 1,412 bytes allocated
==1514== 
==1514== All heap blocks were freed -- no leaks are possible
==1514== 
==1514== For lists of detected and suppressed errors, rerun with: -s
==1514== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
```
#### Q5.0(question dans calcul.c)
*Un résultat calculé en long long tient-il dans un int ? *

**Reponse :**
Pas toujours. tient_dans_int vérifie que la valeur est entre INT_MIN et INT_MAX ; sinon on détruit r et on renvoie MAT_ERR_DEPASSEMENT au lieu de tronquer silencieusement la valeur avec le cast (int)s`.
#### Q5.1
*Le paramètre const Matrice *a empêche-t-il d’écrire a->coef[0][0] = 7; ? Que protège
 exactement ce const ? Que faudrait-il changer pour que le compilateur refuse cette affectation ?

**Reponse :**
Non. Avec const Matrice *a, c'est la structure qui est constante : on ne peut pas écrire a->nb_lignes = 0; ni a->coef = NULL;. Mais le champ coef est de type int ** : a->coef est un pointeur constant vers des int * non constants, donc a->coef[0][0] est un int modifiable et a->coef[0][0] = 7; compile sans avertissement. Le const protège donc seulement les trois champs de la structure, pas les coefficients rangés dans le tas.
Pour que le compilateur refuse cette affectation, il faudrait que le type des coefficients soit constant, par exemple un champ const int *const *coef (ou une structure « vue en lecture » séparée pour les entrées). Comme matrice.h est imposé, chez nous la non-modification des entrées est une règle (R4) que nous respectons et que test_ex3 vérifie (« a et b n'ont pas été modifiées »).
#### Q5.2
*Pourquoi refuse-t-on l’appel mat_additionner(&a, &b, &a) alors que, mathématiquement,
a ←a+b a un sens ? Que se passerait-il avec notre implémentation si on l’acceptait ?

**Reponse :**
Parce que res est un paramètre de sortie (R5) : la fonction commence par l'écraser. Dans notre code, verifier_parametres fait *res = MATRICE_VIDE; si res == &a, la matrice a serait vidée avant d'être lue : son tableau coef serait perdu (fuite de toute la mémoire de a) et mat_est_valide(a) renverrait 0. Même sans cette ligne, on finirait par *res = r;, qui remplace a.coef par celui de r sans libérer l'ancien : fuite. Pour la multiplication, calculer « sur place » serait de toute façon faux, car les coefficients de a déjà écrasés sont encore nécessaires pour les cases suivantes. C'est pourquoi verifier_parametres renvoie MAT_ERR_ARGUMENT si res == a || res == b avant de toucher à *res (test « resultat = entree refuse, a reste intacte »). Pour faire a <- a + b, l'appelant calcule dans r, puis mat_detruire(&a); a = r;.
#### Q5.3
 *Combien de multiplications d’entiers effectue mat_multiplier pour des matrices n × p et
 p ×q ?Combien pour deux matrices 1000×1000 ?

**Reponse :**
La boucle i fait n tours, la boucle j en fait q et la boucle k en fait p ; il y a une multiplication(long long)a->coef[i][k] * b->coef[k][j] par tour de k, donc n x p x q multiplications (et autant d'additions). Pour deux matrices 1000 x 1000 : 1000 x 1000 x 1000 = 10^9 multiplication (un milliard), soit de l'ordre de la seconde, contre seulement 10^6 additions pour mat_additionner. Le coût croît comme le cube de la taille.
#### Q5.4
 *Pourquoi ne suffit-il pas de calculer int s = a + b; puis de tester s < a pour détecter un
 dépassement 

**Reponse :**
En C, le dépassement d'un int signé est un comportement indéfini : une fois int s = a + b; exécuté, il est trop tard, le programme n'a plus aucune garantie. En pratique, le compilateur a le droit de supposer qu'il n'y a jamais de dépassement et peut supprimer le test s < a (avec b > 0, il « sait » que a + b < a est impossible) dès que l'on optimise. De plus le test est incomplet : si b est négatif, s < a est normal et un dépassement vers le bas ne serait pas vu.
Notre code évite le problème en calculant avant de déborder : dans l'addition, (long long)a->coef[i][j] + b->coef[i][j] tient toujours dans un long long (au plus 2^32), puis tient_dans_int vérifie le résultat. Dans la multiplication, chaque produit tient dans un long long (au plus 2^62), et on teste s > LLONG_MAX - p (ou s < LLONG_MIN - p) avant de faire s += p.

#### **exercice 4**
- *4.a :*
```c
    mat_afficher("A",&a);
    mat_afficher("B",&b);
```
- *4.b :*
```c
    if(err !=MAT_OK){
        fprintf(stderr,"Erreur : calcul impossible : %s ", mat_message_erreur(err));
        fprintf(stderr,"(A : %d x %d, B : %d x %d)\n", a.nb_lignes, a.nb_colonnes,b.nb_lignes,b.nb_colonnes);
        goto nettoyage;
    }
```
- *4.c :*
```c
    addition ? mat_afficher("R = A + B",&r) : mat_afficher("R = A x B",&r);
```
- *4.d :*
```c
    printf("Résultat enregistré dans \"%s\".\n",argv[4]);
    statut = EXIT_SUCCESS;
```

Test de l'exercice 4 (scénarios du sujet) :
```bash
$ ./demo_matrices add donnees/A.txt donnees/B.txt R.txt
A (4 x 3) :
       25       48       84
       15       33       11
       45       88       10
        0       12       -5
B (4 x 3) :
        1        2        3
        4        5        6
        7        8        9
       10       11       12
R = A + B (4 x 3) :
       26       50       87
       19       38       17
       52       96       19
       10       23        7
Résultat enregistré dans "R.txt".
$ echo $?
0
$ cat R.txt
4 3
26 50 87
19 38 17
52 96 19
10 23 7
```
```bash
$ ./demo_matrices mul donnees/A.txt donnees/C.txt R.txt
A (4 x 3) :
       25       48       84
       15       33       11
       45       88       10
        0       12       -5
B (3 x 2) :
        1        0
        0        1
        2       -1
R = A x B (4 x 2) :
      193      -36
       37       22
       65       78
      -10       17
Résultat enregistré dans "R.txt".
$ echo $?
0
```
```bash
$ ./demo_matrices add donnees/A.txt donnees/C.txt R.txt
A (4 x 3) :
       25       48       84
       15       33       11
       45       88       10
        0       12       -5
B (3 x 2) :
        1        0
        0        1
        2       -1
Erreur : calcul impossible : dimensions incompatibles (A : 4 x 3, B : 3 x 2)
$ echo $?
1
```

```bash
$ ./demo_matrices add donnees/invalide.txt donnees/B.txt R.txt
Erreur : lecture de "donnees/invalide.txt" : fichier mal formé
$ echo $?
1
```

Test final avec Valgrind (cas réussi) :
```bash
==475== Memcheck, a memory error detector
==475== Copyright (C) 2002-2022, and GNU GPL'd, by Julian Seward et al.
==475== Using Valgrind-3.22.0 and LibVEX; rerun with -h for copyright info
==475== Command: ./demo_matrices add donnees/A.txt donnees/B.txt R.txt
==475== Parent PID: 391
==475== 
==475== 
==475== HEAP SUMMARY:
==475==     in use at exit: 0 bytes in 0 blocks
==475==   total heap usage: 22 allocs, 22 frees, 18,040 bytes allocated
==475== 
==475== All heap blocks were freed -- no leaks are possible
==475== 
==475== For lists of detected and suppressed errors, rerun with: -s
==475== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
```

Test avec Valgrind (cas d'erreur : dimensions incompatibles) :
```bash
==476== Memcheck, a memory error detector
==476== Copyright (C) 2002-2022, and GNU GPL'd, by Julian Seward et al.
==476== Using Valgrind-3.22.0 and LibVEX; rerun with -h for copyright info
==476== Command: ./demo_matrices add donnees/A.txt donnees/C.txt R.txt
==476== Parent PID: 391
==476== 
==476== 
==476== HEAP SUMMARY:
==476==     in use at exit: 0 bytes in 0 blocks
==476==   total heap usage: 14 allocs, 14 frees, 13,360 bytes allocated
==476== 
==476== All heap blocks were freed -- no leaks are possible
==476== 
==476== For lists of detected and suppressed errors, rerun with: -s
==476== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
```


#### Q6.1
*Pourquoi le message d'erreur est-il affiché par main.c (ou ses fonctions static) et non par mat_lire ?*

**Reponse :**
Une bibliothèque ne sait pas dans quel programme elle sera utilisée. Un programme graphique n'a pas de terminal : un fprintf(stderr, ...) dans mat_lire serait invisible, alors que le programme voudrait afficher une boîte de dialogue, traduire le message, ou réessayer sans rien dire. De plus mat_lire ne reçoit qu'un FILE * : elle ne connaît même pas le nom du fichier. C'est charger qui le connaît et peut écrire un message précis : Erreur : lecture de "donnees/invalide.txt" : fichier mal formé. La bibliothèque renvoie donc seulement un code, et l'appelant choisit comment le présenter (avec mat_message_erreur).

#### Q6.2
*Pourquoi le résultat de fclose est-il testé dans sauvegarder mais pas dans charger ?*

**Reponse :**
En écriture, fprintf écrit d'abord dans un tampon en mémoire ; les dernières données peuvent n'être envoyées au disque qu'au moment de fclose (disque plein, quota, clé retirée, lecteur réseau). Si fclose échoue, le fichier R.txt peut être incomplet : il faut le signaler (MAT_ERR_ECRITURE) et terminer avec un code d'échec. En lecture, la matrice a déjà été entièrement lue et vérifiée par mat_lire au moment de fclose : un échec de la fermeture ne fait perdre aucune donnée et il n'y a rien d'utile à faire, on garde donc la matrice.

#### Q6.3
*Dans le scénario 8, le calcul a réussi mais l'enregistrement a échoué. Combien de matrices faut-il libérer ?*

**Reponse :**
**trois** : a et b (lues) et r (le résultat, dont main est devenu propriétaire quand mat_additionner a renvoyé MAT_OK, règle R2). Quand sauvegarder échoue, on fait goto nettoyage; et les trois mat_detruire sont exécutés ; statut est resté à EXIT_FAILURE. Vérifié sous valgrind (./demo_matrices add donnees/A.txt donnees/B.txt dossier_inexistant/R.txt) : total heap usage: 21 allocs, 21 frees, All heap blocks were freed -- no leaks are possible, code de sortie 1. Les 15 blocs des trois matrices 4 x 3 (1 + 4 chacune) sont bien libérés, les autres allocations étant celles de la bibliothèque standard (tampons des FILE).







valgrind du 6.2
```bash
==1117== Memcheck, a memory error detector
==1117== Copyright (C) 2002-2024, and GNU GPL'd, by Julian Seward et al.
==1117== Using Valgrind-3.26.0 and LibVEX; rerun with -h for copyright info
==1117== Command: ./demo_matrices
==1117== 
Usage : ./demo_matrices <add|mul> <fichier_A> <fichier_B> <fichier_R>
==1117== 
==1117== HEAP SUMMARY:
==1117==     in use at exit: 0 bytes in 0 blocks
==1117==   total heap usage: 0 allocs, 0 frees, 0 bytes allocated
==1117== 
==1117== All heap blocks were freed -- no leaks are possible
==1117== 
==1117== For lists of detected and suppressed errors, rerun with: -s
==1117== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
```
