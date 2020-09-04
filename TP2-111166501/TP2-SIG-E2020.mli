(*********************************************************************)
(* Langages de Programmation: IFT 3000 NRC 55052                     *)
(* TP2 ÉTÉ 2020. Date limite: jeudi 16 juillet à 17h                 *)
(* Implanter un système de recherche par pays pour la pandémie       *)
(* du Coronavirus Covid-19 en utilisant des données ouvertes         *)
(*********************************************************************)
(*********************************************************************)
(* Signature du système de recherche Covid-19                        *)
(*********************************************************************)

module type TP2E20 = sig

  class sCorona : string list ->
  object
    val nom_comte : string
    val province_etat : string
    val pays_region : string
    val derniere_mise_a_jour : string
    val lat : float
    val long : float
    val cas_confirmes : int
    val cas_decedes : int
    val cas_retablis : int
    val cas_actifs : int
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

  class sysRecherche_Virus : string -> string ->
  object
    val origine_donnees : string
    val type_virus : string
    method get_origine_donnees : string
    method get_type_virus : string
  end

  class sysRecherche_Coronavirus : string -> string ->
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

  class app_sysCorona : string -> string -> string ->
  object
    val nom_fichier : string
    val mutable sysR : sysRecherche_Coronavirus
    method get_sysR : sysRecherche_Coronavirus
    method set_sysR : sysRecherche_Coronavirus -> unit
    method lancer_app_sCorona : unit
  end    

end
