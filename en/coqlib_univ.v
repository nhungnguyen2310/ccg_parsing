(* Basic types *)
Parameter Entity : Type.
Parameter Event : Type.

(* Thematic roles *)
Parameter subj : Event -> Entity.
Parameter top : Event -> Entity.
Parameter nom : Event -> Entity.
Parameter acc : Event -> Entity.
Parameter acci : Event -> Prop -> Prop.
Parameter acce : Event -> Event.
Parameter dat : Event -> Entity.
Parameter attr : Event -> Entity.
Parameter deg : Event -> Entity.

Parameter Subj : Event -> Entity.
Parameter Top : Event -> Entity.
Parameter Nom : Event -> Entity.
Parameter Acc : Event -> Entity.
Parameter AccI : Event -> Prop -> Prop.
Parameter AccE : Event -> Event.
Parameter Dat : Event -> Entity.
Parameter Attr : Event -> Entity.
Parameter Deg : Event -> Entity.

(* Temporal operators *)
Parameter Prog : Prop -> Prop.
Parameter Hold : Event -> Prop.
Parameter Cul : Event -> Prop.
Parameter Past : Event -> Prop.
Parameter Future : Event -> Prop.

(* Modal operators *)
Parameter Poss : Event -> Prop.
Parameter NonPoss : Event -> Prop.

(* Proposition marker and question marker *)
Parameter Content : Entity -> (((Event -> Prop) -> Event -> Prop) -> Prop) -> Prop.
Parameter WH : Prop -> Prop.

(* Auxiliary operators *)
Parameter Rel : Entity -> Entity -> Prop.
Parameter Mod : Entity -> Event -> Prop.
Parameter this : (Entity -> Prop) -> Entity.
Parameter that : (Entity -> Prop) -> Entity.
Parameter _in_front_of : Event -> Entity -> Prop.
Parameter _at_least : Event -> Prop.

Parameter ArgOf : Entity -> Entity -> Prop.
Parameter _argof : Entity -> Entity -> Prop.
Parameter _partof : Entity -> Entity -> Prop.
Parameter _evtoent : Event -> Entity -> Prop.

Parameter _have : Event -> Prop.
Parameter plur : Entity -> Prop.
Parameter _plur : Entity -> Prop.
Parameter female : Entity -> Prop.
Parameter male : Entity -> Prop.

(* Generalized quantifiers *)

(* Binary quantifiers *)
Parameter most : (Entity -> Prop) -> (Entity -> Prop) -> Prop.

Axiom most_ex_import :
  forall (F G: Entity -> Prop),
   (most F G -> exists x, F x /\ G x).

Axiom most_consv :
  forall (F G: Entity -> Prop),
   (most F G -> most F (fun x => (F x /\ G x))).

Axiom most_rightup :
  forall (F G H: Entity -> Prop),
   ((most F G) ->
   (forall x, G x -> H x) -> (most F H)).

Hint Resolve most_ex_import most_consv most_rightup.

(* Unary quantifiers *)
Parameter Few : (Entity -> Prop) -> Prop.

Axiom few_down : 
  forall (F G: Entity -> Prop),
   Few F -> (forall x, G x -> F x) -> Few G.

(* veridical predicates *)
Parameter _true : Event -> Prop.

Axiom veridical_true : forall v : Event, forall P : Prop, _true v -> AccI v P -> P.
Ltac solve_veridical_true :=
 match goal with
   H1 : _true ?e, H2 : AccI ?e _ |- _
     => try apply veridical_true with (v := e) in H2
 end.

(*
Parameter _true : Prop -> Prop.

Axiom veridical_true : forall P, (_true P -> P).

Ltac solve_veridical_true :=
  match goal with
    H : _true _ |- _
    => try apply veridical_true in H
  end.
*)

Parameter _????????? : Event -> Prop.
Axiom factive_?????????1 : forall (v : Event) (P : ((Event -> Prop) -> Event -> Prop) -> Prop),
  _????????? v -> Content (Nom v) P -> P (fun I => I).
Axiom factive_?????????2 : forall v : Event, forall P : Prop,
  _????????? v -> AccI v P ->  P.
