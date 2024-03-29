% Definicja zewnetrznego rozkladu, kazdy dolaczony rozklad musi konczyc sie
% nazwa Generator, posiadac pola name oraz arguments. Musi posiadac funkcję
% o nazwie generate zwracającą wygenerowaną macierz liczb pseudolosowych dla danego rozkładu.
% Funkcja musi przyjmować wskaznik this oraz 2 wektory: pierwszy zawierającymi dodatkowe
% parametry, drugi zawierający rozmiar X oraz Y macierzy do generacji.
% Pola w klasie:
% name - nazwa użytego rozkładu, wyświetlana w programie
% arguments - nazwy dodatkowych argumentów, wyświetlane w programie
% Funkcje:
% generate(obj,Params, Size) - funkcja zwraca macierz o rozmiarze Size(1) x Size(2),
% wykorzystując dodatkowe parametry z wektora Params


classdef externalGenerator
    properties
        name = 'Zewnętrzny - studenta'; % Nazwa rozkladu
        arguments = {'St. swobody'} % Nazwy dodatkowych parametrow
       %arguments ={} % gdy brak dodatkowych argumentow
       %arguments = {'arg1' , 'arg2'}; %dwa argumenty

    end
    methods
        function RandM = generate(obj, stopnie, rozmiar)
            RandM = random('T',stopnie, rozmiar(1), rozmiar(2));
        end
    end
end