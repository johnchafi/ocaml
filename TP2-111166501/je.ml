(***************************************************************************)
(* Jeu d'essai pour TP2 - ÉTÉ 2020                                         *)
(***************************************************************************)

(* On charge le fichier ml du Tp après avoir implanté
les méthodes demandées pour realiser les tests  *)

#use "TP2-E2020.ml";;
(* Résultat:
module PaireCles :
  sig
    type t = string * string
    val compare : String.t * String.t -> String.t * String.t -> int
  end
module SCoronaMap :
  sig
    type key = PaireCles.t
    type 'a t = 'a Map.Make(PaireCles).t
    val empty : 'a t
    val is_empty : 'a t -> bool
    val mem : key -> 'a t -> bool
    val add : key -> 'a -> 'a t -> 'a t
    val update : key -> ('a option -> 'a option) -> 'a t -> 'a t
    val singleton : key -> 'a -> 'a t
    val remove : key -> 'a t -> 'a t
    val merge :
      (key -> 'a option -> 'b option -> 'c option) -> 'a t -> 'b t -> 'c t
    val union : (key -> 'a -> 'a -> 'a option) -> 'a t -> 'a t -> 'a t
    val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
    val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
    val iter : (key -> 'a -> unit) -> 'a t -> unit
    val fold : (key -> 'a -> 'b -> 'b) -> 'a t -> 'b -> 'b
    val for_all : (key -> 'a -> bool) -> 'a t -> bool
    val exists : (key -> 'a -> bool) -> 'a t -> bool
    val filter : (key -> 'a -> bool) -> 'a t -> 'a t
    val partition : (key -> 'a -> bool) -> 'a t -> 'a t * 'a t
    val cardinal : 'a t -> int
    val bindings : 'a t -> (key * 'a) list
    val min_binding : 'a t -> key * 'a
    val min_binding_opt : 'a t -> (key * 'a) option
    val max_binding : 'a t -> key * 'a
    val max_binding_opt : 'a t -> (key * 'a) option
    val choose : 'a t -> key * 'a
    val choose_opt : 'a t -> (key * 'a) option
    val split : key -> 'a t -> 'a t * 'a option * 'a t
    val find : key -> 'a t -> 'a
    val find_opt : key -> 'a t -> 'a option
    val find_first : (key -> bool) -> 'a t -> key * 'a
    val find_first_opt : (key -> bool) -> 'a t -> (key * 'a) option
    val find_last : (key -> bool) -> 'a t -> key * 'a
    val find_last_opt : (key -> bool) -> 'a t -> (key * 'a) option
    val map : ('a -> 'b) -> 'a t -> 'b t
    val mapi : (key -> 'a -> 'b) -> 'a t -> 'b t
    val to_seq : 'a t -> (key * 'a) Seq.t
    val to_seq_from : key -> 'a t -> (key * 'a) Seq.t
    val add_seq : (key * 'a) Seq.t -> 'a t -> 'a t
    val of_seq : (key * 'a) Seq.t -> 'a t
  end
val appartient : 'a -> 'a list -> bool = <fun>
val enlever : 'a -> 'a list -> 'a list = <fun>
val remplacer : 'a -> 'a -> 'a list -> 'a list = <fun>
val uniques : string List.t -> string List.t = <fun>
val decouper_chaine : char -> string -> string List.t = <fun>
val explode : string -> char List.t = <fun>
val enlever_char : string -> char -> string = <fun>
val timeRun : ('a -> 'b) -> 'a -> 'b * float = <fun>
val lire_ligne : in_channel -> string = <fun>
val lire_fichier : in_channel -> char -> string List.t List.t = <fun>
module type TP2E20 =
  sig
    class sCorona :
      string list ->
      object
        val cas_actifs : int
        val cas_confirmes : int
        val cas_decedes : int
        val cas_retablis : int
        val derniere_mise_a_jour : string
        val lat : float
        val long : float
        val nom_comte : string
        val pays_region : string
        val province_etat : string
        method get_cas_actifs : int
        method get_cas_confirmes : int
        method get_cas_decedes : int
        method get_cas_retablis : int
        method get_derniere_mise_a_jour : string
        method get_lat : float
        method get_long : float
        method get_nom_comte : string
        method get_pays_region : string
        method get_province_etat : string
        method retourner_chaine_sCorona : string
      end
    class sysRecherche_Virus :
      string ->
      string ->
      object
        val origine_donnees : string
        val type_virus : string
        method get_origine_donnees : string
        method get_type_virus : string
      end
    class sysRecherche_Coronavirus :
      string ->
      string ->
      object
        val mutable map_sCoronas : sCorona SCoronaMap.t ref
        val origine_donnees : string
        val type_virus : string
        method ajouter_liste_sCoronas : string List.t List.t -> unit
        method ajouter_sCorona : string list -> unit
        method charger_donnees : string -> unit
        method get_map_sCoronas : sCorona SCoronaMap.t ref
        method get_origine_donnees : string
        method get_type_virus : string
        method retourner_chaine_info_pays : string -> int -> string
        method retourner_chaine_liste_sCoronas : sCorona list -> string
        method retourner_chaine_resultats_ordonnes : int -> string
        method retourner_chaine_sommes_donnees_pays : string -> string
        method retourner_donnees : sCorona list
        method retourner_donnees_pays : string -> sCorona list
        method retourner_nbr_sCoronas : int
        method retourner_noms_pays_distincts_ordonnes : string list
        method retourner_sCorona : string * string -> sCorona
        method retourner_somme_donnees_pays : string -> int -> int
        method set_map_sCoronas : sCorona SCoronaMap.t ref -> unit
        method supprimer_liste_sCoronas : (string * string) list -> unit
        method supprimer_sCorona : string * string -> unit
      end
    class app_sysCorona :
      string ->
      string ->
      string ->
      object
        val nom_fichier : string
        val mutable sysR : sysRecherche_Coronavirus
        method get_sysR : sysRecherche_Coronavirus
        method lancer_app_sCorona : unit
        method set_sysR : sysRecherche_Coronavirus -> unit
      end
  end
module Tp2e20 : TP2E20
*)

(* On ouvre le module du TP *)
open Tp2e20;;

(* On exécute maintenant les méthodes une à une *)

let sc = new sysRecherche_Coronavirus "Covid19" "Repository of the CSSE at Johns Hopkins University";;

(* Résultat:
Recherche des donnees dans Repository of the CSSE at Johns Hopkins University pour le type de virus: Covid19.
val sc : Tp2e20.sysRecherche_Coronavirus = <obj>
*)

let sCorona1 = new sCorona ["";"";"Quebec";"Canada";"2020-06-19 04:33:17";
                            "52.9399";"-73.54911";"54383";"5340";"22754";"26289";
                            "Quebec, Canada"];;


(* Résultat:
val sCorona1 : Tp2e20.sCorona = <obj>
*)

print_string (sCorona1#retourner_chaine_sCorona);;

(* Résultat:
Province ou etat: Quebec
Pays ou region: Canada
Derniere mise a jour: 2020-06-19 04:33:17
Lat et Long: 52.9399 -73.54911
Cas confirmes: 54383
Cas decedes: 5340
Cas retablis: 22754
Cas actifs: 26289
- : unit = ()
*)

let sCorona2 = new sCorona ["";"";"Kirov Oblast";"Russia";"2020-06-19 04:33:17";
                            "57.9665589";"49.4074599";"2734";"28";"1986";"720";
                            "Kirov Oblast, Russia"];;

(* Résultat:
val sCorona2 : Tp2e20.sCorona = <obj>
*)

print_string (sc#retourner_chaine_liste_sCoronas [sCorona1;sCorona2]);;




(* Résultat:
Province ou etat: Quebec
Pays ou region: Canada
Derniere mise a jour: 2020-06-19 04:33:17
Lat et Long: 52.9399 -73.54911
Cas confirmes: 54383
Cas decedes: 5340
Cas retablis: 22754
Cas actifs: 26289

Province ou etat: Kirov Oblast
Pays ou region: Russia
Derniere mise a jour: 2020-06-19 04:33:17
Lat et Long: 57.9665589 49.4074599
Cas confirmes: 2734
Cas decedes: 28
Cas retablis: 1986
Cas actifs: 720

- : unit = (
*)


sc#ajouter_sCorona  ["";"";"Colima";"Mexico";"2020-06-19 04:33:17";
                            "19.1223";"-104.0072";"339";"42";"208";"89";
                            "Colima, Mexico"];;

(* Résultat:
- : unit = ()
*)

let nc= sc#retourner_nbr_sCoronas;;

(* Résultat:
val nc : int = 1
*)

sc#ajouter_liste_sCoronas [["";"";"";"Zimbabwe";"2020-06-19 04:33:17";
                            "-19.015438";"29.154857";"463";"4";"63";"396";
                            "Zimbabwe"];
                          ["";"";"";"Portugal";"2020-06-19 04:33:17";
                            "39.3999";"-8.2245";"38089";"1524";"24010";"12555";
                            "Portugal"]];;

(* Résultat:
- : unit = ()
*)

let nc= sc#retourner_nbr_sCoronas;;

(* Résultat:
val nc : int = 3
*)

sc#supprimer_sCorona ("Colima","Mexico");;

(* Résultat:
- : unit = ()
*)

let nc= sc#retourner_nbr_sCoronas;;

(* Résultat:
val nc : int = 2
*)


sc#supprimer_liste_sCoronas [("","Zimbabwe");
                            ("","Portugal")];;

(* Résultat:
- : unit = ()
*)

let nc= sc#retourner_nbr_sCoronas;;

(* Résultat:
val nc : int = 0
*)

(* Source des données:
https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_daily_reports/06-23-2020.csv
*)
sc#charger_donnees "data-06-23-2020.csv";;


(* Résultat:
- : unit = ()
*)

let nc= sc#retourner_nbr_sCoronas;;

(* Résultat:
val nc : int = 3761
*)

sc#retourner_donnees;;

(* Résultat:
- : Tp2e20.sCorona list =
[<obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>;
 <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>;
 <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>;
 <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>;
 <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>;
 <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>;
 <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>;
 <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>;
 <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>;
 <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>;
 <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>;
 <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>;
 <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>;
 <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; ...]
*)

let cqc = sc#retourner_sCorona ("Quebec","Canada");;

(* Résultat:
val cqc : Tp2e20.sCorona = <obj>
*)


let lp = sc#retourner_donnees_pays "Canada";;
let nc = List.length lp;;

(* Résultat:
val lp : Tp2e20.sCorona list =
  [<obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>; <obj>;
   <obj>; <obj>; <obj>; <obj>]
# val nc : int = 14
*)


let lc1 = sc#retourner_chaine_info_pays "Canada" 1;;
print_string lc1;;
let lc2 = sc#retourner_chaine_info_pays "Canada" 2;;
print_string lc2;;
let lc3 = sc#retourner_chaine_info_pays "Canada" 3;;
print_string lc3;;
let lc4 = sc#retourner_chaine_info_pays "Canada" 4;;
print_string lc4;;

(* Résultat:
val lc1 : string =
  "Pays: Canada\nDerniere mise a jour: 2020-06-24 04:33:28\nCas confirmes: 103767\n"
# Pays: Canada
Derniere mise a jour: 2020-06-24 04:33:28
Cas confirmes: 103767
- : unit = ()
# val lc2 : string =
  "Pays: Canada\nDerniere mise a jour: 2020-06-24 04:33:28\nCas decedes: 8512\n"
# Pays: Canada
Derniere mise a jour: 2020-06-24 04:33:28
Cas decedes: 8512
- : unit = ()
# val lc3 : string =
  "Pays: Canada\nDerniere mise a jour: 2020-06-24 04:33:28\nCas retablis: 66135\n"
# Pays: Canada
Derniere mise a jour: 2020-06-24 04:33:28
Cas retablis: 66135
- : unit = ()
# val lc4 : string =
  "Pays: Canada\nDerniere mise a jour: 2020-06-24 04:33:28\nCas actifs: 29120\n"
# Pays: Canada
Derniere mise a jour: 2020-06-24 04:33:28
Cas actifs: 29120
- : unit = ()
*)

let lu = sc#retourner_chaine_sommes_donnees_pays "US";;
print_string lu;;

(* Résultat:
val lu : string =
  "Pays: US\nDerniere mise a jour: 2020-06-24 04:33:28\nCas confirmes: 2347022\nCas decedes: 121228\nCas retablis: 647548\nCas actifs: 1510931\n"
# Pays: US
Derniere mise a jour: 2020-06-24 04:33:28
Cas confirmes: 2347022
Cas decedes: 121228
Cas retablis: 647548
Cas actifs: 1510931
- : unit = ()
*)

sc#retourner_noms_pays_distincts_ordonnes;;

(* Résultat:
- : string list =
["Afghanistan"; "Albania"; "Algeria"; "Andorra"; "Angola";
 "Antigua and Barbuda"; "Argentina"; "Armenia"; "Australia"; "Austria";
 "Azerbaijan"; "Bahamas"; "Bahrain"; "Bangladesh"; "Barbados"; "Belarus";
 "Belgium"; "Belize"; "Benin"; "Bhutan"; "Bolivia"; "Bosnia and Herzegovina";
 "Botswana"; "Brazil"; "Brunei"; "Bulgaria"; "Burkina Faso"; "Burma";
 "Burundi"; "Cabo Verde"; "Cambodia"; "Cameroon"; "Canada";
 "Central African Republic"; "Chad"; "Chile"; "China"; "Colombia"; "Comoros";
 "Congo (Brazzaville)"; "Congo (Kinshasa)"; "Costa Rica"; "Cote d'Ivoire";
 "Croatia"; "Cuba"; "Cyprus"; "Czechia"; "Denmark"; "Diamond Princess";
 "Djibouti"; "Dominica"; "Dominican Republic"; "Ecuador"; "Egypt";
 "El Salvador"; "Equatorial Guinea"; "Eritrea"; "Estonia"; "Eswatini";
 "Ethiopia"; "Fiji"; "Finland"; "France"; "Gabon"; "Gambia"; "Georgia";
 "Germany"; "Ghana"; "Greece"; "Grenada"; "Guatemala"; "Guinea";
 "Guinea-Bissau"; "Guyana"; "Haiti"; "Holy See"; "Honduras"; "Hungary";
 "Iceland"; "India"; "Indonesia"; "Iran"; "Iraq"; "Ireland"; "Israel";
 "Italy"; "Jamaica"; "Japan"; "Jordan"; "Kazakhstan"; "Kenya"; "Korea South";
 "Kosovo"; "Kuwait"; "Kyrgyzstan"; "Laos"; "Latvia"; "Lebanon"; "Lesotho";
 "Liberia"; "Libya"; "Liechtenstein"; "Lithuania"; "Luxembourg";
 "MS Zaandam"; "Madagascar"; "Malawi"; "Malaysia"; "Maldives"; "Mali";
 "Malta"; "Mauritania"; "Mauritius"; "Mexico"; "Moldova"; "Monaco";
 "Mongolia"; "Montenegro"; "Morocco"; "Mozambique"; "Namibia"; "Nepal";
 "Netherlands"; "New Zealand"; "Nicaragua"; "Niger"; "Nigeria";
 "North Macedonia"; "Norway"; "Oman"; "Pakistan"; "Panama";
 "Papua New Guinea"; "Paraguay"; "Peru"; "Philippines"; "Poland"; "Portugal";
 "Qatar"; "Romania"; "Russia"; "Rwanda"; "Saint Kitts and Nevis";
 "Saint Lucia"; "Saint Vincent and the Grenadines"; "San Marino";
 "Sao Tome and Principe"; "Saudi Arabia"; "Senegal"; "Serbia"; "Seychelles";
 "Sierra Leone"; "Singapore"; "Slovakia"; "Slovenia"; "Somalia";
 "South Africa"; "South Sudan"; "Spain"; "Sri Lanka"; "Sudan"; "Suriname";
 "Sweden"; "Switzerland"; "Syria"; "Taiwan*"; "Tajikistan"; "Tanzania";
 "Thailand"; "Timor-Leste"; "Togo"; "Trinidad and Tobago"; "Tunisia";
 "Turkey"; "US"; "Uganda"; "Ukraine"; "United Arab Emirates";
 "United Kingdom"; "Uruguay"; "Uzbekistan"; "Venezuela"; "Vietnam";
 "West Bank and Gaza"; "Western Sahara"; "Yemen"; "Zambia"; "Zimbabwe"]
*)

sc#retourner_somme_donnees_pays "Brazil" 1;;
sc#retourner_somme_donnees_pays "Brazil" 2;;
sc#retourner_somme_donnees_pays "Brazil" 3;;
sc#retourner_somme_donnees_pays "Brazil" 4;;

(* Résultat:
- : int = 1145906
# - : int = 52645
# - : int = 627963
# - : int = 465298
*)

let lcp = sc#retourner_chaine_resultats_ordonnes 1;;
print_string lcp;;

(* Résultat:
val lcp : string =
  "Numero 1: US = 2347022\nNumero 2: Brazil = 1145906\nNumero 3: Russia = 598878\nNumero 4: India = 456183\nNumero 5: United Kingdom = 307682\nNumero 6: Peru = 260810\nNumero 7: Chile = 250767\nNumero 8: Spain = 246752\nNumero 9: Italy = 238833\nNumero 10: Iran = 209970\nNumero 11: France = 197804\nNumero 12: Ge"... (* string length 5245; truncated *)
# Numero 1: US = 2347022
Numero 2: Brazil = 1145906
Numero 3: Russia = 598878
Numero 4: India = 456183
Numero 5: United Kingdom = 307682
Numero 6: Peru = 260810
Numero 7: Chile = 250767
Numero 8: Spain = 246752
Numero 9: Italy = 238833
Numero 10: Iran = 209970
Numero 11: France = 197804
Numero 12: Germany = 192480
Numero 13: Mexico = 191410
Numero 14: Turkey = 190165
Numero 15: Pakistan = 188926
Numero 16: Saudi Arabia = 164144
Numero 17: Bangladesh = 119198
Numero 18: South Africa = 106108
Numero 19: Canada = 103767
Numero 20: Qatar = 89579
Numero 21: China = 84653
Numero 22: Colombia = 73760
Numero 23: Sweden = 60837
Numero 24: Belgium = 60810
Numero 25: Belarus = 59487
Numero 26: Egypt = 58141
Numero 27: Ecuador = 51643
Numero 28: Netherlands = 49930
Numero 29: Indonesia = 47896
Numero 30: Argentina = 47203
Numero 31: United Arab Emirates = 45683
Numero 32: Singapore = 42432
Numero 33: Kuwait = 41033
Numero 34: Portugal = 39737
Numero 35: Ukraine = 38901
Numero 36: Iraq = 34502
Numero 37: Poland = 32527
Numero 38: Oman = 32394
Numero 39: Philippines = 31825
Numero 40: Switzerland = 31332
Numero 41: Afghanistan = 29481
Numero 42: Dominican Republic = 27936
Numero 43: Panama = 27314
Numero 44: Bolivia = 26389
Numero 45: Ireland = 25391
Numero 46: Romania = 24505
Numero 47: Bahrain = 23062
Numero 48: Israel = 21512
Numero 49: Nigeria = 21371
Numero 50: Armenia = 21006
Numero 51: Kazakhstan = 18765
Numero 52: Japan = 17879
Numero 53: Austria = 17408
Numero 54: Moldova = 14714
Numero 55: Ghana = 14568
Numero 56: Guatemala = 14540
Numero 57: Honduras = 13943
Numero 58: Azerbaijan = 13715
Numero 59: Serbia = 13092
Numero 60: Denmark = 12761
Numero 61: Korea South = 12535
Numero 62: Cameroon = 12270
Numero 63: Algeria = 12076
Numero 64: Czechia = 10650
Numero 65: Morocco = 10344
Numero 66: Nepal = 10099
Numero 67: Sudan = 8889
Numero 68: Norway = 8772
Numero 69: Malaysia = 8590
Numero 70: Cote d'Ivoire = 7904
Numero 71: Australia = 7521
Numero 72: Finland = 7155
Numero 73: Uzbekistan = 6662
Numero 74: Senegal = 6034
Numero 75: Congo (Kinshasa) = 6027
Numero 76: Tajikistan = 5567
Numero 77: Haiti = 5324
Numero 78: North Macedonia = 5311
Numero 79: Guinea = 5040
Numero 80: El Salvador = 4973
Numero 81: Kenya = 4952
Numero 82: Gabon = 4849
Numero 83: Ethiopia = 4848
Numero 84: Djibouti = 4617
Numero 85: Venezuela = 4187
Numero 86: Luxembourg = 4133
Numero 87: Bulgaria = 4114
Numero 88: Hungary = 4107
Numero 89: Kyrgyzstan = 3726
Numero 90: Bosnia and Herzegovina = 3588
Numero 91: Greece = 3302
Numero 92: Mauritania = 3292
Numero 93: Thailand = 3156
Numero 94: Central African Republic = 3051
Numero 95: Somalia = 2812
Numero 96: Costa Rica = 2368
Numero 97: Croatia = 2366
Numero 98: Cuba = 2318
Numero 99: Maldives = 2238
Numero 100: Nicaragua = 2170
Numero 101: Kosovo = 2169
Numero 102: Albania = 2047
Numero 103: Sri Lanka = 1991
Numero 104: Estonia = 1982
Numero 105: Mali = 1978
Numero 106: South Sudan = 1930
Numero 107: Iceland = 1824
Numero 108: Lithuania = 1803
Numero 109: Madagascar = 1724
Numero 110: Equatorial Guinea = 1664
Numero 111: Lebanon = 1622
Numero 112: Slovakia = 1589
Numero 113: Guinea-Bissau = 1556
Numero 114: Slovenia = 1534
Numero 115: New Zealand = 1516
Numero 116: Zambia = 1477
Numero 117: Paraguay = 1422
Numero 118: Sierra Leone = 1347
Numero 119: West Bank and Gaza = 1169
Numero 120: Tunisia = 1159
Numero 121: Latvia = 1111
Numero 122: Congo (Brazzaville) = 1087
Numero 123: Niger = 1051
Numero 124: Jordan = 1047
Numero 125: Yemen = 992
Numero 126: Cyprus = 990
Numero 127: Cabo Verde = 982
Numero 128: Georgia = 911
Numero 129: Burkina Faso = 907
Numero 130: Uruguay = 885
Numero 131: Chad = 860
Numero 132: Andorra = 855
Numero 133: Benin = 850
Numero 134: Malawi = 803
Numero 135: Rwanda = 798
Numero 136: Uganda = 797
Numero 137: Mozambique = 757
Numero 138: Diamond Princess = 712
Numero 139: Sao Tome and Principe = 707
Numero 140: San Marino = 698
Numero 141: Eswatini = 674
Numero 142: Jamaica = 670
Numero 143: Malta = 665
Numero 144: Liberia = 652
Numero 145: Libya = 639
Numero 146: Togo = 576
Numero 147: Zimbabwe = 525
Numero 148: Tanzania = 509
Numero 149: Taiwan* = 446
Numero 150: Montenegro = 378
Numero 151: Vietnam = 349
Numero 152: Mauritius = 340
Numero 153: Suriname = 319
Numero 154: Burma = 292
Numero 155: Comoros = 265
Numero 156: Syria = 231
Numero 157: Mongolia = 215
Numero 158: Guyana = 206
Numero 159: Angola = 189
Numero 160: Burundi = 144
Numero 161: Eritrea = 143
Numero 162: Brunei = 141
Numero 163: Cambodia = 130
Numero 164: Trinidad and Tobago = 123
Numero 165: Bahamas = 104
Numero 166: Monaco = 101
Numero 167: Barbados = 97
Numero 168: Botswana = 89
Numero 169: Liechtenstein = 86
Numero 170: Namibia = 72
Numero 171: Bhutan = 70
Numero 172: Gambia = 42
Numero 173: Saint Vincent and the Grenadines = 29
Numero 174: Antigua and Barbuda = 26
Numero 175: Timor-Leste = 24
Numero 176: Grenada = 23
Numero 177: Belize = 23
Numero 178: Saint Lucia = 19
Numero 179: Laos = 19
Numero 180: Fiji = 18
Numero 181: Dominica = 18
Numero 182: Lesotho = 17
Numero 183: Saint Kitts and Nevis = 15
Numero 184: Holy See = 12
Numero 185: Seychelles = 11
Numero 186: Western Sahara = 10
Numero 187: Papua New Guinea = 9
Numero 188: MS Zaandam = 9
- : unit = ()
*)

let app = new app_sysCorona "Covid19" "Repository of the CSSE at Johns Hopkins University" "data-06-23-2020.csv";;

(* Résultat:
Recherche des donnees dans Repository of the CSSE at Johns Hopkins University pour le type de virus: Covid19.
Chargement des donnees en cours ...
Chargement termine dans un temps de: 1.35156393051 secondes
Merci et au revoir!

val app : Tp2e20.app_sysCorona = <obj>
Affichage d'une fenêtre graphique (voir énoncé).
*)



(***************************************)
(* Verification des messages d'erreurs *)
(***************************************)

try
  sc#ajouter_sCorona ["";"";""]
with
  Failure s -> print_endline s;;

(* Résultat:
ajouter_sCorona: La longueur de la liste est incorrecte
- : unit = ()
*)

try
  sc#charger_donnees "existe_pas.cvs"
with
  Failure s -> print_endline s;;

(* Résultat:
charger_donnees: Fichier inacessible
- : unit = ()
*)

try
  ignore (sc#retourner_sCorona ("",""))
with
  Not_found -> print_endline "L'objet n'existe pas";;

(* Résultat:
L'objet n'existe pas
- : unit = ()
*)

try
  ignore (sc#retourner_chaine_info_pays "Canada" 5)
with
  Failure s -> print_endline s;;

(* Résultat:
le type de donnees est incorrect
- : unit = ()
*)

try
  ignore (sc#retourner_somme_donnees_pays "" 1)
with
  Failure s -> print_endline s;;

(* Résultat:
Aucune donnee trouvee, veuillez verifier le nom du pays
- : unit = ()
*)












 












