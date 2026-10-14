% ============================================================================
% Optimisation pour l'IA — Séance 2 — TD-TP PPC, Exercice 6
% Ordonnancement ExedBike en MiniZinc — même instance qu'au TP2 (Exercice 4,
% CP-SAT/OR-Tools) : 3 lots sur une même ligne, non-chevauchement, minimiser
% le makespan. En MiniZinc, la contrainte globale de non-chevauchement
% d'intervalles est "disjunctive".
% ============================================================================

include "disjunctive.mzn";

int: horizon = 15;
array[1..3] of string: noms = ["Urban", "Cargo", "Sport"];
array[1..3] of int: dur = [3, 5, 4];  % durées en heures

array[1..3] of var 0..horizon: s;  % dates de début
array[1..3] of var 0..horizon: e;  % dates de fin

% --- ETAPE 1 : lier début, durée et fin (déjà écrit) ------------------------
constraint forall(i in 1..3)(e[i] = s[i] + dur[i]);

% --- ETAPE 2 : non-chevauchement --------------------------------------------
% La ligne ne peut traiter qu'un lot à la fois : utilisez la contrainte
% globale "disjunctive(s, dur)" (elle prend directement les tableaux de
% débuts et de durées).
%
% A COMPLETER (1 ligne) :
constraint disjunctive(s, dur);


% --- ETAPE 3 : objectif = minimiser la date de fin du dernier lot ----------
var 0..horizon: makespan;
%
% A COMPLETER (2 lignes : contrainte liant makespan à max(e), puis solve minimize) :
constraint makespan = max(e);
solve minimize makespan;

output [ noms[i] ++ " : début=" ++ show(s[i]) ++ "h, fin=" ++ show(e[i]) ++ "h\n" | i in 1..3 ]
      ++ ["makespan = ", show(makespan), "h"];

%--- Question 2 : le makespan optimal est 12 h. Comme il n’y a qu’une seule ligne et aucun temps mort entre chaque lot (pas d'adapation de la ligne à un nouveau lot), on ne peut pas faire mieux que la somme de leur durée de production qui vaut 12h, quelque soit l'ordre. Il y a 6 solutions possibles mais le solveur n'en affiche qu'une.

%--- Question 3 : avec le solveur CP-SAT/OR :  un peu plus de code, avec création IntervalVar (début, durée, fin), avec contrainte fin = début + durée. Puis AddNoOverlap entre les intervalles, puis AddMaxEquality(makespan, fin), puis Minimize(makespan). En revanche il est plus adapté à ce type de problème, donc à priori plus rapide sur ces problèmes.