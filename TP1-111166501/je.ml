(***************************************************************************)
(* Jeu d'essai - TP1 - ÉTÉ 2020                                            *)
(***************************************************************************)

(* Pour changer ou obtenir le répertoire courant
Sys.getcwd ();;
Sys.chdir;;
*)

(* Pour afficher les listes avec plus de «profondeurs»:
#print_depth 1000;;
#print_length 1000;;
*)

(* On charge le fichier ml du Tp après avoir implanté
les fonctions demandées pour realiser les tests  *)

#use "TP1-E2020.ml";;

(* Résultat:
module type SYSCOVID19 =
  sig
    exception Err of string
    type sCorona = {
      nom_comte : string;
      province_etat : string;
      pays_region : string;
      derniere_mise_a_jour : string;
      lat : float;
      long : float;
      cas_confirmes : int;
      cas_decedes : int;
      cas_retablis : int;
      cas_actifs : int;
    }
    type donnees_Covid19 = sCorona list
    val creer_sCorona : string list -> sCorona
    val ajouter_sCorona : string list -> unit
    val ajouter_liste_sCorona : string list list -> unit
    val charger_donnees : string -> unit
    val retourner_donnees : unit -> donnees_Covid19
    val sCorona_existe : sCorona -> bool
    val retourner_nbr_sCorona : unit -> int
    val retourner_sCorona : string * string -> sCorona
    val supprimer_sCorona : string * string -> unit
    val supprimer_liste_sCorona : (string * string) list -> unit
    val afficher_sCorona : sCorona -> unit
    val afficher_donnees_Covid19 : donnees_Covid19 -> unit
    val retourner_donnees_pays : string -> donnees_Covid19
    val afficher_info_region_pays : string * string -> int -> unit
    val afficher_sommes_donnees_pays : string -> unit
    val lancer_systeme_Covid19 : string -> unit
  end
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
    val singleton : key -> 'a -> 'a t
    val remove : key -> 'a t -> 'a t
    val merge :
      (key -> 'a option -> 'b option -> 'c option) -> 'a t -> 'b t -> 'c t
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
    val max_binding : 'a t -> key * 'a
    val choose : 'a t -> key * 'a
    val split : key -> 'a t -> 'a t * 'a option * 'a t
    val find : key -> 'a t -> 'a
    val map : ('a -> 'b) -> 'a t -> 'b t
    val mapi : (key -> 'a -> 'b) -> 'a t -> 'b t
  end
module SysCovid19 : SYSCOVID19
*)

(* On ouvre le module disposant de fonctions pertinentes pour nos tests *)
open SysCovid19;;

(* On exécute maintenant les fonctions une à une *)

let sCorona1 = creer_sCorona ["";"";"Quebec";"Canada";"2020-05-27 02:32:31";
                            "52.9399";"-73.54911";"48607";"4140";"14999";"29468";
                            "Quebec, Canada"];;

(* Résultat:
val sCorona1 : SysCovid19.sCorona =
  {nom_comte = ""; province_etat = "Quebec"; pays_region = "Canada";
   derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 52.9399;
   long = -73.54911; cas_confirmes = 48607; cas_decedes = 4140;
   cas_retablis = 14999; cas_actifs = 29468}
*)

let sCorona2 = creer_sCorona ["";"";"";"Russia";"2020-05-27 02:32:31";
                            "61.52401";"105.318756";"362342";"3807";"131129";"227406";
                            "Russia"];;

(* Résultat:
val sCorona2 : SysCovid19.sCorona =
  {nom_comte = ""; province_etat = ""; pays_region = "Russia";
   derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 61.52401;
   long = 105.318756; cas_confirmes = 362342; cas_decedes = 3807;
   cas_retablis = 131129; cas_actifs = 227406}
*)

(* Source des données: 
https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_daily_reports/05-26-2020.csv
*)
let _ = charger_donnees "data-05-26-2020.csv";;

(* Résultat:
- : unit = ()
*)

let nb = retourner_nbr_sCorona ();;

(* Résultat:
val nb : int = 3410
 *)

let sc = retourner_sCorona ("Quebec","Canada");;

(* Résultat:
val sc : SysCovid19.sCorona =
  {nom_comte = ""; province_etat = "Quebec"; pays_region = "Canada";
   derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 52.9399;
   long = -73.5491; cas_confirmes = 48607; cas_decedes = 4140;
   cas_retablis = 14999; cas_actifs = 29468}
*)

let _ = supprimer_sCorona ("Quebec","Canada");;

(* Résultat:
- : unit = ()
*)

let _ = supprimer_liste_sCorona [("Rondonia","Brazil");("Reunion","France")];;

(* Résultat:
- : unit = ()
*)

afficher_sCorona sCorona1;;

(* Résultat:
Province ou etat: Quebec
Pays ou region: Canada
Derniere mise a jour: 2020-05-27 02:32:31
Lat et Long: 52.9399 -73.54911
Cas confirmes: 48607
Cas decedes: 4140
Cas retablis: 14999
Cas actifs: 29468
- : unit = ()
*)

afficher_donnees_Covid19 [sCorona1;sCorona2];;

(* Résultat:
Province ou etat: Quebec
Pays ou region: Canada
Derniere mise a jour: 2020-05-27 02:32:31
Lat et Long: 52.9399 -73.54911
Cas confirmes: 48607
Cas decedes: 4140
Cas retablis: 14999
Cas actifs: 29468

Pays ou region: Russia
Derniere mise a jour: 2020-05-27 02:32:31
Lat et Long: 61.52401 105.318756
Cas confirmes: 362342
Cas decedes: 3807
Cas retablis: 131129
Cas actifs: 227406

- : unit = ()
*)

let lcsp = retourner_donnees_pays "US";;
let nbp = List.length lcsp;;
  
(* Résultat:
val lcsp : SysCovid19.donnees_Covid19 =
  [{nom_comte = "Abbeville"; province_etat = "South Carolina";
    pays_region = "US"; derniere_mise_a_jour = "2020-05-27 02:32:31";
    lat = 34.22333378; long = -82.46170658; cas_confirmes = 35;
    cas_decedes = 0; cas_retablis = 0; cas_actifs = 35};
   {nom_comte = "Acadia"; province_etat = "Louisiana"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 30.2950649;
    long = -92.41419698; cas_confirmes = 395; cas_decedes = 18;
    cas_retablis = 0; cas_actifs = 377};
   {nom_comte = "Accomack"; province_etat = "Virginia"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 37.76707161;
    long = -75.63234615; cas_confirmes = 758; cas_decedes = 11;
    cas_retablis = 0; cas_actifs = 747};
   {nom_comte = "Ada"; province_etat = "Idaho"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 43.4526575;
    long = -116.24155159999998; cas_confirmes = 796; cas_decedes = 23;
    cas_retablis = 0; cas_actifs = 773};
   {nom_comte = "Adair"; province_etat = "Iowa"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 41.33075609;
    long = -94.47105874; cas_confirmes = 7; cas_decedes = 0;
    cas_retablis = 0; cas_actifs = 7};
   {nom_comte = "Adair"; province_etat = "Kentucky"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 37.10459774;
    long = -85.28129668; cas_confirmes = 96; cas_decedes = 19;
    cas_retablis = 0; cas_actifs = 77};
   {nom_comte = "Adair"; province_etat = "Missouri"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 40.19058551;
    long = -92.60078167; cas_confirmes = 46; cas_decedes = 0;
    cas_retablis = 0; cas_actifs = 46};
   {nom_comte = "Adair"; province_etat = "Oklahoma"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 35.88494195;
    long = -94.65859267; cas_confirmes = 82; cas_decedes = 3;
    cas_retablis = 0; cas_actifs = 79};
   {nom_comte = "Adams"; province_etat = "Colorado"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 39.87432092;
    long = -104.3362578; cas_confirmes = 2964; cas_decedes = 116;
    cas_retablis = 0; cas_actifs = 2848};
   {nom_comte = "Adams"; province_etat = "Idaho"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 44.89333571;
    long = -116.4545247; cas_confirmes = 3; cas_decedes = 0;
    cas_retablis = 0; cas_actifs = 3};
   {nom_comte = "Adams"; province_etat = "Illinois"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 39.98815591;
    long = -91.18786813; cas_confirmes = 44; cas_decedes = 1;
    cas_retablis = 0; cas_actifs = 43};
   {nom_comte = "Adams"; province_etat = "Indiana"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 40.7457653;
    long = -84.93671406; cas_confirmes = 12; cas_decedes = 1;
    cas_retablis = 0; cas_actifs = 11};
   {nom_comte = "Adams"; province_etat = "Iowa"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 41.02903567;
    long = -94.69932645; cas_confirmes = 5; cas_decedes = 0;
    cas_retablis = 0; cas_actifs = 5};
   {nom_comte = "Adams"; province_etat = "Mississippi"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 31.47669768;
    long = -91.35326037; cas_confirmes = 189; cas_decedes = 15;
    cas_retablis = 0; cas_actifs = 174};
   {nom_comte = "Adams"; province_etat = "Nebraska"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 40.524494200000007;
    long = -98.50117804; cas_confirmes = 265; cas_decedes = 11;
    cas_retablis = 0; cas_actifs = 254};
   {nom_comte = "Adams"; province_etat = "Ohio"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 38.84541072;
    long = -83.4718964; cas_confirmes = 8; cas_decedes = 1; cas_retablis = 0;
    cas_actifs = 7};
   {nom_comte = "Adams"; province_etat = "Pennsylvania"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 39.87140411;
    long = -77.21610347; cas_confirmes = 233; cas_decedes = 7;
    cas_retablis = 0; cas_actifs = 226};
   {nom_comte = "Adams"; province_etat = "Washington"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 46.98299757;
    long = -118.5601734; cas_confirmes = 53; cas_decedes = 0;
    cas_retablis = 0; cas_actifs = 53};
   {nom_comte = "Adams"; province_etat = "Wisconsin"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 43.96974651;
    long = -89.76782777; cas_confirmes = 4; cas_decedes = 1;
    cas_retablis = 0; cas_actifs = 3};
   {nom_comte = "Addison"; province_etat = "Vermont"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 44.03217337;
    long = -73.14130877; cas_confirmes = 62; cas_decedes = 2;
    cas_retablis = 0; cas_actifs = 60};
   {nom_comte = "Aiken"; province_etat = "South Carolina";
    pays_region = "US"; derniere_mise_a_jour = "2020-05-27 02:32:31";
    lat = 33.54338026; long = -81.63645384; cas_confirmes = 181;
    cas_decedes = 7; cas_retablis = 0; cas_actifs = 174};
   {nom_comte = "Aitkin"; province_etat = "Minnesota"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 46.60962049;
    long = -93.4116826; cas_confirmes = 7; cas_decedes = 0; cas_retablis = 0;
    cas_actifs = 7};
   {nom_comte = "Alachua"; province_etat = "Florida"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 29.67866525;
    long = -82.35928158; cas_confirmes = 370; cas_decedes = 7;
    cas_retablis = 0; cas_actifs = 363};
   {nom_comte = "Alamance"; province_etat = "North Carolina";
    pays_region = "US"; derniere_mise_a_jour = "2020-05-27 02:32:31";
    lat = 36.0434701; long = -79.39976137; cas_confirmes = 300;
    cas_decedes = 23; cas_retablis = 0; cas_actifs = 277};
   {nom_comte = "Alameda"; province_etat = "California"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 37.64629437;
    long = -121.8929271; cas_confirmes = 2986; cas_decedes = 93;
    cas_retablis = 0; cas_actifs = 2893};
   {nom_comte = "Alamosa"; province_etat = "Colorado"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 37.57250606;
    long = -105.7885451; cas_confirmes = 58; cas_decedes = 2;
    cas_retablis = 0; cas_actifs = 56};
   {nom_comte = "Albany"; province_etat = "New York"; pays_region = "US";
    derniere_mise_a_jour = "2020-05-27 02:32:31"; lat = 42.60060306;
    long = -73.97723916; cas_confirmes = 1793; cas_decedes = 76;
    cas_retablis = 0; cas_actifs = 1717};
   {nom_comte = ...; province_etat = ...; pays_region = ...;
    derniere_mise_a_jour = ...; lat = ...; long = ...; cas_confirmes = ...;
    cas_decedes = ...; cas_retablis = ...; cas_actifs = ...};
   ...]
# val nbp : int = 3016
*)

afficher_info_region_pays ("Albany,New York","US") 1;;

(* Résultat:
Cas confirmes pour Albany,New York,US: 1793
- : unit = ()
*)

afficher_info_region_pays ("Albany,New York","US") 2;;

(* Résultat:
Cas decedes pour Albany,New York,US: 76
- : unit = ()
*)

afficher_info_region_pays ("Albany,New York","US") 3;;

(* Résultat:
Cas retablis pour Albany,New York,US: 0
- : unit = ()
 *)

afficher_info_region_pays ("Albany,New York","US") 4;;

(* Résultat:
Cas actifs pour Albany,New York,US: 1717
- : unit = ()
 *)

afficher_sommes_donnees_pays "US";;

(* Résultat:
Pays: US
Derniere mise a jour: 2020-05-27 02:32:31
Cas confirmes: 1680913
Cas decedes: 98913
Cas retablis: 384902
Cas actifs: 1228728
- : unit = ()
*)

afficher_sommes_donnees_pays "Canada";;

(* Résultat:
Pays: Canada
Derniere mise a jour: 2020-05-27 02:32:31
Cas confirmes: 39483
Cas decedes: 2613
Cas retablis: 30353
Cas actifs: 6517
- : unit = ()
 *)

afficher_sommes_donnees_pays "Tunisia";;

(* Résultat:
Pays ou region: Tunisia
Derniere mise a jour: 2020-05-27 02:32:31
Lat et Long: 33.886917 9.537499
Cas confirmes: 1051
Cas decedes: 48
Cas retablis: 929
Cas actifs: 74

- : unit = ()
 *)

let _ = lancer_systeme_Covid19 "data-05-26-2020.csv";;

(* Résultat:
Outil de recherche des donnees de Covid19
Chargement des donnees en cours ...
Chargement termine dans un temps de: 0.140000104904 secondes
Veuillez entrer le nom du pays qui vous interesse:
Canada
  ;;
Entrer 1 si vous voulez afficher les donnees detaillees du pays ou 2 pour afficher la somme des donnees ?:
1
;;
Voici les donnees detaillees du pays:

Nombre de comtes, etats ou provinces trouves = 14

Province ou etat: Alberta
Pays ou region: Canada
Derniere mise a jour: 2020-05-27 02:32:31
Lat et Long: 53.9333 -116.5765
Cas confirmes: 6901
Cas decedes: 139
Cas retablis: 6048
Cas actifs: 714

Province ou etat: British Columbia
Pays ou region: Canada
Derniere mise a jour: 2020-05-27 02:32:31
Lat et Long: 53.7267 -127.6476
Cas confirmes: 2541
Cas decedes: 161
Cas retablis: 2122
Cas actifs: 258

Province ou etat: Diamond Princess
Pays ou region: Canada
Derniere mise a jour: 2020-05-27 02:32:31
Lat et Long: 0. 0.
Cas confirmes: 1
Cas decedes: 1
Cas retablis: 0
Cas actifs: 0

Province ou etat: Grand Princess
Pays ou region: Canada
Derniere mise a jour: 2020-05-27 02:32:31
Lat et Long: 0. 0.
Cas confirmes: 13
Cas decedes: 0
Cas retablis: 13
Cas actifs: 0

Province ou etat: Manitoba
Pays ou region: Canada
Derniere mise a jour: 2020-05-27 02:32:31
Lat et Long: 53.7609 -98.8139
Cas confirmes: 292
Cas decedes: 7
Cas retablis: 269
Cas actifs: 16

Province ou etat: New Brunswick
Pays ou region: Canada
Derniere mise a jour: 2020-05-27 02:32:31
Lat et Long: 46.5653 -66.4619
Cas confirmes: 122
Cas decedes: 0
Cas retablis: 120
Cas actifs: 2

Province ou etat: Newfoundland and Labrador
Pays ou region: Canada
Derniere mise a jour: 2020-05-27 02:32:31
Lat et Long: 53.1355 -57.6604
Cas confirmes: 260
Cas decedes: 3
Cas retablis: 255
Cas actifs: 2

Province ou etat: Northwest Territories
Pays ou region: Canada
Derniere mise a jour: 2020-05-27 02:32:31
Lat et Long: 64.8255 -124.8457
Cas confirmes: 5
Cas decedes: 0
Cas retablis: 5
Cas actifs: 0

Province ou etat: Nova Scotia
Pays ou region: Canada
Derniere mise a jour: 2020-05-27 02:32:31
Lat et Long: 44.682 -63.7443
Cas confirmes: 1052
Cas decedes: 59
Cas retablis: 976
Cas actifs: 17

Province ou etat: Ontario
Pays ou region: Canada
Derniere mise a jour: 2020-05-27 02:32:31
Lat et Long: 51.2538 -85.3232
Cas confirmes: 27624
Cas decedes: 2235
Cas retablis: 19958
Cas actifs: 5431

Province ou etat: Prince Edward Island
Pays ou region: Canada
Derniere mise a jour: 2020-05-27 02:32:31
Lat et Long: 46.5107 -63.4168
Cas confirmes: 27
Cas decedes: 0
Cas retablis: 27
Cas actifs: 0

Province ou etat: Quebec
Pays ou region: Canada
Derniere mise a jour: 2020-05-27 02:32:31
Lat et Long: 52.9399 -73.5491
Cas confirmes: 48607
Cas decedes: 4140
Cas retablis: 14999
Cas actifs: 29468

Province ou etat: Saskatchewan
Pays ou region: Canada
Derniere mise a jour: 2020-05-27 02:32:31
Lat et Long: 52.9399 -106.4509
Cas confirmes: 634
Cas decedes: 8
Cas retablis: 549
Cas actifs: 77

Province ou etat: Yukon
Pays ou region: Canada
Derniere mise a jour: 2020-05-27 02:32:31
Lat et Long: 64.2823 -135.
Cas confirmes: 11
Cas decedes: 0
Cas retablis: 11
Cas actifs: 0


Merci et au revoir!- : unit = ()
*)

let _ = lancer_systeme_Covid19 "data-05-26-2020.csv";;

(*
Outil de recherche des donnees de Covid19
Chargement des donnees en cours ...
Chargement termine dans un temps de: 0.25 secondes
Veuillez entrer le nom du pays qui vous interesse:
Brazil
  ;;
Entrer 1 si vous voulez afficher les donnees detaillees du pays ou 2 pour afficher la somme des donnees ?:
2
;;
Voici la somme des donnees trouvees pour le pays selectionne:

Pays: Brazil
Derniere mise a jour: 2020-05-27 02:32:31
Cas confirmes: 391222
Cas decedes: 24512
Cas retablis: 158593
Cas actifs: 208117

Merci et au revoir!- : unit = ()
*)

(************************************************)
(* Verification de certains  messages d'erreurs *)
(************************************************)

try
  ignore (creer_sCorona [""])
with
  Err s -> print_endline s;;

(* Résultat:
La longueur de la liste est incorrecte
- : unit = ()
*)

try
  ignore (charger_donnees "existe_pas.cvs")
with
  Err s -> print_endline s;;

(* Résultat:
Fichier inacessible
- : unit = ()
*)

try
  ignore (retourner_sCorona ("",""))
with
  Not_found -> print_endline "Les donnees n'existe pas";;

(* Résultat:
Les donnees n'existe pas
- : unit = ()
*)