Ltac solve_????????? :=
 match goal with
   | [H1 : _????????? ?e, H2 : Content (Nom ?e) _ |- _] => try apply factive_?????????1 with (v:=e) in H2
   | [H1 : _????????? ?e, H2 : AccI ?e _ |- _] => try apply factive_?????????2 with (v := e) in H2
 end.

Parameter _?????? : Entity -> Prop.
Axiom factive_?????? : forall v : Event, forall P : Prop,
  _?????? (Nom v) -> AccI v P -> P.
Ltac solve_?????? :=
 match goal with
   H1 : _?????? (Nom ?e), H2 : AccI ?e _ |- _
     => try apply factive_?????? with (v := e) in H2
 end.

(* anti-veridical predicates *)
Parameter _false : Event -> Prop.

Axiom antiveridical_false : forall v : Event, forall P : Prop, _false v -> AccI v P -> ~P.

Hint Resolve antiveridical_false.

Ltac solve_antiveridical_false :=
 match goal with
   H1 : _false ?e, H2 : AccI ?e _ |- _
     => try apply antiveridical_false with (v := e) in H2
 end.

(*
Parameter _false : Prop -> Prop.

Axiom antiveridical_false : forall P, (_false P -> ~P).

Hint Resolve antiveridical_false.

Ltac solve_antiveridical_false :=
  match goal with
    H : _false _ |- _
    => try apply antiveridical_false in H
  end.
*)

Parameter _??? : Entity -> Prop.
Axiom factive_??? : forall v : Event, forall P : Prop,
  _??? (Nom v) -> AccI v P -> ~P.

Ltac solve_??? :=
 match goal with
   H1 : _??? (Nom ?e), H2 : AccI ?e _ |- _
     => try apply factive_??? with (v := e) in H2
 end.

Axiom anti_factive_NonPoss1 : forall (v : Event) (P : ((Event -> Prop) -> Event -> Prop) -> Prop),
  NonPoss v -> Content (Nom v) P -> ~ (P (fun I => I)).
Axiom anti_factive_NonPoss2 : forall v : Event, forall P : Prop,
  NonPoss v -> AccI v P -> ~P.

Ltac solve_Poss :=
 match goal with
   | [H1 : NonPoss ?e, H2 : Content (Nom ?e) _ |- _] => try apply anti_factive_NonPoss1 with (v:=e) in H2
   | [H1 : NonPoss ?e, H2 : AccI ?e _ |- _] => try apply anti_factive_NonPoss2 with (v := e) in H2
 end.

(* Attitude verbs *)
Parameter _?????? : Event -> Prop.
Parameter _?????? : Event -> Prop.
Axiom pos_??????_?????? : forall (v : Event) (P : Prop), (_?????? v -> AccI v P -> _?????? v /\ AccI v P).
Axiom neg_prop_??????_?????? : forall (v : Event) (P : ((Event -> Prop) -> Event -> Prop) -> Prop),
  _?????? v -> Content (Acc v) P -> _?????? v /\ AccI v (~ (P (fun I => I))).
Axiom neg_wh_??????_?????? : forall v P, (_?????? v -> AccI v (WH (~P)) -> _?????? v /\ AccI v P).

Ltac solve_??????_?????? :=
 match goal with
   | [H1 : _?????? ?e, H2 : AccI ?e (WH _) |- _] => try apply neg_wh_??????_?????? with (v := e) in H2
   | [H1 : _?????? ?e, H2 : Content (Acc ?e) _ |- _] => try apply neg_prop_??????_?????? with (v:=e) in H2
   | [H1 : _?????? ?e, H2 : AccI ?e _ |- _] => try apply pos_??????_?????? with (v := e) in H2
 end.

(* implicative verbs *)
Parameter _manage : Event -> Prop.

Axiom implicative_manage : forall v : Event, forall P : Prop, AccI v P -> _manage v -> P.

Ltac solve_implicative_manage :=
  match goal with
    H1 : _manage ?v, H2 : AccI ?v _ |- _
    => try apply implicative_manage in H2
  end.

Parameter _manage1 : Entity -> Prop -> Prop.

