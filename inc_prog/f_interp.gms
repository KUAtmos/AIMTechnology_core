Loop(Y5$(v_year(Y5)=floor((v_year('%calc_year%'))/5)*5),
    Loop((%4)$(%5),
       If(mod(v_year('%calc_year%'),5)=0,
          %1(%2) = %3(%2,Y5);
       Elseif %3(%2,Y5)=inf or %3(%2,Y5+1)=inf,
          %1(%2) = inf;
          else
          %1(%2) = %3(%2,Y5)+(%3(%2,Y5+1)-%3(%2,Y5))/5*(mod(v_year('%calc_year%'),5));
          );
       );
    );
