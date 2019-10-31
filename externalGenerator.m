% Definicja zewnetrznego rozkladu, kazdy dolaczony rozklad musi konczyc sie
% nazwa Generator, posiadac pola name oraz arguments. Musi posiadac funkcjê
% o nazwie generate zwracaj¹c¹ wygenerowan¹ macierz liczb pseudolosowych dla danego rozk³adu.
% Funkcja musi przyjmowaæ wskaznik this oraz 2 wektory: pierwszy zawieraj¹cymi dodatkowe
% parametry, drugi zawieraj¹cy rozmiar X oraz Y macierzy do generacji.
% Pola w klasie:
% name - nazwa u¿ytego rozk³adu, wyœwietlana w programie
% arguments - nazwy dodatkowych argumentów, wyœwietlane w programie
% Funkcje:
% generate(obj,Params, Size) - funkcja zwraca macierz o rozmiarze Size(1) x Size(2),
% wykorzystuj¹c dodatkowe parametry z wektora Params


classdef externalGenerator
    properties
        name = 'Zewnêtrzny - studenta'; % Nazwa rozkladu
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