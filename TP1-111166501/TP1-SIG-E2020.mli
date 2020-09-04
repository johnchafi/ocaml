(*********************************************************************)
(* Langages de Programmation: IFT 3000 NRC 55052                     *)
(* TP1 ÉTÉ 2020. Date limite: mercredi 10 juin à 17h                 *)
(* Implanter un système de recherche par pays pour la pandémie       *)
(* du Coronavirus Covid-19 en utilisant des données ouvertes         *)
(*********************************************************************)
(*********************************************************************)
(* Signature du système de recherche Covid-19                        *)
(*********************************************************************)

module type SYSCOVID19 = sig

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
