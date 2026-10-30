# Makefile -- TD Stockage de matrices en C
#
#   make           compile les 3 tests et le programme de demonstration
#   make tests     compile et lance test_ex1, test_ex2, test_ex3
#   make valgrind  lance les 3 tests et un scenario de demo sous valgrind
#   make clean     supprime les .o, les executables et les fichiers produits
#
# Les tests sont compiles avec -DMAT_TEST_ALLOC (echecs d allocation simules),
# le programme de demonstration sans. On produit donc deux jeux de fichiers
# objets : *.o pour la demo et *_t.o pour les tests.

CC      = gcc
CFLAGS  = -std=c11 -Wall -Wextra -Wpedantic -g
TFLAGS  = $(CFLAGS) -DMAT_TEST_ALLOC

EXECS   = test_ex1 test_ex2 test_ex3 demo_matrices

.PHONY: all tests valgrind clean

all: $(EXECS)

# ---- Edition de liens --------------------------------------------------
demo_matrices: main.o matrice.o matrice_alloc.o matrice_io.o matrice_calcul.o
	$(CC) $^ -o $@

test_ex1: test_ex1_t.o matrice_t.o matrice_alloc_t.o
	$(CC) $^ -o $@

test_ex2: test_ex2_t.o matrice_t.o matrice_alloc_t.o matrice_io_t.o
	$(CC) $^ -o $@

test_ex3: test_ex3_t.o matrice_t.o matrice_alloc_t.o matrice_calcul_t.o
	$(CC) $^ -o $@

# ---- Compilation separee ----------------------------------------------
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%_t.o: %.c
	$(CC) $(TFLAGS) -c $< -o $@

# ---- Dependances vers les en-tetes (graphe des inclusions) ------------
matrice.o matrice_t.o:               matrice.c matrice.h
matrice_alloc.o matrice_alloc_t.o:   matrice_alloc.c matrice_alloc.h matrice.h
matrice_io.o matrice_io_t.o:         matrice_io.c matrice_io.h matrice_alloc.h matrice.h
matrice_calcul.o matrice_calcul_t.o: matrice_calcul.c matrice_calcul.h matrice_alloc.h matrice.h
main.o: main.c matrice.h matrice_alloc.h matrice_io.h matrice_calcul.h
test_ex1_t.o: test_ex1.c matrice.h matrice_alloc.h
test_ex2_t.o: test_ex2.c matrice.h matrice_alloc.h matrice_io.h
test_ex3_t.o: test_ex3.c matrice.h matrice_alloc.h matrice_calcul.h

# ---- Raccourcis --------------------------------------------------------
tests: test_ex1 test_ex2 test_ex3
	./test_ex1
	./test_ex2
	./test_ex3

valgrind: $(EXECS)
	valgrind --leak-check=full ./test_ex1
	valgrind --leak-check=full ./test_ex2
	valgrind --leak-check=full ./test_ex3
	valgrind --leak-check=full ./demo_matrices add donnees/A.txt donnees/B.txt R.txt

clean:
	rm -f *.o $(EXECS) *.exe R.txt R2.txt test_ex2_sortie.txt
