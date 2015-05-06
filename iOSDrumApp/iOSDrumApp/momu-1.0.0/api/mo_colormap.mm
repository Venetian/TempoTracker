/*----------------------------------------------------------------------------
  MoMu: A Mobile Music Toolkit
  Copyright (c) 2010 Nicholas J. Bryan, Jorge Herrera, Jieun Oh, and Ge Wang
  All rights reserved.
    http://momu.stanford.edu/toolkit/
 
  Mobile Music Research @ CCRMA
  Music, Computing, Design Group
  Stanford University
    http://momu.stanford.edu/
    http://ccrma.stanford.edu/groups/mcd/
 
 MoMu is distributed under the following BSD style open source license:
 
 Permission is hereby granted, free of charge, to any person obtaining a 
 copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The authors encourage users of MoMu to include this copyright notice,
 and to let us know that you are using MoMu. Any person wishing to 
 distribute modifications to the Software is encouraged to send the 
 modifications to the original authors so that they can be incorporated 
 into the canonical version.
 
 The Software is provided "as is", WITHOUT ANY WARRANTY, express or implied,
 including but not limited to the warranties of MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE and NONINFRINGEMENT.  In no event shall the authors
 or copyright holders by liable for any claim, damages, or other liability,
 whether in an actino of a contract, tort or otherwise, arising from, out of
 or in connection with the Software or the use or other dealings in the 
 software.
 -----------------------------------------------------------------------------*/
//-----------------------------------------------------------------------------
// name: mo_colormap.h
// desc: MoPhO API for color map/graphics routines
//
// authors: Nick Bryan (njb@ccrma.stanford.edu)
//          Ge Wang
//
//    date: Fall 2009
//    version: 1.0.0
//
// Mobile Music research @ CCRMA, Stanford University:
//     http://momu.stanford.edu/
//-----------------------------------------------------------------------------
#include "mo_colormap.h"


//-----------------------------------------------------------------------------
// name: Color::Color Constructor
// desc: no args constructor
//-----------------------------------------------------------------------------
Color::Color()
{
    r = 0;
    g = 0;
    b = 0;
    a = 1.0;
}


//-----------------------------------------------------------------------------
// name: Color::Color Constructor
// desc: RGB constructor
//-----------------------------------------------------------------------------
Color::Color(double red, double green, double blue)
{
    r = red;
    g = green;
    b = blue;
    a = 1.0;
}


//-----------------------------------------------------------------------------
// name: Color::Color Constructor
// desc: RGBA constructor
//-----------------------------------------------------------------------------
Color::Color(double red, double green, double blue, double alpha)
{
    r = red;
    g = green;
    b = blue;
    a = alpha;
}


//-----------------------------------------------------------------------------
// name: Color::setRGBA
// desc: setter for RGBA
//-----------------------------------------------------------------------------
void Color::setRGBA(double red, double green, double blue, double alpha)
{
    r = red;
    g = green;
    b = blue;
    a = alpha;
}


//-----------------------------------------------------------------------------
// name: Color::setRGB
// desc: setter for RGB
//-----------------------------------------------------------------------------
void Color::setRGB(double red, double green, double blue)
{
    r = red;
    g = green;
    b = blue;
}


// initialize the static variables for ColorMap
map <string, colorName> ColorMap::m_colorMap;
int  ColorMap::isInit = ColorMap::init();


