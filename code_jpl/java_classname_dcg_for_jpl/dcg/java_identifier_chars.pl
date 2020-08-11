:- module(java_classname_dcg, 
          [ java_identifier_start_char/1, java_identifier_part_char/1 ]).
          

% ===
% Classify codepoints (i.e. integers) as "Java identifier start/part characters"
% ===

% ===
% A "Java identifier" starts with a "Java identifier start character" and
% continues with a "Java identifier part character".
%
% A "Java identifier start character" is a character for which
% Character.isJavaIdentifierStart(c) returns true, where "c" can be a
% Java char or an integer Unicode code value (basically, that's the definition).
%
% Similarly, a "Java identifier part character" is a character for which
% point Character.isJavaIdentifierPart(c) returns true
%
% See:
%
% https://docs.oracle.com/en/java/javase/14/docs/api/java.base/java/lang/Character.html#isJavaIdentifierStart(int)
% https://docs.oracle.com/en/java/javase/14/docs/api/java.base/java/lang/Character.html#isJavaIdentifierPart(int)
%
% A simple Java program was used to generate the runs of unicode character
% points listed below. They are searched lineraly. Generally, a
% code point/value encountered by jpl would be below even 255 and so be
% found quickly
%
% PROBLEM:
% 
% 1) If the Prolog implementation does not represent characters internally
%    with Unicode code values, i.e. if atom_codes/2 takes/returns other values 
%    than Unicode code values (may be the case for Prologs other than SWI Prolog)
%    an implementation-dependent mapping from/to Unicode will have to be performed 
%    first!
%
% 2) Is this slow or not? It depends on what the compiler does.
% ===

java_identifier_start_char(C) :-
   java_identifier_start_char_ranges(Ranges), % retrieve ranges
   char_inside_range(C,Ranges).               % check

java_identifier_part_char(C) :-
   java_identifier_part_char_ranges(Ranges),  % retrieve ranges
   char_inside_range(C,Ranges).               % check

char_inside_range(C,[[_Low,High]|Ranges]) :-
   High < C,!,char_inside_range(C,Ranges).

char_inside_range(C,[[Low,High]|_]) :-
   Low =< C, C =< High.

% ---
% The ranges below are generated with a Java program, then printed
% See "CharRangePrinter.java"
% ---

