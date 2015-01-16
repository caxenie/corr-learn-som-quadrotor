 function normalized = normalize_var(array)
     % replace this local var with params for more flexibility 
     x = -1.0;
     y = 1.0;
     % Normalize to [0, 1]:
     m = min(array);
     range = max(array) - m;
     array = (array - m) ./ range; 
     % Then scale to [x,y]:
     range2 = y - x;
     normalized = (array.*range2) + x;
 end