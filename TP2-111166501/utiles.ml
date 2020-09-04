(*********************************************************************)
(* Langages de Programmation: IFT 3000 NRC 55052                     *)
(* Fonctions, modules et librairies utiles pour le TP2               *)
(* Implanter un système de recherche par pays pour la pandémie       *)
(* du Coronavirus Covid-19 en utilisant des données ouvertes         *)
(*********************************************************************)

#load "unix.cma";; (* Charger le module unix *)
#load "str.cma";;  (* Charger le module Str  *)
#directory "/home/etudiant/.opam/4.08.0/lib/labltk";;
#load "labltk.cma";;  (* Charger le module labltk  *)

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

open List
open Tk

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
  (* Retourner une liste en découpant une chaîne selon un séparateur (p.ex ',') *)

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

  (* explode : string -> char list                            *)
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
    if not (String.contains chaine c) then chaine else
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

   let compareDonne x y = 
   if snd x = snd y then 0
   else if snd x > snd y then 1
   else -1


  let remove_blank = Str.global_replace (Str.regexp " ") ""