java_identifier_start_char_ranges(
   [[36,36],[65,90],[95,95],[97,122],[162,165],[170,170],[181,181],[186,186],
   [192,214],[216,246],[248,705],[710,721],[736,740],[748,748],[750,750],
   [880,884],[886,887],[890,893],[895,895],[902,902],[904,906],[908,908],
   [910,929],[931,1013],[1015,1153],[1162,1327],[1329,1366],[1369,1369],
   [1376,1416],[1423,1423],[1488,1514],[1519,1522],[1547,1547],[1568,1610],
   [1646,1647],[1649,1747],[1749,1749],[1765,1766],[1774,1775],[1786,1788],
   [1791,1791],[1808,1808],[1810,1839],[1869,1957],[1969,1969],[1994,2026],
   [2036,2037],[2042,2042],[2046,2069],[2074,2074],[2084,2084],[2088,2088],
   [2112,2136],[2144,2154],[2208,2228],[2230,2237],[2308,2361],[2365,2365],
   [2384,2384],[2392,2401],[2417,2432],[2437,2444],[2447,2448],[2451,2472],
   [2474,2480],[2482,2482],[2486,2489],[2493,2493],[2510,2510],[2524,2525],
   [2527,2529],[2544,2547],[2555,2556],[2565,2570],[2575,2576],[2579,2600],
   [2602,2608],[2610,2611],[2613,2614],[2616,2617],[2649,2652],[2654,2654],
   [2674,2676],[2693,2701],[2703,2705],[2707,2728],[2730,2736],[2738,2739],
   [2741,2745],[2749,2749],[2768,2768],[2784,2785],[2801,2801],[2809,2809],
   [2821,2828],[2831,2832],[2835,2856],[2858,2864],[2866,2867],[2869,2873],
   [2877,2877],[2908,2909],[2911,2913],[2929,2929],[2947,2947],[2949,2954],
   [2958,2960],[2962,2965],[2969,2970],[2972,2972],[2974,2975],[2979,2980],
   [2984,2986],[2990,3001],[3024,3024],[3065,3065],[3077,3084],[3086,3088],
   [3090,3112],[3114,3129],[3133,3133],[3160,3162],[3168,3169],[3200,3200],
   [3205,3212],[3214,3216],[3218,3240],[3242,3251],[3253,3257],[3261,3261],
   [3294,3294],[3296,3297],[3313,3314],[3333,3340],[3342,3344],[3346,3386],
   [3389,3389],[3406,3406],[3412,3414],[3423,3425],[3450,3455],[3461,3478],
   [3482,3505],[3507,3515],[3517,3517],[3520,3526],[3585,3632],[3634,3635],
   [3647,3654],[3713,3714],[3716,3716],[3718,3722],[3724,3747],[3749,3749],
   [3751,3760],[3762,3763],[3773,3773],[3776,3780],[3782,3782],[3804,3807],
   [3840,3840],[3904,3911],[3913,3948],[3976,3980],[4096,4138],[4159,4159],
   [4176,4181],[4186,4189],[4193,4193],[4197,4198],[4206,4208],[4213,4225],
   [4238,4238],[4256,4293],[4295,4295],[4301,4301],[4304,4346],[4348,4680],
   [4682,4685],[4688,4694],[4696,4696],[4698,4701],[4704,4744],[4746,4749],
   [4752,4784],[4786,4789],[4792,4798],[4800,4800],[4802,4805],[4808,4822],
   [4824,4880],[4882,4885],[4888,4954],[4992,5007],[5024,5109],[5112,5117],
   [5121,5740],[5743,5759],[5761,5786],[5792,5866],[5870,5880],[5888,5900],
   [5902,5905],[5920,5937],[5952,5969],[5984,5996],[5998,6000],[6016,6067],
   [6103,6103],[6107,6108],[6176,6264],[6272,6276],[6279,6312],[6314,6314],
   [6320,6389],[6400,6430],[6480,6509],[6512,6516],[6528,6571],[6576,6601],
   [6656,6678],[6688,6740],[6823,6823],[6917,6963],[6981,6987],[7043,7072],
   [7086,7087],[7098,7141],[7168,7203],[7245,7247],[7258,7293],[7296,7304],
   [7312,7354],[7357,7359],[7401,7404],[7406,7411],[7413,7414],[7418,7418],
   [7424,7615],[7680,7957],[7960,7965],[7968,8005],[8008,8013],[8016,8023],
   [8025,8025],[8027,8027],[8029,8029],[8031,8061],[8064,8116],[8118,8124],
   [8126,8126],[8130,8132],[8134,8140],[8144,8147],[8150,8155],[8160,8172],
   [8178,8180],[8182,8188],[8255,8256],[8276,8276],[8305,8305],[8319,8319],
   [8336,8348],[8352,8383],[8450,8450],[8455,8455],[8458,8467],[8469,8469],
   [8473,8477],[8484,8484],[8486,8486],[8488,8488],[8490,8493],[8495,8505],
   [8508,8511],[8517,8521],[8526,8526],[8544,8584],[11264,11310],[11312,11358],
   [11360,11492],[11499,11502],[11506,11507],[11520,11557],[11559,11559],
   [11565,11565],[11568,11623],[11631,11631],[11648,11670],[11680,11686],
   [11688,11694],[11696,11702],[11704,11710],[11712,11718],[11720,11726],
   [11728,11734],[11736,11742],[11823,11823],[12293,12295],[12321,12329],
   [12337,12341],[12344,12348],[12353,12438],[12445,12447],[12449,12538],
   [12540,12543],[12549,12591],[12593,12686],[12704,12730],[12784,12799],
   [13312,19893],[19968,40943],[40960,42124],[42192,42237],[42240,42508],
   [42512,42527],[42538,42539],[42560,42606],[42623,42653],[42656,42735],
   [42775,42783],[42786,42888],[42891,42943],[42946,42950],[42999,43009],
   [43011,43013],[43015,43018],[43020,43042],[43064,43064],[43072,43123],
   [43138,43187],[43250,43255],[43259,43259],[43261,43262],[43274,43301],
   [43312,43334],[43360,43388],[43396,43442],[43471,43471],[43488,43492],
   [43494,43503],[43514,43518],[43520,43560],[43584,43586],[43588,43595],
   [43616,43638],[43642,43642],[43646,43695],[43697,43697],[43701,43702],
   [43705,43709],[43712,43712],[43714,43714],[43739,43741],[43744,43754],
   [43762,43764],[43777,43782],[43785,43790],[43793,43798],[43808,43814],
   [43816,43822],[43824,43866],[43868,43879],[43888,44002],[44032,55203],
   [55216,55238],[55243,55291],[63744,64109],[64112,64217],[64256,64262],
   [64275,64279],[64285,64285],[64287,64296],[64298,64310],[64312,64316],
   [64318,64318],[64320,64321],[64323,64324],[64326,64433],[64467,64829],
   [64848,64911],[64914,64967],[65008,65020],[65075,65076],[65101,65103],
   [65129,65129],[65136,65140],[65142,65276],[65284,65284],[65313,65338],
   [65343,65343],[65345,65370],[65382,65470],[65474,65479],[65482,65487],
   [65490,65495],[65498,65500],[65504,65505],[65509,65510]]).

