* this program is loaded for CGE integration mode only.

Set
    CGEIntSE            'CGEInt sector'
    CGEscen             'CGEscenario'
;
Parameter
    CGEservchanger(CGEscen,R,CGEIntSE,Y5)   'service demand change rate'
    CGEservchange(CGEscen,R,CGEIntSE,Y5)    'service demand change'
    CGEgdpchange(CGEscen,R,Y5)              'GDP change rate'
    CGEservchanger_t(R,CGEIntSE,H)          'service demand change rate, interpolated'
    CGEservchange_t(R,CGEIntSE,H)           'service demand change, interpolated'
    CGEgdpchange_t(R,H)                     'GDP change rate, interpolated'
;
$gdxin '%prog_dir%/data/CGEInt/CGE2Enduse.gdx'
$load CGEscen,CGEIntSE=SE,CGEservchange=servchange,CGEservchanger=servchangerate,CGEgdpchange=gdpchangerate
$gdxin

Set
    MIntSE(CGEIntSE,J)  'sector-service mapping' /
        STL.IS_DRV
        CEM.IYC_DRV
        OIN.(OI_BOL,OI_HET,OI_MAC,OI_ELE,OI_OTH)
        RWM.RWM
        RCL.RCL
        RHW.RHW
        ROT.(RLT,ROT)
        SWM.SWM
        SCL.SCL
        SOT.(SLT,SOT)
        PSS.(TPPG,TPPD,TPBS,TPRL,TPAD,TIAI)
        FRG.(TFTS,TFTL,TFRL,TFND,TINI)
        /
;
* fill year
CGEservchanger(CGEscen,R,CGEIntSE,Y5)$(not CGEservchanger(CGEscen,R,CGEIntSE,Y5))   =eps;
CGEservchange(CGEscen,R,CGEIntSE,Y5)$(not CGEservchanger(CGEscen,R,CGEIntSE,Y5))    =eps;
CGEgdpchange(CGEscen,R,Y5)$(not CGEgdpchange(CGEscen,R,Y5))                         =eps;
CGEservchanger_t(R,CGEIntSE,YEAR)$(v_year(YEAR) ge 2005)=interp;
CGEservchange_t(R,CGEIntSE,YEAR)$(v_year(YEAR) ge 2005) =interp;
CGEgdpchange_t(R,YEAR)$(v_year(YEAR) ge 2005)           =interp;
CGEservchanger_t(R,CGEIntSE,Y5)$(v_year(Y5) ge 2005)    =CGEservchanger('%CGEIntScen%',R,CGEIntSE,Y5);
CGEservchange_t(R,CGEIntSE,Y5)$(v_year(Y5) ge 2005)     =CGEservchange('%CGEIntScen%',R,CGEIntSE,Y5)*sum(MQ$sameas(R,MQ),ind_t(MQ,'POP',Y5))/1000;
CGEservchange_t(R,'CEM',Y5)$(v_year(Y5) ge 2005)        =CGEservchange('%CGEIntScen%',R,'CEM',Y5)*sum(MQ$sameas(R,MQ),ind_t(MQ,'POP',Y5))/10**6; // cement production are estimated with log-linear function to GDP.
CGEgdpchange_t(R,Y5)$(v_year(Y5) ge 2005)               =CGEgdpchange('%CGEIntScen%',R,Y5);
$batinclude %fill_parameter% CGEservchanger_t R,CGEIntSE "R,CGEIntSE" v_year YEAR YEAR1 YEAR2 1
$batinclude %fill_parameter% CGEservchange_t R,CGEIntSE "R,CGEIntSE" v_year YEAR YEAR1 YEAR2 1
$batinclude %fill_parameter% CGEgdpchange_t R "R" v_year YEAR YEAR1 YEAR2 1

* service demand adjustment
serv_t(R,I,J,H)$(FL_IJ(R,I,J) and serv_t(R,I,J,H) and v_year(H) ge 2005)=serv_t(R,I,J,H)*(1+sum(MIntSE(CGEIntSE,J),CGEservchanger_t(R,CGEIntSE,H)))+sum(MIntSE(CGEIntSE,J),CGEservchange_t(R,CGEIntSE,H));
serv_t(R,I,J,H)$(FL_IJ(R,I,J) and serv_t(R,I,J,H) and v_year(H) ge 2005)=max(0,serv_t(R,I,J,H));

* GDP adujustment for reporting
ind_t(MQ,'GDP_MER',H)$(v_year(H) ge 2005 and ind_t(MQ,'GDP_MER',H))=ind_t(MQ,'GDP_MER',H)*(1+sum(R$sameas(R,MQ),CGEgdpchange_t(R,H)));
ind_t(MQ,'GDP_PPP',H)$(v_year(H) ge 2005 and ind_t(MQ,'GDP_MER',H))=ind_t(MQ,'GDP_PPP',H)*(1+sum(R$sameas(R,MQ),CGEgdpchange_t(R,H)));
