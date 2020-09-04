(*********************************************************************)
(* Langages de Programmation: IFT 3000 NRC 55052                     *)
(* TP1 ÉTÉ 2020. Date limite: mercredi 10 juin à 17h                 *)
(* Implanter un système de recherche par pays pour la pandémie       *)
(* du Coronavirus Covid-19 en utilisant des données ouvertes         *)
(*********************************************************************)
(*********************************************************************)
(* Étudiant(e):                                                      *)
(* NOM: _Uwimana______________________ PRÉNOM:_Jean de Dieu__________*)
(* MATRICULE: 111166501____________ PROGRAMME: Informatique_________ *)
(*                                                                   *)
(*********************************************************************)

#load "str.cma";;  (* Charger le module Str *)
#load "unix.cma";; (* Charger le module Unix *)

(* Charger la signature du système de Covid19 *)
#use "TP1-SIG-E2020.mli";;

(********************************************************************) 
(* Implantation du système en utilisant un map,                     *)
(* les listes et les enregistrements                    	        *) 
(********************************************************************)

(* Module permettant d'utiliser un map dont les clés sont des paires de chaînes de caractères *)
module PaireCles =
    struct
       type t = string * string
       (* Les clés dans le map doivent être ordonnées (donc comparables) *)
       let compare (x0,y0) (x1,y1) =
           match String.compare x0 x1 with
             | 0 -> String.compare y0 y1
             | c -> c
     end

(* Map utilisant un arbre binaire de recherche *)
module SCoronaMap = Map.Make(PaireCles);;

(* Module du TP *)

module SysCovid19: SYSCOVID19 = struct

  open List
  open Str

(* *****************************************************************)
(* Déclarations d'exceptions et de types                           *)
(* *****************************************************************)

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

(*********************************************************************)
(* Fonctions fournies (vous n'êtes pas obligé de toutes les utiliser *)
(* *******************************************************************)

(* Fonctions manipulant les listes, les chaînes de caractères et/ou les fichiers *)

  (* appartient : 'a -> 'a list -> bool                   *)
  (* Retourner si un élément existe ou non dans une liste *)

  let appartient e l = exists (fun x -> x = e) l

  (* enlever : 'a -> 'a list -> 'a list *)
  (* Enlever un élément dans une liste  *)

  let enlever e l = 
    let (l1, l2) = partition (fun x -> x = e) l
    in l2

  (* remplacer : 'a -> 'a -> 'a list -> 'a list       *)
  (* Remplacer un élément par un autre dans une liste *)

  let remplacer e e' l =
    map (fun x -> (if (x = e) then e' else x)) l 

  (* uniques : string list -> string list                         *)
  (* Retourner une liste ne contenant que des éléments uniques    *) 
  (* Les chaînes vides sont également enlevées de la liste        *)
  (* ainsi que les espaces inutiles avant et/ou après les chaînes *)

  let uniques liste =
    let res = ref [] in
    let rec fct l = match l with
     | [] -> !res
     | x::xs -> if (not (mem x !res) && (x <> "")) then res := (!res)@[String.trim x]; fct xs
    in fct liste

  (* decouper_chaine : char -> string -> string list                            *)
  (* Retourner une liste en découpant une chaîne selon un séparateur (p.ex ",") *)

  (* let decouper_chaine chaine separateur = split (regexp separateur) *)

  let decouper_chaine  separateur chaine =
    let r = ref [] in
    let j = ref (String.length chaine) in
    for i = String.length chaine - 1 downto 0 do
      if chaine.[i] = separateur then begin
       r := String.sub chaine (i + 1) (!j - i - 1) :: !r;
       j := i end
    done;
    String.sub chaine 0 !j :: !r;;

  (* explode : string -> char list                             *)
  (* Permet de convertir une chaîne de caractères en une liste *)

  let explode chaine = match chaine with 
    | "" -> []
    | s -> let rec loop acc n = match n with
	  | 0 -> s.[0] :: acc
	  | x -> loop (s.[x] :: acc) (x - 1)
         in
	 loop [] (String.length s - 1)

  (* enlever_char : string -> char -> string                                    *)
  (* Permet de supprimer toutes les occurrences d'un caractère dans une chaîne  *)

  let enlever_char chaine c =
    if not(String.contains chaine c) then chaine else
    let che = explode chaine in
    let rec loop ls = match ls with
     | [] -> ""
     | e::r -> if e = c then (loop r) else (String.make 1 e) ^ (loop r)
    in
     loop che
  
  (* timeRun : ('a -> 'b) -> 'a -> 'b * float                                     *)
  (* Permet d'estimer la durée d'exécution d'une fonction passée en argument;    *)
  (* Elle prend en argument la fonction à évaluer et un paramètre, et retourne le *)
  (* résultat de cette application ainsi que la durée de cette application        *) 
  
  let timeRun f x =
    let	time1 = Unix.gettimeofday() in
    let r = f x in
    let time2 = Unix.gettimeofday() in
    (r,time2 -. time1)

  (* read_line : in_channel -> string                        *)
  (* Permet de lire une ligne dans un fichier                *)
  (* Elle retourne une chaîne vide si le fichier est terminé *)
 
   let lire_ligne ic =
     try
       input_line ic (* Lire une ligne *)
     with End_of_file -> "" 

   (* lire_fichier : in_channel -> char -> string list list                       *)
   (* Lire un fichier CSV et retourne une lite de listes de chaînes de caractères *)
   (* en spécifiant le séparateur qu'il faut utiliser pour délimiter les chaînes  *)

   let rec lire_fichier (flux:in_channel) (separateur:char) =
     let ligne = lire_ligne flux in
       match ligne with
	 | "" -> []
	 | s -> (decouper_chaine separateur (String.trim s))::(lire_fichier flux separateur)

(* Fonctions manipulant les données de Covid19 *)

   (* creer_sCorona : string list -> sCorona                       *)
   (* Retourner les données d'un pays, état, province ou région    *)
   (* selon une liste de chaînes de caractères                     *)
              
  let creer_sCorona (lch:string list) = 
    if (length lch) < 12 then raise (Err "La longueur de la liste est incorrecte") else
     {	 
       nom_comte = nth lch 1; 
       province_etat = nth lch 2;
       pays_region = enlever_char (nth lch 3) '\"';
       derniere_mise_a_jour = nth lch 4;
       lat = if (nth lch 5) = "" then 0.0 else float_of_string (nth lch 5);
       long = if (nth lch 6) = "" then 0.0 else float_of_string (nth lch 6);
       cas_confirmes = if (nth lch 7) = "" then 0 else  int_of_string (nth lch 7);
       cas_decedes = if (nth lch 8) = "" then 0 else  int_of_string (nth lch 8);
       cas_retablis = if (nth lch 9) = "" then 0 else  int_of_string (nth lch 9);
       cas_actifs = if (nth lch 10) = "" then 0 else  int_of_string (nth lch 10);
     }

   (* Ce code permet d'instancier un map (une référence) ainsi que les types de ses données *)
   (* Chaque clè (province_etat * pays_region) va être associée à un sCorona                *)
   (* représentant les données d'un pays,un état, une province ou une région                *)

   let m = ref (SCoronaMap.empty)
   let _ = m := SCoronaMap.add ("","") (creer_sCorona ["";"";"";"";"";"0.0";"0.0";"0";"0";"0";"0";""]) !m; 
          m := SCoronaMap.remove ("","") !m

   (* ajouter_sCorona : string list -> unit                                 *)
   (* Permet d'ajouter les données d'un pays ou d'une région  dans le map   *)
   (* en utilisant une liste de chaînes de caractères                       *)

   let ajouter_sCorona (lch: string list) =
     let cle1 = if (nth lch 1) = "" && (nth lch 2) = "" then "" else
                if (nth lch 1) = "" then nth lch 2 else (nth lch 1) ^ "," ^ (nth lch 2) in
     let cle2 = enlever_char (nth lch 3) '\"' in
     m := SCoronaMap.add (cle1, cle2) (creer_sCorona lch) !m

   (* ajouter_liste_sCorona : string list list -> unit                          *)
   (* Permet d'ajouter une liste de sCorona représentant les données de Covid19 *)
   (* en utilisant une liste de listes de chaînes de caractères                 *)

   let ajouter_liste_sCorona (llch: string list list) =
       iter (fun lch -> ajouter_sCorona lch) llch

   (* charger_donnees : string -> unit          *)
   (* Permet de charger les données dans le map *)

   let charger_donnees (fichier:string) =
       let ic =  try open_in fichier with _ -> raise (Err "Fichier inacessible") in
       let _ = input_line ic in (* ignorer la première ligne *)
       let liste_lignes = lire_fichier ic ',' in
       close_in ic; m := SCoronaMap.empty; ajouter_liste_sCorona liste_lignes

   (* retourner_donnees : unit -> donnees_Covid19 *)
   (* Permet de retourner les données sous la forme d'une *)
   (* liste d'enregistrement à partir du map *)

   let retourner_donnees (): donnees_Covid19 =
       let lsc = SCoronaMap.bindings !m in
       map (fun (k,c) -> c) lsc
       
   (* sCorona_existe : sCorona -> bool *)
   (* Retourner si les données d'un pays ou d'une région existe dans le map  *)

   let sCorona_existe (sc:sCorona)  =
       SCoronaMap.exists (fun k c -> c = sc) !m

   (* retourner_nbr_sCoronas : unit -> int *)
   (* Retourner le nombre de sCorona dans le map *)
   (* Représente le nombre de lignes dans le fichier csv -1 *)

   let retourner_nbr_sCorona () =
       SCoronaMap.cardinal !m

(******************************************************************)
(* Fonctions à implanter				                          *)
(* ****************************************************************)

   (* retourner_sCorona : string * string -> sCorona *)
   (* Retourne les données d'un pays ou d'une région (sCorona) se trouvant dans le map *)
   (* Lance l'exeption Notfound (géré par le map) si les données n'existent pas *)

   let retourner_sCorona (cle:string*string) = 
      SCoronaMap.find cle !m

   (* supprimer_sCorona : string * string -> unit *)
   (* Supprime les données d'un pays ou d'une région (sCorona) se trouvant dans le map *)
   (* Ne doit rien faire si le match n'existe pas (géré par le map) *)
   
   let supprimer_sCorona (cle:string*string) = 
       m:=SCoronaMap.remove cle !m
      
   (* supprimer_liste_sCoronas : (string * string) list -> unit *)
   (* Supprime une liste de sCorona (représentant les données d'un pays ou d'une région) dans le map *)

   let supprimer_liste_sCorona (lcles:(string*string) list) = match lcles with
      |[] -> raise(Err"Votre liste est vide , il y a rien a  supprimer")
      |_ ->  iter (fun cles -> supprimer_sCorona cles) lcles    (* ici oapplique la fonction supprimer a chaque cle de la liste *) 
  


   (* afficher_sCorona : sCorona -> unit                     *)
   (* Affiche les données d'un pays ou d'une région (sCorona) selon un certain formatage *)

   let afficher_sCorona (sc:sCorona) = 
    if (compare sc.province_etat "" = 0) then print_string (
        " \n Pays ou region: " ^ sc.pays_region                              (* ici ce le format d'afficher un scrona un cas ou la province est vide ou null *)
       ^ " \n Derniere mise a jour: " ^ sc.derniere_mise_a_jour 
       ^ " \n Lat et Long: " ^ string_of_float sc.lat ^ " " ^ string_of_float sc.long
       ^ " \n Cas confirmes: " ^ string_of_int sc.cas_confirmes 
       ^ " \n Cas decedes: " ^ string_of_int sc.cas_decedes 
       ^ " \n Cas retablis: " ^ string_of_int sc.cas_retablis
       ^ " \n Cas actifs: " ^ string_of_int sc.cas_actifs ^ "\n")
                                                                             (* ici c'est l,affichage de scorona*)
    else  print_string (
        " \n Province ou etat: " ^ sc.province_etat
       ^ " \n Pays ou region: " ^ sc.pays_region 
       ^ " \n Derniere mise a jour: " ^ sc.derniere_mise_a_jour 
       ^ " \n Lat et Long: " ^ string_of_float sc.lat ^ " " ^ string_of_float sc.long
       ^ " \n Cas confirmes: " ^ string_of_int sc.cas_confirmes 
       ^ " \n Cas decedes: " ^ string_of_int sc.cas_decedes 
       ^ " \n Cas retablis: " ^ string_of_int sc.cas_retablis
       ^ " \n Cas actifs: " ^ string_of_int sc.cas_actifs ^ "\n")

   (* afficher_donnees_Covid19 : donnees_Covid19 -> unit *)
   (* Affiche une liste de sCorona représentant les données de Covid19 par pays ou région *)
  let afficher_donnees_Covid19 (scs:donnees_Covid19) = match scs with
  | [] -> raise (Err"La liste est vide vous n'avez pas des données a afficher") (* ici on iter sur la liste de scorona et on affiche scorona *)
  | _ -> List.iter afficher_sCorona scs

   (* retourner_donnees_pays : string -> donnees_Covid19    *)
   (* Permet de retourner les données d'un pays spécifique   *)
   (* sous la forme de liste de sCorona à partir du map      *)

   let retourner_donnees_pays (pays:string): donnees_Covid19 =                           (* ici on associe  le pay a la deuxieme cle pour trouve scorona et on les ajouter dans un liste*)
   SCoronaMap.fold(fun _ i acc -> i::acc)(SCoronaMap.filter ( fun (_,y) _ -> y = pays) !m) []

      
   (* afficher_info_region_pays : string * string -> int -> unit  *)
   (* Permet d'afficher les cas de sCorona pour un comté, une province, un état ou un pays selon la valeur de td *)
   (* td = 1: Cas confirmes;  td = 2: Cas decedes; td = 3: Cas retablis; td = 4: Cas actifs;                     *)


   let afficher_info_region_pays (cle:string*string) (td:int) = match td with           (* ici o afffiche les infos d'un pays*) 
    | 1 -> print_string("Cas confirmes pour " ^ let(x,y) = cle in x ^"," ^ y ^":" ^ string_of_int(retourner_sCorona cle).cas_confirmes ^ "\n")
    | 2 -> print_string("Cas decedes pour " ^ let(x,y) = cle in x ^"," ^ y ^ ":" ^ string_of_int(retourner_sCorona cle).cas_decedes ^ "\n")
    | 3 -> print_string("Cas retablis pour " ^ let(x,y) = cle in x ^"," ^ y ^ ":" ^ string_of_int(retourner_sCorona cle).cas_retablis ^ "\n")
    | 4 -> print_string("Cas actifs pour " ^ let(x,y) = cle in x ^"," ^ y ^ ":" ^ string_of_int(retourner_sCorona cle).cas_actifs ^ "\n")
    | _ -> raise(Err"Entre un td valide " )
  

   (* afficher_sommes_donnees_pays : string -> unit          *)
   (* Permet de calculer et afficher pour un pays la somme   *)
   (* des cas confirmés, décédés, retablis et actifs         *)

   let afficher_sommes_donnees_pays (pays:string) =
   if SCoronaMap.is_empty (SCoronaMap.filter ( fun (x,y) _ -> y = pays) !m )then raise(Err"Il y a rien a afficher")
   else if  (SCoronaMap.cardinal(SCoronaMap.filter ( fun (x,y) _ -> y = pays) !m) = 1) then let (x,y) = SCoronaMap.min_binding(SCoronaMap.filter (fun (x,y) _ -> y = pays) !m) in 
   afficher_sCorona y
   else print_string ("Pays ou region: " ^ let (x,y) = SCoronaMap.min_binding(SCoronaMap.filter (fun (x,y) _ -> y = pays) !m) in 
    y.pays_region ^ "\n" ^
    "Derniere mise a jour: " ^ let (x,y) = SCoronaMap.min_binding(SCoronaMap.filter (fun (x,y) _ -> y = pays) !m) in 
    y.derniere_mise_a_jour ^ "\n" ^
    "Cas_confirmer :"^ string_of_int(SCoronaMap.fold(fun cle _ acc-> 
    (retourner_sCorona cle).cas_confirmes + acc ) (SCoronaMap.filter ( fun (x,y) _ -> y = pays) !m) 0)    (* Pour ces lignes suivantes on filtre le map selon un pay et ensuite on 
                                                                                                          on fait l'operation des donnes q'on cherche avec la fonction fold   *)
       ^ "\n" ^"Cas decedes : "^ string_of_int(SCoronaMap.fold(fun cle _ acc-> 
    (retourner_sCorona cle).cas_decedes + acc ) (SCoronaMap.filter ( fun (x,y) _ -> y = pays) !m) 0)
       ^ "\n" ^"Cas retablis : "^ string_of_int(SCoronaMap.fold(fun cle _ acc-> 
    (retourner_sCorona cle).cas_retablis + acc ) (SCoronaMap.filter ( fun (x,y) _ -> y = pays) !m) 0)
       ^ "\n" ^"Cas actifs : "^ string_of_int(SCoronaMap.fold(fun cle _ acc-> 
    (retourner_sCorona cle).cas_actifs + acc ) (SCoronaMap.filter ( fun (x,y) _ -> y = pays) !m) 0) ^ "\n") 


   (* lancer_systeme_Covid19 : string -> unit                                       *)
   (* Lancer le système de Covid19 afin de trouver les données qui nous intéressent *)

 let lancer_systeme_Covid19 (fichier:string) =
      print_string("Outil de recherche des donnees de Covid19 \n");
      print_string("Chargement des donnees en cours ... \n");
      flush stdout;
      let result = timeRun charger_donnees fichier in
      print_string ("Chargement termine dans un temps de: " ^ (fun (_,x) -> string_of_float x) result ^ " secondes \n");
      print_string("Veuillez entrer le nom du pays qui vous interesse:");
      flush stdout;
      let pays = read_line()  in
      print_string("Entrer 1 si vous voulez afficher les donnees detaillees du pays ou 2 pour afficher la somme des donnees ?:");
      ignore (read_line());
      flush stdout;
      let choix = read_line() in
      if choix = "1" then
        (print_string("Voici les donnees detaillees du pays: \n"); afficher_donnees_Covid19 (retourner_donnees_pays pays))
      else if choix = "2" then
        (print_string("Voici la somme des donnees trouvees pour le pays selectionne: \n");afficher_sommes_donnees_pays pays)
      else raise (Err "Choix invalide , veuillez recommencer");
      print_string( "Merci et au revoir! \n");
      ignore (read_line())


     let retourner_noms_pays_distincts() =
      List.map (fun (x, _)-> let (p,_) = x in  p) (SCoronaMap.bindings !m)



      let list = 1 - -9
      let list = 1 --9
      let list 1 _ _ 9
 
end
