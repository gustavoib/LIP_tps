declare
[Circuitos]={Module.link['C:/Users/joaog/OneDrive/Documentos/LIP/t3_LIP/Circuitos.ozf']} 

declare A B 
A = 1|1|_
B = 0|1|_
S in
{Circuitos.circuito1 A B S}
{Browse 'saida circuito 1'}
{Browse S}

declare C D E
C = 0|1|_
D = 1|1|_
E = 0|0|_
S1 in
{Circuitos.circuito2 C D E S1}
{Browse 'saida circuito 2'}
{Browse S1}


declare F G H I
F = 1|1|_
G = 0|0|_
H = 0|0|_
I = 1|0|_
S2 in
{Circuitos.circuito3 F G H I S2}
{Browse 'saida circuito 3'}
{Browse S2}
