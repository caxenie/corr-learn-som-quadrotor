function y = fix_sign_atan(in)
singularities = find(in==0);
for idx =1:length(singularities)
   if(singularities(idx)==1) 
       in(singularities(idx)) = in(singularities(idx)+1);
   else
       in(singularities(idx)) = in(singularities(idx)-1); 
   end
end
y = in;
end