inputs = load('inputs.mat').Inputs1; 
subBytes = load('subBytes.mat').SubBytes;
traces = load('traces1000x512.mat').traces; 

nb_traces = size(traces, 1);
nb_time = size(traces, 2);
nb_keys = 256; 
M_Hamming = zeros(num_traces, num_keys); 

for k = 0:nb_keys-1
    for i = 1:nb_traces
        octet_entree = uint8(inputs(i));  
        
        roundKeyOutput = bitxor(octet_entree, uint8(k));
        
        subByteOutput = subBytes(roundKeyOutput+1); 
        
        M_Hamming(i, k+1) = sum(dec2bin(subByteOutput, 8) == '1'); 
    end
end


corre = zeros(nb_keys, nb_time);
for k = 1:nb_keys
    for t = 1:nb_time
        M_output = corrcoef(M_Hamming(:, k), traces(:, t));
        corre(k, t) = M_output(1, 2);  
    end
end

[~, max_index] = max(max(corre, [], 2));

plot(corre(max_index, :));
title('Représentation 2D');
xlabel('Echelle de temps');
ylabel('Corrélation');

surf(corre);
title('Représentation 3D');
xlabel('Echelle de temps');
ylabel('Clé');
zlabel('Corrélation');

res = max_index - 1;