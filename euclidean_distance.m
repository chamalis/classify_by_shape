function d = euclidean_distance(vectorA, vectorB)

d = sqrt( sum( ((vectorA - vectorB).^2) )  );