//-----------------------------------------------------------------------------
// name: ColorMap::init()
// desc: Initializes the static color map 
//-----------------------------------------------------------------------------
int ColorMap::init()
{
    m_colorMap["indianred0"] = indianred0;
    m_colorMap["crimson"] = crimson;
    m_colorMap["lightpink"] = lightpink;
    m_colorMap["lightpink1"] = lightpink1;
    m_colorMap["lightpink2"] = lightpink2;
    m_colorMap["lightpink3"] = lightpink3;
    m_colorMap["lightpink4"] = lightpink4;
    m_colorMap["pink"] = pink;
    m_colorMap["pink1"] = pink1;
    m_colorMap["pink2"] = pink2;
    m_colorMap["pink3"] = pink3;
    m_colorMap["pink4"] = pink4;
    m_colorMap["palevioletred"] = palevioletred;
    m_colorMap["palevioletred1"] = palevioletred1;
    m_colorMap["palevioletred2"] = palevioletred2;
    m_colorMap["palevioletred3"] = palevioletred3;
    m_colorMap["palevioletred4"] = palevioletred4;
    m_colorMap["lavenderblush1"] = lavenderblush1;
    m_colorMap["lavenderblush2"] = lavenderblush2;
    m_colorMap["lavenderblush3"] = lavenderblush3;
    m_colorMap["lavenderblush4"] = lavenderblush4;
    m_colorMap["violetred1"] = violetred1;
    m_colorMap["violetred2"] = violetred2;
    m_colorMap["violetred3"] = violetred3;
    m_colorMap["violetred4"] = violetred4;
    m_colorMap["hotpink"] = hotpink;
    m_colorMap["hotpink1"] = hotpink1;
    m_colorMap["hotpink2"] = hotpink2;
    m_colorMap["hotpink3"] = hotpink3;
    m_colorMap["hotpink4"] = hotpink4;
    m_colorMap["raspberry"] = raspberry;
    m_colorMap["deeppink1"] = deeppink1;
    m_colorMap["deeppink2"] = deeppink2;
    m_colorMap["deeppink3"] = deeppink3;
    m_colorMap["deeppink4"] = deeppink4;
    m_colorMap["maroon1"] = maroon1;
    m_colorMap["maroon2"] = maroon2;
    m_colorMap["maroon3"] = maroon3;
    m_colorMap["maroon4"] = maroon4;
    m_colorMap["mediumvioletred"] = mediumvioletred;
    m_colorMap["violetred"] = violetred;
    m_colorMap["orchid"] = orchid;
    m_colorMap["orchid1"] = orchid1;
    m_colorMap["orchid2"] = orchid2;
    m_colorMap["orchid3"] = orchid3;
    m_colorMap["orchid4"] = orchid4;
    m_colorMap["thistle"] = thistle;
    m_colorMap["thistle1"] = thistle1;
    m_colorMap["thistle2"] = thistle2;
    m_colorMap["thistle3"] = thistle3;
    m_colorMap["thistle4"] = thistle4;
    m_colorMap["plum1"] = plum1;
    m_colorMap["plum2"] = plum2;
    m_colorMap["plum3"] = plum3;
    m_colorMap["plum4"] = plum4;
    m_colorMap["plum"] = plum;
    m_colorMap["violet"] = violet;
    m_colorMap["magenta"] = magenta;
    m_colorMap["magenta2"] = magenta2;
    m_colorMap["magenta3"] = magenta3;
    m_colorMap["magenta4"] = magenta4;
    m_colorMap["purple"] = purple;
    m_colorMap["mediumorchid"] = mediumorchid;
    m_colorMap["mediumorchid1"] = mediumorchid1;
    m_colorMap["mediumorchid2"] = mediumorchid2;
    m_colorMap["mediumorchid3"] = mediumorchid3;
    m_colorMap["mediumorchid4"] = mediumorchid4;
    m_colorMap["darkviolet"] = darkviolet;
    m_colorMap["darkorchid"] = darkorchid;
    m_colorMap["darkorchid1"] = darkorchid1;
    m_colorMap["darkorchid2"] = darkorchid2;
    m_colorMap["darkorchid3"] = darkorchid3;
    m_colorMap["darkorchid4"] = darkorchid4;
    m_colorMap["indigo"] = indigo;
    m_colorMap["blueviolet"] = blueviolet;
    m_colorMap["purple1"] = purple1;
    m_colorMap["purple2"] = purple2;
    m_colorMap["purple3"] = purple3;
    m_colorMap["purple4"] = purple4;
    m_colorMap["mediumpurple"] = mediumpurple;
    m_colorMap["mediumpurple1"] = mediumpurple1;
    m_colorMap["mediumpurple2"] = mediumpurple2;
    m_colorMap["mediumpurple3"] = mediumpurple3;
    m_colorMap["mediumpurple4"] = mediumpurple4;
    m_colorMap["darkslateblue"] = darkslateblue;
    m_colorMap["lightslateblue"] = lightslateblue;
    m_colorMap["mediumslateblue"] = mediumslateblue;
    m_colorMap["slateblue"] = slateblue;
    m_colorMap["slateblue1"] = slateblue1;
    m_colorMap["slateblue2"] = slateblue2;
    m_colorMap["slateblue3"] = slateblue3;
    m_colorMap["slateblue4"] = slateblue4;
    m_colorMap["ghostwhite"] = ghostwhite;
    m_colorMap["lavender"] = lavender;
    m_colorMap["blue"] = blue;
    m_colorMap["blue2"] = blue2;
    m_colorMap["blue3"] = blue3;
    m_colorMap["blue4"] = blue4;
    m_colorMap["navy"] = navy;
    m_colorMap["midnightblue"] = midnightblue;
    m_colorMap["cobalt"] = cobalt;
    m_colorMap["royalblue"] = royalblue;
    m_colorMap["royalblue1"] = royalblue1;
    m_colorMap["royalblue2"] = royalblue2;
    m_colorMap["royalblue3"] = royalblue3;
    m_colorMap["royalblue4"] = royalblue4;
    m_colorMap["cornflowerblue"] = cornflowerblue;
    m_colorMap["lightsteelblue"] = lightsteelblue;
    m_colorMap["lightsteelblue1"] = lightsteelblue1;
    m_colorMap["lightsteelblue2"] = lightsteelblue2;
    m_colorMap["lightsteelblue3"] = lightsteelblue3;
    m_colorMap["lightsteelblue4"] = lightsteelblue4;
    m_colorMap["lightslategray"] = lightslategray;
    m_colorMap["slategray"] = slategray;
    m_colorMap["slategray1"] = slategray1;
    m_colorMap["slategray2"] = slategray2;
    m_colorMap["slategray3"] = slategray3;
    m_colorMap["slategray4"] = slategray4;
    m_colorMap["dodgerblue1"] = dodgerblue1;
    m_colorMap["dodgerblue2"] = dodgerblue2;
    m_colorMap["dodgerblue3"] = dodgerblue3;
    m_colorMap["dodgerblue4"] = dodgerblue4;
    m_colorMap["aliceblue"] = aliceblue;
    m_colorMap["steelblue"] = steelblue;
    m_colorMap["steelblue1"] = steelblue1;
    m_colorMap["steelblue2"] = steelblue2;
    m_colorMap["steelblue3"] = steelblue3;
    m_colorMap["steelblue4"] = steelblue4;
    m_colorMap["lightskyblue"] = lightskyblue;
    m_colorMap["lightskyblue1"] = lightskyblue1;
    m_colorMap["lightskyblue2"] = lightskyblue2;
    m_colorMap["lightskyblue3"] = lightskyblue3;
    m_colorMap["lightskyblue4"] = lightskyblue4;
    m_colorMap["skyblue1"] = skyblue1;
    m_colorMap["skyblue2"] = skyblue2;
    m_colorMap["skyblue3"] = skyblue3;
    m_colorMap["skyblue4"] = skyblue4;
    m_colorMap["skyblue"] = skyblue;
    m_colorMap["deepskyblue1"] = deepskyblue1;
    m_colorMap["deepskyblue2"] = deepskyblue2;
    m_colorMap["deepskyblue3"] = deepskyblue3;
    m_colorMap["deepskyblue4"] = deepskyblue4;
    m_colorMap["peacock"] = peacock;
    m_colorMap["lightblue"] = lightblue;
    m_colorMap["lightblue1"] = lightblue1;
    m_colorMap["lightblue2"] = lightblue2;
    m_colorMap["lightblue3"] = lightblue3;
    m_colorMap["lightblue4"] = lightblue4;
    m_colorMap["powderblue"] = powderblue;
    m_colorMap["cadetblue1"] = cadetblue1;
    m_colorMap["cadetblue2"] = cadetblue2;
    m_colorMap["cadetblue3"] = cadetblue3;
    m_colorMap["cadetblue4"] = cadetblue4;
    m_colorMap["turquoise1"] = turquoise1;
    m_colorMap["turquoise2"] = turquoise2;
    m_colorMap["turquoise3"] = turquoise3;
    m_colorMap["turquoise4"] = turquoise4;
    m_colorMap["cadetblue"] = cadetblue;
    m_colorMap["darkturquoise"] = darkturquoise;
    m_colorMap["azure1"] = azure1;
    m_colorMap["azure2"] = azure2;
    m_colorMap["azure3"] = azure3;
    m_colorMap["azure4"] = azure4;
    m_colorMap["lightcyan1"] = lightcyan1;
    m_colorMap["lightcyan2"] = lightcyan2;
    m_colorMap["lightcyan3"] = lightcyan3;
    m_colorMap["lightcyan4"] = lightcyan4;
    m_colorMap["paleturquoise1"] = paleturquoise1;
    m_colorMap["paleturquoise2"] = paleturquoise2;
    m_colorMap["paleturquoise3"] = paleturquoise3;
    m_colorMap["paleturquoise4"] = paleturquoise4;
    m_colorMap["darkslategray"] = darkslategray;
    m_colorMap["darkslategray1"] = darkslategray1;
    m_colorMap["darkslategray2"] = darkslategray2;
    m_colorMap["darkslategray3"] = darkslategray3;
    m_colorMap["darkslategray4"] = darkslategray4;
    m_colorMap["cyan"] = cyan;
    m_colorMap["cyan2"] = cyan2;
    m_colorMap["cyan3"] = cyan3;
    m_colorMap["cyan4"] = cyan4;
    m_colorMap["teal"] = teal;
    m_colorMap["mediumturquoise"] = mediumturquoise;
    m_colorMap["lightseagreen"] = lightseagreen;
    m_colorMap["manganeseblue"] = manganeseblue;
    m_colorMap["turquoise"] = turquoise;
    m_colorMap["coldgrey"] = coldgrey;
    m_colorMap["turquoiseblue"] = turquoiseblue;
    m_colorMap["aquamarine1"] = aquamarine1;
    m_colorMap["aquamarine2"] = aquamarine2;
    m_colorMap["aquamarine3"] = aquamarine3;
    m_colorMap["aquamarine4"] = aquamarine4;
    m_colorMap["mediumspringgreen"] = mediumspringgreen;
    m_colorMap["mintcream"] = mintcream;
    m_colorMap["springgreen"] = springgreen;
    m_colorMap["springgreen1"] = springgreen1;
    m_colorMap["springgreen2"] = springgreen2;
    m_colorMap["springgreen3"] = springgreen3;
    m_colorMap["mediumseagreen"] = mediumseagreen;
    m_colorMap["seagreen1"] = seagreen1;
    m_colorMap["seagreen2"] = seagreen2;
    m_colorMap["seagreen3"] = seagreen3;
    m_colorMap["seagreen4"] = seagreen4;
    m_colorMap["emeraldgreen"] = emeraldgreen;
    m_colorMap["mint"] = mint;
    m_colorMap["cobaltgreen"] = cobaltgreen;
    m_colorMap["honeydew1"] = honeydew1;
    m_colorMap["honeydew2"] = honeydew2;
    m_colorMap["honeydew3"] = honeydew3;
    m_colorMap["honeydew4"] = honeydew4;
    m_colorMap["darkseagreen"] = darkseagreen;
    m_colorMap["darkseagreen1"] = darkseagreen1;
    m_colorMap["darkseagreen2"] = darkseagreen2;
    m_colorMap["darkseagreen3"] = darkseagreen3;
    m_colorMap["darkseagreen4"] = darkseagreen4;
    m_colorMap["palegreen"] = palegreen;
    m_colorMap["palegreen1"] = palegreen1;
    m_colorMap["palegreen2"] = palegreen2;
    m_colorMap["palegreen3"] = palegreen3;
    m_colorMap["palegreen4"] = palegreen4;
    m_colorMap["limegreen"] = limegreen;
    m_colorMap["forestgreen"] = forestgreen;
    m_colorMap["green1"] = green1;
    m_colorMap["green2"] = green2;
    m_colorMap["green3"] = green3;
    m_colorMap["green4"] = green4;
    m_colorMap["green"] = green;
    m_colorMap["darkgreen"] = darkgreen;
    m_colorMap["sapgreen"] = sapgreen;
    m_colorMap["lawngreen"] = lawngreen;
    m_colorMap["chartreuse1"] = chartreuse1;
    m_colorMap["chartreuse2"] = chartreuse2;
    m_colorMap["chartreuse3"] = chartreuse3;
    m_colorMap["chartreuse4"] = chartreuse4;
    m_colorMap["greenyellow"] = greenyellow;
    m_colorMap["darkolivegreen1"] = darkolivegreen1;
    m_colorMap["darkolivegreen2"] = darkolivegreen2;
    m_colorMap["darkolivegreen3"] = darkolivegreen3;
    m_colorMap["darkolivegreen4"] = darkolivegreen4;
    m_colorMap["darkolivegreen"] = darkolivegreen;
    m_colorMap["olivedrab"] = olivedrab;
    m_colorMap["olivedrab1"] = olivedrab1;
    m_colorMap["olivedrab2"] = olivedrab2;
    m_colorMap["olivedrab3"] = olivedrab3;
    m_colorMap["olivedrab4"] = olivedrab4;
    m_colorMap["ivory1"] = ivory1;
    m_colorMap["ivory2"] = ivory2;
    m_colorMap["ivory3"] = ivory3;
    m_colorMap["ivory4"] = ivory4;
    m_colorMap["beige"] = beige;
    m_colorMap["lightyellow1"] = lightyellow1;
    m_colorMap["lightyellow2"] = lightyellow2;
    m_colorMap["lightyellow3"] = lightyellow3;
    m_colorMap["lightyellow4"] = lightyellow4;
    m_colorMap["lightgoldenrodyellow"] = lightgoldenrodyellow;
    m_colorMap["yellow1"] = yellow1;
    m_colorMap["yellow2"] = yellow2;
    m_colorMap["yellow3"] = yellow3;
    m_colorMap["yellow4"] = yellow4;
    m_colorMap["warmgrey"] = warmgrey;
    m_colorMap["olive"] = olive;
    m_colorMap["darkkhaki"] = darkkhaki;
    m_colorMap["khaki1"] = khaki1;
    m_colorMap["khaki2"] = khaki2;
    m_colorMap["khaki3"] = khaki3;
    m_colorMap["khaki4"] = khaki4;
    m_colorMap["khaki"] = khaki;
    m_colorMap["palegoldenrod"] = palegoldenrod;
    m_colorMap["lemonchiffon1"] = lemonchiffon1;
    m_colorMap["lemonchiffon2"] = lemonchiffon2;
    m_colorMap["lemonchiffon3"] = lemonchiffon3;
    m_colorMap["lemonchiffon4"] = lemonchiffon4;
    m_colorMap["lightgoldenrod1"] = lightgoldenrod1;
    m_colorMap["lightgoldenrod2"] = lightgoldenrod2;
    m_colorMap["lightgoldenrod3"] = lightgoldenrod3;
    m_colorMap["lightgoldenrod4"] = lightgoldenrod4;
    m_colorMap["banana"] = banana;
    m_colorMap["gold1"] = gold1;
    m_colorMap["gold2"] = gold2;
    m_colorMap["gold3"] = gold3;
    m_colorMap["gold4"] = gold4;
    m_colorMap["cornsilk1"] = cornsilk1;
    m_colorMap["cornsilk2"] = cornsilk2;
    m_colorMap["cornsilk3"] = cornsilk3;
    m_colorMap["cornsilk4"] = cornsilk4;
    m_colorMap["goldenrod"] = goldenrod;
    m_colorMap["goldenrod1"] = goldenrod1;
    m_colorMap["goldenrod2"] = goldenrod2;
    m_colorMap["goldenrod3"] = goldenrod3;
    m_colorMap["goldenrod4"] = goldenrod4;
    m_colorMap["darkgoldenrod"] = darkgoldenrod;
    m_colorMap["darkgoldenrod1"] = darkgoldenrod1;
    m_colorMap["darkgoldenrod2"] = darkgoldenrod2;
    m_colorMap["darkgoldenrod3"] = darkgoldenrod3;
    m_colorMap["darkgoldenrod4"] = darkgoldenrod4;
    m_colorMap["orange1"] = orange1;
    m_colorMap["orange2"] = orange2;
    m_colorMap["orange3"] = orange3;
    m_colorMap["orange4"] = orange4;
    m_colorMap["floralwhite"] = floralwhite;
    m_colorMap["oldlace"] = oldlace;
    m_colorMap["wheat"] = wheat;
    m_colorMap["wheat1"] = wheat1;
    m_colorMap["wheat2"] = wheat2;
    m_colorMap["wheat3"] = wheat3;
    m_colorMap["wheat4"] = wheat4;
    m_colorMap["moccasin"] = moccasin;
    m_colorMap["papayawhip"] = papayawhip;
    m_colorMap["blanchedalmond"] = blanchedalmond;
    m_colorMap["navajowhite1"] = navajowhite1;
    m_colorMap["navajowhite2"] = navajowhite2;
    m_colorMap["navajowhite3"] = navajowhite3;
    m_colorMap["navajowhite4"] = navajowhite4;
    m_colorMap["eggshell"] = eggshell;
    m_colorMap["tan"] = tanN;
    m_colorMap["brick"] = brick;
    m_colorMap["cadmiumyellow"] = cadmiumyellow;
    m_colorMap["antiquewhite"] = antiquewhite;
    m_colorMap["antiquewhite1"] = antiquewhite1;
    m_colorMap["antiquewhite2"] = antiquewhite2;
    m_colorMap["antiquewhite3"] = antiquewhite3;
    m_colorMap["antiquewhite4"] = antiquewhite4;
    m_colorMap["burlywood"] = burlywood;
    m_colorMap["burlywood1"] = burlywood1;
    m_colorMap["burlywood2"] = burlywood2;
    m_colorMap["burlywood3"] = burlywood3;
    m_colorMap["burlywood4"] = burlywood4;
    m_colorMap["bisque1"] = bisque1;
    m_colorMap["bisque2"] = bisque2;
    m_colorMap["bisque3"] = bisque3;
    m_colorMap["bisque4"] = bisque4;
    m_colorMap["melon"] = melon;
    m_colorMap["carrot"] = carrot;
    m_colorMap["darkorange"] = darkorange;
    m_colorMap["darkorange1"] = darkorange1;
    m_colorMap["darkorange2"] = darkorange2;
    m_colorMap["darkorange3"] = darkorange3;
    m_colorMap["darkorange4"] = darkorange4;
    m_colorMap["orange"] = orange;
    m_colorMap["tan1"] = tan1;
    m_colorMap["tan2"] = tan2;
    m_colorMap["tan3"] = tan3;
    m_colorMap["tan4"] = tan4;
    m_colorMap["linen"] = linen;
    m_colorMap["peachpuff1"] = peachpuff1;
    m_colorMap["peachpuff2"] = peachpuff2;
    m_colorMap["peachpuff3"] = peachpuff3;
    m_colorMap["peachpuff4"] = peachpuff4;
    m_colorMap["seashell1"] = seashell1;
    m_colorMap["seashell2"] = seashell2;
    m_colorMap["seashell3"] = seashell3;
    m_colorMap["seashell4"] = seashell4;
    m_colorMap["sandybrown"] = sandybrown;
    m_colorMap["rawsienna"] = rawsienna;
    m_colorMap["chocolate"] = chocolate;
    m_colorMap["chocolate1"] = chocolate1;
    m_colorMap["chocolate2"] = chocolate2;
    m_colorMap["chocolate3"] = chocolate3;
    m_colorMap["chocolate4"] = chocolate4;
    m_colorMap["ivoryblack"] = ivoryblack;
    m_colorMap["flesh"] = flesh;
    m_colorMap["cadmiumorange"] = cadmiumorange;
    m_colorMap["burntsienna"] = burntsienna;
    m_colorMap["sienna"] = sienna;
    m_colorMap["sienna1"] = sienna1;
    m_colorMap["sienna2"] = sienna2;
    m_colorMap["sienna3"] = sienna3;
    m_colorMap["sienna4"] = sienna4;
    m_colorMap["lightsalmon1"] = lightsalmon1;
    m_colorMap["lightsalmon2"] = lightsalmon2;
    m_colorMap["lightsalmon3"] = lightsalmon3;
    m_colorMap["lightsalmon4"] = lightsalmon4;
    m_colorMap["coral"] = coral;
    m_colorMap["orangered1"] = orangered1;
    m_colorMap["orangered2"] = orangered2;
    m_colorMap["orangered3"] = orangered3;
    m_colorMap["orangered4"] = orangered4;
    m_colorMap["sepia"] = sepia;
    m_colorMap["darksalmon"] = darksalmon;
    m_colorMap["salmon1"] = salmon1;
    m_colorMap["salmon2"] = salmon2;
    m_colorMap["salmon3"] = salmon3;
    m_colorMap["salmon4"] = salmon4;
    m_colorMap["coral1"] = coral1;
    m_colorMap["coral2"] = coral2;
    m_colorMap["coral3"] = coral3;
    m_colorMap["coral4"] = coral4;
    m_colorMap["burntumber"] = burntumber;
    m_colorMap["tomato1"] = tomato1;
    m_colorMap["tomato2"] = tomato2;
    m_colorMap["tomato3"] = tomato3;
    m_colorMap["tomato4"] = tomato4;
    m_colorMap["salmon"] = salmon;
    m_colorMap["mistyrose1"] = mistyrose1;
    m_colorMap["mistyrose2"] = mistyrose2;
    m_colorMap["mistyrose3"] = mistyrose3;
    m_colorMap["mistyrose4"] = mistyrose4;
    m_colorMap["snow1"] = snow1;
    m_colorMap["snow2"] = snow2;
    m_colorMap["snow3"] = snow3;
    m_colorMap["snow4"] = snow4;
    m_colorMap["rosybrown"] = rosybrown;
    m_colorMap["rosybrown1"] = rosybrown1;
    m_colorMap["rosybrown2"] = rosybrown2;
    m_colorMap["rosybrown3"] = rosybrown3;
    m_colorMap["rosybrown4"] = rosybrown4;
    m_colorMap["lightcoral"] = lightcoral;
    m_colorMap["indianred"] = indianred;
    m_colorMap["indianred1"] = indianred1;
    m_colorMap["indianred2"] = indianred2;
    m_colorMap["indianred4"] = indianred4;
    m_colorMap["indianred3"] = indianred3;
    m_colorMap["brown"] = brown;
    m_colorMap["brown1"] = brown1;
    m_colorMap["brown2"] = brown2;
    m_colorMap["brown3"] = brown3;
    m_colorMap["brown4"] = brown4;
    m_colorMap["firebrick"] = firebrick;
    m_colorMap["firebrick1"] = firebrick1;
    m_colorMap["firebrick2"] = firebrick2;
    m_colorMap["firebrick3"] = firebrick3;
    m_colorMap["firebrick4"] = firebrick4;
    m_colorMap["red1"] = red1;
    m_colorMap["red2"] = red2;
    m_colorMap["red3"] = red3;
    m_colorMap["red4"] = red4;
    m_colorMap["maroon"] = maroon;
    m_colorMap["sgibeet"] = sgibeet;
    m_colorMap["sgislateblue"] = sgislateblue;
    m_colorMap["sgilightblue"] = sgilightblue;
    m_colorMap["sgiteal"] = sgiteal;
    m_colorMap["sgichartreuse"] = sgichartreuse;
    m_colorMap["sgiolivedrab"] = sgiolivedrab;
    m_colorMap["sgibrightgray"] = sgibrightgray;
    m_colorMap["sgisalmon"] = sgisalmon;
    m_colorMap["sgidarkgray"] = sgidarkgray;
    m_colorMap["sgigray12"] = sgigray12;
    m_colorMap["sgigray16"] = sgigray16;
    m_colorMap["sgigray32"] = sgigray32;
    m_colorMap["sgigray36"] = sgigray36;
    m_colorMap["sgigray52"] = sgigray52;
    m_colorMap["sgigray56"] = sgigray56;
    m_colorMap["sgilightgray"] = sgilightgray;
    m_colorMap["sgigray72"] = sgigray72;
    m_colorMap["sgigray76"] = sgigray76;
    m_colorMap["sgigray92"] = sgigray92;
    m_colorMap["sgigray96"] = sgigray96;
    m_colorMap["white"] = white;
    m_colorMap["whitesmoke"] = whitesmoke;
    m_colorMap["gainsboro"] = gainsboro;
    m_colorMap["lightgrey"] = lightgrey;
    m_colorMap["silver"] = silver;
    m_colorMap["darkgray"] = darkgray;
    m_colorMap["gray"] = gray;
    m_colorMap["dimgray"] = dimgray;
    m_colorMap["black"] = black;
    m_colorMap["gray99"] = gray99;
    m_colorMap["gray98"] = gray98;
    m_colorMap["gray97"] = gray97;
    m_colorMap["gray95"] = gray95;
    m_colorMap["gray94"] = gray94;
    m_colorMap["gray93"] = gray93;
    m_colorMap["gray92"] = gray92;
    m_colorMap["gray91"] = gray91;
    m_colorMap["gray90"] = gray90;
    m_colorMap["gray89"] = gray89;
    m_colorMap["gray88"] = gray88;
    m_colorMap["gray87"] = gray87;
    m_colorMap["gray86"] = gray86;
    m_colorMap["gray85"] = gray85;
    m_colorMap["gray84"] = gray84;
    m_colorMap["gray83"] = gray83;
    m_colorMap["gray82"] = gray82;
    m_colorMap["gray81"] = gray81;
    m_colorMap["gray80"] = gray80;
    m_colorMap["gray79"] = gray79;
    m_colorMap["gray78"] = gray78;
    m_colorMap["gray77"] = gray77;
    m_colorMap["gray76"] = gray76;
    m_colorMap["gray75"] = gray75;
    m_colorMap["gray74"] = gray74;
    m_colorMap["gray73"] = gray73;
    m_colorMap["gray72"] = gray72;
    m_colorMap["gray71"] = gray71;
    m_colorMap["gray70"] = gray70;
    m_colorMap["gray69"] = gray69;
    m_colorMap["gray68"] = gray68;
    m_colorMap["gray67"] = gray67;
    m_colorMap["gray66"] = gray66;
    m_colorMap["gray65"] = gray65;
    m_colorMap["gray64"] = gray64;
    m_colorMap["gray63"] = gray63;
    m_colorMap["gray62"] = gray62;
    m_colorMap["gray61"] = gray61;
    m_colorMap["gray60"] = gray60;
    m_colorMap["gray59"] = gray59;
    m_colorMap["gray58"] = gray58;
    m_colorMap["gray57"] = gray57;
    m_colorMap["gray56"] = gray56;
    m_colorMap["gray55"] = gray55;
    m_colorMap["gray54"] = gray54;
    m_colorMap["gray53"] = gray53;
    m_colorMap["gray52"] = gray52;
    m_colorMap["gray51"] = gray51;
    m_colorMap["gray50"] = gray50;
    m_colorMap["gray49"] = gray49;
    m_colorMap["gray48"] = gray48;
    m_colorMap["gray47"] = gray47;
    m_colorMap["gray46"] = gray46;
    m_colorMap["gray45"] = gray45;
    m_colorMap["gray44"] = gray44;
    m_colorMap["gray43"] = gray43;
    m_colorMap["gray42"] = gray42;
    m_colorMap["dimgay"] = dimgay;
    m_colorMap["gray40"] = gray40;
    m_colorMap["gray39"] = gray39;
    m_colorMap["gray38"] = gray38;
    m_colorMap["gray37"] = gray37;
    m_colorMap["gray36"] = gray36;
    m_colorMap["gray35"] = gray35;
    m_colorMap["gray34"] = gray34;
    m_colorMap["gray33"] = gray33;
    m_colorMap["gray32"] = gray32;
    m_colorMap["gray31"] = gray31;
    m_colorMap["gray30"] = gray30;
    m_colorMap["gray29"] = gray29;
    m_colorMap["gray28"] = gray28;
    m_colorMap["gray27"] = gray27;
    m_colorMap["gray26"] = gray26;
    m_colorMap["gray25"] = gray25;
    m_colorMap["gray24"] = gray24;
    m_colorMap["gray23"] = gray23;
    m_colorMap["gray22"] = gray22;
    m_colorMap["gray21"] = gray21;
    m_colorMap["gray20"] = gray20;
    m_colorMap["gray19"] = gray19;
    m_colorMap["gray18"] = gray18;
    m_colorMap["gray17"] = gray17;
    m_colorMap["gray16"] = gray16;
    m_colorMap["gray15"] = gray15;
    m_colorMap["gray14"] = gray14;
    m_colorMap["gray13"] = gray13;
    m_colorMap["gray12"] = gray12;
    m_colorMap["gray11"] = gray11;
    m_colorMap["gray10"] = gray10;
    m_colorMap["gray9"] = gray9;
    m_colorMap["gray8"] = gray8;
    m_colorMap["gray7"] = gray7;
    m_colorMap["gray6"] = gray6;
    m_colorMap["gray5"] = gray5;
    m_colorMap["gray4"] = gray4;
    m_colorMap["gray3"] = gray3;
    m_colorMap["gray2"] = gray2;
    m_colorMap["gray1"] = gray1;
    
    return 1;
    
}


