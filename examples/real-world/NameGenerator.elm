module NameGenerator exposing (ship)

import Array
import Dict
import LexicalRandom
import Random
import String.Extra


defaultLexicon =
    LexicalRandom.fromString """

# These phonems have been generated from a dictionary of common english words.
# I think that using a dictionary of proper nouns only would yield better
# results, but for now will do.

# Note that this dictionary uses a "color" entry, but does NOT define it.
# In this way, we can manually insert the entry with the actual color of the
# ship! (See the code below to see how this is done)

ini
    in,re,un,con,de,dis,ex,im,an,com,en,al,pro,pre,per,over,as,ar,di,mis,be,ac,sub,ad,ma,mar,car,out,ap,au,or,for,ob,
    par,co,se,em,man,vi,non,am,mo,su,ab,cor,ca,pa,es,hy,can,bar,mi,col,so,mon,at,up,ir,ver,ra,mer,lu,gen,trans,pe,ro,
    po,op,ter,sen,fore,coun,pen,el,cal,af,no,fa,bi,mag,hu,min,mu,mul,back,har,ju,eu,tran,ten,pi,gar,ed,cat,mil,li,sun,
    lo,pan,hand,fer,sur,her,elec,la,os,mal,ef,ag,fi,ban,to,pu,mor,wa,cu,cir,me,nu,ge,tri,tor,du,cen,sa,home,head,va,mas,
    il,mid,er,wood,win,oc,mod,cur,syn,na,pur,hon,of,sup,bur,uni,do,hi,lin,pri,psy,the,pas,pho,black,char,cre,pal,ho,
    mc,cas,sym,ser,air,ru,san,ne,men,down,he,tu,tem,sta,fu,fire,ba,sim,tan,por,sec,is,cap,para,cam,poly,work,post,sul,
    rec,hor,des,ve,le,hol,fal,cru,res,house,short,sal,gal

mid
    i,ti,a,o,er,ter,u,ri,to,si,cal,di,ca,al,ta,li,ni,tion,per,der,ra,tu,e,ful,na,ma,la,ing,fi,sa,ci,ous,con,is,en,re,
    mi,men,bil,less,cu,tri,ten,te,tive,pi,mo,po,pa,sive,ber,bi,ish,com,man,gi,de,tal,vi,ga,va,in,ro,tra,ed,an,pe,ver,
    so,den,pen,pos,tro,mu,pli,wom,mat,or,le,son,lar,lu,no,nal,sion,fer,co,gen,for,cious,pro,log,cep,lo,ac,tis,cen,ar,
    pre,sen,hous,ces,mer,mis,da,el,ol,se,tar,fec,sis,ge,duc,su,por,ven,dis,tur,do,pres,ger,struc,jec,tan,ne,as,tle,
    me,go,tain,ba,mon,ex,tic,cil,tor,par,il,tiv,graph,cial,sti,cel,tial,gan,cis,ton,gu,cer,be,nis,car,y,low,cum,at,
    thet,sur,til,ser,abil,wor,nu,tin,tious,ble,fa,cus,bu,nar,mar,mal,met,rec,ple,pu,alis,lec,ap,nom,the,sid,vis,
    ness,cul,pri,cur,hen,cre,dic,ner,mor,tol,can,tel,ui,fu,cy,trac,lous

end
    ly,es,ness,er,est,ers,tions,ty,tion,able,ic,ings,ments,ry,ties,tors,al,cal,man,ters,less,cy,ous,tive,ful,men,
    ates,ble,an,tic,ists,gy,na,ies,sions,son,ans,ta,ment,ton,ism,ries,ics,bles,bly,als,fies,fy,la,da,en,lates,
    tives,ders,ny,ably,tures,cies,pers,sive,ish,ter,cates,ley,tal,sis,dles,gles,ery,by,to,gists,ens,nates,nia,
    tles,ma,cles,lies,tics,um,my,ways,do,land,ra,sion,ca,las,cious,gers,gies,lar,ages,bers,nal,ets,gates,ums,
    ship,els,boards,tates,les,tial,heads,mas,sy,py,den,ples,der,dy,lines,ka,tos,tious,nas,lo,ary,co,rates,phy,
    tary,some,mates,ti,ships,lets,nies,its,lands,try,va,ses,cent,ni,tis,rooms,nous,sors,work,backs,lars,line,
    stones,fuls,dents,tine,outs,tals,wood,wards,tons,ances,ners,cals,sia,ba,cians,ors,go,thy,sides,ki,lous,di,
    mers,ia,cence,ent,phers,dies,most,ga,sons,ons,downs,mi,sters,lows,dos,on,balls,lent,tus,ate,grams,ten,ables,
    ture,dence,los,ford,bies,nals,holes,nary,sa,sures

properNoun
    {ini}{end}
    {ini}{mid}{end}

adverb
    always,inevitably,necessarily,surely,inescapably,assuredly

superlativeAdjective
    flawless,victorious,favoured,triumphant,successful,fortunate,lucky,outstanding,strong
    auspicious,crowned,extraordinary,unbeaten,undefeated,unconquered,prevailing,excellent,superior,greatest
    illustrious,splendid,fierce
    amazing,awesome,excellent,fabulous,fantastic,favorable,fortuitous,ineffable,perfect,propitious,spectacular,wondrous

genericAdjective
    mighty,great,straight,lightning

noun
    champion,challenger,defender,conqueror,guardian,paladin,vanquisher,victor,warrior,augury
    hammer,mallet,anvil
    sword,mercy
    blade,sabre,dagger,scimitar,foil,glaive
    arrow
    fury,anger,wrath,storm,lightning,thunder,omen,vengeance
    light,sunrise,peace
    Sun,Moon,Daystar
    cross,


potentiallyQualifiedNoun
    {noun}
    {noun}
    {noun} of {properNoun}
    {noun} of {properNoun}
    {noun} of the Gods

exalted
    {adverb} {superlativeAdjective}
    {adverb} {superlativeAdjective} {potentiallyQualifiedNoun}
    {superlativeAdjective} {potentiallyQualifiedNoun}

ship
    {noun}
    {genericAdjective} {properNoun}
    {properNoun}
    {color} {properNoun}
    {color} {properNoun}
    {genericAdjective} {noun}
    {color} {noun}
    {color} {noun}
    {superlativeAdjective}
    {exalted}

fleet
    {color} Fleet
    {properNoun} Fleet
    {noun} Fleet

red
    red,ruby,crimson,vermillion,fiery,sanguine,burning,searing,

green
    green,verdant,emerald,jade,lime,viridian

blue
    blue,sapphire,cerulean,cobalt,ultramarine

cyan
    azure,cerulean,sky,pale

purple
    purple,lilac,violet,amethyst

yellow
    yellow,amber,chrome,ivory,gold,golden,saffron,sand
"""


{-| Let's say that our startship is yellow.

The function will add an entry to the dictionary corresponding to

    color
        yellow

In this way, whenever a definition above uses {color}, it will fall back to
the "yellow" entry, picking randomly among "yellow", "amber", "chrome" etc..

-}
ship : String -> Random.Generator String
ship colorName =
    let
        fragment =
            LexicalRandom.Key colorName

        definition =
            [ fragment ]

        entry =
            Array.fromList
                [ definition ]

        lexicon =
            Dict.insert "color" entry defaultLexicon
    in
        LexicalRandom.generator "---" lexicon "ship"
            |> Random.map String.Extra.toTitleCase
