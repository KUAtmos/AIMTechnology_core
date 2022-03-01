Loop(Y5$(ord(Y5)=ceil(ord(Year)/5)),
    Loop((%4)$(%5),
       If(mod(ord(YEAR),5)=1,
          %1(%2) = %3(%2,Y5);
       Elseif %3(%2,Y5)=inf or %3(%2,Y5+1)=inf,
          %1(%2) = inf;
          else
          %1(%2) = %3(%2,Y5)+(%3(%2,Y5+1)-%3(%2,Y5))/5*(mod(ord(YEAR)-1,5));
          );
       );
    );
