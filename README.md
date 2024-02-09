# Projet scolaire en MatLab simulant la partie logiciel d'une attaque CPA d'un chiffrement symétrique AES
## Chargement des données
```matlab
entrees = load('entrees.mat').Entrees1;
subBytes = load('subBytes.mat').SubBytes;
traces = load('traces1000x512.mat').traces;
Le code commence par charger les données d'entrée, la table SubBytes, et les traces de consommation d'énergie à partir de fichiers matériels.

Initialisation des variables
matlab
Copy code
num_traces = size(traces, 1);
num_samples_temporels = size(traces, 2);
num_cles = 256;
P = zeros(num_traces, num_cles);
Les variables importantes sont initialisées, notamment le nombre de traces, le nombre d'échantillons temporels, le nombre de clés possibles (256 pour une clé d'1 octet), et une matrice P pour l'estimation du poids de Hamming.

Boucle de Traitement des Clés et des Traces
matlab
Copy code
for k = 0:num_cles-1
    for i = 1:num_traces
        octet_entree = uint8(entrees(i));
        sortieRoundKey = bitxor(octet_entree, uint8(k));
        sortieSubBytes = subBytes(sortieRoundKey+1);
        P(i, k+1) = sum(dec2bin(sortieSubBytes, 8) == '1');
    end
end
Une double boucle est utilisée pour traiter chaque clé potentielle. Pour chaque clé, la fonction AddRoundKey est simulée en utilisant XOR, suivie de la fonction SubBytes. Le poids de Hamming de la sortie SubBytes est ensuite estimé et stocké dans la matrice P.

Calcul de la Corrélation
matlab
Copy code
matrice_correlation = zeros(num_cles, num_samples_temporels);
for k = 1:num_cles
    for t = 1:num_samples_temporels
        R = corrcoef(P(:, k), traces(:, t));
        matrice_correlation(k, t) = R(1, 2);
    end
end
La corrélation entre les poids de Hamming estimés (matrice P) et les traces de consommation d'énergie est calculée. La corrélation est stockée dans une matrice.

Identification de la Clé Probable
matlab
Copy code
[~, indice_max_cle] = max(max(matrice_correlation, [], 2));
cle_probable = indice_max_cle - 1;
La clé avec la corrélation maximale est identifiée, et la clé probable est stockée dans la variable cle_probable.

Tracé des Résultats
matlab
Copy code
plot(matrice_correlation(indice_max_cle, :));
title('Graphique de corrélation 2D');
xlabel('Échantillon temporel');
ylabel('Corrélation');
Un graphique 2D de la corrélation entre la clé probable et les échantillons temporels est tracé.

matlab
Copy code
surf(matrice_correlation);
title('Surface de corrélation 3D');
xlabel('Échantillon temporel');
ylabel('Clé');
zlabel('Corrélation');
Une surface 3D de la corrélation entre toutes les clés et échantillons temporels est tracée.