java_identifier_part_char_ranges(
   [[0,8],[14,27],[36,36],[48,57],[65,90],[95,95],[97,122],[127,159],[162,165],
   [170,170],[173,173],[181,181],[186,186],[192,214],[216,246],[248,705],
   [710,721],[736,740],[748,748],[750,750],[768,884],[886,887],[890,893],
   [895,895],[902,902],[904,906],[908,908],[910,929],[931,1013],[1015,1153],
   [1155,1159],[1162,1327],[1329,1366],[1369,1369],[1376,1416],[1423,1423],
   [1425,1469],[1471,1471],[1473,1474],[1476,1477],[1479,1479],[1488,1514],
   [1519,1522],[1536,1541],[1547,1547],[1552,1562],[1564,1564],[1568,1641],
   [1646,1747],[1749,1757],[1759,1768],[1770,1788],[1791,1791],[1807,1866],
   [1869,1969],[1984,2037],[2042,2042],[2045,2093],[2112,2139],[2144,2154],
   [2208,2228],[2230,2237],[2259,2403],[2406,2415],[2417,2435],[2437,2444],
   [2447,2448],[2451,2472],[2474,2480],[2482,2482],[2486,2489],[2492,2500],
   [2503,2504],[2507,2510],[2519,2519],[2524,2525],[2527,2531],[2534,2547],
   [2555,2556],[2558,2558],[2561,2563],[2565,2570],[2575,2576],[2579,2600],
   [2602,2608],[2610,2611],[2613,2614],[2616,2617],[2620,2620],[2622,2626],
   [2631,2632],[2635,2637],[2641,2641],[2649,2652],[2654,2654],[2662,2677],
   [2689,2691],[2693,2701],[2703,2705],[2707,2728],[2730,2736],[2738,2739],
   [2741,2745],[2748,2757],[2759,2761],[2763,2765],[2768,2768],[2784,2787],
   [2790,2799],[2801,2801],[2809,2815],[2817,2819],[2821,2828],[2831,2832],
   [2835,2856],[2858,2864],[2866,2867],[2869,2873],[2876,2884],[2887,2888],
   [2891,2893],[2902,2903],[2908,2909],[2911,2915],[2918,2927],[2929,2929],
   [2946,2947],[2949,2954],[2958,2960],[2962,2965],[2969,2970],[2972,2972],
   [2974,2975],[2979,2980],[2984,2986],[2990,3001],[3006,3010],[3014,3016],
   [3018,3021],[3024,3024],[3031,3031],[3046,3055],[3065,3065],[3072,3084],
   [3086,3088],[3090,3112],[3114,3129],[3133,3140],[3142,3144],[3146,3149],
   [3157,3158],[3160,3162],[3168,3171],[3174,3183],[3200,3203],[3205,3212],
   [3214,3216],[3218,3240],[3242,3251],[3253,3257],[3260,3268],[3270,3272],
   [3274,3277],[3285,3286],[3294,3294],[3296,3299],[3302,3311],[3313,3314],
   [3328,3331],[3333,3340],[3342,3344],[3346,3396],[3398,3400],[3402,3406],
   [3412,3415],[3423,3427],[3430,3439],[3450,3455],[3458,3459],[3461,3478],
   [3482,3505],[3507,3515],[3517,3517],[3520,3526],[3530,3530],[3535,3540],
   [3542,3542],[3544,3551],[3558,3567],[3570,3571],[3585,3642],[3647,3662],
   [3664,3673],[3713,3714],[3716,3716],[3718,3722],[3724,3747],[3749,3749],
   [3751,3773],[3776,3780],[3782,3782],[3784,3789],[3792,3801],[3804,3807],
   [3840,3840],[3864,3865],[3872,3881],[3893,3893],[3895,3895],[3897,3897],
   [3902,3911],[3913,3948],[3953,3972],[3974,3991],[3993,4028],[4038,4038],
   [4096,4169],[4176,4253],[4256,4293],[4295,4295],[4301,4301],[4304,4346],
   [4348,4680],[4682,4685],[4688,4694],[4696,4696],[4698,4701],[4704,4744],
   [4746,4749],[4752,4784],[4786,4789],[4792,4798],[4800,4800],[4802,4805],
   [4808,4822],[4824,4880],[4882,4885],[4888,4954],[4957,4959],[4992,5007],
   [5024,5109],[5112,5117],[5121,5740],[5743,5759],[5761,5786],[5792,5866],
   [5870,5880],[5888,5900],[5902,5908],[5920,5940],[5952,5971],[5984,5996],
   [5998,6000],[6002,6003],[6016,6099],[6103,6103],[6107,6109],[6112,6121],
   [6155,6158],[6160,6169],[6176,6264],[6272,6314],[6320,6389],[6400,6430],
   [6432,6443],[6448,6459],[6470,6509],[6512,6516],[6528,6571],[6576,6601],
   [6608,6617],[6656,6683],[6688,6750],[6752,6780],[6783,6793],[6800,6809],
   [6823,6823],[6832,6845],[6912,6987],[6992,7001],[7019,7027],[7040,7155],
   [7168,7223],[7232,7241],[7245,7293],[7296,7304],[7312,7354],[7357,7359],
   [7376,7378],[7380,7418],[7424,7673],[7675,7957],[7960,7965],[7968,8005],
   [8008,8013],[8016,8023],[8025,8025],[8027,8027],[8029,8029],[8031,8061],
   [8064,8116],[8118,8124],[8126,8126],[8130,8132],[8134,8140],[8144,8147],
   [8150,8155],[8160,8172],[8178,8180],[8182,8188],[8203,8207],[8234,8238],
   [8255,8256],[8276,8276],[8288,8292],[8294,8303],[8305,8305],[8319,8319],
   [8336,8348],[8352,8383],[8400,8412],[8417,8417],[8421,8432],[8450,8450],
   [8455,8455],[8458,8467],[8469,8469],[8473,8477],[8484,8484],[8486,8486],
   [8488,8488],[8490,8493],[8495,8505],[8508,8511],[8517,8521],[8526,8526],
   [8544,8584],[11264,11310],[11312,11358],[11360,11492],[11499,11507],
   [11520,11557],[11559,11559],[11565,11565],[11568,11623],[11631,11631],
   [11647,11670],[11680,11686],[11688,11694],[11696,11702],[11704,11710],
   [11712,11718],[11720,11726],[11728,11734],[11736,11742],[11744,11775],
   [11823,11823],[12293,12295],[12321,12335],[12337,12341],[12344,12348],
   [12353,12438],[12441,12442],[12445,12447],[12449,12538],[12540,12543],
   [12549,12591],[12593,12686],[12704,12730],[12784,12799],[13312,19893],
   [19968,40943],[40960,42124],[42192,42237],[42240,42508],[42512,42539],
   [42560,42607],[42612,42621],[42623,42737],[42775,42783],[42786,42888],
   [42891,42943],[42946,42950],[42999,43047],[43064,43064],[43072,43123],
   [43136,43205],[43216,43225],[43232,43255],[43259,43259],[43261,43309],
   [43312,43347],[43360,43388],[43392,43456],[43471,43481],[43488,43518],
   [43520,43574],[43584,43597],[43600,43609],[43616,43638],[43642,43714],
   [43739,43741],[43744,43759],[43762,43766],[43777,43782],[43785,43790],
   [43793,43798],[43808,43814],[43816,43822],[43824,43866],[43868,43879],
   [43888,44010],[44012,44013],[44016,44025],[44032,55203],[55216,55238],
   [55243,55291],[63744,64109],[64112,64217],[64256,64262],[64275,64279],
   [64285,64296],[64298,64310],[64312,64316],[64318,64318],[64320,64321],
   [64323,64324],[64326,64433],[64467,64829],[64848,64911],[64914,64967],
   [65008,65020],[65024,65039],[65056,65071],[65075,65076],[65101,65103],
   [65129,65129],[65136,65140],[65142,65276],[65279,65279],[65284,65284],
   [65296,65305],[65313,65338],[65343,65343],[65345,65370],[65382,65470],
   [65474,65479],[65482,65487],[65490,65495],[65498,65500],[65504,65505],
   [65509,65510],[65529,65531]]).

