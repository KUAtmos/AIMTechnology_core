loop((%2,%5)$((ord(%5) gt 1) and %8),
    if(%1(%3,%5) eq interp,
        s_break=0;
        loop(%6$(ord(%6) gt ord(%5)),
            if(%1(%3,%6) ne interp,
                loop(%7$((ord(%7) ge ord(%5)) and (ord(%7) lt ord(%6))),
                    %1(%3,%7)   =(%1(%3,%6)-%1(%3,%5-1))/(%4(%6)-%4(%5-1))*(%4(%7)-%4(%5-1))+%1(%3,%5-1);
                    s_break =1;
                );
            );
            break$s_break
            if(ord(%6) eq card(%6),
                %1(%3,%7)$(ord(%7) ge ord(%5)) =%1(%3,%5-1);
            );
        );
    );
)
;