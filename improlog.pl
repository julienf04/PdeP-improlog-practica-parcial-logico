% integrante(grupo, persona, instrumento)
integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

% nivelQueTiene(persona, instrumento, nivel)
nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

% instrumento(instrumento, rol)
instrumento(violin, melodico(cuerdas)).
instrumento(guitarra, armonico).
instrumento(bateria, ritmico).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(pandereta, ritmico).
instrumento(voz, melodico(vocal)).

% 1)

rolEnGrupo(Grupo, Rol) :- integrante(Grupo, _, Instrumento), instrumento(Instrumento, Rol).

buenaBase(Grupo) :- rolEnGrupo(Grupo, ritmico), rolEnGrupo(Grupo, armonico).


% 2)

nivelEnUnGrupo(Grupo, Persona, Nivel) :-
    integrante(Grupo, Persona, Instrumento),
    nivelQueTiene(Persona, Instrumento, Nivel).

destaca(Grupo, Persona) :-
    nivelEnUnGrupo(Grupo, Persona, Nivel),
    forall(
        (nivelEnUnGrupo(Grupo, OtraPersona, OtroNivel), Persona \= OtraPersona),
        Nivel > OtroNivel + 2
    ).
    

% 3)

grupo(vientosDelEste, bigBand).
grupo(sophieTrio, formacion(contrabajo)).
grupo(sophieTrio, formacion(guitarra)).
grupo(sophieTrio, formacion(violin)).
grupo(jazzmin, formacion(bateria)).
grupo(jazzmin, formacion(bajo)).
grupo(jazzmin, formacion(trompeta)).
grupo(jazzmin, formacion(piano)).
grupo(jazzmin, formacion(guitarra)).


% 4)

instrumento(Instrumento) :- instrumento(Instrumento, _).
instrumentoEnGrupo(Grupo, Instrumento) :- integrante(Grupo, _, Instrumento).


cupo(Grupo, Instrumento) :- grupo(Grupo, bigBand), instrumento(Instrumento, melodico(viento)).
cupo(Grupo, Instrumento) :-
    grupo(Grupo, Tipo),
    instrumento(Instrumento),
    not(instrumentoEnGrupo(Grupo, Instrumento)),
    sirve(Tipo, Instrumento).

% 
sirve(formacion(Instrumento), Instrumento).
sirve(bigBand, Instrumento) :- instrumento(Instrumento, melodico(viento)).
sirve(bigBand, bateria).
sirve(bigBand, bajo).
sirve(bigBand, piano).


% 5)

grupo(Grupo) :- grupo(Grupo, _).
persona(Persona) :- nivelQueTiene(Persona, _, _).

minimoNivelEsperado(Grupo, 1) :- grupo(Grupo, bigBand).
minimoNivelEsperado(Grupo, Nivel) :-
    grupo(Grupo, formacion(_)),
    findall(Instrumento, grupo(Grupo, formacion(Instrumento)), Instrumentos),
    length(Instrumentos, RestoNivel),
    Nivel is 7 - RestoNivel.

nivelSuficiente(Persona, Instrumento, Grupo) :-
    nivelQueTiene(Persona, Instrumento, Nivel),
    minimoNivelEsperado(Grupo, NivelEsperado),
    Nivel >= NivelEsperado.

incorporacion(Persona, Instrumento, Grupo) :-
    grupo(Grupo),
    instrumento(Instrumento),
    persona(Persona),
    not(integrante(Grupo, Persona, _)),
    cupo(Grupo, Instrumento),
    nivelSuficiente(Persona, Instrumento, Grupo).


% 6)

seQuedoEnBanda(Persona) :- persona(Persona), not(integrante(_, Persona, _)), not(incorporacion(Persona, _, _)).


% 7)

cantidadPersonasConRol(Grupo, Rol, Cantidad) :-
    findall(Persona, (integrante(Grupo, Persona, Instrumento), instrumento(Instrumento, Rol)), Personas),
    length(Personas, Cantidad).
    
puedeTocar(Grupo) :-
    grupo(Grupo, bigBand),
    buenaBase(Grupo),
    cantidadPersonasConRol(Grupo, melodico(viento), Cantidad),
    Cantidad >= 5.

puedeTocar(Grupo) :-
    grupo(Grupo, formacion(_)),
    forall(grupo(Grupo, formacion(Instrumento)), integrante(Grupo, _, Instrumento)).
    

% 8)

grupo(estudio1, ensamble).

minimoNivelEsperado(estudio1, 3).

sirve(ensamble, _).

puedeTocar(Grupo) :-
    grupo(Grupo, ensamble),
    buenaBase(Grupo),
    integrante(Grupo, _, Instrumento),
    instrumento(Instrumento, melodico(_)).