//-----------------------------------------------------------------------------
// name: ColorMap::getColor(string input) 
// desc: getter via color name that returns the color fields by reference 
//-----------------------------------------------------------------------------
void  ColorMap::getColor(string input, float & r, float & g, float & b)
{
    // get the color
    Color color = getColor(input);

    // Assign the values
    r = color.r; g = color.g; b = color.b;
}


//-----------------------------------------------------------------------------
// name: ColorMap::getColor(string input) 
// desc: getter via color name that returns a Color object. 
//-----------------------------------------------------------------------------
Color ColorMap::getColor(string input) 
{
    switch(m_colorMap[input])
    {
        case indianred0:
            return Color(0.690196, 0.090196, 0.121569);
        case crimson:
            return Color(0.862745, 0.078431, 0.235294);
        case lightpink:
            return Color(1.000000, 0.713725, 0.756863);
        case lightpink1:
            return Color(1.000000, 0.682353, 0.725490);
        case lightpink2:
            return Color(0.933333, 0.635294, 0.678431);
        case lightpink3:
            return Color(0.803922, 0.549020, 0.584314);
        case lightpink4:
            return Color(0.545098, 0.372549, 0.396078);
        case pink:
            return Color(1.000000, 0.752941, 0.796078);
        case pink1:
            return Color(1.000000, 0.709804, 0.772549);
        case pink2:
            return Color(0.933333, 0.662745, 0.721569);
        case pink3:
            return Color(0.803922, 0.568627, 0.619608);
        case pink4:
            return Color(0.545098, 0.388235, 0.423529);
        case palevioletred:
            return Color(0.858824, 0.439216, 0.576471);
        case palevioletred1:
            return Color(1.000000, 0.509804, 0.670588);
        case palevioletred2:
            return Color(0.933333, 0.474510, 0.623529);
        case palevioletred3:
            return Color(0.803922, 0.407843, 0.537255);
        case palevioletred4:
            return Color(0.545098, 0.278431, 0.364706);
        case lavenderblush1:
            return Color(1.000000, 0.941176, 0.960784);
        case lavenderblush2:
            return Color(0.933333, 0.878431, 0.898039);
        case lavenderblush3:
            return Color(0.803922, 0.756863, 0.772549);
        case lavenderblush4:
            return Color(0.545098, 0.513725, 0.525490);
        case violetred1:
            return Color(1.000000, 0.243137, 0.588235);
        case violetred2:
            return Color(0.933333, 0.227451, 0.549020);
        case violetred3:
            return Color(0.803922, 0.196078, 0.470588);
        case violetred4:
            return Color(0.545098, 0.133333, 0.321569);
        case hotpink:
            return Color(1.000000, 0.411765, 0.705882);
        case hotpink1:
            return Color(1.000000, 0.431373, 0.705882);
        case hotpink2:
            return Color(0.933333, 0.415686, 0.654902);
        case hotpink3:
            return Color(0.803922, 0.376471, 0.564706);
        case hotpink4:
            return Color(0.545098, 0.227451, 0.384314);
        case raspberry:
            return Color(0.529412, 0.149020, 0.341176);
        case deeppink1:
            return Color(1.000000, 0.078431, 0.576471);
        case deeppink2:
            return Color(0.933333, 0.070588, 0.537255);
        case deeppink3:
            return Color(0.803922, 0.062745, 0.462745);
        case deeppink4:
            return Color(0.545098, 0.039216, 0.313725);
        case maroon1:
            return Color(1.000000, 0.203922, 0.701961);
        case maroon2:
            return Color(0.933333, 0.188235, 0.654902);
        case maroon3:
            return Color(0.803922, 0.160784, 0.564706);
        case maroon4:
            return Color(0.545098, 0.109804, 0.384314);
        case mediumvioletred:
            return Color(0.780392, 0.082353, 0.521569);
        case violetred:
            return Color(0.815686, 0.125490, 0.564706);
        case orchid:
            return Color(0.854902, 0.439216, 0.839216);
        case orchid1:
            return Color(1.000000, 0.513725, 0.980392);
        case orchid2:
            return Color(0.933333, 0.478431, 0.913725);
        case orchid3:
            return Color(0.803922, 0.411765, 0.788235);
        case orchid4:
            return Color(0.545098, 0.278431, 0.537255);
        case thistle:
            return Color(0.847059, 0.749020, 0.847059);
        case thistle1:
            return Color(1.000000, 0.882353, 1.000000);
        case thistle2:
            return Color(0.933333, 0.823529, 0.933333);
        case thistle3:
            return Color(0.803922, 0.709804, 0.803922);
        case thistle4:
            return Color(0.545098, 0.482353, 0.545098);
        case plum1:
            return Color(1.000000, 0.733333, 1.000000);
        case plum2:
            return Color(0.933333, 0.682353, 0.933333);
        case plum3:
            return Color(0.803922, 0.588235, 0.803922);
        case plum4:
            return Color(0.545098, 0.400000, 0.545098);
        case plum:
            return Color(0.866667, 0.627451, 0.866667);
        case violet:
            return Color(0.933333, 0.509804, 0.933333);
        case magenta:
            return Color(1.000000, 0.000000, 1.000000);
        case magenta2:
            return Color(0.933333, 0.000000, 0.933333);
        case magenta3:
            return Color(0.803922, 0.000000, 0.803922);
        case magenta4:
            return Color(0.545098, 0.000000, 0.545098);
        case purple:
            return Color(0.501961, 0.000000, 0.501961);
        case mediumorchid:
            return Color(0.729412, 0.333333, 0.827451);
        case mediumorchid1:
            return Color(0.878431, 0.400000, 1.000000);
        case mediumorchid2:
            return Color(0.819608, 0.372549, 0.933333);
        case mediumorchid3:
            return Color(0.705882, 0.321569, 0.803922);
        case mediumorchid4:
            return Color(0.478431, 0.215686, 0.545098);
        case darkviolet:
            return Color(0.580392, 0.000000, 0.827451);
        case darkorchid:
            return Color(0.600000, 0.196078, 0.800000);
        case darkorchid1:
            return Color(0.749020, 0.243137, 1.000000);
        case darkorchid2:
            return Color(0.698039, 0.227451, 0.933333);
        case darkorchid3:
            return Color(0.603922, 0.196078, 0.803922);
        case darkorchid4:
            return Color(0.407843, 0.133333, 0.545098);
        case indigo:
            return Color(0.294118, 0.000000, 0.509804);
        case blueviolet:
            return Color(0.541176, 0.168627, 0.886275);
        case purple1:
            return Color(0.607843, 0.188235, 1.000000);
        case purple2:
            return Color(0.568627, 0.172549, 0.933333);
        case purple3:
            return Color(0.490196, 0.149020, 0.803922);
        case purple4:
            return Color(0.333333, 0.101961, 0.545098);
        case mediumpurple:
            return Color(0.576471, 0.439216, 0.858824);
        case mediumpurple1:
            return Color(0.670588, 0.509804, 1.000000);
        case mediumpurple2:
            return Color(0.623529, 0.474510, 0.933333);
        case mediumpurple3:
            return Color(0.537255, 0.407843, 0.803922);
        case mediumpurple4:
            return Color(0.364706, 0.278431, 0.545098);
        case darkslateblue:
            return Color(0.282353, 0.239216, 0.545098);
        case lightslateblue:
            return Color(0.517647, 0.439216, 1.000000);
        case mediumslateblue:
            return Color(0.482353, 0.407843, 0.933333);
        case slateblue:
            return Color(0.415686, 0.352941, 0.803922);
        case slateblue1:
            return Color(0.513725, 0.435294, 1.000000);
        case slateblue2:
            return Color(0.478431, 0.403922, 0.933333);
        case slateblue3:
            return Color(0.411765, 0.349020, 0.803922);
        case slateblue4:
            return Color(0.278431, 0.235294, 0.545098);
        case ghostwhite:
            return Color(0.972549, 0.972549, 1.000000);
        case lavender:
            return Color(0.901961, 0.901961, 0.980392);
        case blue:
            return Color(0.000000, 0.000000, 1.000000);
        case blue2:
            return Color(0.000000, 0.000000, 0.933333);
        case blue3:
            return Color(0.000000, 0.000000, 0.803922);
        case blue4:
            return Color(0.000000, 0.000000, 0.545098);
        case navy:
            return Color(0.000000, 0.000000, 0.501961);
        case midnightblue:
            return Color(0.098039, 0.098039, 0.439216);
        case cobalt:
            return Color(0.239216, 0.349020, 0.670588);
        case royalblue:
            return Color(0.254902, 0.411765, 0.882353);
        case royalblue1:
            return Color(0.282353, 0.462745, 1.000000);
        case royalblue2:
            return Color(0.262745, 0.431373, 0.933333);
        case royalblue3:
            return Color(0.227451, 0.372549, 0.803922);
        case royalblue4:
            return Color(0.152941, 0.250980, 0.545098);
        case cornflowerblue:
            return Color(0.392157, 0.584314, 0.929412);
        case lightsteelblue:
            return Color(0.690196, 0.768627, 0.870588);
        case lightsteelblue1:
            return Color(0.792157, 0.882353, 1.000000);
        case lightsteelblue2:
            return Color(0.737255, 0.823529, 0.933333);
        case lightsteelblue3:
            return Color(0.635294, 0.709804, 0.803922);
        case lightsteelblue4:
            return Color(0.431373, 0.482353, 0.545098);
        case lightslategray:
            return Color(0.466667, 0.533333, 0.600000);
        case slategray:
            return Color(0.439216, 0.501961, 0.564706);
        case slategray1:
            return Color(0.776471, 0.886275, 1.000000);
        case slategray2:
            return Color(0.725490, 0.827451, 0.933333);
        case slategray3:
            return Color(0.623529, 0.713725, 0.803922);
        case slategray4:
            return Color(0.423529, 0.482353, 0.545098);
        case dodgerblue1:
            return Color(0.117647, 0.564706, 1.000000);
        case dodgerblue2:
            return Color(0.109804, 0.525490, 0.933333);
        case dodgerblue3:
            return Color(0.094118, 0.454902, 0.803922);
        case dodgerblue4:
            return Color(0.062745, 0.305882, 0.545098);
        case aliceblue:
            return Color(0.941176, 0.972549, 1.000000);
        case steelblue:
            return Color(0.274510, 0.509804, 0.705882);
        case steelblue1:
            return Color(0.388235, 0.721569, 1.000000);
        case steelblue2:
            return Color(0.360784, 0.674510, 0.933333);
        case steelblue3:
            return Color(0.309804, 0.580392, 0.803922);
        case steelblue4:
            return Color(0.211765, 0.392157, 0.545098);
        case lightskyblue:
            return Color(0.529412, 0.807843, 0.980392);
        case lightskyblue1:
            return Color(0.690196, 0.886275, 1.000000);
        case lightskyblue2:
            return Color(0.643137, 0.827451, 0.933333);
        case lightskyblue3:
            return Color(0.552941, 0.713725, 0.803922);
        case lightskyblue4:
            return Color(0.376471, 0.482353, 0.545098);
        case skyblue1:
            return Color(0.529412, 0.807843, 1.000000);
        case skyblue2:
            return Color(0.494118, 0.752941, 0.933333);
        case skyblue3:
            return Color(0.423529, 0.650980, 0.803922);
        case skyblue4:
            return Color(0.290196, 0.439216, 0.545098);
        case skyblue:
            return Color(0.529412, 0.807843, 0.921569);
        case deepskyblue1:
            return Color(0.000000, 0.749020, 1.000000);
        case deepskyblue2:
            return Color(0.000000, 0.698039, 0.933333);
        case deepskyblue3:
            return Color(0.000000, 0.603922, 0.803922);
        case deepskyblue4:
            return Color(0.000000, 0.407843, 0.545098);
        case peacock:
            return Color(0.200000, 0.631373, 0.788235);
        case lightblue:
            return Color(0.678431, 0.847059, 0.901961);
        case lightblue1:
            return Color(0.749020, 0.937255, 1.000000);
        case lightblue2:
            return Color(0.698039, 0.874510, 0.933333);
        case lightblue3:
            return Color(0.603922, 0.752941, 0.803922);
        case lightblue4:
            return Color(0.407843, 0.513725, 0.545098);
        case powderblue:
            return Color(0.690196, 0.878431, 0.901961);
        case cadetblue1:
            return Color(0.596078, 0.960784, 1.000000);
        case cadetblue2:
            return Color(0.556863, 0.898039, 0.933333);
        case cadetblue3:
            return Color(0.478431, 0.772549, 0.803922);
        case cadetblue4:
            return Color(0.325490, 0.525490, 0.545098);
        case turquoise1:
            return Color(0.000000, 0.960784, 1.000000);
        case turquoise2:
            return Color(0.000000, 0.898039, 0.933333);
        case turquoise3:
            return Color(0.000000, 0.772549, 0.803922);
        case turquoise4:
            return Color(0.000000, 0.525490, 0.545098);
        case cadetblue:
            return Color(0.372549, 0.619608, 0.627451);
        case darkturquoise:
            return Color(0.000000, 0.807843, 0.819608);
        case azure1:
            return Color(0.941176, 1.000000, 1.000000);
        case azure2:
            return Color(0.878431, 0.933333, 0.933333);
        case azure3:
            return Color(0.756863, 0.803922, 0.803922);
        case azure4:
            return Color(0.513725, 0.545098, 0.545098);
        case lightcyan1:
            return Color(0.878431, 1.000000, 1.000000);
        case lightcyan2:
            return Color(0.819608, 0.933333, 0.933333);
        case lightcyan3:
            return Color(0.705882, 0.803922, 0.803922);
        case lightcyan4:
            return Color(0.478431, 0.545098, 0.545098);
        case paleturquoise1:
            return Color(0.733333, 1.000000, 1.000000);
        case paleturquoise2:
            return Color(0.682353, 0.933333, 0.933333);
        case paleturquoise3:
            return Color(0.588235, 0.803922, 0.803922);
        case paleturquoise4:
            return Color(0.400000, 0.545098, 0.545098);
        case darkslategray:
            return Color(0.184314, 0.309804, 0.309804);
        case darkslategray1:
            return Color(0.592157, 1.000000, 1.000000);
        case darkslategray2:
            return Color(0.552941, 0.933333, 0.933333);
        case darkslategray3:
            return Color(0.474510, 0.803922, 0.803922);
        case darkslategray4:
            return Color(0.321569, 0.545098, 0.545098);
        case cyan:
            return Color(0.000000, 1.000000, 1.000000);
        case cyan2:
            return Color(0.000000, 0.933333, 0.933333);
        case cyan3:
            return Color(0.000000, 0.803922, 0.803922);
        case cyan4:
            return Color(0.000000, 0.545098, 0.545098);
        case teal:
            return Color(0.000000, 0.501961, 0.501961);
        case mediumturquoise:
            return Color(0.282353, 0.819608, 0.800000);
        case lightseagreen:
            return Color(0.125490, 0.698039, 0.666667);
        case manganeseblue:
            return Color(0.011765, 0.658824, 0.619608);
        case turquoise:
            return Color(0.250980, 0.878431, 0.815686);
        case coldgrey:
            return Color(0.501961, 0.541176, 0.529412);
        case turquoiseblue:
            return Color(0.000000, 0.780392, 0.549020);
        case aquamarine1:
            return Color(0.498039, 1.000000, 0.831373);
        case aquamarine2:
            return Color(0.462745, 0.933333, 0.776471);
        case aquamarine3:
            return Color(0.400000, 0.803922, 0.666667);
        case aquamarine4:
            return Color(0.270588, 0.545098, 0.454902);
        case mediumspringgreen:
            return Color(0.000000, 0.980392, 0.603922);
        case mintcream:
            return Color(0.960784, 1.000000, 0.980392);
        case springgreen:
            return Color(0.000000, 1.000000, 0.498039);
        case springgreen1:
            return Color(0.000000, 0.933333, 0.462745);
        case springgreen2:
            return Color(0.000000, 0.803922, 0.400000);
        case springgreen3:
            return Color(0.000000, 0.545098, 0.270588);
        case mediumseagreen:
            return Color(0.235294, 0.701961, 0.443137);
        case seagreen1:
            return Color(0.329412, 1.000000, 0.623529);
        case seagreen2:
            return Color(0.305882, 0.933333, 0.580392);
        case seagreen3:
            return Color(0.262745, 0.803922, 0.501961);
        case seagreen4:
            return Color(0.180392, 0.545098, 0.341176);
        case emeraldgreen:
            return Color(0.000000, 0.788235, 0.341176);
        case mint:
            return Color(0.741176, 0.988235, 0.788235);
        case cobaltgreen:
            return Color(0.239216, 0.568627, 0.250980);
        case honeydew1:
            return Color(0.941176, 1.000000, 0.941176);
        case honeydew2:
            return Color(0.878431, 0.933333, 0.878431);
        case honeydew3:
            return Color(0.756863, 0.803922, 0.756863);
        case honeydew4:
            return Color(0.513725, 0.545098, 0.513725);
        case darkseagreen:
            return Color(0.560784, 0.737255, 0.560784);
        case darkseagreen1:
            return Color(0.756863, 1.000000, 0.756863);
        case darkseagreen2:
            return Color(0.705882, 0.933333, 0.705882);
        case darkseagreen3:
            return Color(0.607843, 0.803922, 0.607843);
        case darkseagreen4:
            return Color(0.411765, 0.545098, 0.411765);
        case palegreen:
            return Color(0.596078, 0.984314, 0.596078);
        case palegreen1:
            return Color(0.603922, 1.000000, 0.603922);
        case palegreen2:
            return Color(0.564706, 0.933333, 0.564706);
        case palegreen3:
            return Color(0.486275, 0.803922, 0.486275);
        case palegreen4:
            return Color(0.329412, 0.545098, 0.329412);
        case limegreen:
            return Color(0.196078, 0.803922, 0.196078);
        case forestgreen:
            return Color(0.133333, 0.545098, 0.133333);
        case green1:
            return Color(0.000000, 1.000000, 0.000000);
        case green2:
            return Color(0.000000, 0.933333, 0.000000);
        case green3:
            return Color(0.000000, 0.803922, 0.000000);
        case green4:
            return Color(0.000000, 0.545098, 0.000000);
        case green:
            return Color(0.000000, 0.501961, 0.000000);
        case darkgreen:
            return Color(0.000000, 0.392157, 0.000000);
        case sapgreen:
            return Color(0.188235, 0.501961, 0.078431);
        case lawngreen:
            return Color(0.486275, 0.988235, 0.000000);
        case chartreuse1:
            return Color(0.498039, 1.000000, 0.000000);
        case chartreuse2:
            return Color(0.462745, 0.933333, 0.000000);
        case chartreuse3:
            return Color(0.400000, 0.803922, 0.000000);
        case chartreuse4:
            return Color(0.270588, 0.545098, 0.000000);
        case greenyellow:
            return Color(0.678431, 1.000000, 0.184314);
        case darkolivegreen1:
            return Color(0.792157, 1.000000, 0.439216);
        case darkolivegreen2:
            return Color(0.737255, 0.933333, 0.407843);
        case darkolivegreen3:
            return Color(0.635294, 0.803922, 0.352941);
        case darkolivegreen4:
            return Color(0.431373, 0.545098, 0.239216);
        case darkolivegreen:
            return Color(0.333333, 0.419608, 0.184314);
        case olivedrab:
            return Color(0.419608, 0.556863, 0.137255);
        case olivedrab1:
            return Color(0.752941, 1.000000, 0.243137);
        case olivedrab2:
            return Color(0.701961, 0.933333, 0.227451);
        case olivedrab3:
            return Color(0.603922, 0.803922, 0.196078);
        case olivedrab4:
            return Color(0.411765, 0.545098, 0.133333);
        case ivory1:
            return Color(1.000000, 1.000000, 0.941176);
        case ivory2:
            return Color(0.933333, 0.933333, 0.878431);
        case ivory3:
            return Color(0.803922, 0.803922, 0.756863);
        case ivory4:
            return Color(0.545098, 0.545098, 0.513725);
        case beige:
            return Color(0.960784, 0.960784, 0.862745);
        case lightyellow1:
            return Color(1.000000, 1.000000, 0.878431);
        case lightyellow2:
            return Color(0.933333, 0.933333, 0.819608);
        case lightyellow3:
            return Color(0.803922, 0.803922, 0.705882);
        case lightyellow4:
            return Color(0.545098, 0.545098, 0.478431);
        case lightgoldenrodyellow:
            return Color(0.980392, 0.980392, 0.823529);
        case yellow1:
            return Color(1.000000, 1.000000, 0.000000);
        case yellow2:
            return Color(0.933333, 0.933333, 0.000000);
        case yellow3:
            return Color(0.803922, 0.803922, 0.000000);
        case yellow4:
            return Color(0.545098, 0.545098, 0.000000);
        case warmgrey:
            return Color(0.501961, 0.501961, 0.411765);
        case olive:
            return Color(0.501961, 0.501961, 0.000000);
        case darkkhaki:
            return Color(0.741176, 0.717647, 0.419608);
        case khaki1:
            return Color(1.000000, 0.964706, 0.560784);
        case khaki2:
            return Color(0.933333, 0.901961, 0.521569);
        case khaki3:
            return Color(0.803922, 0.776471, 0.450980);
        case khaki4:
            return Color(0.545098, 0.525490, 0.305882);
        case khaki:
            return Color(0.941176, 0.901961, 0.549020);
        case palegoldenrod:
            return Color(0.933333, 0.909804, 0.666667);
        case lemonchiffon1:
            return Color(1.000000, 0.980392, 0.803922);
        case lemonchiffon2:
            return Color(0.933333, 0.913725, 0.749020);
        case lemonchiffon3:
            return Color(0.803922, 0.788235, 0.647059);
        case lemonchiffon4:
            return Color(0.545098, 0.537255, 0.439216);
        case lightgoldenrod1:
            return Color(1.000000, 0.925490, 0.545098);
        case lightgoldenrod2:
            return Color(0.933333, 0.862745, 0.509804);
        case lightgoldenrod3:
            return Color(0.803922, 0.745098, 0.439216);
        case lightgoldenrod4:
            return Color(0.545098, 0.505882, 0.298039);
        case banana:
            return Color(0.890196, 0.811765, 0.341176);
        case gold1:
            return Color(1.000000, 0.843137, 0.000000);
        case gold2:
            return Color(0.933333, 0.788235, 0.000000);
        case gold3:
            return Color(0.803922, 0.678431, 0.000000);
        case gold4:
            return Color(0.545098, 0.458824, 0.000000);
        case cornsilk1:
            return Color(1.000000, 0.972549, 0.862745);
        case cornsilk2:
            return Color(0.933333, 0.909804, 0.803922);
        case cornsilk3:
            return Color(0.803922, 0.784314, 0.694118);
        case cornsilk4:
            return Color(0.545098, 0.533333, 0.470588);
        case goldenrod:
            return Color(0.854902, 0.647059, 0.125490);
        case goldenrod1:
            return Color(1.000000, 0.756863, 0.145098);
        case goldenrod2:
            return Color(0.933333, 0.705882, 0.133333);
        case goldenrod3:
            return Color(0.803922, 0.607843, 0.113725);
        case goldenrod4:
            return Color(0.545098, 0.411765, 0.078431);
        case darkgoldenrod:
            return Color(0.721569, 0.525490, 0.043137);
        case darkgoldenrod1:
            return Color(1.000000, 0.725490, 0.058824);
        case darkgoldenrod2:
            return Color(0.933333, 0.678431, 0.054902);
        case darkgoldenrod3:
            return Color(0.803922, 0.584314, 0.047059);
        case darkgoldenrod4:
            return Color(0.545098, 0.396078, 0.031373);
        case orange1:
            return Color(1.000000, 0.647059, 0.000000);
        case orange2:
            return Color(0.933333, 0.603922, 0.000000);
        case orange3:
            return Color(0.803922, 0.521569, 0.000000);
        case orange4:
            return Color(0.545098, 0.352941, 0.000000);
        case floralwhite:
            return Color(1.000000, 0.980392, 0.941176);
        case oldlace:
            return Color(0.992157, 0.960784, 0.901961);
        case wheat:
            return Color(0.960784, 0.870588, 0.701961);
        case wheat1:
            return Color(1.000000, 0.905882, 0.729412);
        case wheat2:
            return Color(0.933333, 0.847059, 0.682353);
        case wheat3:
            return Color(0.803922, 0.729412, 0.588235);
        case wheat4:
            return Color(0.545098, 0.494118, 0.400000);
        case moccasin:
            return Color(1.000000, 0.894118, 0.709804);
        case papayawhip:
            return Color(1.000000, 0.937255, 0.835294);
        case blanchedalmond:
            return Color(1.000000, 0.921569, 0.803922);
        case navajowhite1:
            return Color(1.000000, 0.870588, 0.678431);
        case navajowhite2:
            return Color(0.933333, 0.811765, 0.631373);
        case navajowhite3:
            return Color(0.803922, 0.701961, 0.545098);
        case navajowhite4:
            return Color(0.545098, 0.474510, 0.368627);
        case eggshell:
            return Color(0.988235, 0.901961, 0.788235);
        case tanN:
            return Color(0.823529, 0.705882, 0.549020);
        case brick:
            return Color(0.611765, 0.400000, 0.121569);
        case cadmiumyellow:
            return Color(1.000000, 0.600000, 0.070588);
        case antiquewhite:
            return Color(0.980392, 0.921569, 0.843137);
        case antiquewhite1:
            return Color(1.000000, 0.937255, 0.858824);
        case antiquewhite2:
            return Color(0.933333, 0.874510, 0.800000);
        case antiquewhite3:
            return Color(0.803922, 0.752941, 0.690196);
        case antiquewhite4:
            return Color(0.545098, 0.513725, 0.470588);
        case burlywood:
            return Color(0.870588, 0.721569, 0.529412);
        case burlywood1:
            return Color(1.000000, 0.827451, 0.607843);
        case burlywood2:
            return Color(0.933333, 0.772549, 0.568627);
        case burlywood3:
            return Color(0.803922, 0.666667, 0.490196);
        case burlywood4:
            return Color(0.545098, 0.450980, 0.333333);
        case bisque1:
            return Color(1.000000, 0.894118, 0.768627);
        case bisque2:
            return Color(0.933333, 0.835294, 0.717647);
        case bisque3:
            return Color(0.803922, 0.717647, 0.619608);
        case bisque4:
            return Color(0.545098, 0.490196, 0.419608);
        case melon:
            return Color(0.890196, 0.658824, 0.411765);
        case carrot:
            return Color(0.929412, 0.568627, 0.129412);
        case darkorange:
            return Color(1.000000, 0.549020, 0.000000);
        case darkorange1:
            return Color(1.000000, 0.498039, 0.000000);
        case darkorange2:
            return Color(0.933333, 0.462745, 0.000000);
        case darkorange3:
            return Color(0.803922, 0.400000, 0.000000);
        case darkorange4:
            return Color(0.545098, 0.270588, 0.000000);
        case orange:
            return Color(1.000000, 0.501961, 0.000000);
        case tan1:
            return Color(1.000000, 0.647059, 0.309804);
        case tan2:
            return Color(0.933333, 0.603922, 0.286275);
        case tan3:
            return Color(0.803922, 0.521569, 0.247059);
        case tan4:
            return Color(0.545098, 0.352941, 0.168627);
        case linen:
            return Color(0.980392, 0.941176, 0.901961);
        case peachpuff1:
            return Color(1.000000, 0.854902, 0.725490);
        case peachpuff2:
            return Color(0.933333, 0.796078, 0.678431);
        case peachpuff3:
            return Color(0.803922, 0.686275, 0.584314);
        case peachpuff4:
            return Color(0.545098, 0.466667, 0.396078);
        case seashell1:
            return Color(1.000000, 0.960784, 0.933333);
        case seashell2:
            return Color(0.933333, 0.898039, 0.870588);
        case seashell3:
            return Color(0.803922, 0.772549, 0.749020);
        case seashell4:
            return Color(0.545098, 0.525490, 0.509804);
        case sandybrown:
            return Color(0.956863, 0.643137, 0.376471);
        case rawsienna:
            return Color(0.780392, 0.380392, 0.078431);
        case chocolate:
            return Color(0.823529, 0.411765, 0.117647);
        case chocolate1:
            return Color(1.000000, 0.498039, 0.141176);
        case chocolate2:
            return Color(0.933333, 0.462745, 0.129412);
        case chocolate3:
            return Color(0.803922, 0.400000, 0.113725);
        case chocolate4:
            return Color(0.545098, 0.270588, 0.074510);
        case ivoryblack:
            return Color(0.160784, 0.141176, 0.129412);
        case flesh:
            return Color(1.000000, 0.490196, 0.250980);
        case cadmiumorange:
            return Color(1.000000, 0.380392, 0.011765);
        case burntsienna:
            return Color(0.541176, 0.211765, 0.058824);
        case sienna:
            return Color(0.627451, 0.321569, 0.176471);
        case sienna1:
            return Color(1.000000, 0.509804, 0.278431);
        case sienna2:
            return Color(0.933333, 0.474510, 0.258824);
        case sienna3:
            return Color(0.803922, 0.407843, 0.223529);
        case sienna4:
            return Color(0.545098, 0.278431, 0.149020);
        case lightsalmon1:
            return Color(1.000000, 0.627451, 0.478431);
        case lightsalmon2:
            return Color(0.933333, 0.584314, 0.447059);
        case lightsalmon3:
            return Color(0.803922, 0.505882, 0.384314);
        case lightsalmon4:
            return Color(0.545098, 0.341176, 0.258824);
        case coral:
            return Color(1.000000, 0.498039, 0.313725);
        case orangered1:
            return Color(1.000000, 0.270588, 0.000000);
        case orangered2:
            return Color(0.933333, 0.250980, 0.000000);
        case orangered3:
            return Color(0.803922, 0.215686, 0.000000);
        case orangered4:
            return Color(0.545098, 0.145098, 0.000000);
        case sepia:
            return Color(0.368627, 0.149020, 0.070588);
        case darksalmon:
            return Color(0.913725, 0.588235, 0.478431);
        case salmon1:
            return Color(1.000000, 0.549020, 0.411765);
        case salmon2:
            return Color(0.933333, 0.509804, 0.384314);
        case salmon3:
            return Color(0.803922, 0.439216, 0.329412);
        case salmon4:
            return Color(0.545098, 0.298039, 0.223529);
        case coral1:
            return Color(1.000000, 0.447059, 0.337255);
        case coral2:
            return Color(0.933333, 0.415686, 0.313725);
        case coral3:
            return Color(0.803922, 0.356863, 0.270588);
        case coral4:
            return Color(0.545098, 0.243137, 0.184314);
        case burntumber:
            return Color(0.541176, 0.200000, 0.141176);
        case tomato1:
            return Color(1.000000, 0.388235, 0.278431);
        case tomato2:
            return Color(0.933333, 0.360784, 0.258824);
        case tomato3:
            return Color(0.803922, 0.309804, 0.223529);
        case tomato4:
            return Color(0.545098, 0.211765, 0.149020);
        case salmon:
            return Color(0.980392, 0.501961, 0.447059);
        case mistyrose1:
            return Color(1.000000, 0.894118, 0.882353);
        case mistyrose2:
            return Color(0.933333, 0.835294, 0.823529);
        case mistyrose3:
            return Color(0.803922, 0.717647, 0.709804);
        case mistyrose4:
            return Color(0.545098, 0.490196, 0.482353);
        case snow1:
            return Color(1.000000, 0.980392, 0.980392);
        case snow2:
            return Color(0.933333, 0.913725, 0.913725);
        case snow3:
            return Color(0.803922, 0.788235, 0.788235);
        case snow4:
            return Color(0.545098, 0.537255, 0.537255);
        case rosybrown:
            return Color(0.737255, 0.560784, 0.560784);
        case rosybrown1:
            return Color(1.000000, 0.756863, 0.756863);
        case rosybrown2:
            return Color(0.933333, 0.705882, 0.705882);
        case rosybrown3:
            return Color(0.803922, 0.607843, 0.607843);
        case rosybrown4:
            return Color(0.545098, 0.411765, 0.411765);
        case lightcoral:
            return Color(0.941176, 0.501961, 0.501961);
        case indianred:
            return Color(0.803922, 0.360784, 0.360784);
        case indianred1:
            return Color(1.000000, 0.415686, 0.415686);
        case indianred2:
            return Color(0.933333, 0.388235, 0.388235);
        case indianred4:
            return Color(0.545098, 0.227451, 0.227451);
        case indianred3:
            return Color(0.803922, 0.333333, 0.333333);
        case brown:
            return Color(0.647059, 0.164706, 0.164706);
        case brown1:
            return Color(1.000000, 0.250980, 0.250980);
        case brown2:
            return Color(0.933333, 0.231373, 0.231373);
        case brown3:
            return Color(0.803922, 0.200000, 0.200000);
        case brown4:
            return Color(0.545098, 0.137255, 0.137255);
        case firebrick:
            return Color(0.698039, 0.133333, 0.133333);
        case firebrick1:
            return Color(1.000000, 0.188235, 0.188235);
        case firebrick2:
            return Color(0.933333, 0.172549, 0.172549);
        case firebrick3:
            return Color(0.803922, 0.149020, 0.149020);
        case firebrick4:
            return Color(0.545098, 0.101961, 0.101961);
        case red1:
            return Color(1.000000, 0.000000, 0.000000);
        case red2:
            return Color(0.933333, 0.000000, 0.000000);
        case red3:
            return Color(0.803922, 0.000000, 0.000000);
        case red4:
            return Color(0.545098, 0.000000, 0.000000);
        case maroon:
            return Color(0.501961, 0.000000, 0.000000);
        case sgibeet:
            return Color(0.556863, 0.219608, 0.556863);
        case sgislateblue:
            return Color(0.443137, 0.443137, 0.776471);
        case sgilightblue:
            return Color(0.490196, 0.619608, 0.752941);
        case sgiteal:
            return Color(0.219608, 0.556863, 0.556863);
        case sgichartreuse:
            return Color(0.443137, 0.776471, 0.443137);
        case sgiolivedrab:
            return Color(0.556863, 0.556863, 0.219608);
        case sgibrightgray:
            return Color(0.772549, 0.756863, 0.666667);
        case sgisalmon:
            return Color(0.776471, 0.443137, 0.443137);
        case sgidarkgray:
            return Color(0.333333, 0.333333, 0.333333);
        case sgigray12:
            return Color(0.117647, 0.117647, 0.117647);
        case sgigray16:
            return Color(0.156863, 0.156863, 0.156863);
        case sgigray32:
            return Color(0.317647, 0.317647, 0.317647);
        case sgigray36:
            return Color(0.356863, 0.356863, 0.356863);
        case sgigray52:
            return Color(0.517647, 0.517647, 0.517647);
        case sgigray56:
            return Color(0.556863, 0.556863, 0.556863);
        case sgilightgray:
            return Color(0.666667, 0.666667, 0.666667);
        case sgigray72:
            return Color(0.717647, 0.717647, 0.717647);
        case sgigray76:
            return Color(0.756863, 0.756863, 0.756863);
        case sgigray92:
            return Color(0.917647, 0.917647, 0.917647);
        case sgigray96:
            return Color(0.956863, 0.956863, 0.956863);
        case white:
            return Color(1.000000, 1.000000, 1.000000);
        case whitesmoke:
            return Color(0.960784, 0.960784, 0.960784);
        case gainsboro:
            return Color(0.862745, 0.862745, 0.862745);
        case lightgrey:
            return Color(0.827451, 0.827451, 0.827451);
        case silver:
            return Color(0.752941, 0.752941, 0.752941);
        case darkgray:
            return Color(0.662745, 0.662745, 0.662745);
        case gray:
            return Color(0.501961, 0.501961, 0.501961);
        case dimgray:
            return Color(0.411765, 0.411765, 0.411765);
        case black:
            return Color(0.000000, 0.000000, 0.000000);
        case gray99:
            return Color(0.988235, 0.988235, 0.988235);
        case gray98:
            return Color(0.980392, 0.980392, 0.980392);
        case gray97:
            return Color(0.968627, 0.968627, 0.968627);
        case gray95:
            return Color(0.949020, 0.949020, 0.949020);
        case gray94:
            return Color(0.941176, 0.941176, 0.941176);
        case gray93:
            return Color(0.929412, 0.929412, 0.929412);
        case gray92:
            return Color(0.921569, 0.921569, 0.921569);
        case gray91:
            return Color(0.909804, 0.909804, 0.909804);
        case gray90:
            return Color(0.898039, 0.898039, 0.898039);
        case gray89:
            return Color(0.890196, 0.890196, 0.890196);
        case gray88:
            return Color(0.878431, 0.878431, 0.878431);
        case gray87:
            return Color(0.870588, 0.870588, 0.870588);
        case gray86:
            return Color(0.858824, 0.858824, 0.858824);
        case gray85:
            return Color(0.850980, 0.850980, 0.850980);
        case gray84:
            return Color(0.839216, 0.839216, 0.839216);
        case gray83:
            return Color(0.831373, 0.831373, 0.831373);
        case gray82:
            return Color(0.819608, 0.819608, 0.819608);
        case gray81:
            return Color(0.811765, 0.811765, 0.811765);
        case gray80:
            return Color(0.800000, 0.800000, 0.800000);
        case gray79:
            return Color(0.788235, 0.788235, 0.788235);
        case gray78:
            return Color(0.780392, 0.780392, 0.780392);
        case gray77:
            return Color(0.768627, 0.768627, 0.768627);
        case gray76:
            return Color(0.760784, 0.760784, 0.760784);
        case gray75:
            return Color(0.749020, 0.749020, 0.749020);
        case gray74:
            return Color(0.741176, 0.741176, 0.741176);
        case gray73:
            return Color(0.729412, 0.729412, 0.729412);
        case gray72:
            return Color(0.721569, 0.721569, 0.721569);
        case gray71:
            return Color(0.709804, 0.709804, 0.709804);
        case gray70:
            return Color(0.701961, 0.701961, 0.701961);
        case gray69:
            return Color(0.690196, 0.690196, 0.690196);
        case gray68:
            return Color(0.678431, 0.678431, 0.678431);
        case gray67:
            return Color(0.670588, 0.670588, 0.670588);
        case gray66:
            return Color(0.658824, 0.658824, 0.658824);
        case gray65:
            return Color(0.650980, 0.650980, 0.650980);
        case gray64:
            return Color(0.639216, 0.639216, 0.639216);
        case gray63:
            return Color(0.631373, 0.631373, 0.631373);
        case gray62:
            return Color(0.619608, 0.619608, 0.619608);
        case gray61:
            return Color(0.611765, 0.611765, 0.611765);
        case gray60:
            return Color(0.600000, 0.600000, 0.600000);
        case gray59:
            return Color(0.588235, 0.588235, 0.588235);
        case gray58:
            return Color(0.580392, 0.580392, 0.580392);
        case gray57:
            return Color(0.568627, 0.568627, 0.568627);
        case gray56:
            return Color(0.560784, 0.560784, 0.560784);
        case gray55:
            return Color(0.549020, 0.549020, 0.549020);
        case gray54:
            return Color(0.541176, 0.541176, 0.541176);
        case gray53:
            return Color(0.529412, 0.529412, 0.529412);
        case gray52:
            return Color(0.521569, 0.521569, 0.521569);
        case gray51:
            return Color(0.509804, 0.509804, 0.509804);
        case gray50:
            return Color(0.498039, 0.498039, 0.498039);
        case gray49:
            return Color(0.490196, 0.490196, 0.490196);
        case gray48:
            return Color(0.478431, 0.478431, 0.478431);
        case gray47:
            return Color(0.470588, 0.470588, 0.470588);
        case gray46:
            return Color(0.458824, 0.458824, 0.458824);
        case gray45:
            return Color(0.450980, 0.450980, 0.450980);
        case gray44:
            return Color(0.439216, 0.439216, 0.439216);
        case gray43:
            return Color(0.431373, 0.431373, 0.431373);
        case gray42:
            return Color(0.419608, 0.419608, 0.419608);
        case dimgay:
            return Color(0.411765, 0.411765, 0.411765);
        case gray40:
            return Color(0.400000, 0.400000, 0.400000);
        case gray39:
            return Color(0.388235, 0.388235, 0.388235);
        case gray38:
            return Color(0.380392, 0.380392, 0.380392);
        case gray37:
            return Color(0.368627, 0.368627, 0.368627);
        case gray36:
            return Color(0.360784, 0.360784, 0.360784);
        case gray35:
            return Color(0.349020, 0.349020, 0.349020);
        case gray34:
            return Color(0.341176, 0.341176, 0.341176);
        case gray33:
            return Color(0.329412, 0.329412, 0.329412);
        case gray32:
            return Color(0.321569, 0.321569, 0.321569);
        case gray31:
            return Color(0.309804, 0.309804, 0.309804);
        case gray30:
            return Color(0.301961, 0.301961, 0.301961);
        case gray29:
            return Color(0.290196, 0.290196, 0.290196);
        case gray28:
            return Color(0.278431, 0.278431, 0.278431);
        case gray27:
            return Color(0.270588, 0.270588, 0.270588);
        case gray26:
            return Color(0.258824, 0.258824, 0.258824);
        case gray25:
            return Color(0.250980, 0.250980, 0.250980);
        case gray24:
            return Color(0.239216, 0.239216, 0.239216);
        case gray23:
            return Color(0.231373, 0.231373, 0.231373);
        case gray22:
            return Color(0.219608, 0.219608, 0.219608);
        case gray21:
            return Color(0.211765, 0.211765, 0.211765);
        case gray20:
            return Color(0.200000, 0.200000, 0.200000);
        case gray19:
            return Color(0.188235, 0.188235, 0.188235);
        case gray18:
            return Color(0.180392, 0.180392, 0.180392);
        case gray17:
            return Color(0.168627, 0.168627, 0.168627);
        case gray16:
            return Color(0.160784, 0.160784, 0.160784);
        case gray15:
            return Color(0.149020, 0.149020, 0.149020);
        case gray14:
            return Color(0.141176, 0.141176, 0.141176);
        case gray13:
            return Color(0.129412, 0.129412, 0.129412);
        case gray12:
            return Color(0.121569, 0.121569, 0.121569);
        case gray11:
            return Color(0.109804, 0.109804, 0.109804);
        case gray10:
            return Color(0.101961, 0.101961, 0.101961);
        case gray9:
            return Color(0.090196, 0.090196, 0.090196);
        case gray8:
            return Color(0.078431, 0.078431, 0.078431);
        case gray7:
            return Color(0.070588, 0.070588, 0.070588);
        case gray6:
            return Color(0.058824, 0.058824, 0.058824);
        case gray5:
            return Color(0.050980, 0.050980, 0.050980);
        case gray4:
            return Color(0.039216, 0.039216, 0.039216);
        case gray3:
            return Color(0.031373, 0.031373, 0.031373);
        case gray2:
            return Color(0.019608, 0.019608, 0.019608);
        case gray1:
            return Color(0.011765, 0.011765, 0.011765);
        default:
            NSLog(@"Not a valid color\n");
            return Color(0.0, 0.0, 0.0);
    }    
}
