% Base de faits : Destinations et caracteristiques
lieu(dakar, [plage, culture, gastronomie], budget_moyen, climat_tropical, acces_facile, 5, 45000).
lieu(ile_de_goree, [histoire, culture, patrimoine], budget_eleve, climat_tropical, acces_bateau, 4, 53000).
lieu(niokolo_koba, [nature, safari, aventure], budget_moyen, climat_saharien, acces_difficile, 4, 36500).
lieu(saly, [plage, detente, luxe], budget_eleve, climat_tropical, acces_facile, 5, 48000).
lieu(saint_louis, [histoire, culture, musique], budget_moyen, climat_tempere, acces_facile, 5, 44000).
lieu(cap_skirring, [plage, detente, gastronomie], budget_eleve, climat_tropical, acces_difficile, 4, 42000).
lieu(ziguinchor, [nature, culture, gastronomie], budget_moyen, climat_tropical, acces_facile, 4, 3600).
lieu(touba, [histoire, culture, religion], budget_moyen, climat_saharien, acces_facile, 3, 30000).
lieu(lompoul, [aventure, nature, detente], budget_moyen, climat_saharien, acces_difficile, 4, 33000).
lieu(kedougou, [safari, aventure, nature], budget_eleve, climat_saharien, acces_difficile, 5, 52000).
lieu(popenguine, [plage, nature, detente], budget_moyen, climat_tropical, acces_facile, 4, 35000).
lieu(joal_fadiouth, [culture, histoire, nature], budget_moyen, climat_tempere, acces_facile, 5, 40000).

% Restaurants a proximite
restaurant(dakar, ["Chez Loutcha", "Le Ngor"]).
restaurant(ile_de_goree, ["Chez Fanny"]).
restaurant(niokolo_koba, ["Campement Safari"]).
restaurant(saly, ["La Riviera"]).
restaurant(saint_louis, ["Flamingo"]).
restaurant(cap_skirring, ["Le Petit Ziguinchor", "La Paillote"]).
restaurant(ziguinchor, ["Le Perroquet", "Kadiandoumagne"]).
restaurant(touba, ["Daraay Khaar", "Touba Darou Salam"]).
restaurant(lompoul, ["Auberge des Dunes"]).
restaurant(kedougou, ["Le Bedik", "Relais de Kedougou"]).
restaurant(popenguine, ["La Cabane du Pecheur"]).
restaurant(joal_fadiouth, ["Chez Keur Fatou", "L'ile aux Coquillages"]).

% Itineraire recommande
itineraire(dakar, "Visite de l'ile de Goree -> Plage de Yoff -> Diner a Chez Loutcha").
itineraire(ile_de_goree, "Musee de la Maison des Esclaves -> Plage -> Dejeuner a Chez Fanny").
itineraire(niokolo_koba, "Safari matin -> Randonnee -> Repas au Campement Safari").
itineraire(saly, "Plage privee -> Detente spa -> Diner a La Riviera").
itineraire(saint_louis, "Visite de l'ile Saint-Louis -> Concert jazz -> Diner au Flamingo").
itineraire(cap_skirring, "Plage paradisiaque -> Degustation fruits de mer -> Diner a La Paillote").
itineraire(ziguinchor, "Balade en pirogue -> Marche artisanal -> Diner a Le Perroquet").
itineraire(touba, "Visite de la Grande Mosquee -> Decouverte de la ville -> Diner a Daraay Khaar").
itineraire(lompoul, "Excursion dans le desert -> Coucher de soleil sur les dunes -> Diner a l'Auberge des Dunes").
itineraire(kedougou, "Randonnee aux cascades de Dindefelo -> Rencontre avec les Bediks -> Diner au Relais de Kedougou").
itineraire(popenguine, "Visite de la reserve naturelle -> Plage -> Diner a La Cabane du Pecheur").
itineraire(joal_fadiouth, "Balade sur l'ile aux Coquillages -> Visite du cimetiere mixte -> Diner a Chez Keur Fatou").

% Regles pour recommander une destination en fonction de deux activites, du budget et du climat
recommander_par_criteres(Activite1, Activite2, Budget, Climat, Destination) :-
    lieu(Destination, Activites, Budget, Climat, _, _, _),
    member(Activite1, Activites),
    member(Activite2, Activites).

% Regles pour afficher les details d'une destination
afficher_details(Destination) :-
    lieu(Destination, _, Budget, Climat, Accessibilite, Note, Prix), nl,
    write('Destination: '), write(Destination), nl,
    write('Budget: '), write(Budget), nl,
    write('Climat: '), write(Climat), nl,
    write('Accessibilite: '), write(Accessibilite), nl,
    write('Note: '), write(Note), nl,
    write('Prix moyen par jour: '), write(Prix), nl.

% Regles pour afficher les restaurants d'une destination
afficher_restaurants(Destination) :-
    restaurant(Destination, Restaurants),
    write('Restaurants a proximite: '), nl,
    afficher_liste(Restaurants).

afficher_liste([]).
afficher_liste([H|T]) :-
    write('- '), write(H), nl,
    afficher_liste(T).

% Regles pour afficher l'itineraire recommande
afficher_itineraire(Destination) :-
    itineraire(Destination, Itineraire),
    write('Itineraire recommande: '), nl,
    write(Itineraire), nl.

% Regles pour executer tout le systeme en une seule commande
test :-
    write('Entrez vos deux activit�s pr�f�r�es (sous forme de liste, par exemple [plage, culture]): '), nl,
    read(Activites),
    write('Entrez votre budget (budget_moyen ou budget_eleve): '), nl,
    read(Budget),
    write('Entrez le climat d�sir� (climat_tropical, climat_saharien ou climat_tempere): '), nl,
    read(Climat),
    (   is_list(Activites), length(Activites, 2) ->
        [Activite1, Activite2] = Activites,
        findall(Destination, recommander_par_criteres(Activite1, Activite2, Budget, Climat, Destination), Destinations),
        (   Destinations = [] ->
            write('D�sol�, aucune destination ne correspond � ces crit�res.'), nl
        ;   afficher_toutes_destinations(Destinations)
        )
    ;   write('Erreur: Veuillez entrer exactement deux activites sous forme de liste.'), nl, fail
    ).

% Regle pour afficher toutes les destinations correspondantes
afficher_toutes_destinations([]).
afficher_toutes_destinations([Destination|Rest]) :-
    afficher_details(Destination),
    afficher_restaurants(Destination),
    afficher_itineraire(Destination),
    nl,
    afficher_toutes_destinations(Rest).
