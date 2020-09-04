(*********************************************************************)
(* Langages de Programmation: IFT 3000 NRC 55052                     *)
(* TP2 ÉTÉ 2020. Date limite: jeudi 16 juillet à 17h                 *)
(* Implanter un système de recherche par pays pour la pandémie       *)
(* du Coronavirus Covid-19 en utilisant des données ouvertes         *)
(*********************************************************************)
(* Étudiant(e):                                                      *)
(* NOM: Uwimana            PRÉNOM:_Jean de Dieu______________________*)
(* MATRICULE: 111150166_________________     PROGRAMME: INFORMATIQUE_ *)
(*                                                                   *)
(*********************************************************************)

(* Chargement de modules, fonctions et librairies utiles pour le TP2 *)
#use "utiles.ml";; 

(* Chargement de la signature du TP2 *)
#use "TP2-SIG-E2020.mli";;

(********************************************************************)
(* Implantation du système en utilisant                             *)
(* la programmation orientée objet                       	    *)
(********************************************************************)

(* Module du TP *)

module Tp2e20 : TP2E20 = struct

  (* Classes du TP *)

  class sCorona (lch:string list) =
    object(self)

      val nom_comte : string = nth lch 1;
      val province_etat : string = nth lch 2;
      val pays_region : string = enlever_char (nth lch 3) '\"';
      val derniere_mise_a_jour : string = nth lch 4;
      val lat : float = if (nth lch 5) = "" then 0.0 else float_of_string (nth lch 5);
      val long : float = if (nth lch 6) = "" then 0.0 else float_of_string (nth lch 6);
      val cas_confirmes : int = if (nth lch 7) = "" then 0 else  int_of_string (nth lch 7);
      val cas_decedes : int = if (nth lch 8) = "" then 0 else  int_of_string (nth lch 8);
      val cas_retablis : int = if (nth lch 9) = "" then 0 else  int_of_string (nth lch 9);
      val cas_actifs : int = if (nth lch 10) = "" then 0 else  int_of_string (nth lch 10);

      method get_nom_comte = nom_comte
      method get_province_etat = province_etat
      method get_pays_region = pays_region
      method get_derniere_mise_a_jour = derniere_mise_a_jour
      method get_lat = lat
      method get_long = long
      method get_cas_confirmes = cas_confirmes
      method get_cas_decedes = cas_decedes
      method get_cas_retablis = cas_retablis
      method get_cas_actifs = cas_actifs

	  (* -- À IMPLANTER/COMPLÉTER (5 PTS) ----------------------------------*)
	  (* @Méthode      : retourner_chaine_sCorona : string			*)
	  (* @Description  : retourne la chaîne contenant les données		*)
	  (*		     d'un objet sCorona				        *)
      method retourner_chaine_sCorona =

          "Province ou etat: " ^ self#get_province_etat ^ "\n" ^
          "Pays ou region:" ^ self#get_pays_region ^ "\n" ^
          "Derniere mise a jour:" ^ self#get_derniere_mise_a_jour ^ "\n" ^
          "Lat et Long: " ^ string_of_float(self#get_lat) ^ "   " ^ string_of_float(self#get_long) ^ "\n" ^
          "Cas confirmes:" ^ string_of_int(self#get_cas_confirmes) ^ "\n" ^
          "Cas decedes:" ^ string_of_int(self#get_cas_decedes)^ "\n"^
          "Cas retablis:" ^ string_of_int(self#get_cas_retablis) ^ "\n" ^
          "Cas actifs: " ^ string_of_int(self#get_cas_actifs)^ "\n" ^ "\n" 
      
  end

  class sysRecherche_Virus (tv:string) (od:string) =
    object
        val type_virus : string = tv
        val origine_donnees : string = od
	method get_type_virus = type_virus
	method get_origine_donnees = origine_donnees

  end

  class sysRecherche_Coronavirus (tv:string) (od:string) =
    object(self)
      inherit sysRecherche_Virus tv od as parent
      val mutable map_sCoronas : sCorona SCoronaMap.t ref = ref (SCoronaMap.empty)
      method get_map_sCoronas = map_sCoronas
      method set_map_sCoronas (mi: sCorona SCoronaMap.t ref) = map_sCoronas <- mi

      method ajouter_sCorona (lch: string list) =
        if (length lch) < 12 then failwith "ajouter_sCorona: La longueur de la liste est incorrecte" else
		let cle1 = if (nth lch 1) = "" && (nth lch 2) = "" then "" else
				   if (nth lch 1) = "" then nth lch 2 else (nth lch 1) ^ "," ^ (nth lch 2) in
		let cle2 = enlever_char (nth lch 3) '\"' in
        map_sCoronas := SCoronaMap.add (cle1, cle2) (new sCorona lch) !map_sCoronas

      method ajouter_liste_sCoronas (llch:string list list) =
        iter (fun lch -> (self#ajouter_sCorona lch)) llch

      method charger_donnees (fichier:string) =
        let ic =  try open_in fichier with _ -> failwith "charger_donnees: Fichier inacessible" in
        let _ = input_line ic in (* ignorer la première lignes *)
        let liste_lignes = lire_fichier ic ',' in
        close_in ic; map_sCoronas := SCoronaMap.empty; self#ajouter_liste_sCoronas liste_lignes

      method retourner_donnees : sCorona list =
        let lsc = SCoronaMap.bindings !map_sCoronas in
        map (fun (k,c) -> c) lsc

      method retourner_nbr_sCoronas =
        SCoronaMap.cardinal !map_sCoronas

      (* -- À IMPLANTER (2 PTS) ------------------------------------------------*)
      (* @Méthode      : retourner_sCorona : string * string -> sCorona		*)
      (* @Description  : retourne un objet sCorona correspondant au paramètre	*)
      (*	         d'entrée représentant la clé dans le Map       	*)
      method retourner_sCorona (cle:string*string) =
	(* Supprimez cette ligne et implantez la méthode *)
	    SCoronaMap.find cle !map_sCoronas

      (* -- À IMPLANTER (2 PTS) ------------------------------------------------*)
      (* @Méthode      : supprimer_sCorona : string * string -> unit		*)
      (* @Description  : supprime un objet sCorona du Map			*)
      method supprimer_sCorona (cle:string*string) =
	(* Supprimez cette valeur de unit et implantez la méthode *)
      map_sCoronas := SCoronaMap.remove cle !map_sCoronas
   
       
      (* -- À IMPLANTER (2 PTS) ----------------------------------------------------*)
      (* @Méthode      : supprimer_liste_sCoronas : (string * string) list -> unit  *)
      (* @Description  : supprime une liste d'objets du Map		            *)
      method supprimer_liste_sCoronas (lcles:(string*string) list) =
	(* Supprimez cette valeur de unit et implantez la méthode *)
      iter (fun cle -> self#supprimer_sCorona cle) lcles  
  
        
      (* -- À IMPLANTER (5 PTS) ----------------------------------------------------*)
      (* @Méthode      : retourner_chaine_liste_sCoronas : sCorona list -> string   *)
      (* @Description  : retourne la chaîne contenant les données		    *)
      (*	         d'une liste d'objet sCorona	        	            *)
      method retourner_chaine_liste_sCoronas (scs:sCorona list) =
    
       if (length scs) = 0 then failwith("La liste est vide vous n'avez pas des données à afficher")
      else fold_left( fun a sc-> a ^ sc#retourner_chaine_sCorona ) "" scs

      (* -- À IMPLANTER (3 PTS) ------------------------------------------------*)
      (* @Méthode      : retourner_donnees_pays : string -> sCorona list	*)
      (* @Description  : retourne une liste d'objets sCorona représentant    	*)
      (*	         les données d'un pays		        		*)
      method retourner_donnees_pays (pays:string): sCorona list =
	(* Supprimez cette ligne  et implantez la méthode *)

      SCoronaMap.fold (fun _ i acc -> acc @ [i]) 
           (SCoronaMap.filter (fun (x,y) ind -> y = pays) !map_sCoronas) []

      (* -- À IMPLANTER (9 PTS) ------------------------------------------------*)
      (* @Méthode      : retourner_chaine_info_pays : string -> int -> string	*)
      (* @Description  : retourne une chaîne contenant la somme d'un type	*)
      (*	         de cas concernant un pays en particulier	        *)
      method retourner_chaine_info_pays (pays:string) (td:int) =
	(* Supprimez cette chaîne vide et implantez la méthode *)
 
    if (td<1 || td>4) then failwith ("le type de donnees est incorrect")            
    else
    let dp = SCoronaMap.filter (fun (x,y) _ -> y = pays) !map_sCoronas in                  (* cherche les donnes du pays *)
    let dernMisAj = (snd(SCoronaMap.min_binding dp))#get_derniere_mise_a_jour in
    match td with
       | 1 -> let lc1 =
          let cc = SCoronaMap.fold (fun _ sc acc -> acc + sc#get_cas_confirmes) dp 0 in 
          "Pays : " ^ pays ^  "\nDerniere mise a jour " ^ dernMisAj ^ " " ^"\nCas confirmes:  " ^ string_of_int cc ^"\n" in lc1;         (* reourne les donnes selon la valeur de td *)

       | 2 -> let lc2 =
          let cd = SCoronaMap.fold (fun _ sc acc -> acc + sc#get_cas_decedes) dp 0 in 
          "Pays : " ^ pays ^ "\nDerniere mise a jour " ^ dernMisAj ^ " " ^"\nCas decedes: " ^ string_of_int cd ^"\n" in lc2;

       | 3 -> let lc3 =
          let cr = SCoronaMap.fold (fun _ sc acc -> acc + sc#get_cas_retablis) dp 0 in 
          "Pays : " ^ pays ^ "\nDerniere mise a jour " ^ dernMisAj ^ " " ^"\nCas retablis: " ^ string_of_int cr ^"\n" in lc3;

       | 4 -> let lc4 =
          let ca = SCoronaMap.fold (fun _ sc acc -> acc + sc#get_cas_actifs) dp 0 in 
          "Pays : " ^ pays ^ "\nDerniere mise a jour " ^ dernMisAj ^ " " ^"\nCas actifs: " ^ string_of_int ca ^"\n" in lc4;
      
       | _ -> failwith("le type de donnees est incorrect")   
  
      (* -- À IMPLANTER (9 PTS) ----------------------------------------------------*)
      (* @Méthode      : retourner_chaine_sommes_donnees_pays : string -> string    *)
      (* @Description  : retourne une chaîne contenant les sommes des types	    *)
      (*	          de cas concernant un pays en particulier	            *)
      method retourner_chaine_sommes_donnees_pays (pays:string) =
	(* Supprimez cette chaîne vide et implantez la méthode *)
     let dp = SCoronaMap.filter (fun (x,y) _ -> y = pays) !map_sCoronas in
     let dernMisAj = (snd(SCoronaMap.min_binding dp))#get_derniere_mise_a_jour in          (* trouve le pays et accumuler la somme des cas  *)
     let cc = SCoronaMap.fold (fun _ sc acc -> acc + sc#get_cas_confirmes) dp 0 in 
     let cd = SCoronaMap.fold (fun _ sc acc -> acc + sc#get_cas_decedes) dp 0 in 
     let cr = SCoronaMap.fold (fun _ sc acc -> acc + sc#get_cas_retablis) dp 0 in 
     let ca = SCoronaMap.fold (fun _ sc acc -> acc + sc#get_cas_actifs) dp 0 in
      "Pays : " ^ pays ^ "\nDerniere mise a jour " ^ dernMisAj ^ " " ^"\nCas confirmes: " ^ string_of_int cc^"\nCas decedes: " ^ string_of_int cd ^  
      "\nCas retablis: " ^ string_of_int cr ^ "\nCas actifs: " ^ string_of_int ca ^"\n"
      
  
      (* -- À IMPLANTER (8 PTS) ------------------------------------------------*)
      (* @Méthode      : retourner_noms_pays_distincts_ordonnes : string list   *)
      (* @Description  : retourne une liste de chaînes représentant la liste    *)
      (*		     des pays triée par ordre croissant		        *)
      method retourner_noms_pays_distincts_ordonnes: string list =
	(* Supprimez cette liste et implantez la méthode *)

     let listPays =map (fun (x,y) -> let(_,p) = x in p)(SCoronaMap.bindings !map_sCoronas) in
     sort_uniq(fun a b  -> compare a b)listPays

      (* -- À IMPLANTER (8 PTS) ------------------------------------------------*)
      (* @Méthode      : retourner_somme_donnees_pays : string -> int -> int	*)
      (* @Description  : retourne un entier représentant la somme du type 	*)
      (*	         de cas choisi selon la valeur de td		        *)
      method retourner_somme_donnees_pays (pays:string) (td:int): int =
	(* Supprimez ce zéro et implantez la méthode *)
  
   if (td<1 || td>4) then failwith ("le type de donnees est incorrect") else         (* retourne le nombre des cas selon  la valeur de td *)
   let dp = SCoronaMap.filter (fun (x,y) _ -> y = pays) !map_sCoronas in
   match td with
   | 1 ->  SCoronaMap.fold (fun _ sc acc -> acc + sc#get_cas_confirmes) dp 0 
   | 2 ->  SCoronaMap.fold (fun _ sc acc -> acc + sc#get_cas_decedes) dp 0 
   | 3 ->  SCoronaMap.fold (fun _ sc acc -> acc + sc#get_cas_retablis) dp 0 
   | 4 ->  SCoronaMap.fold (fun _ sc acc -> acc + sc#get_cas_actifs) dp 0 
   | _ -> failwith("le type de donnees est incorrect")
   

      (* -- À IMPLANTER (10 PTS) -----------------------------------------------*)
      (* @Méthode      : retourner_chaine_resultats_ordonnes : int -> string	*)
      (* @Description  : retourne une chaîne de caractères contenant les sommes *)
      (*	         du type de cas choisi par pays et qui sont triées par 	*)
      (*	         ordre décroissant				        *)
      method retourner_chaine_resultats_ordonnes (td:int)  =
	(* Supprimez cette chaîne vide et implantez la méthode *)

 
   if (td<1 || td>4) then failwith ("le type de donnees est incorrect") else
   let scorList = self#retourner_donnees in                                  (* rcecherche les pays  *)
   let paysList =  map (fun sc -> sc#get_pays_region)scorList in             
   let paysUnique = uniques paysList in                                      (* enlever les doublons  *)
   let paysDonnee = fold_left(fun acc p->  let d = self#retourner_somme_donnees_pays p td in (p,d)::acc) [] paysUnique in    (* retounes les donnes des pays   *)
   let paysOrdonne = sort(fun a b -> compareDonne a b)paysDonnee in                     (* ordonnes les pays *)
   let n = ref 0 in
   let num = "Numero  " in 
   fold_right(fun (pa, donne) acc-> incr n; acc ^num ^ string_of_int(!n)^": "^ pa ^" = "^string_of_int(donne)^ "\n")   paysOrdonne ""  (* chaine contenant resulats selon le cas *)




      initializer print_string ("Recherche des donnees dans " ^ (parent#get_origine_donnees) ^
				" pour le type de virus: " ^ (self#get_type_virus) ^ ".");
				print_newline();


  end  

  class app_sysCorona (tv:string) (od:string) (nf:string) =
    object(self)
      val nom_fichier = nf
      val mutable sysR = new sysRecherche_Coronavirus tv od
      method get_sysR = sysR
      method set_sysR (sr: sysRecherche_Coronavirus) = sysR <- sr

      (* -- À COMPLÉTER (25 PTS) ----------------------------------------------------*)
      (* @Méthode      : lancer_app_sCorona : unit	                             *)
      (* @Description  : affiche une interface graphique en utilisant la librairie   *)
      (*                 labltk (https://garrigue.github.io/labltk/) 		     *)



   method lancer_app_sCorona =

    (* set la fenetre principale ave c les bouton e les listes box *)
       let top = openTk () in
    Wm.title_set top "Système de la pandémie Coronavirus";
        Wm.geometry_set top "680x580";
        let l1 = Label.create ~text:"Bienvenue à l'outil de recherche des données du Covid19" top in
        let daughter = let d = Toplevel.create top in destroy d; ref d  in
         let listeDonne = sysR#retourner_noms_pays_distincts_ordonnes in  
        let listeChoix = ["Les cas confirmes"; "Les cas decedes"; "Les cas retablis"; "Les cas actifs"; "Les donnees detaillees"; "La somme des donnees"] in
        let labelPays =  Label.create ~text:"Pays selectionné:" top in
        let v = Textvariable.create ()  in
        Textvariable.set v " ?";
        let labelPaysDis = Label.create ~textvariable:v top in
         let v2 = Textvariable.create ()  in
        Textvariable.set v2 " ?";
        let labelDonneDis = Label.create ~textvariable:v2 top in
        let labelDonne = Label.create ~text:"Type de données selectionne" top in
        let b = Textvariable.create () in 
        Textvariable.set b "OFF";
        let checkB = Checkbutton.create
        ~text:"Case à cocher"
        ~variable:b
        ~onvalue:"ON" ~offvalue:"OFF" top in
        let mylist = Listbox.create 
        ~width:100
        ~height:10
         ~selectmode:`Single top
       in
    
        let mylist2 = Listbox.create 
        ~width:100
        ~height:10
         ~selectmode:`Single top
       in

        let _1 = Listbox.insert 
            ~index:`End
            ~texts: listeDonne  
            mylist
         in

        pack [l1];
        pack[mylist];  
         
         let _2 = Listbox.insert 
            ~index:`End
            ~texts:listeChoix 
           mylist2
         in 

         let btnAffpays = Button.create 
         ~text:"Afficher le pays" 
         ~command:(fun () -> 
          try
          let n = match (List.hd(Listbox.curselection mylist)) with 
          | `Num y -> y
          |_ -> failwith "pas de selection" in 

          Textvariable.set v (List.nth listeDonne n)
        with _ -> (print_endline"pas de selection"; flush stdout))

         top in

          let btnAffDonne = Button.create 
         ~text:"Afficher le type données" 
          ~command:(fun () -> 
          try
          let n = match (List.hd(Listbox.curselection mylist2)) with 
          | `Num y -> y
          |_ -> failwith "pas de selection" in 
          Textvariable.set v2 (List.nth listeChoix n)
        with _ -> (print_endline"pas de selection"; flush stdout))

         top in

       (* cereation de la fenetre qui affice les donnes *)  
         let make_daughter () =
          let d = Toplevel.create top in
          Wm.title_set d "Résultats de la recherche";
          Wm.geometry_set d "330x330";


          let a_frame = Frame.create ~relief:`Groove ~borderwidth: 2 d in
          let scry = Scrollbar.create a_frame in 
          let txt = Text.create ~width:100 ~height:100 
          ~yscrollcommand:(Scrollbar.set scry)
          ~background:(`Color "#FFCB60")
          ~foreground:(`Color "#3F2204")

          a_frame in 
          Scrollbar.configure ~command:(Text.yview txt) scry;
          grid ~column:0 ~row:0 [scry];
          grid ~column:1 ~row:0 [txt];

          let pays = Textvariable.get v in 
          let dataSelected = Textvariable.get v2 in
          let data = remove_blank dataSelected in
          let switch = Textvariable.get b in

         (* affiche les donnes sans coche trie par le type *)
          
          if (data = "Lesdonneesdetaillees" && switch = "OFF") then 
          let displayDetaille  = sysR#retourner_chaine_liste_sCoronas(sysR#retourner_donnees_pays pays) in 
          Text.insert (`End,[]) ("Voici les donnees detaillees du pays seléctionné \n"^"\n"^ displayDetaille) txt;

          else if(data = "Lescasconfirmes" && switch = "OFF") then let displayCasConfir = (sysR#retourner_chaine_info_pays pays 1) in 
          Text.insert (`End,[]) ("Voici la somme des cas trouvés pour le pays selectionné: \n" ^"\n"^ displayCasConfir) txt;

          else if(data = "Lasommedesdonnees" && switch = "OFF") then let displayCasConfir = (sysR#retourner_chaine_sommes_donnees_pays pays) in 
          Text.insert (`End,[]) ("Voici la somme des données  trouvés pour le pays selectionné: \n" ^"\n"^ displayCasConfir) txt;


          else if(data = "Lescasdecedes" && switch = "OFF") then let displayCasDec = (sysR#retourner_chaine_info_pays pays 2) in 
          Text.insert (`End,[]) ("Voici la somme des cas trouvés pour le pays selectionné: \n" ^"\n"^ displayCasDec) txt;

          else if(data = "Lescasretablis" && switch = "OFF") then let displayCasRet = (sysR#retourner_chaine_info_pays pays 3) in 
          Text.insert (`End,[]) ("Voici la somme des cas trouvés pour le pays selectionné: \n" ^"\n"^ displayCasRet) txt;

          else if(data = "Lescasactifs" && switch = "OFF") then let displayCasAct = (sysR#retourner_chaine_info_pays pays 4) in 
          Text.insert (`End,[]) ("Voici la somme des cas trouvés pour le pays selectionné: \n" ^"\n"^ displayCasAct) txt;

          (* affiche la liste des pays ordonnes selon les cas*)

          else if(data = "Lescasconfirmes" && switch = "ON"  ) then let casConfR = (sysR#retourner_chaine_resultats_ordonnes 1) in 
          Text.insert (`End,[]) ("Voici la liste  des pays origine_donnees selon le nombre de cas confirmes: \n" ^"\n"^ casConfR) txt;

           else if(data = "Lescasdecedes" && switch = "ON"  ) then let casDecR = (sysR#retourner_chaine_resultats_ordonnes 2) in 
          Text.insert (`End,[]) ("Voici la liste  des pays origine_donnees selon le nombre de cas decedes: \n" ^"\n"^ casDecR) txt;

           else if(data = "Lescasretablis" && switch = "ON"  ) then let casRetaR = (sysR#retourner_chaine_resultats_ordonnes 3) in 
          Text.insert (`End,[]) ("Voici la liste  des pays origine_donnees selon le nombre de cas retablis: \n" ^"\n"^ casRetaR ) txt;

           else if(data = "Lescasactifs" && switch = "ON"  ) then let casActifR = (sysR#retourner_chaine_resultats_ordonnes 4) in 
          Text.insert (`End,[]) ("Voici la liste  des pays origine_donnees selon le nombre de cas actifs : \n" ^"\n"^ casActifR ) txt;

          else
          Text.insert (`End,[]) "Error 404 !!! page introuvale" txt;

          
          pack [coe a_frame];    
          daughter := d  in

          let btnAffRes = Button.create 
         ~text:"Afficher les résultats" 
         ~command:(make_daughter) top in
          
         (* ajoute les bouton ddans la fenetre principale*)
        pack [mylist2];
        pack [labelPays];
        pack [labelPaysDis];
        pack [labelDonne];
        pack [labelDonneDis];
        pack [coe checkB];
        pack [btnAffpays];
        pack [btnAffDonne];
        pack [btnAffRes];  

        let _ = Printexc.print mainLoop () in
        print_endline "Merci et au revoir!\n"

   initializer
        print_string "Chargement des donnees en cours ...\n";
        flush stdout;
        let _,t = timeRun sysR#charger_donnees nom_fichier in
        print_string ("Chargement termine dans un temps de: " ^ (string_of_float t) ^ " secondes\n");
        flush stdout;
        self#lancer_app_sCorona

    
    end
    
  end

