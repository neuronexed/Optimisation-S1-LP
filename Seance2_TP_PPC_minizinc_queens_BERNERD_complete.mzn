% ============================================================================
% Optimisation pour l'IA — Séance 2 — TD-TP PPC, Exercice 4
% Les n reines en MiniZinc — Modèle 1 (compact) vu en cours (Modélisation PPC) :
% une variable par colonne, son domaine = la ligne occupée.
% ============================================================================

int: n = 8;  % passez à 8 pour la Question 3 (le problème classique des 8 reines)

array[1..n] of var 1..n: q;  % q[i] = ligne de la reine de la colonne i

% --- ETAPE 1 : pas deux reines sur la même ligne ----------------------------
% (déjà écrit — rien à modifier ici)
include "alldifferent.mzn";


% --- ETAPE 2 : pas deux reines sur la même diagonale montante --------------
% Deux reines i != j s'attaquent sur une diagonale montante ssi q[i]+i = q[j]+j.
% Il faut donc que les valeurs (q[i]+i) soient toutes différentes.
% Syntaxe MiniZinc :  alldifferent([ expression | i in 1..n ])
%
constraint alldifferent([ q[i] + i | i in 1..n ]);   % pas deux reines sur la diagonale montante


% --- ETAPE 3 : pas deux reines sur la même diagonale descendante -----------
% Même idée avec (q[i]-i).
%
constraint alldifferent([ q[i] - i | i in 1..n ]);   % pas deux reines sur la diagonale descendante


% --- ETAPE 4 : contrainte "pas sur la même ligne" (déjà donnée ci-dessus) --
constraint alldifferent(q);

solve satisfy;

output ["q = ", show(q)];

% --- Question n°1 : avec n= 4, on trouve une solution q = [3, 1, 4, 2]
% --- Question n°2 : avec n= 4, et l'option -a (toutes les solutions), on trouve deux solutions. La 2nd solution est le symétrique de la première, ce qui est normal pour un jeu type damier. q = [3, 1, 4, 2] et q = [2, 4, 1, 3]
% -- Question n°3 : avec n= 8, et l'option -a (toutes les solutions), le solveur Gecode 6.4.0 trouve 92 solutions différentes
