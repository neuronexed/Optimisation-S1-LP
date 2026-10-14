% ============================================================================
% Optimisation pour l'IA — Séance 2 — TD-TP PPC, Exercice 5
% Le Sudoku du cours, en MiniZinc — grille 9x9 partiellement remplie (30
% indices donnés). Sa solution est EXACTEMENT la grille 9x9 des diapositives
% (section Modélisation PPC, "Le même modèle, à toutes les échelles").
% ============================================================================

include "alldifferent.mzn";

int: N = 9;

array[1..N,1..N] of int: given = array2d(1..N, 1..N, [
  0, 3, 0, 0, 0, 0, 0, 0, 2,
  0, 0, 0, 1, 0, 0, 3, 0, 0,
  1, 9, 8, 0, 0, 2, 0, 0, 0,
  0, 0, 0, 7, 0, 1, 4, 0, 0,
  4, 0, 0, 8, 0, 0, 0, 9, 0,
  0, 0, 0, 0, 2, 4, 0, 5, 6,
  0, 6, 1, 5, 3, 7, 0, 0, 4,
  2, 0, 7, 0, 0, 9, 0, 3, 0,
  0, 0, 0, 0, 0, 6, 1, 0, 0
]);

array[1..N,1..N] of var 1..N: cell;

% --- ETAPE 1 : respecter les indices donnés (déjà écrit) -------------------
constraint forall(i,j in 1..N where given[i,j] > 0)(cell[i,j] = given[i,j]);

% --- ETAPE 2 : une valeur par ligne -----------------------------------------
% Syntaxe :  forall(i in 1..N)(alldifferent([cell[i,j] | j in 1..N]))
%
% A COMPLETER (1 ligne) :
constraint forall(i in 1..N)(alldifferent([cell[i,j] | j in 1..N]));


% --- ETAPE 3 : une valeur par colonne ---------------------------------------
%
% A COMPLETER (1 ligne) :
constraint forall(j in 1..N)(alldifferent([cell[i,j] | i in 1..N]));

% --- ETAPE 4 : une valeur par bloc 3x3 --------------------------------------
% Indice : bi,bj in 0..2 indexent les 9 blocs ; la case (bi*3+i, bj*3+j) pour
% i,j in 1..3 parcourt les 9 cases du bloc (bi,bj).
%
% A COMPLETER (1 ligne, peut être coupée sur 2 lignes) :
constraint forall(bi, bj in 0..2)(alldifferent([cell[bi*3+i,bj*3+j] | i, j in 1..3]));

% --- BONUS : contraintes redondantes avec la contrainte Somme = 45 sur chaque ligne, colonne et bloc  --------------
constraint forall(i in 1..N)(sum(j in 1..N)(cell[i,j]) = 45);
constraint forall(j in 1..N)(sum(i in 1..N)(cell[i,j]) = 45);
constraint forall(bi, bj in 0..2)(sum(i, j in 1..3)(cell[bi*3+i, bj*3+j]) = 45);

solve satisfy;

output [ if j = 1 then "\n" else " " endif ++ show(cell[i,j]) | i in 1..N, j in 1..N ];

%--- Question 1 : une solution trouvée avec la grille ci-dessous identique à sudoku.mod du cours :
%---5 3 4 6 7 8 9 1 2
%---6 7 2 1 9 5 3 4 8
%---1 9 8 3 4 2 5 6 7
%---8 5 9 7 6 1 4 2 3
%---4 2 6 8 5 3 7 9 1
%---7 1 3 9 2 4 8 5 6
%---9 6 1 5 3 7 2 8 4
%---2 8 7 4 1 9 6 3 5
%---3 4 5 2 8 6 1 7 9

%--- Question 2 : avec l'option -a (output solving statistics), on a qu'une solution pour cette grille, résolue en 388 msec.

%--- Question 3 : avec la contrainte Somme = 45 sur chaque ligne, colonne et bloc : pas de changement dans la solution évidement puis que le problème de change pas, on ne fait que rajouter des contraintes redondantes mais pas différentes. Le programme semble un peu plus rapide en moyenne (plutôt autour de 300 à 340 msec)