Axiom implicative_manage1 : forall x P, (_manage1 x P -> P).

Ltac solve_implicative_manage1 :=
  match goal with
    H : _manage1 _ _ |- _
    => try apply implicative_manage1 in H
  end.

Parameter _fail : Event -> Prop.

Axiom implicative_fail :  forall v : Event, forall P : Prop, AccI v P -> _fail v -> ~ P.

Ltac solve_implicative_fail :=
  match goal with
    H : _fail ?v, H2 : AccI ?v _ |- _
    => try apply implicative_fail in H2
  end.

Parameter _fail1 : Entity -> Prop -> Prop.

Axiom implicative_fail1 : forall x P, (_fail1 x P -> ~ P).

Ltac solve_implicative_fail1 :=
  match goal with
    H : _fail1 _ _ |- _
    => try apply implicative_fail1 in H
  end.

Parameter _?????? : Event -> Prop.
Axiom implicative_?????? : forall (v : Event) (x : Entity) (P : ((Event -> Prop) -> Event -> Prop) -> Prop),
  _?????? v -> Nom v = x -> Past v -> Content (Dat v) P -> P (fun J : Event -> Prop => fun e : Event => J e /\ Nom e = x /\ Past e).
Ltac solve_?????? :=
 match goal with
   | [H1 : _?????? ?e, H2 : Nom ?e = ?t, H3 : Past ?e, H4 : Content (Dat ?e) _ |- _]
     => apply implicative_?????? with (v:=e)(x:=t) in H4
 end.

(* factive verbs *)
Parameter _know : Event -> Prop.

Axiom factive_know : forall v : Event, forall P : Prop, AccI v P -> _know v -> P.

Ltac solve_factive :=
  match goal with
    H1 : _know ?v, H2 : AccI ?v _ |- _
    => try apply factive_know in H2
  end.

Parameter _know1 : Entity -> Prop -> Prop.

Axiom factive_know1 : forall x P, (_know1 x P -> P).

Ltac solve_factive1 :=
  match goal with
    H : _know1 _ _ |- _
    => try apply factive_know1 in H
  end.

(* Perceptual verbs *)
Parameter _?????? : Event -> Prop.
Axiom factive_?????? : forall (v : Event) (P : ((Event -> Prop) -> Event -> Prop) -> Prop),
  _?????? v -> Past v -> Content (Acc v) P -> P (fun J : Event -> Prop => fun e : Event => J e /\ Past e).
Ltac solve_factive_?????? :=
 match goal with
   | [H1 : _?????? ?e, H2 : Past ?e, H3 : Content (Acc ?e) _ |- _]
     => apply factive_?????? with (v:=e) in H3
 end.

