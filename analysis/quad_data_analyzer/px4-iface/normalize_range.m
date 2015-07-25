 function normalized = normalize_range(array, minv, maxv)
     % replace this local var with params for more flexibility 
     x = minv;
     y = maxv;
     % Normalize to [0, 1]:
     m = min(array);
     range = max(array) - m;
     array = (array - m) ./ range; 
     % Then scale to [x,y]:
     range2 = y - x;
     normalized = (array.*range2) + x;
 end