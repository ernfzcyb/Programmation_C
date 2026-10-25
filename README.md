# _Projet a rendre Programation en C_

## Groupe Noé Ferre--Zekry, Mickael Longché, Anas hamdi

### Rapport :
#### **exercice 1**

- *1.a :* Dans le fichier matrice.c nous avons ajouté les lignes :

```bash
    case MAT_ERR_DIMENSIONS:  return "dimensions incompatibles";
    case MAT_ERR_DEPASSEMENT: return "dépassement de la mémoire";
```
avec description du cas de dépassement de mémoire

- *1.b :* Nous avons ajouter un return afin de renvoyer le resultat de toute les condition
````bash
              return m != NULL &&
              m->coef != NULL &&   
              m->nb_lignes >= 1 && m->nb_lignes <= MAT_DIM_MAX &&
              m->nb_colonnes >= 1 && m->nb_colonnes <= MAT_DIM_MAX; 
````
Nous avons mis en commentaire les ligne provisoire :
```bash
    (void)m;      
    return 0;
````
- *1.c :*
```bash
    if ((((nb_lignes < 1) || (nb_lignes > MAT_DIM_MAX)))||(((nb_colonnes < 1) || (nb_colonnes > MAT_DIM_MAX)))){
        return MAT_ERR_ARGUMENT;
    }
```

- *1.d :*
```bash
        for (int i = 0; i < nb_lignes; i++) {
            coef[i] = mat_calloc((size_t)nb_colonnes,sizeof*coef[i]);    // nb_colonnes entiers
            if (coef[i] == NULL) {
                for (int k = i - 1; k >= 0; k--)  // lignes déjà
                    free(coef[k]);                // obtenues
                free(coef);                       // puis le tableau
                return MAT_ERR_ALLOCATION;
            }
        }  
```
- *1.e :*
```bash
        res->coef = coef;
        res->nb_lignes = nb_lignes;
        res->nb_colonnes = nb_colonnes;
        return MAT_OK;
```
Nous avons commenté ces lignes provisoire :
```bash    
    free(coef);                  
    return MAT_ERR_LECTURE;
```
- *1.f:*
```bash
    if (m->coef != NULL) 
    {
        for (int i = 0; i < m->nb_lignes; i++) {
            free(m->coef[i]); 
            }               // obtenues
            free(m->coef);                                   
    } 
```
retour de test_ex1 :
```
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
mat_detruire est une fonction qui sert a libéré l'emplacement mémoire d'une matrice vide qui est formé de tableau dynamique. En prenant juste Matrice on travailleurais une une variable locale qui ce qui ne changerait pas la matrice original qu'on cherche a libéré

#### Q3.2 
*Combien d'appels à calloc et à free faut-il pour une matrice n x p ? Si la k-ième allocation échoue, combien de libérations mat_allouer doit-elle effectuer ?*

**Reponse :** On doit faire autant de free que de calloc soit n + 1 (1 pour le tableau de taille p qui regroupe les autre tableu et n autre tableau a défini)
Dans le cas l'allocation échoue(coef[i] == NULL)  mat_allouer doit free i+1 fois

#### Q3.3 
*Appeler deux fois free sur la même adresse est un comportement indéfini. Pourquoi appeler
deux fois mat_detruire sur la même matrice est-il sans danger ? Est-ce encore vrai si l'on a fait une copie Matrice b = a; puis appele mat_detruire (&a) et mat_detruire (&b) ?*

**Reponse :**
La fonction mat_detruire prend un pointeur versune structure. En premier il teste si ce pointeur n'est pas null. Puis vérifie si la matrice est vide. Une fois fait l'état du pointeur est alors remis dans un etat vide.
Dans le cas d'un second appel la premier vérification permet de ce prémunire erreur.

Matrice b = a
Le pointeur interne b.coef pointe vers exactement la meme zone memoire que
a.coef. Les deux matrices partagent le même tableau de données.
donc au Premier appel mat_detruire(&a) libèrerat la tableau ensuite il y aura une erreur  car mat_detruire(&b) pointera encore vers une zone memoir déjà désallouer il y aura un comportement indefini.

#### Q3.4 
*Pourquoi mat_allouer commence-t-elle par l'affectation* *res =MATRICE_VIDE, avant même de vérifier les dimensions ?*

**Reponse :**
Dans le but de faire un code robuste on affecte avant toute action une matrice vide afin de permettre un retour exploitable, stable et déterminé en cas d'erreur.

#### **exercice 2**