Axiom closure_?????? : forall (v: Event) (P P': ((Event -> Prop) -> Event -> Prop) -> Prop),
  _?????? v -> Content (Acc v) P -> (P (fun I => I) -> P' (fun I => I)) -> Content (Acc v) P'.
Ltac solve_closure_?????? :=
 match goal with
   | [H1 : _?????? ?e, H2 : Content (Acc ?e) ?A |- Content (Acc ?e) ?B ]
     => apply closure_?????? with (v:=e)(P:=A)(P':=B)
 end.

Parameter _?????? : Event -> Prop.
Axiom factive_?????? : forall (v : Event) (P : ((Event -> Prop) -> Event -> Prop) -> Prop),
  _?????? v -> Past v -> Content (Acc v) P -> P (fun J : Event -> Prop => fun e : Event => J e /\ Past e).
Ltac solve_factive_?????? :=
 match goal with
   | [H1 : _?????? ?e, H2 : Past ?e, H3 : Content (Acc ?e) _ |- _]
     => apply factive_?????? with (v:=e) in H3
 end.

Axiom closure_?????? : forall (v: Event) (P P': ((Event -> Prop) -> Event -> Prop) -> Prop),
  _?????? v -> Content (Acc v) P -> (P (fun I => I) -> P' (fun I => I)) -> Content (Acc v) P'.
Ltac solve_closure_?????? :=
 match goal with
   | [H1 : _?????? ?e, H2 : Content (Acc ?e) ?A |- Content (Acc ?e) ?B ]
     => apply closure_?????? with (v:=e)(P:=A)(P':=B)
 end.

(* privative adjectives *)
Parameter _former1 : Prop -> Prop.
Axiom privative_former1 : forall P, (_former1 P -> ~P).

Ltac solve_privative_former1 :=
  match goal with
    H : _former1 _ |- _
    => try apply privative_former1 in H
  end.

(*
Parameter _fake : Prop -> Prop.
Axiom privative_fake : forall P, (_fake P -> ~P).

Ltac solve_privative_fake :=
  match goal with
    H : _fake _ |- _
    => try apply privative_fake in H
  end.
*)

Parameter _former : (Entity -> Prop) -> Entity -> Prop.
Axiom privative_former : forall F : Entity -> Prop, forall x : Entity, (_former F x -> ~ (F x)).
Ltac solve_privative_former :=
  match goal with
    H : _former ?A ?t |- _
    => try apply privative_former with (F:= A)(x:= t) in H
  end.

Parameter _fake : (Entity -> Prop) -> Entity -> Prop.
Axiom privative_fake : forall F : Entity -> Prop, forall x : Entity, (_fake F x -> ~ (F x)).
Ltac solve_privative_fake :=
  match goal with
    H : _fake ?A ?t |- _
    => try apply privative_fake with (F:= A)(x:= t) in H
  end.

Parameter _?????? : (Entity -> Prop) -> Entity -> Prop.

Parameter _?????? : (Entity -> Prop) -> Entity -> Prop.
Axiom wouldbe : forall F G: Entity -> Prop, forall x : Entity, _?????? F x -> (F x -> G x) -> _?????? G x.
Ltac solve_closure_wouldbe :=
  match goal with
    H : _?????? ?A ?t |- _?????? _ _
    => try apply wouldbe with (F:= A); try apply H
  end.

(* intensional verbal modifiers *)
Parameter _?????? : (Event -> Prop) -> Event -> Prop.
Axiom anti_veridical_?????? : forall F : Event -> Prop, forall v : Event, (_?????? F v -> ~ (F v)).
Ltac solve_anti_veridical_?????? :=
  match goal with
    H : _?????? ?A ?t |- _
    => try apply anti_veridical_?????? with (F:= A)(v:= t) in H
  end.

Parameter _????????? : (Event -> Prop) -> Event -> Prop.
Axiom anti_veridical_????????? : forall F : Event -> Prop, forall v : Event, (_????????? F v -> ~ (F v)).
Ltac solve_anti_veridical_????????? :=
  match goal with
    H : _????????? ?A ?t |- _
    => try apply anti_veridical_????????? with (F:= A)(v:= t) in H
  end.

(* antonyms *)
Parameter _????????? : Entity -> Prop.
Parameter _????????? : Entity -> Prop.
Axiom antonym_?????????_????????? : forall x : Entity, _????????? x -> _????????? x -> False.
Ltac solve_antonym_?????????_????????? :=
  match goal with
    H1 : _????????? _, H2 : _????????? ?t |- False
  => try apply antonym_?????????_????????? with (x := t)
  end.

Parameter _???????????? : Event -> Prop.
Parameter _????????? : Event -> Prop.
Axiom antonym_????????????_????????? : forall v : Event, _???????????? v -> _????????? v -> False.
Ltac solve_antonym_????????????_????????? :=
  match goal with
    H1 : _???????????? _, H2 : _????????? ?e |- False
  => try apply antonym_????????????_????????? with (v := e)
  end.

Parameter _?????? : Event -> Prop.
Parameter _????????? : Event -> Prop.
Axiom antonym_??????_????????? : forall v : Event, _?????? v -> _????????? v -> False.
Ltac solve_antonym_??????_????????? :=
  match goal with
    H1 : _?????? ?e, H2 : _????????? ?e |- _ 
  => try apply antonym_??????_????????? with (v := e) in H1
  end.

(* causatives and benefactives *)
Parameter _?????? : Event -> Prop.
Parameter _????????? : Event -> Prop.

Axiom causative1 : forall v : Event, forall x : Entity,
  _?????? v -> Dat v = x -> Nom v = x.
Axiom causative2 : forall v : Event, forall x : Entity,
  _?????? v -> Acc v = x -> Nom v = x.
Hint Resolve causative1 causative2.

Axiom benefactive : forall v : Event, forall x : Entity,
  _????????? v -> Dat v = x -> Nom v = x.
Hint Resolve benefactive.


(* Causative alternation *)
Parameter _?????? : Event -> Prop.
Parameter _????????? : Event -> Prop.
Axiom causative_??????_????????? : forall v : Event,
  _?????? v -> _????????? v /\ Nom v = Acc v.

Ltac solve_causative_??????_????????? :=
  match goal with
    | [ H1 : _?????? ?e |- _ ]
     => apply causative_??????_????????? with (v := e) in H1
  end.

Parameter _????????? : Event -> Prop.
Axiom causative_?????????_????????? : forall v : Event,
  _????????? v -> _????????? v /\ Nom v = Acc v.

Ltac solve_causative_?????????_????????? :=
  match goal with
    | [ H1 : _????????? ?e |- _ ]
     => apply causative_?????????_????????? with (v := e) in H1
  end.

(* before and after *)
(*
Parameter _before : Event -> Event -> Prop.
Parameter _after : Event -> Event -> Prop.

Axiom transitivity_before : forall v1 v2 v3 : Event,
  _before v1 v2 -> _before v2 v3 -> _before v1 v3.

Axiom transitivity_after : forall v1 v2 v3 : Event,
  _after v1 v2 -> _after v2 v3 -> _after v1 v3.

Axiom before_after : forall v1 v2 : Event,
  _before v1 v2 -> _after v2 v1.

Axiom after_before : forall v1 v2 : Event,
  _after v1 v2 -> _before v2 v1.

Hint Resolve transitivity_before transitivity_after before_after after_before.
*)

(* Preliminary tactics *)

Ltac apply_ent :=
  match goal with
    | [x : Entity, H : forall x : Entity, _ |- _]
     => apply H; clear H
  end.

Ltac eqlem_sub :=
  match goal with
    | [ H1: ?A ?t, H2: forall x, @?D x -> @?C x |- _ ]
     => match D with context[ A ]
         => assert(C t); try (apply H2 with (x:= t)); clear H2
    end
  end.

Ltac eqlem1 :=
  match goal with
    | [x : Entity, H0 : ?A ?x, H : forall x, ?A x -> _ -> @?C x |- _]
     => match type of H with context[_ = _]
        => assert(C x)
     end
  end.

Ltac eqlem2 :=
  match goal with
    | [x : Entity, H0 : ?A ?x, H : forall x, ?A x /\ ?B x -> _ -> @?C x |- _]
     => match type of H with context[_ = _]
        => assert(C x)
     end
  end.

Ltac eqlem3 :=
  match goal with
    | [x : Entity, H0 : ?A ?x, H : forall x, _ /\ ?A x -> @?C x |- _]
     => match type of H with context[_ = _]
        => assert(C x)
     end
  end.

Axiom unique_role : forall v1 v2 : Event, Subj v1 = Subj v2 -> v1 = v2.
Ltac resolve_unique_role :=
  match goal with 
    H : Subj ?v1 = Subj ?v2 |- _
    => repeat apply unique_role in H
  end.

Ltac substitution :=
  match goal with
    | [H1 : _ = ?t |- _ ]
      => try repeat resolve_unique_role; try rewrite <- H1 in *; subst
    | [H1 : ?t = _ |- _ ]
      => try resolve_unique_role; try rewrite H1 in *; subst
  end.

Ltac exchange :=
  match goal with
    | [H1 : forall x, _, H2 : forall x, _ |- _]
     => generalize dependent H2
  end.

Ltac exchange_equality :=
  match goal with
    | [H1 : _ = _, H2: _ =  _ |- _]
     => generalize dependent H2
  end.

Ltac clear_pred :=
  match goal with
    | [H1 : ?F ?t, H2 : ?F ?u |- _ ]
     => clear H2
  end.

Ltac solve_false :=
  match goal with
    | [H : _ -> False |- False]
     => apply H
  end.

Axiom urevent : Event.
Ltac ap_event := try apply urevent.


(* Main tactics *)

Ltac nltac_init :=
  try(intuition;
      try solve_false;
      firstorder;
      repeat subst;
      firstorder).

Ltac nltac_base := 
  try nltac_init;
  try (eauto; eexists; firstorder);
  try repeat substitution;
  try (subst; eauto; firstorder; try congruence);
  try ap_event. 

Ltac nltac_axiom :=
 try first
   [solve_veridical_true |
    solve_antiveridical_false |
    solve_implicative_manage |
    solve_implicative_fail |
    solve_factive |
    solve_privative_former |
    solve_privative_fake |
    solve_implicative_manage1 |
    solve_implicative_fail1 |
    solve_factive1 |
    solve_privative_former1 |
    solve_????????? |
    solve_?????? |
    solve_??? |
    solve_Poss |
    solve_??????_?????? |
    solve_?????? |
    solve_factive_?????? |
    solve_factive_?????? |
    solve_anti_veridical_?????? |
    solve_anti_veridical_????????? |
    solve_causative_??????_????????? |
    solve_causative_?????????_????????? |
    solve_antonym_?????????_????????? |
    solve_antonym_????????????_????????? |
    solve_antonym_??????_?????????
   ].

Ltac nltac_closure_axiom :=
 try first
   [solve_closure_?????? |
    solve_closure_?????? |
    solve_closure_wouldbe
   ].

Ltac nltac_set :=
  repeat (nltac_init;
          try repeat substitution;
          try exchange_equality;
          try repeat substitution;  
          try apply_ent;
          try eqlem_sub).

Ltac nltac_set_exch :=
  repeat (nltac_init;
          try repeat substitution;
          try apply_ent;
          try exchange;
          try eqlem_sub).

Ltac nltac_final :=
  try solve [repeat nltac_base | clear_pred; repeat nltac_base].

Ltac nltac_prove :=
  try solve [nltac_set; nltac_final | nltac_set_exch; nltac_final].

Ltac solve_gq :=
  match goal with
    H : most _ _ |- _
    => let H0 := fresh in
       try solve [         
          pose (H0 := H); eapply most_ex_import in H0;
            try (nltac_set; nltac_final) |
          pose (H0 := H); eapply most_consv in H0;
            eapply most_rightup in H0;
            try (nltac_set; nltac_final) |
          pose (H0 := H); eapply most_consv in H0;
            try (nltac_set; nltac_final) |
          pose (H0 := H); eapply most_rightup in H0;
            try (nltac_set; nltac_final) ]
  end.

Ltac solve_gq1 :=
  match goal with
    H : most _ _ |- _
    => let H0 := fresh in
       try solve [         
          pose (H0 := H); eapply most_ex_import in H0; nltac_prove |
          pose (H0 := H); eapply most_consv in H0; eapply most_rightup; nltac_prove |
          pose (H0 := H); eapply most_consv in H0; nltac_prove |
          pose (H0 := H); eapply most_rightup in H0; nltac_prove ]
  end.

Ltac solve_gq2 :=
  match goal with
    H : Few _ |- _
    => let H0 := fresh in
       try solve [
          pose (H0 := H); eapply few_down in H0; nltac_prove ]
  end.

(* JSeM *)
Ltac nltac_ja :=
  try solve
    [nltac_prove |
     nltac_init; (solve_gq1 || solve_gq2) |
     nltac_set; try nltac_axiom; solve [nltac_final | nltac_prove] |
     nltac_set; nltac_base; try nltac_closure_axiom; solve [nltac_final | nltac_prove]
    ].

(* SICK *)
Ltac nltac_simp :=
  try solve
    [nltac_set; nltac_final].

Ltac nltac :=
  try solve
    [nltac_final |
     nltac_set; nltac_final |
     (* nltac_set_exch; nltac_final | *)
     nltac_init; solve_gq |
     nltac_set; try nltac_axiom; solve [nltac_final | nltac_set; nltac_final]
    ].
