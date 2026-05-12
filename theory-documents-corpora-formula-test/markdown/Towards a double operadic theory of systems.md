---
library_id: sha256:7b3e07f15cda74f67f956ec679f36b0118374c5a14840bd9dc3f2c74210f9738
source_path: theory-documents/Towards a double operadic theory of systems.pdf
markdown_path: theory-documents-corpora-formula-test/markdown/Towards a double operadic theory of systems.md
media_type: application/pdf
source_hash: 7b3e07f15cda74f67f956ec679f36b0118374c5a14840bd9dc3f2c74210f9738
source_mtime: 2026-05-04T16:17:32.503852+00:00
processed_at: 2026-05-06T07:54:19.123467+00:00
processor: docling
processor_version: unknown
chunk_count: 1075
status: indexed
title: Towards a double operadic theory of systems
page_count: 80
embedding_provider: openrouter
embedding_model: local/hash-embedding
---

## Towards a double operadic theory of systems

Sophie Libkind David Jaz Myers

June 10, 2025

## Abstract

We present a unified framework for categorical systems theory which packages a collection of open systems, their interactions, and their maps into a symmetric monoidal loose right module of systems over a symmetric monoidal double category of interfaces and interactions . As examples, we give detailed descriptions of (1) the module of open Petri nets over undirected wiring diagrams and (2) the module of deterministic Moore machines over lenses. We define several pseudo-functorial constructions of modules of systems in the form of doctrines of systems theories . In particular, we introduce doctrines for port-plugging systems, variable sharing systems, and generalized Moore machines, each of which generalizes existing work in categorical systems theory. Finally, we observe how diagrammatic interaction patterns are free processes in particular doctrines.

## Contents

|   1 Introduction | 1 Introduction                                               | 1 Introduction                                               |   2 |
|------------------|--------------------------------------------------------------|--------------------------------------------------------------|-----|
|                  | 1.1                                                          | Categorical systems theories . . . . . . . . . . . . . .     |   2 |
|                  | 1.2                                                          | Operadic systems theories and process theories . . .         |   3 |
|                  | 1.3                                                          | Double operadic systems theory . . . . . . . . . . .         |   5 |
|                  | 1.4                                                          | Contributions of this paper . . . . . . . . . . . . . .      |   7 |
|                  | 1.5                                                          | Future work . . . . . . . . . . . . . . . . . . . . . . .    |   8 |
|                2 | Preliminaries                                                | Preliminaries                                                |   9 |
|                  | 2.1                                                          | 2-Categories and ℱ -sketches . . . . . . . . . . . . .       |   9 |
|                  | 2.2                                                          | Double categorical preliminaries . . . . . . . . . . .       |  11 |
|                  | 2.3                                                          | Adequate triples, spans, and lenses . . . . . . . . . .      |  12 |
|                3 | Loose bimodules and loose right modules                      | Loose bimodules and loose right modules                      |  19 |
|                  | 3.1                                                          | Loose bimodules . . . . . . . . . . . . . . . . . . . .      |  20 |
|                  | 3.2                                                          | Loose bimodules as pseudo-bimodules . . . . . . .            |  22 |
|                  | 3.3                                                          | Collapse and restriction of loose bimodules . . . . .        |  24 |
|                4 | Symmetric monoidal loose right modules as modules of systems | Symmetric monoidal loose right modules as modules of systems |  32 |
|                  | 4.1                                                          | Module of systems over interactions . . . . . . . . .        |  32 |
|                  | 4.2                                                          | Examples of modules of systems . . . . . . . . . . .         |  35 |
|                5 | Constructing modules of systems via doctrines                | Constructing modules of systems via doctrines                |  49 |
|                  | 5.1                                                          | Doctrines of systems theories . . . . . . . . . . . . .      |  49 |
|                  | 5.2                                                          | Doctrine of initial processes . . . . . . . . . . . . . .    |  50 |
|                6 | Span and cospan doctrines via adequate triples               | Span and cospan doctrines via adequate triples               |  53 |
|                  | 6.1                                                          | Doctrine of spans of adequate triples . . . . . . . . .      |  53 |
|                  | 6.2                                                          | Span and cospan doctrines for lex and rex categories         |  54 |

| 7                                           | The doctrine of generalized Moore machines   | The doctrine of generalized Moore machines   |   55 |
|---------------------------------------------|----------------------------------------------|----------------------------------------------|------|
|                                             | 7.1                                          | Tangencies . . . . . . . . . . . . . . . . . |   56 |
|                                             | 7.2                                          | Tangencies as systems theories . . . . .     |   59 |
|                                             | 7.3                                          | Doctrine of open coalgebras . . . . . . .    |   63 |
|                                             | 7.4                                          | Doctrine of ODEs in tangent categories       |   66 |
| 8 Restricting doctines to free interactions | 8 Restricting doctines to free interactions  | 8 Restricting doctines to free interactions  |   68 |
|                                             | 8.1                                          | Wiring diagrams are free interactions . .    |   68 |
|                                             | 8.2                                          | Restricting a doctrine to free interactions  |   70 |
|                                             | 8.3                                          | Examples of restricting doctrines . . . .    |   72 |

## 1 Introduction

## 1.1 Categorical systems theories

Categorical systems theory is the branch of applied category theory that uses methods of categorical algebra to aid in the modular design and compositional analysis of complex systems.

No one can quite agree on what a 'system' is; and they shouldn't have to. Rather, different people working on different problems devise different particular notions of system systems theories -to best address the needs of the problem at hand. 'Systems' might be systems of equations such as ODEs or PDEs, (non-)deterministic automata of varying forms, Markov processes or Markov decision processes, Hamiltonians on symplectic manifolds, Lagrangian relations, or a variety of diagrammatic languages used to describe systems such as circuit diagrams, stock-flow diagrams, Petri nets, Tonti diagrams, labelled transition systems, weighted graphs, and many others.

In general, the term 'system' only means that a whole has been composed of many parts. We use the term categorical systems theory to refer to a large body of work that uses categorical algebra to organize the patterns of composition by which complex systems may be formed out of simpler components, and giving methods for analysing the behavior of composite systems in terms of their components' behavior and the pattern by which they were composed. The basic ideas of categorical systems theory are:

## 1.1.1 Basic ideas of categorical systems theory

1. Any system interacts with its environment through its interface , which can be described separately from the system itself.
2. All interactions of the system with its environment take place through its interface, so that from the point of view of the environment, all we need to know about a system is what is going on at the interface.
3. Systems interact with other systems through their respective interfaces through ongoing processes . So, to understand complex systems in terms of their component subsystems, we need to understand the processes through which interfaces can interact. We refer to a particularly simple (for example, state-free) interaction as a composition pattern .
4. Given (a) a process describing how system interfaces may interact and (b) component systems with those interfaces, we should derive a composite system that is the totality of the component subsystems interacting according to that process. This application of processes to component systems allows for the modular design of systems.
5. For a given systems theory, we can derive certain behaviors, facts, and features of a composite system from the behaviors, facts, and features of its component subsystems and the process that connects them. Such a method is known as a compositionality theorem . It is not always possible

to characterize the behaviors of composite systems in terms of their component subsystems, but we often can compose the behaviors of composite systems to derive some of the behaviors of their composites, and then study the difference.

In this paper, we put forward a general framework for categorical systems theory in the form of symmetric monoidal loose right modules (of systems) over symmetric monoidal double categories (of interfaces and interactions). This framework builds on the 'double indexed' approach [Jaz21] and its expansion in the manuscript [Mye21], as well as the operadic theory of systems [LBPF22]. We aim to kick off a program of organizing categorical systems theory in this double operadic point of view by:

1. Constructing, pseudo-functorially in basic data, a number of symmetric monoidal loose right modules of systems of various kinds, including
2. (a) Systems that compose via lens composition, such as systems of ODEs, partially observable Markov decision processes, and Moore machines of various kinds.
3. (b) Systems that compose by gluing together parts (pushout), such as Petri nets, stock-flow diagrams, causal loop diagrams, and other diagrammatic presentations of systems.
4. (c) Systems that compose by sharing variables, as in Jan Willems' behavioral approach to control theory [Wil07], or Lagrangian relations.
2. Giving a method for restricting the interactions between systems to those generated by particular data, allowing us to extend the above pseudo-functorial constructions to produce algebras for (double) operads of various sorts of wiring diagrams .

Pseudo-functoriality of the above constructions can be used to give a number of black-boxing compositionality theorems along the lines of Fong and Sarazola's recipes [FS18a].

In the remainder of this introduction, we will briefly review existing approaches to categorical systems theory and where categorial systems theory would benefit from our 'double operadic' approach (in Section 1.2); we will then sketch, informally, the double operadic view on systems theory (in Section 1.3); finally, we will summarize the contributions of this paper (in Section 1.4) and sketch some future directions for the double operadic theory of systems (in Section 1.5).

## 1.2 Operadic systems theories and process theories

Category theorists make the informal ideas of § 1.1.1 formal by associating to each systems theory (ODEs, Markov decision processes, causal loop diagrams, etc.) a categorical structure, and expressing compositionality theorems as morphisms between these structures. Speaking generally, categorical systems theory has relied on two key gadgets: algebras for operads and symmetric monoidal categories , perhaps with extra structure.

- In the operadic point of view (see, e.g. [FBSD21], [LBPF22], [Spi13], [BF21]), we use two mathematical structures to define a systems theory:
1. A (symmetric, multi-object) operad 𝑊 whose objects are system interfaces and whose morphisms 𝑤 : 𝐼 1 , . . . , 𝐼 𝑛 → 𝐽 are ways that 𝑛 systems (each with interface 𝐼 𝑗 for 0 ≤ 𝑗 ≤ 𝑛 ) may be composed into a single system with interface 𝐽 (often known as wiring diagrams [Yau18]);
2. An algebra 𝑆 : 𝑊 → Set which associates to every interface 𝐼 ∈ 𝑊 the set 𝑆 ( 𝐼 ) of systems with this interface, and associates to every composition pattern 𝑤 : 𝐼 1 , . . . , 𝐼 𝑛 → 𝐽 the operation 𝑆 ( 𝑤 ) : 𝑆 ( 𝐼 1 ) × · · · × 𝑆 ( 𝐼 𝑛 ) → 𝑆 ( 𝐽 ) of composition by that pattern.

Acompositionality theorem then takes the form of a morphism between the operads of composition patterns and, relative to this, a morphism of the algebras of systems. Examples of this pattern include [SSV19], [Spi15], [DL25], [Lib+22], and [BPSM20].

- In the symmetric monoidal point of view (see, e.g. [BS10], [BE14], [BCR17], [Fri20], [CFS16]), we use a symmetric monoidal category 𝑆 (perhaps with extra structure) to define a systems theory.
1. It is the morphisms of 𝑆 which are the systems in this theory; a system 𝑠 : 𝐼 → 𝑂 in this point of view always has an input interface 𝐼 and an output interface 𝑂 .
2. Systems compose in series using composition of morphisms in 𝑆 , and they compose in parallel using the symmetric monoidal product of 𝑆 .
3. Since systems in this point of view always have an input and output, we will follow the seminal [KSW97] and call such symmetric monoidal categories process theories (to separate them from the operadic systems theories ).

Acompositionality theorem takes the form of a lax symmetric monoidal functor between symmetric monoidal categories. Examples of this pattern include [FS18a], [BFP16], [BF15], [BCR17].

Both operad algebras and symmetric monoidal categories miss out on a crucial way that systems relate to each other: maps between systems . In systems theory, maps between systems include:

1. Refinements , coarse grainings , and simulations .
2. Subsystem inclusions such as attractors .
3. Behaviors of systems such as trajectories , traces , as well as behaviors satisfying special properties such as periodic orbits and steady states .
4. Lyapunov and control-barrier functions which witness certain properties of the behavior of systems.

Our theories of systems must account for maps between systems in order to study system behavior, express notions of refinement, coarse-graining, and bisimulation which are needed for model surrogacy, and witness safety and liveness properties of systems.

Various approachs to categorical systems theory have successfully accounted for maps between systems. Indeed, much of categorical systems theory has focused primarily on systems and their maps, and not on the composition of the systems themselves. The highly successful application of coalgebras ([Rut00], [Kur01], [Cir13]) to systems theory exemplifies how the study of maps between systems can capture the structure of the systems themselves.

Baez et. al. [BFMP17] extended the operadic systems theories to account for maps between systems by using operad algebras valued in categories of systems, rather than sets of systems. However, this approach only expresses maps between systems with identical interfaces; many interesting maps, such as trajetories, steady states, and Lyapunov functions must act on the interface as well.

The seminal work of Katis, Sabadini, and Walters [KSW97], introduced symmetric monoidal bicategories as process theories (see also [GHL99], [BLLL23], [CGHR22], [Di +20]). This line of work expressed maps between processes as well as sequential and parallel composition of processes. However, as with the operadic systems theories, this approach does not express maps between systems with different interaces.

In his thesis [Cou20], Courser further extends the process theory lineage by considering symmetric monoidal double categories of systems (see also [BC17], [BCV22a], [Lor25], [Mas21], [BM20]). The upgrade to double categories introduces maps between processes with different interfaces. However, the process theory approach obscures the composition patterns that interconnect systems, and presupposes that system interfaces have a clean division into input and output. See Remark 8.12 for a more detailed comparison between our approach and Courser's.

In this paper, we put forward a new approach categorical systems theory using algebras for double operads , or, more precisely, symmetric monoidal loose right modules of symmetric monoidal double categories. We will call our approach the double operadic theory of systems (or 'DOTS'). Double operadic systems theory combines the best of the operadic systems theory and process theory approaches. As in operadic systems theories, a double operadic systems theory treats composition patterns as concrete objects that can act on systems. As in Courser's processes theories, a double operadic systems theory includes maps between systems with different interfaces.

## 1.3 Double operadic systems theory

The basic ideas of categorical systems theory leave a lot of questions unanswered. What is, or what could be a system? What is an interface? What is a process of interactions? between systems? What is a behavior of a system, and how can we study it categorically? There is no single answer to this suite of questions. Rather, we may package answers to this suite of questions into a systems theory .

Informal definition 1.1 (Systems theory) . A systems theory is a particular way to answer the following questions:

1. What does it mean to be a system ? Does it have a notion of states, or of behaviors? Or is it a diagram describing the way some primitive parts are organized?
2. What should the interface of a system be?
3. How can interfaces be connected through processes of interaction or composition patterns ?
4. How are systems composed through processes of interaction between their interfaces?
5. How do systems refine , simulate , or coarse-grain each other? How may systems be included as sub-systems ? In other words, what is a map between systems, and what is a corresponding notion of map for interfaces?
6. When can maps between systems be composed along the same interactions as the systems?

The questions in Informal definition 1.1 suggests the following ontology for systems theory, which we may package into a very small (strict) double category:

Figure 1: Ontology of double categorical systems theory

![[Towards a double operadic theory of systems.assets/figure-0001.png]]

We read the elements of this double category as the kinds of entities determined by theory of systems: system s, interfaces , interactions , and so on. The extra unnamed object · is there just to give system a domain. If we suppose that all displayed elements except for system are identities in this double category, we get a very compact way of expressing the following axioms for systems theories:

1. Every system admits an interface : we have system : · p → interface .
2. An interaction has an "inner" interface and an "outer" interface: we have interaction : interface p → interface .
3. We may compose a system with a interaction to get a new system:
4. There is a notion of map for interfaces ( interface map : interface → interface ), and a notion of map for systems ( system map ); every system map comes with a corresponding map from the interface of its domain to the interface of its codomain. We may compose interface maps to get new interface maps (since interface map ◦ interface map = interface map ) and similarly we may compose system maps to get new system maps.

![[Towards a double operadic theory of systems.assets/figure-0002.png]]

![[Towards a double operadic theory of systems.assets/figure-0003.png]]

5. There is a notion of map of interactions , which we might also think of as a compatibility between interface maps and composition patterns. Given a map of interactions, we may compose a system map along those interaction maps to get a new system map between the composed systems:

![[Towards a double operadic theory of systems.assets/figure-0004.png]]

In general, we may think of the double category Figure 1 as our ontology for systems theory. A particular systems theory is the necessary assumptions to form a collection of entities of the above kinds, able to compose in the above ways. In other words, a systems theory will give rise to a (generally not strict) double category S equipped with a double functor to the above simple double category, labelling each of its elements with the appropriate kinds. We call such a labeled double category a module of systems , and we may picture a module of systems as follows:

Figure 2: Systems theory as labelled double category

![[Towards a double operadic theory of systems.assets/figure-0005.png]]

Not quite pictured above is the most basic kind of composition of systems: the parallel product , where two systems are composed but do not interact . We write the paralell product as ∥ for both systems and interfaces, so that in the above picture we have system ∥ system = system (that is, the parallel product of two systems is a system) and interface ∥ interface = interface (the parallell product of two interfaces is an interface), and so on for the other elements of a module of systems. This leads us to our formal definition in Section 4.1 of a module of systems as a symmetric monoidal object of an appropriate 2-category of loose (right) modules of double categories : a symmetric monoidal loose right module (of systems and maps) over a symmetric monoidal double category (of interfaces, interactions, and maps between them).

We will see this point of view on systems theories worked out with full examples in Section 4.

Remark 1.2 (Symmetric monoidal loose right modules and algebras of double operads) . One might wonder why we have decided to use the name "double operadic systems theory" when our main objects of study are not algebras for double operads but instead symmetric monoidal loose right modules on symmetric monoidal double categories.

In the 1-categorical case, symmetric monoidal categories C may be identified with operads (here meaning symmetric multicategories) which have all tensors. In this case, algebras for C (which may be defined as operad morphisms 𝐴 : C → Set ) correspond to lax symmetric monoidal functors 𝐴 : C → Set . Such functors are symmetric monoidal right modules (also known as profunctors) over the symmetric monoidal category C .

To facilitate the constructions we perform in this paper, we make use of the same trick. We will use symmetric monoidal loose right modules over a symmetric monoidal double category in place of algebras for double operads. We put off a formal comparison between these two notions to later work. However, it is true that in the double categorical setting, these two notions diverge more strongly than in the 1-categorical setting. Nevertheless, the constructions we present here suffice to give algebras for double operads.

For the expert reader, here is a specific conjecture concerning their relationship: the 2-category of symmetric monoidal loose right modules over isofibrant double categories and pseudo symmetric monoidal pseudo double functors whose unitors and laxators are companion commuter transformations is equivalent to the 2-category of algebras for isofibrant double operads with all tensors and pseudo-morphisms whose universal comparison map between tensors is companion to an isomorphism.

## 1.4 Contributions of this paper

In this paper, we put forward a general setting for the modular design and compositional analysis of complex systems that accounts for both the composition of systems and of the maps between them. Below we present several key aspects of our approach to categorical systems theory and their relation to past work in categorical systems theory.

1. We define a module of systems as symmetric monoidal loose right module (of systems and their maps) over a symmetric monoidal double category (of interfaces, interactions, and their maps). That is, we see loose morphisms in symmetric monoidal double categories as interaction processes by which systems can be composed. Seeing operads as process theories which act on systems by composing them is the approach taken in the recent [SSWC25]; we add to this approach the maps of systems and their interfaces.
2. We give a number of (pseudo-)functorial constructions of systems theories, incorporating existing work and providing new examples, including:
3. (a) For any (symmetric monoidal double category), we associate its systems theory of initial processes 𝑆 : ∗ p → 𝐼 . See Section 5.2 for this construction.
4. (b) For any category 𝐶 with pushouts (such as a category of Petri nets [BM20], stock and flow diagrams [Bae+23], or other presentations of systems), together with some marked objects 𝑃 ⊆ 𝐶 called ports , we associate the systems theory of objects of 𝐶 composing by gluing together their ports as specified by undirected wiring diagrams [FS18c]. See Section 6 for this construction, with undirected wiring diagrams covered in Example 8.10.

- (c) For any category 𝐶 with pullbacks, we will associate a behavioral systems theory, where systems are "variable sets" of system variables, and composition is by sharing exposed variables. This categorifies Willem's behavior approach to systems theory [Wil07] (as put forward by Schultz, Spivak, and Vasilakopolous [SSV19]); it also includes compositional Hamiltonian and Lagrangian mechanics (as in [BWY21] and in Section 1.3.2 of [Sch]). See Section 6 for this construction.
- (d) For any tangent category [CCL19], we will associate a systems theory of ODEs composing by directed wiring diagrams [VSL14]. Indeed, we extend this to any "first order differential structure (FODS)" as in [CCGZ24]. See Section 7.4.
- (e) For any lax monoidal endofunctor 𝐹 on a cartesian category, we will associate a systems theory of open 𝐹 -coalgebras or 𝐹 -Moore machines composing by lenses, including directed wiring diagrams. This includes partially observable Markov decision processes (for 𝐹 a probability monad), as well as ordinary (possibly non-deterministic) Moore machines. See Section 7.3.

These constructions are pseudo-functorial in their underlying data; we therefore see that systems theories organize into doctrines according to the data needed to specify them. This pseudofunctoriality gives us a number of recipes for 'black-boxing' functors - in this case, pseudosymmetric monoidal pseudo-functors between symmetric monoidal loose right modules. This extends the approach of Fong and Sarazola [FS18a] in constructing morphisms of hypergraph categories from morphisms between decoration data for corelations. Our theorems above give recipes not only for giving morphisms between hypergraph (double) categories (symmetric monoidal modules over cospan double categories), but also between modules for lens double categories of, e.g. ODEs or POMDPs.

3. We will observe that many of the diagrammatic languages used in categorical systems theories arise as free processes in the various doctrines of systems theories. In particular, undirected wiring diagrams are free processes in both span- and cospan-based systems theories, while directed wiring diagrams are free processes in lens-based systems theories. See Section 8. This let's us recover hypergraph categories of decorated or structured cospans and of relational systems which compose by sharing variables, as well as the algebras for wiring diagrams of directed operads considered by Spivak et. al. [SSV19]. All constructions are pseudo-functorial, giving recipes for 'black boxing functors' between a variety of different sorts of systems.

## 1.5 Future work

This paper is the beginning of a series on the double operadic theory of systems, based on the formal category theory of symmetric monoidal loose right modules on symmetric monoidal double categories. In future work we will:

1. Examine the Yoneda theory of systems theories (extending the work on representable morphisms of systems theories in Chapter 5 of [Mye21]). We will show that the simplest form of Willems' behavioral approach to systems theory, as categorified in the sheaf approach of Schultz, Spivak, and Vasilakopolous [SSV19], is a discrete opfibration classifier in the 2-category of systems theories. In particular, features of systems theories representable by maps (such as trajectories , steady states , etc. but also control-barrier functions and cocycles ) give (sometimes lax) morphisms of systems theories into Willems' style behavioral systems theories (as demonstrated in the manuscript [Mye21]). This gives a robust class of compositionality theorems. We will explore how time variation in system behaviors arises out of a choice of a category of clock-systems which represent time-varying behavior, and connect this with the sheaf theoretic approach of [SSV19].
2. Explore assume-guarantee reasoning and compositional system validation using slice systems theories. Since maps between systems not only represent behaviors of those systems but also can express

the satisfaction of certain properties (for example, Lyapunov functions [AMT25] which witness stability), we can form certified systems theories as slices (comma objects) in the 2-category of systems theories. Compositionality within these certified systems theories gives a form of assume-guarantee reasoning, or compositional model checking.

Acknowledgements 1. We would like to thank Mitchell Riley for his careful reading and comments during the drafting of this paper. This project was funded by the Advanced Research + Invention Agency (ARIA).

## 2 Preliminaries

In this section, we will collect a number of preliminary notions which we will use throughout the remainder of the paper. In particular, we will review the some necessary 2-category theory; recall the definition of the 2-category of double categories which we will use in this paper; and recall the theory of adequate triples which can be used to give tight control over the S pan -construction. Finally, we will review Spivak's notion of lens ([Spi19]) via the S pan -construction for adequate triples.

## 2.1 2-Categories and ℱ -sketches

In this section, we review some necessary background from the theory of 2-categories and 2-categorical algebra.

By a 2-category we will mean a category enriched in the cartesian monoidal (1-)category of categories. That is, by 2-category we will always mean something strict. For a comprehensive account, we refer the reader to [JY20]; for a more informal introduction, see [Lac09]. We note that as a category of categories enriched over a cartesian monoidal category with all limits, the category of 2-categories admits all pullbacks.

Wewill make extensive use of constructions involving 2-categories with (strict, 2-categorical) products. For this reason, we recall the following definition of a cartesian 2-category.

Definition 2.1 (Cartesian 2-category) . A 2-category 𝒦 is cartesian when it has all finite 2-categorical products - products as categories enriched in Cat . That is, for each pair of objects 𝐴 and 𝐵 in 𝒦 , there is an object 𝐴 × 𝐵 together with 2-natural isomorphisms of categories:

![[Towards a double operadic theory of systems.assets/formula-0001.png]]

and there is a terminal object 1 for which

![[Towards a double operadic theory of systems.assets/formula-0002.png]]

A2-functor which preserves finite products is called a cartesian 2-functor.

It is straightforward to show that cartesian 2-categories, and cartesian 2-functors form a category, and that this 2-category admits all pullbacks (constructed in 2 𝒞 at ).

The reason we are interested in cartesian 2-categories is they are the appropriate setting for describing 2-algebraic structure - such as symmetric monoidal or cartesian structure - on objects. To fix an account of 2-algebra in this paper, we will use the ℱ -sketch formalism of the excellent [ABK24]. We will review this briefly here.

An ℱ -category (originally defined in [LS12]) is a 2-category with a class of its 1-cells marked inert . An ℱ -functor is a 2-functor which sends inert 1-cells to inert 1-cells.

Remark 2.2 (Terminology for ℱ -categories) . In both [LS12] and [ABK24], the marked 1-cells of an ℱ -category are called tight and the general 1-cells are called loose . In this paper, we will use the terms 'tight' and 'loose' to refer to the two sorts of morphisms in a double category; for this reason, we will name the marked 1-cells of an ℱ -sketch inert in this paper. As for why we chose the word 'inert', see below.

In Remark 5.11 of [ABK24], the authors describe how in many cases the inert morphisms of an ℱ -category are chosen as display maps, and they give an example of the theory of a category with hom-sets displayed over sets of objects. The simplex category Δ may be equipped with the structure of a limit sketch whose models are categories (via the Segal conditions ); the maps which display the hom-sets ( 𝑋 ( Δ [ 1 ]) ) over the object-sets ( 𝑋 ( Δ [ 0 ]) ) for such a model 𝑋 are 'inert' maps in the active-inert factorization system on Δ . This is why we choose the name 'inert'.

We will generally consider our 2-categories as chordate ℱ -categories, meaning that all of their 1-cells are marked as inert. Any cartesian 2-category, when considered as a chordate ℱ -category, supports the definition of (symmetric) monoidal objects - pseudo-monoids - as described in Definition 4.13 of [ABK24]. To describe the 2-category 𝒮 M (𝒦) of symmetric pseudo-monoids in a cartesian 2-category 𝒦 , we will appeal to the theory of ℱ -sketches.

An ℱ -sketch (Definition 5.8 of [ABK24]) is an ℱ -category equipped with some 2-categorical cones marked as formal limit cones. A model of an ℱ -sketch 𝒜 in another 𝒦 is an ℱ -functor 𝑀 : 𝒜 → 𝒦 which sends these marked cones to marked cones; usually, we take 𝒦 to be a suitably complete 2-category and mark the limit cones, so that a model becomes an ℱ -functor 𝑀 : 𝒜 → 𝒦 which sends the marked formal limit cones to actual limit cones.

See Definition 5.10 of [ABK24] for a definition of the ℱ -category ℳ od 𝑤 (𝒜 ; 𝒦) for the ℱ -category of models of an ℱ -sketch 𝒜 with 𝑤 -morphisms for 𝑤 a weakness : strict, pseudo, lax, or colax. With this definition in mind, we may make the following definitions which we will use in this paper.

Definition 2.3 ( 𝒮 M and 𝒞 art ) . Let 𝒦 be a cartesian 2-category . We then define

![[Towards a double operadic theory of systems.assets/formula-0003.png]]

![[Towards a double operadic theory of systems.assets/formula-0004.png]]

to be the 2-categories of models and pseudo-morphisms where 𝒜𝒮 M is the ℱ -sketch of symmetric pseudo-monoids (extending Example 5.12 of [ABK24] by a symmtery isomorphism in an evident way), and 𝒜𝒞 art is the ℱ -sketch of cartesian objects (pseudo-monoids where multiplication is adjoint to diagonal and unit is adjoint to the terminal map).

Noting the covariant representablility of symmetric monoidal objects by the symmetric pseudo-monoid ℱ -sketch in this way makes it clear that not only is the assignment 𝒦 ↦→ 𝒮 M (𝒦) functorial with respect to cartesian 2-functors, but also that this assignment preserves pullbacks of 2-categories:

![[Towards a double operadic theory of systems.assets/formula-0005.png]]

Finally, we recall the wonderful symmetry of internalization result from Theorem 7.5 of [ABK24], which states that if 𝒜 and ℬ are ℱ -sketches which whose marked limits are entirely inert , then

![[Towards a double operadic theory of systems.assets/formula-0006.png]]

for any weakness 𝑤 , where 𝑤 is the dual weakness (so, lax = colax and vice versa, but pseudo = pseudo ).

We will use the the theory of ℱ -sketches fluently to compute what it means to be a symmetric monoidal object of a variety of 2-categories under consideration in this paper.

and

## 2.2 Double categorical preliminaries

In this section, we review the 2-category 𝒟 bl of double categories, (pseudo-)double functors, and tight transformations. For a comprehensive review of double category theory, we review the reader to [Gra19]; all the necessary concepts we will use are also written explicitly, in conventions closer to our own, in the excellent [LP24].

Definition 2.4 (The 2-category of double categories) . Wetake 𝒟 bl to be the 2-category of (pseudo-)double categories, pseudo-double functors, and tight transformations. Specifically, we define

![[Towards a double operadic theory of systems.assets/formula-0007.png]]

to be the 2-category of models of the ℱ -sketch of pseudo-categories (Example 5.13 of [ABK24]) valued in the 2-category of categories.

See Defintion 5.2.1 of [Lei04] for a full definition of a double category (there called a 'weak' double category) with unbiased, 𝑛 -ary composition, and see Definition 3.5.1 of [Gra19] for a definition of lax double functor (pseudo-double functors are lax double functors whose unitor and laxitors are isomorphisms) and Definition 3.5.4 of [Gra19] for a definition of tight transformation (there called a 'horizontal transformation').

Convention 2.5 (Double categorical terminology) . A(pseudo-)double category D has an underlying span

![[Towards a double operadic theory of systems.assets/figure-0006.png]]

where Tight ( D ) is its category of objects and tight morphisms, and Loose ( D ) is its category of loose morphisms and squares . That is, we refer to those morphisms of D which compose strictly as 'tight' morphisms, and those that compose up to coherent isomorphism as 'loose' morphisms. We refer to composition of morphisms in Tight ( D ) and Loose ( D ) as tight composition , and composition of D qua pseudo-category in 𝒞 at as loose composition .

Wewill tend to draw our tight morphisms going down the page and loose morphisms going across the page.We avoid using the terminology 'vertical' and 'horizontal' to avoid confusion with other conventions in the double categorical literature.

We recall that the 2-category of double categories is cartesian, and that products of double categories may be constructed in 𝒞 at .

Lemma 2.6 ( 𝒟 bl is cartesian) . The 2-category 𝒟 bl of double categories is cartesian.

As such, we may consider symmetric monoidal double categories , which are symmetric monoidal objects in the 2-category 𝒟 bl . Similarly, cartesian double categories (as considered, for example, in [LP24]) are cartesian objects of 𝒟 bl .

Finally, we recall two technical definitions which will appear in the upcoming Section 3 and be important constraints in the rest of the paper.

Lemma 2.7 (Tight isomorphisms are commuter cells) . Let 𝑓 : 𝑥 ⇒ 𝑦 be a tight isomorphism between loose maps:

![[Towards a double operadic theory of systems.assets/formula-0008.png]]

Suppose that 𝑓 0 and 𝑓 1 are companions; then 𝑓 is a companion commuter cell. Dually, if 𝑓 0 and 𝑓 1 are conjoints, then 𝑓 is a conjoint commuter cell.

Proof. The inverse of the transposed cell 𝑓 &lt; is the transposed cell associated to the tight inverse of 𝑓 . □

## Definition 2.8 (Commuter cells) . Acell

![[Towards a double operadic theory of systems.assets/formula-0009.png]]

in a double category is said to be a companion commuter (Definition 8.1 of [Par23]) if 𝑓 0 and 𝑓 1 have companions 𝑓 &gt; 0 and 𝑓 &gt; 1 respectively and the associated globular transpose cell 𝑓 &gt; of 𝑓 is a tight isomorphism:

![[Towards a double operadic theory of systems.assets/formula-0010.png]]

Dually, 𝑓 is a conjoint commuter if 𝑓 0 and 𝑓 1 have conjoints, and the associated globular transpose of 𝑓 is a tight isomorphism.

## 2.3 Adequate triples, spans, and lenses

In this section, we will review the notion of adequate triple (due to [HHLN20]) and the resulting span construction and its special case, the lens construction of Spivak [Spi19].

## 2.3.1 Adequate triples and spans

In this section, we'll give a general span construction making use of a (1-categorical version of) [HHLN20] adequate triples . An adequate triple is just the data needed on a category in order to perform the span construction on it.

Definition 2.9 (Adequate triple) . An adequate triple ( C , ( 𝐿, 𝑅 )) (Definition 1.2 of [HHLN20]) consists of a category C together with two classes of maps 𝐿 and 𝑅 in C satisfying the following axioms:

1. Both 𝐿 and 𝑅 contain all identities and are closed under composition.
2. In any pullback square as below with ℓ ∈ 𝐿 and 𝑟 ∈ 𝑅 ,

![[Towards a double operadic theory of systems.assets/figure-0007.png]]

the arrow 𝑟 ′ is in 𝑅 and ℓ ′ is in 𝐿 . Furthermore, for any cospan as drawn in solid above, there is such a pullback. We will call these pullback squares " 𝐿 -𝑅 pullbacks".

The 2-category 𝒜 dTr consists of adequate triples, functors preserving the classes 𝐿 and 𝑅 and preserving 𝐿 -𝑅 pullbacks, and arbitrary natural transformations.

The main reason for defining the notion of adequate triples is that they capture (almost) the minimally necessary data and properties of a category needed to perform the span construction.

Construction2.10 (Spanconstruction of an adequate triple) . Weconstructa2-functor S pan : 𝒜 dTr →𝒟 bl 𝑢 sending an adequate triple ( C , ( 𝐿, 𝑅 )) to the double category S pan ( C , ( 𝐿, 𝑅 )) whose tight category is C and whose loose morphisms are spans

![[Towards a double operadic theory of systems.assets/figure-0008.png]]

whose left leg is in 𝐿 and whose right leg is in 𝑅 , with composition given by pullback (noting that an adequate triple asks for precisely the sorts of pullbacks we need to compose these spans). Squares are the usual maps of spans.

Amap 𝐹 : ( C 1 , ( 𝐿 1 , 𝑅 1 )) → ( C 2 , ( 𝐿 2 , 𝑅 2 )) of adequate triples gets sent to the double functor given by applying 𝐹 to all elements.

Proof. That the span construction gives a 2-functor into double categories appears as Proposition 3.26 of [DPP10]. While this performs the usual construction beginning with a category with all pullbacks, we only actually ever take the 𝐿 -𝑅 pullbacks guarenteed by the axioms of an adequate triple, and double functoriality only requires preserving these 𝐿 -𝑅 pullbacks. Since 𝐹 preserves identities, and since identity spans are those with both legs identities, S pan ( 𝐹 ) is a strictly unitary double functor. □

Lemma 2.11 (Companions and conjoints in S pan of an adequate triple) . Let ( C , ( 𝐿, 𝑅 )) be an adequate triple. Then 𝑓 : 𝑐 0 → 𝑐 1 is a companion (resp. conjoint) in the span construction S pan ( C , ( 𝐿, 𝑅 )) if and only if it is in 𝑅 (resp. 𝐿 ).

Proof. In a span double category, 𝑓 : 𝑐 0 → 𝑐 1 has a companion given by

![[Towards a double operadic theory of systems.assets/figure-0009.png]]

This only works in S pan ( C , ( 𝐿, 𝑅 )) if 𝑓 ∈ 𝑅 , by construction. Dually for conjoints.

□

The span construction gives us a 2-functorial way to produce double categories. We can easily extend the span construction to produce symmetric monoidal double categories by observing that it preserves cartesian products, and therefore preserves symmetric monoidal objects.

Lemma 2.12 (Adequate triples form a cartesian 2-category) . The 2-category 𝒜 dTr of adequate triples has cartesian products given by

![[Towards a double operadic theory of systems.assets/formula-0011.png]]

Proof. This is straightforward to verify. The projections preserve (and jointly reflect) both classes by definition, and a square in C 1 × C 2 is a pullback if and only if both its components are pullbacks. □

Next, we explicate symmetric monoidal adequate triples and show that they are preserved by the span construction.

Lemma 2.13 (Symmetric monoidal adequate triples) . A symmetric monoidal adequate triple (an object of 𝒮 M (𝒜 dTr ) ) is equivalently a symmetric monoidal category ( C , ⊗ , 1 ) equipped with the structure of an adequate triple ( C , ( 𝐿, 𝑅 )) , such that:

1. The monoidal product preserves both classes: if 𝑓 and 𝑔 are both in 𝐿 or both in 𝑅 , then so is 𝑓 ⊗ 𝑔 .
2. The monoidal product preserves 𝐿 -𝑅 pullbacks: if the square below are pullbacks

![[Towards a double operadic theory of systems.assets/formula-0012.png]]

then the diagram below is a pullback.

![[Towards a double operadic theory of systems.assets/formula-0013.png]]

Lemma 2.14 (The span construction is a cartesian 2-functor) . The span construction S pan : 𝒜 dTr →𝒟 bl 𝑢 is a cartesian 2-functor.

Proof. This is straightforward by the construction of products in 𝒜 dTr and . By Lemma 2.12, the product in 𝒜 dTr given by the product of the underlying categories, and a span in the product is a pair of spans. □

## 2.3.2 Lex and rex categories

An important set of examples of adequate triples come from lex and rex categories, which we define below.

- 2.3.2.1 Lex categories First, we can recover the ordinary span construction from the span construction for adequate triples by taking a category with finite limits (called a lex category) and turning it into an adequate triple where both classes contain all maps.

Definition 2.15 (The 2-category of categories with finite limits) . Define ℒ ex to be the 2-category whose objects are locally small categories with finite limits (also called lex categories ), whose morphisms are functors which preserve finite limits (also called lex functors ), and whose 2-cells are natural transformations.

Lemma 2.16 (The 2-category ℒ ex of lex categories is cartesian) . The 2-category ℒ ex of lex categories is cartesian, and its finite products may be computed on underlying categories.

Proof. The terminal category is lex, and the terminal morphisms into it all preserve finite limits. Limits in products are computed component-wise, so if two categories have finite limits then so does their product, and the projections preserve these limits. □

Construction 2.17 (Adequate triple of a lex category) . There is a faithful, cartesian 2-functor ℒ ex →𝒜 dTr from the 2-category of lex categories to the 2-category of adequate triples which sends a lex category C to the triple ( C , ( all , all )) where both classes consist of all maps. Any lex functor trivially preserves both classes. It also preserves all pullbacks and hence all 𝐿 -𝑅 pullbacks.

Observation 2.18 (Span of adequate triple from lex category is ordinary span construction) . The span construction S pan ( C , ( all , all )) of the adequate triple constructed from a lex category C is the ordinary span construction S pan ( C ) as described, for example, in Section 3 of [DPP10].

In addition the the usual but rather austere spans of sets, we also find spans in richer categories that can act as systems in their own right [BWY21]. For example, Lagrangian correspondences.

Example 2.19 ( Lagrangian spans ) . In 1.3.2 of [Sch], Schreiber describes a simple construction of a double category faithfully including symplectic manifolds and Lagrangian correspondences. We summarize this construction here, as an example of the variable sharing doctrine.

Let 𝐻 be a topos of smooth sets such as sheaves on the site of smooth manifolds and open covers (see, [GS23] for a comprehensive introduction to this topos), or Dubuc's topos [Dub79]. For any of these sites, there is a notion of differential form definable on the objects of the site - for smooth manifold 𝑀 , the set Λ 𝑛 ( 𝑀 ) of alternating 𝑛 -forms on 𝑀 -stable under pullback and defined locally; that is, there is a sheaf Λ 𝑛 which represents differential 𝑛 -forms in the sense that a form 𝜔 ∈ Λ 𝑛 ( 𝑀 ) is equivalently given by a map 𝜔 : 𝑀 → Λ 𝑛 . Since forms are naturally an abelian group, Λ 𝑛 is an abelian group object of 𝐻 .

Since the differential commutes with pullback of forms, there will be a map 𝑑 : Λ 2 → Λ 3 ; its kernel Λ 2 cl classifies closed 2-forms. A map 𝜔 : 𝑀 → Λ 2 cl is therefore a closed alternating 2-form on 𝑀 , also known as a pre-symplectic structure . Since precomposition by 𝑓 : 𝑁 → 𝑀 sends 𝜔 : 𝑀 → Λ 2 cl to its pullback 𝑓 ∗ 𝜔 : 𝑁 → Λ 2 cl , we see that the slice topos 𝐻 ↓ Λ 2 cl consists of the pre-symplectic manifolds and the symplectomorphisms between them: smooth maps 𝑓 : 𝑁 → 𝑀 such that 𝑓 ∗ 𝜔 𝑀 = 𝜔 𝑁 .

As a topos, 𝐻 ↓ Λ 2 cl has finite limits, and therefore lives in ℒ ex . A span in 𝐻 ↓ Λ 2 cl is therefore a commuting square

![[Towards a double operadic theory of systems.assets/figure-0010.png]]

so that 𝑚 ∗ 𝜔 𝑀 = 𝑛 ∗ 𝜔 𝑁 , or 𝑚 ∗ 𝜔 𝑀 -𝑛 ∗ 𝜔 𝑁 = 0 . If of the appropriate dimension ( dim ( 𝑆 ) = 1 2 ( dim ( 𝑀 ) + dim ( 𝑁 )) ), then such a span is a Lagrangian correspondence (see, for example [Wei09]).

2.3.2.2 Rex categories As a straightforward dual of the span construction for a category with finite limits, we can find the cospan construction of a category with finite colimits as a special case of the span construction for adequate triples.

Definition 2.20 (2-Category of rex categories) . We say that a category is rex when it has all finite colimits. The 2-category ℛ ex has the rex categories as objects, finite colimit preserving functors as maps, and (general) natural transformations as 2-cells.

Since a finite colimit in C is equivalently a finite limit in C op , and since (-) op : 𝒞 at 𝒞 at is an involution of the 2-category 𝒞 at of categories, we have the following duality.

Note that in the following, for a 2-category 𝒦 , we define 𝒦 co to be the 2-dimensional dual of 𝒦 : its objects and 1-morphisms are the objects and 1-morphisms of 𝒦 and its 2-cells are dualized.

Observation 2.21 (Duality between lex and rex categories) . The 2-functor (-) op : ℛ ex co →ℒ ex sending a rex category 𝐶 to its dual 𝐶 op is an isomorphism of 2-categories with inverse also given by taking the opposite.

This is what lets us explicitly transport results for lex categories. For clarity, we record them in full nonetheless.

Lemma 2.22 (The 2-category ℛ ex of rex categories is cartesian) . The 2-category ℛ ex of rex categories is cartesian, and products are constructed in 𝒞 at .

Construction 2.23 (Adequatetriple of a rex category) . There is a faithful, cartesian 2-functor ℛ ex co →𝒜 dTr from the 2-dimensional dual of the 2-category of finite cocomplete categories and finitely cocontinuous functors to the 2-category of adequate triples given by sending C to the triple ( C op , ( all , all )) where both classes consist of all maps.

Observation 2.24 (Cospan construction is a span construction) . The span construction S pan ( C op , ( all , all )) of the adequate triple associated to a rex category C is the tight dual C ospan ( C ) op of the cospan construction of C .

2.3.2.3 Trivial adequate triples It is worth noting that every category C may be considered as a trivial adequate triple ( C , ( id , id )) .

Observation 2.25 (Span construction of trivial adequate triple is tight inclusion) . The span construction S pan ( C , ( id , id )) of a is isomorphic to the loosely discrete double category T ( C ) on C .

![[Towards a double operadic theory of systems.assets/figure-0011.png]]

## 2.3.3 Fibrations and functor lenses

In this section, we'll see how the span construction for adequate triples can be used to construct the double categories of lenses (in the sense of [Spi19]) and charts (in the sense of Definition 3.3.0.13 of [Mye21]). These double categories appear as Definition 4.1 of [Jaz21] (and Definition 3.5.0.6 of [Mye21]);here, we'll make use of Proposition 4.2 of [Jaz21] (proven in Theorem 3.9 of [Mye20].) to see them as double categories of spans.

Definition 2.26 (Cartesian fibration) . The2-category ℱ ib of cartesian fibrations (also known as Grothendieck fibrations ) consists of the cartesian fibrations 𝜋 : 𝐸 → 𝐵 , the cartesian functors which are strictly commuting squares

![[Towards a double operadic theory of systems.assets/figure-0012.png]]

where 𝑓 sends cartesian morphisms to cartesian morphisms. A 2-cell is a pair of maps ( 𝛼 : 𝑓 ⇒ 𝑔, 𝛼 : 𝑓 → 𝑔 ) for which 𝜋 ′ 𝛼 = 𝛼𝜋 .

Example 2.27 (Display map fibrations) . Auseful example of cartesian fibrations are display map fi brations.

Definition 2.28 (Display map category) . A display map category ( C , D ) is a category C equipped with a class of maps D ⊆ Arr ( C ) which is closed under pullback along arbitrary maps in C . That is, for any solid diagram below with 𝑑 ∈ D , the dashed pullback exists and 𝑑 ′ is also in D .

![[Towards a double operadic theory of systems.assets/figure-0013.png]]

The 2-category 𝒟 isp of display map categories consists of the display map categories, functors which preserve display maps and their pullbacks, and arbitrary natural transformations.

Lemma 2.29 (2-Category of display map categories is cartesian) . The 2-category 𝒟 isp of display map categories is cartesian, with

![[Towards a double operadic theory of systems.assets/formula-0014.png]]

Any cartesian category can be equipped with a display map structure given by its product projections.

Theorem 2.30 (Display map category associated to a cartesian category) . Let 𝐶 be a cartesian category, having finite products. Then the class proj of left projections 𝜋 : 𝑋 × 𝑌 → 𝑋 in 𝐶 equips 𝐶 with the structure of a display map category.

Moreover, this construction gives a cartesian 2-functor (-, proj ) : 𝒞 art →𝒟 isp .

Proof. In a cartesian category, any square of the following form is a pullback:

![[Towards a double operadic theory of systems.assets/formula-0015.png]]

This can be straightforwardly verified using the universal property of the product, and it shows that ( 𝐶, proj ) is a display map category.

Any cartesian functor preserves projections from cartesian products, so induces a display map functor. Finally, the products in 𝒞 art and 𝒟 isp are constructed in 𝒞 at , and so this inclusion preserves them. □

Theorem 2.31 (Display map fibration) . For any display map category ( 𝐶, 𝐷 ) , the codomain projection 𝜕 1 : 𝐷 → 𝐶 is a cartesian fibration. Moreover, this gives a cartesian 2-functor 𝒟 isp →ℱ ib .

Proof. Cartesian lifts are given by pullback, which exist by assumption. Any display map functor gives a cartesian functor since by assumption it preserves these pullbacks.

Finally, it is straightforwardly cartesian, since cartesian products in each of these 2-categories are constructed down in 𝒞 at . □

Definition 2.32 (Simple fibrations) . The cartesian 2-functor

![[Towards a double operadic theory of systems.assets/formula-0016.png]]

composed of Theorem 2.30 and Theorem 2.31 sends a cartesian category C to its simple fibration proj C 𝜕 1 - → C of (left) product projections.

The simple fibrations appear in systems theories as the Grothendieck constructions of the indexed categories 𝑐 ↦→ cokl ( 𝑐 ×-) : 𝐶 op →𝒞 at (Definition 2.6.2.4 of [Mye21]). We prove the equivalence between these two constructions here for reference.

Lemma 2.33 (Simple fibration is Grothendieck construction of cokl ( 𝑐 ×-) ) . The simple fibration associated to 𝐶 is equivalently the Grothendieck construction of the indexed category 𝑐 ↦→ cokl ( 𝑐 × -) : 𝐶 op →𝒞 at .

Proof. Under the equivalence between fibrations and indexed categories given by the Grothendieck construction, a display map fibration 𝜕 1 : 𝐷 → 𝐶 corresponds to the indexed category 𝐶 ↓ 𝐷 (-) : 𝐶 op → 𝒞 at given by sending 𝑐 ∈ 𝐶 to the full subcategory of the slice 𝐶 ↓ 𝑐 spanned by the display maps 𝐷 . It therefore suffices to show that for any cokl ( 𝑐 × -) ≃ 𝐶 ↓ proj 𝑐 , natural in 𝑐 ∈ 𝐶 .

The objects of cokl ( 𝑐 × -) are those of 𝐶 , while the objects of 𝐶 ↓ proj 𝑐 are the product projections 𝑐 × 𝑥 → 𝑐 , which are in bijection with the objects 𝑥 ∈ 𝐶 . Furthermore, there is a bijection between cokleisli arrows 𝑓 : 𝑐 × 𝑥 → 𝑦 and maps ( id 𝑐 , 𝑓 ) : 𝑐 × 𝑥 → 𝑐 × 𝑦 between product projections. It is straightforward to verify that this bijection is an isomorphism. □

Construction 2.34 (Adequate triple of a cartesian fibration) . There is a cartesian 2-functor ℱ ib →𝒜 dTr sending a cartesian fibration 𝜋 : 𝐸 → 𝐵 to the adequate triple ( 𝐸, vert , cart ) whose left class is the class of vertical maps (such that 𝜋 ( 𝑓 ) is an isomorphism) and whose right class is the class of cartesian maps.

Proof. First, let's show that ( 𝐸, vert , cart ) is an adequate triple. This means showing that in any pullback square like so:

![[Towards a double operadic theory of systems.assets/figure-0014.png]]

we have that ℓ ′ is vertical and 𝑟 ′ is cartesian; and that any solid cospan above can be completed to such a pullback. This follows from Proposition 2.4 and Lemma 2.2 of [Mye20].

Next, we need to check 2-functoriality. We note that the assignment ( 𝜋 : 𝐸 → 𝐵 ) ↦→ 𝐸 gives a 2-functor ℱ ib →𝒞 at by the definition of ℱ ib ; it only remains to show that this 2-functor lands in 𝒜 dTr , which is to say that for any cartesian functor

![[Towards a double operadic theory of systems.assets/figure-0015.png]]

the functor 𝑓 : 𝐸 → 𝐸 ′ preserves both verticals, cartesians, and vert -cart pullbacks. Now, 𝑓 preserves cartesian maps by assumption; it preserves verticals because the above square commutes, so that if 𝑎 : 𝑥 → 𝑦 in 𝐸 is vertical ( 𝜋 𝑎 is iso), then 𝜋 ′ 𝑓 𝑎 = 𝑓 𝜋 𝑎 is also iso. Finally, Lemma 2.2 of [Mye20] says that any vert -cart square is a pullback, since 𝑓 preserves the classes it therefore preserves vert -cart pullbacks. Finally, we need to show that this 2-functor is cartesian. This follows straightforwardly from the fact that the cartesian product of two fibrations is 𝜋 × 𝜋 ′ : 𝐸 × 𝐸 ′ → 𝐵 × 𝐵 ′ . □

For the purposes of this paper, we'll make the following definition of the double category of Spivak lenses.

Definition 2.35 (Double category of Spivak lenses) . The double category L ens ( 𝜋 : 𝐸 → 𝐵 ) (often just L ens ( 𝐸 ) for short) of Spivak lenses ([Spi19]) for the fibration 𝜋 : 𝐸 → 𝐵 is defined to be the span construction of the adequate triple associated to 𝜋 :

![[Towards a double operadic theory of systems.assets/formula-0017.png]]

Notation 2.36 (Spivak lenses) . Let 𝜋 : 𝐸 → 𝐵 be a cartesian fibration.

- For 𝐼 ∈ 𝐸 , we often use 𝐼 𝜋 ( 𝐼 ) to refer to the corresponding object in L ens ( 𝐸 ) . In other words, writing an object 𝐼 in L ens ( 𝐸 ) implies that 𝐼 lives in the fiber over 𝑂 .

𝑂

- A lens is a loose map in L ens ( 𝐸 ) and corresponds to the pair of maps ( 𝑓 , 𝑓 # ) which fit into the diagram below.

We notate this pair

![[Towards a double operadic theory of systems.assets/formula-0018.png]]

![[Towards a double operadic theory of systems.assets/formula-0019.png]]

Explication 2.37 (Explication of Definition 2.35) . Definition 2.35 requires a bit of explanation. In Theorem 3.9 of [Mye20], it is shown that L ens ( 𝜋 : 𝐸 → 𝐵 ) (as defined in Definition 2.35) is equivalent to the Grothendieck double construction of the indexed category 𝐸 (-) : 𝐵 op →𝒞 at associated to 𝜋 (Definition 3.8 of [Mye20]; also Definition 4.1 of [Jaz21]). The Grothendieck double construction is a strict double category whose tight category is the Grothendieck construction of 𝐸 (-) : 𝐵 op → 𝒞 at and whose loose category is the Grothendieck construction of the pointwise-opposite 𝐸 op (-) : 𝐵 op →𝒞 at . This latter Grothendieck construction is Spivak's generalized lens construction (Definition 3.3 of [Spi19]).

If 𝜋 : 𝐸 → 𝐵 is presented as the Grothendieck construction of an indexed category 𝐸 (-) : 𝐵 op →𝒞 at , then a lens 𝑓 ♯ 𝑓 : 𝐴 -𝐴 + p → 𝐵 -𝐵 + is a diagram of the following form:

![[Towards a double operadic theory of systems.assets/formula-0020.png]]

If 𝜋 : 𝐸 → 𝐵 is actually the simple fibration of a cartesian category 𝐵 , then a lens the above diagram takes the following form:

![[Towards a double operadic theory of systems.assets/formula-0021.png]]

which is determined by the pair of maps 𝑓 : 𝐴 + → 𝐵 + and 𝑓 ♯ : 𝐴 + × 𝐵 - → 𝐴 -which characterize a usual 'polymorphic, lawless' lens - a morphism in the fiberwise opposite of the simple fibration.

Example 2.38 (Lens construction of simple fibration) . Let 𝐶 be a cartesian category. Then the lens double category of its simple fibration has as its loose morphisms the lenses 𝑓 ♯ 𝑓 : 𝐴 ♯ 𝐴 ⇆ 𝐵 ♯ 𝐵 the usual cartesian lenses (see, e.g. Definition 1.3.1.1 of [Mye21]) and as tight morphisms the charts (Definition 3.3.0.1 of [Mye21]).

## 3 Loose bimodules and loose right modules

In this paper, we'll make extensive use of the basic theory of loose bimodules between double categories. Unfortunately, this basic theory has not yet been developed, at least as far as we could tell. We therefore set out to develop it ourselves, before splitting it off into a forthcoming companion paper [BCLJ25] for reasons of audience and scope.

In this section, we will introduce what we need of the theory of loose bimodules, including a full definition of the 2-category of loose bimodules and a (very straightforward) construction of loose hom bimodules. We will then sketch the equivalence between the definition we use here ('double barrels') and the perhaps more expected definition as pseudo-bimodules, as well as sketch our two main ways for constructing new bimodules out of old ones: specifically, restriction and collapse . The sketches given here are previews of the complete proofs, which will appear in our forthcoming companion paper [BCLJ25].

## 3.1 Loose bimodules

We begin with the definition of loose bimodule . In order to give a slick definition of the 2-category of loose bimodules, we'll take a labelling approach which categorifies Joyal's barrels . Aloose bimodule will be identified with its collage M together with a labelling double functor ℓ : M → L oose into the walking loose arrow .

Definition 3.1 (Walking loose arrow) . The walking loose arrow L oose is the free strict double category generated by a single loose arrow 2 ℓ : 0 p → 1 .

Explication 3.2 (Walking loose arrow) . The walking loose arrow double category L oose has two objects, three loose arrows (two identities along with the walking loose arrow 2 ℓ ), two identity tight arrows, and three identity squares. These are all pictured below.

![[Towards a double operadic theory of systems.assets/figure-0016.png]]

Adouble functor ℓ : M → L oose therefore labels each object of M by either 0 or 1 (marking it either an object of the source of the associated loose bimdoule, or the target ), and a loose morphism 𝑚 : 𝑥 p → 𝑦 of M can either be labelled by the loose identities id 0 : 0 p → 0 and id 1 : 1 p → 1 , or the walking loose arrow 2 : 0 p → 1 itself. In the former case, we interpret 𝑚 as a loose morphism of the source of M ; in second case, as a loose morphism of the target; and in third case, where ℓ ( 𝑚 ) = 2 , we consider 𝑚 as a loose heteromorphism , or an element of the bimodule.

This story is repeated again for all the tight morphisms and squares. Composition in M gives a coherently unital and associative action of the loose hetermorphisms (and heterosquares - those labelled by the tight identity of 2 : 0 p → 1 ) on the left and right by those loose morphisms and squares labelled by 0 and 1 respectively.

In total, we get all the structure of a loose bimodule out of a labelling double functor ℓ : M → L oose . This observation leads us to the following slick definition of the whole 2-category of looes bimodules.

Definition 3.3 (Loose bimodule) . A loose bimodule is a (necessarily strict) double functor 𝑀 : M → L oose into the walking loose arrow. The 2-category ℓ ℬ imod of loose modules is the (strict) slice 2-category 𝒟 bl ↓ L oose over the walking loose arrow. Explicitly, ℓ ℬ imod consists of:

1. Objects are loose bimodules 𝑀 : M → L oose .
2. Morphisms are strictly commuting triangles:

![[Towards a double operadic theory of systems.assets/figure-0017.png]]

oose

where 𝐹 is a pseudo double functor.

## 3. 2-cells are tight transformations 𝛼 : 𝐹 → 𝐺 so that 𝑁 𝛼 = 𝑀 , again strictly.

This slick definition of loose bimodules has a number of benefits. It becomes trivial to construct loose hom bimodules, for example.

Definition 3.4 (Hom loose bimodule) . Let D be a pseudo-double category. Its loose hom bimodule Hom 𝑙 ( D ) is defined to be the product projection D × L oose → L oose .

This gives us a cartesian 2-functor

![[Towards a double operadic theory of systems.assets/formula-0022.png]]

It is often convenient to notate the loose home bimodule Hom 𝑙 ( D ) : D p → D simply by

![[Towards a double operadic theory of systems.assets/formula-0023.png]]

In D (-, -) , we have two full copies of D appearing as D × { 0 } and D × { 1 } , respectively, acting on the loose morphisms 𝑚 : 𝑥 p → 𝑦 of D appearing as ( 𝑚, 2 ) : ( 𝑥, 0 ) p →( 𝑦, 1 ) by loose composition (and similarly for squares).

We will need to know a bit more about 𝒟 bl ; namely, we need to know that it is cartesian. Since it is a slice 2-category, its products may be constructed by taking pullback; but pullbacks of pseudodouble functors do not always exist. In this case, however, L oose is just so strict that nothing can really go wrong.

Lemma 3.5 (Pullbacks of maps into L oose ) . Any two double functors

![[Towards a double operadic theory of systems.assets/figure-0018.png]]

admit a pullback in the 2-category 𝒟 bl of double categories and pseudo-functors, and it is constructed by taking the pullback of all underlying categories (of tight morphisms and of squares, respectively).

Proof. This is straightforward to verify directly, but let's see an abstract argument.

In [Lac05], Lack shows that comma objects out of a lax morphism and into a strict morphism always exist in 2-categories of algebras for 2-monads and lax morphisms and are constructed in the underlying 2-category. Similarly, iso-commas out of a pseudo-morphism and into a strict morphism always exist in 2-categories of algebras for 2-monads and pseudo-monads, and are again constructed in the underlying 2-category. Since double categories are 2-monadic over graphs of categories, and since all functors into L oose are strict (since there is simply no room to be pseudo), we conclude that the iso-comma of the above cospan exists. But since L oose has only identity tight morphisms and squares, that iso-comma must already be a strict pullback. □

As a corollary, the double category of loose bimodules is cartesian. The product of loose bimodules is straightforward: we take pairs of all things with the same labels.

Corollary 3.6. The 2-category ℓ ℬ imod of loose bimodules is cartesian, with the cartesian product given by taking the pullback of maps into L oose .

Definition 3.7 (Symmetric monoidal loose bimodules) . Define the 2-category of symmetric monoidal loose bimodules to be 𝒮 M ( ℓ ℬ imod ) , the 2-category of .

With Lemma 3.5, we can also formally define the source and target of a loose bimodule.

Definition 3.8 (Source and target of loose bimodule) . Let 𝑀 : M → L oose be a . The source 𝑀 0 of 𝑀 is its pullback along 0 : · → L oose . Its target 𝑀 1 is its pullback along 1 : · → L oose .

Together, taking the source and target of a loose bimodule gives a cartesian 2-functor

![[Towards a double operadic theory of systems.assets/formula-0024.png]]

Notation 3.9 (Loose bimodule) . We often denote a 𝑀 : M → L oose as a proarrow

![[Towards a double operadic theory of systems.assets/formula-0025.png]]

where:

- D 0 is the source 𝑀 0 .
- D 1 is the target 𝑀 1 .

Finally, we introduce the notion of a loose right module, which is simply a loose bimodule whose source is terminal.

Definition 3.10 (2-Category of loose right modules) . Define the 2-category of loose right modules to be the following pullback of 2-categories:

![[Towards a double operadic theory of systems.assets/formula-0026.png]]

Explication 3.11 (Loose right module) . A loose right module M : · p → D 1 is a loose bimodule whose source is the and thus has a trivial left action. The target D 1 acts on the carrier Car ( M ) on the right. We say M is a loose right module over D 1 .

Proposition 3.12 (The 2-category ℓ ℳ od r is cartesian) . The 2-category ℓ ℳ od r is cartesian, and products are constructed in ℓ ℬ imod (as pullbacks over L oose ).

Proof. The source and target maps are cartesian because they are constructed via pullbacks. Since ℓ ℳ od r is a pullback of cartesian 2-categories along cartesian maps, it is cartesian. □

## 3.2 Loose bimodules as pseudo-bimodules

Let's see how the definition of loose bimodule given in Definition 3.3 relates to perhaps more expected definition of a pseudo-bimodule acted on the left and right by pseudo-categories in 𝒞 at . We will only sketch the equivalence here; a full proof will appear in [BCLJ25].

First, we note that to any loose bimodule, we may associate a category which we call its carrier .

Definition 3.13 (Carrier of a loose bimodule) . Let ℓ : M → L oose be a loose bimodule. Its carrier Car ( M ) is the category whose:

- Objects are loose morphisms of M living over the walking loose arrow. We refer to such loose morphisms as heteromorphisms .
- Morphisms are squares of M living over the identity square of the walking loose arrow.

Writing the loose bimodule M → L oose as a proarrow between its source and target

![[Towards a double operadic theory of systems.assets/formula-0027.png]]

we have the following explication.

An object of Car ( M ) consists of a triple

![[Towards a double operadic theory of systems.assets/formula-0028.png]]

where 𝑑 is an object of D , 𝑑 is an object of D , and 𝑚 is a loose morphism in M from 𝑑 to 𝑑 .

0 0 1 1 0 1 Amorphism ( 𝑑 0 , 𝑑 1 , 𝑚 : 𝑑 0 p → 𝑑 1 ) → ( 𝑑 ′ 0 , 𝑑 ′ 1 , 𝑚 ′ : 𝑑 ′ 0 p → 𝑑 ′ 1 ) consists of a tight morphism 𝑓 0 : 𝑑 0 → 𝑑 ′ 0 in D 0 , a tight morphism 𝑓 1 : 𝑑 1 → 𝑑 ′ 1 in the D 0 , and a square 𝛼 : 𝑚 ⇒ 𝑚 ′ in M :

![[Towards a double operadic theory of systems.assets/figure-0019.png]]

𝑚

The carrier of a loose bimodule is spanned over the category of tight arrows of its source and target.

Proposition 3.14 (Projection from the carrier of a loose bimodule to its source and target) . Given a loose bimodule M : D 0 p → D 1 , there are projections from its carrier to the tight category of its source and target of M . This gives a span:

![[Towards a double operadic theory of systems.assets/figure-0020.png]]

With regard to these projections, the carrier Car ( M ) picks up left and right actions by D 0 and D 1 by composition in M :

![[Towards a double operadic theory of systems.assets/figure-0021.png]]

We will often find it more convenient to think of loose bimodules M as being displayed categories Car ( M ) acted on the left and right by double categories. This will make the upcoming constructions of restriction and collapse more easy to understand as well.

Let's now sketch the relationship between loose bimodules presented as double barrels (Definition 3.3) and as pseudo-bimodules between pseudo-categories in 𝒞 at ; this will be a sneak peak at [BCLJ25], though we do not follow exactly this strategy there.

As we saw in Definition 2.4, we may identify the 2-category 𝒟 bl of double categories with the 2-category ℳ od 𝑝 (𝒜 PseudoCat ; 𝒞 at ) of models of the ℱ -sketch of pseudo-categories valued in the 2-category 𝒞 at of categories. We may consider the strict double category L oose : 𝒜 PseudoCat →𝒞 at as such a model; it's 2-category of elements ℰ l ( L oose ) may be endowed with the structure of an ℱ -sketch by taking its marked cones to be those that project down to marked cones in 𝒜 PseudoCat .

An inspection of ℰ l ( L oose ) reveals that it gives a ℱ -sketch for pseudo-bimodules between pseudocategories. By adapting closure properties of 2-fibrations to ℱ -categories, we can prove a categorification of the usual theorem relating slice categories of presheaf categories to presheaves on categories of elements:

![[Towards a double operadic theory of systems.assets/formula-0029.png]]

This gives the equivalence between the definition of loose bimodule we gave in Definition 3.3 and pseudo-bimodules between pseudo-categories.

## 3.3 Collapse and restriction of loose bimodules

In this section, we'll sketch two constructions of new loose bimodules from old: collapse and restriction . All of the loose modules of systems we construct in this paper will be done by restricting loose hom bimodules, and then potentially collapsing them.

We'll begin with the collapse, since it is more straightforward. We then describe the restriction of loose bimodules, and in particular its pseudo-functoriality over a 2-category of niches .

## 3.3.1 Collapse of loose bimodules

Given a loose bimodule M : D 0 p → D 1 we may consider it as a pseudo-bimodule spanned between its source D 0 and its target D 1 :

![[Towards a double operadic theory of systems.assets/figure-0022.png]]

The collapse 𝔠 M of M is the loose right module given by replacing D 0 by the terminal double category:

![[Towards a double operadic theory of systems.assets/figure-0023.png]]

In particular, the collapse 𝔠 M of a loose bimodule M has exactly the same carrier.

This construction is a bit awkward to express with double barrels but evidently 2-functorial when viewed as a construction on pseudo-bimodules. We therefore have the following theorem:

Theorem 3.15 (Collapse of loose bimodule) . The collapse of a loose bimodule into a loose right module gives a cartesian 2-functor

![[Towards a double operadic theory of systems.assets/formula-0030.png]]

## 3.3.2 Restriction of loose bimodules

In this section, we will sketch the restriction of loose bimodules along pseudo-double functors. The construction itself itself is rather straightforward. Suppose we are given a loose bimodule M : D 0 p → D 1 and two double functors 𝐹 0 : E 0 → D 0 and 𝐹 1 : E 1 → D 1 . We may then form the carrier of the restricted loose bimodule M ( 𝐹 0 , 𝐹 1 ) as the limit Explicitly, we will have Car ( M ( 𝐹 0 , 𝐹 1 )) defined as follows:

![[Towards a double operadic theory of systems.assets/figure-0024.png]]

- Objects are triples ( 𝑒 0 : ob ( E 0 ) , 𝑒 1 : ob ( E 1 ) , 𝑚 : 𝐹 0 𝑒 0 p → 𝐹 1 𝑒 1 ) .
- A morphism ( 𝑒 0 , 𝑒 1 , 𝑚 ) → ( 𝑒 ′ 0 , 𝑒 ′ 1 , 𝑚 ′ ) is a triple ( 𝑓 0 : 𝑒 0 → 𝑒 ′ 0 , 𝑓 1 : 𝑒 1 → 𝑒 ′ 1 , 𝛼 ) where 𝛼 is a square in M of the following form:

![[Towards a double operadic theory of systems.assets/formula-0031.png]]

The action of E 0 and E 1 is by first applying 𝐹𝑖 , and then acting in M .

What is more interesting is the pseudo-functoriality of the above construction. We will need a very particular sort of pseudo-functoriality in a domain 2-category which we will describe now.

Definition 3.16 (The 2-category of niches) . Consider the following pullback of 2-categories:

![[Towards a double operadic theory of systems.assets/figure-0025.png]]

Here 2 𝒞 at 𝑐 is the 3-category of 2-categories, 2-functors, colax natural transformations, and modifications, so that 2 𝒞 at 𝑐 ([ 1 ] , 𝒟 bl ) is the 2-category of pseudo double functors and colax-commuting squares. (This will be explicated below.)

We define the 2-category 𝒩 iche to be the wide and locally full sub-2-category of 𝒩 on those 1morphisms whose component in 2 𝒞 at 𝑐 ([ 1 ] , 𝒟 bl ) 2 lies in 2 𝒞 at colax ( Δ [ 1 ] , 𝒟 bl ) conj × 2 𝒞 at colax ( Δ [ 1 ] , 𝒟 bl ) comp , where 2 𝒞 at colax ( Δ [ 1 ] , 𝒟 bl ) conj (resp. 2 𝒞 at colax ( Δ [ 1 ] , 𝒟 bl ) comp ) is the .

We also define the 2-category 𝒩 iche to be the sub-2-category of 𝒩 iche consisting of all objects, but only the 1-cells for which the colaxators are isomorphisms (and all 2-cells).

## Explication 3.17 (The 2-category 𝒩 iche ) . Explicitly:

1. An object of 𝒩 iche consists of a loose bimodule 𝑀 : M → L oose together with two double functors 𝐹 0 : E 0 → 𝑀 0 and 𝐹 1 : E 1 → 𝑀 1 . We will call an object of 𝒩 iche a niche , and can draw it in this way:
2. A 1-cell of the above pullback consists of a map 𝑎 : 𝑀 0 → 𝑀 1 of modules and double functors 𝑓 𝑖 : E 0 𝑖 → E 1 𝑖 , together with two colax-commuting squares of double functors of the following form:

![[Towards a double operadic theory of systems.assets/figure-0026.png]]

![[Towards a double operadic theory of systems.assets/formula-0032.png]]

where 𝑓 0 is a companion commuter transformation and 𝑓 1 is a conjoint commuter transformation.

3. A2-cell of the above pullback consists of tight transformations 𝛼 : 𝑎 0 → 𝑎 1 , and 𝜙 𝑖 : 𝑓 0 𝑖 → 𝑓 1 𝑖 so that the following equations hold:

![[Towards a double operadic theory of systems.assets/formula-0033.png]]

We can now express the pseudo-functoriality of restriction. Because we will make reference to the action of restriction on 1-cells, we include their description here. We remark again the a full proof will appear in our [BCLJ25].

Theorem 3.18 (Restriction of loose bimodules is a pseudo-functor) . Restriction of loose bimodules extends to a cartesian pseudo-functor

$$Res : 𝒩 iche → ℓ ℬ imod .$$

Proof. We will only describe the construction itself, foregoing its proof to [BCLJ25].

Proof. Consider the following 1-cell ( 𝑓 0 , ¯ 𝑓 0 , 𝑓 1 , ¯ 𝑓 1 , 𝑎 ) : ( 𝐹 00 , 𝐹 01 , 𝑀 0 ) → ( 𝐹 10 , 𝐹 11 , 𝑀 1 ) of 𝒩 iche , which we'll abusively denote as 𝑎 .

![[Towards a double operadic theory of systems.assets/figure-0027.png]]

We define a loose bimodule map Res ( 𝑎 ) : M 0 ( 𝐹 00 , 𝐹 01 ) → M 1 ( 𝐹 10 , 𝐹 11 ) as follows:

1. (Endpoints) On the E 0 𝑖 , we take Res ( 𝑎 ) to be 𝑓 𝑖 .
2. (Objects of carrier) Given ( 𝑒 00 , 𝑒 01 , 𝑚 0 : 𝐹 00 𝑒 00 p → 𝐹 01 𝑒 01 ) in M 0 ( 𝐹 00 , 𝐹 01 ) , recall that we have the tight morphism ¯ 𝑓 0 𝑒 00 : 𝑎 0 𝐹 00 ( 𝑒 00 ) → 𝐹 10 𝑓 0 ( 𝑒 00 ) , which has a conjoint ( 𝑓 0 𝑒 00 ) &lt; as part of the definition of 𝒩 iche . Similarly, ¯ 𝑓 1 𝑒 01 has a companion ( 𝑓 1 𝑒 01 ) &gt; . These loosenings will be used to modify 𝑎𝑚 0 : 𝑎 0 𝐹 00 𝑒 00 p → 𝑎 1 𝐹 01 𝑒 01 to have the correct signature.

We therefore define Res ( 𝑎 )( 𝑒 00 , 𝑒 01 , 𝑚 0 ) as ( 𝑓 0 ( 𝑒 00 ) , 𝑓 1 ( 𝑒 01 ) , 𝑚 ′ 0 ) where 𝑚 ′ 0 : 𝐹 01 𝑓 0 ( 𝑒 00 ) p → 𝐹 11 𝑓 1 ( 𝑒 01 ) is the following composite in M 1 :

![[Towards a double operadic theory of systems.assets/formula-0034.png]]

3. (Morphisms of carrier) Consider a square ( 𝜇 0 , 𝜇 1 , 𝜇 ) : ( 𝑒 00 , 𝑒 01 , 𝑚 0 ) → ( 𝑒 ′ 00 , 𝑒 ′ 01 , 𝑚 ′ 0 ) in M 0 ( 𝐹 00 , 𝐹 01 ) , where 𝜇 appears as below:

![[Towards a double operadic theory of systems.assets/formula-0035.png]]

Then we define Res ( 𝑎 )( 𝜇 ) = ( 𝑓 0 𝜇 0 , 𝑓 1 𝜇 1 , 𝜇 ′ ) where 𝜇 ′ is the following square:

![[Towards a double operadic theory of systems.assets/formula-0036.png]]

where the left (resp. right) square is the conjoint (resp. companion) transpose of the tight naturality square associated to 𝑓 0 𝜇 0 (resp. 𝑓 1 𝜇 1 ).

4. (Unitors and laxators) The unit and lax structure is taken from 𝑓 𝑖 when in E 0 𝑖 . There are two remainingcasesforthelaxators: whenwearecomposingaloosein E 0 𝑖 withan ( 𝑒 00 , 𝑒 01 , 𝑚 0 : 𝐹 00 𝑒 00 p → 𝐹 01 𝑒 01 ) on one side or the other. By symmetry, it is enough to consider the case of ℓ : 𝑒 ′ 00 p → 𝑒 00 . Then we have Res ( 𝑎 )( ℓ ) = 𝑓 0 ( ℓ ) , Res ( 𝑎 )( 𝑒 00 , 𝑒 01 , 𝑚 0 ) = ( 𝑓 0 ( 𝑒 00 ) , 𝑓 1 ( 𝑒 01 ) , 𝑚 ′ 0 ) , and Res ( 𝑎 )( ℓ ⊙ ( 𝑒 00 , 𝑒 01 , 𝑚 0 )) = Res ( 𝑎 )( 𝑒 ′ 00 , 𝑒 01 , 𝐹 00 ( ℓ ) ⊙ 𝑚 0 ) = ( 𝑓 0 ( 𝑒 ′ 00 , 𝑓 1 ( 𝑒 01 ) , [ 𝐹 00 ( ℓ ) ⊙ 𝑚 0 ] ′ )) . We define the laxator mapping from the composite of the former two loose maps to the latter to be ( id ( 𝑓 0 ( 𝑒 ′ 00 )) , id ( 𝑓 1 ( 𝑒 01 ) , 𝜆 ℓ ,𝑚 0 )) with 𝜆 ℓ ,𝑚 0 the composite below:

![[Towards a double operadic theory of systems.assets/figure-0028.png]]

Note here that 𝑎 · , · is the laxator of the double functor 𝑎 . Since 𝑓 0 is a commuter transformation, the globular cell ( 𝑓 0 ℓ ) &lt; is a tight isomorphism. Furthermore, since 𝑎 is a pseudo-functor, this overall cell is a tight isomorphism. This, and its correlate using 𝑓 1 , shows that Res ( 𝑎 ) will be a pseudo-functor of loose bimodules. If only 𝑎 were pseudo, then this double functor would still be lax on account of the square associated to 𝑓 𝑖 ; this is why we must assume that the 𝑓 𝑖 are commuter transformations in Res .

Action on 2-cells Now suppose we have a 2-cell like so:

![[Towards a double operadic theory of systems.assets/formula-0037.png]]

𝑖

We then define a tight transformation Res ( 𝛼 , · · · ) as follows:

1. On E 0 𝑖 , Res ( 𝛼 , · · · ) is just 𝜙 𝑖 .
2. The only nontrivial loose case to handle is 𝑚 0 : 𝐹 00 𝑒 00 p → 𝐹 01 𝑒 01 , which we assign to the square

![[Towards a double operadic theory of systems.assets/formula-0038.png]]

where the left and right squares are the transposes of the commutativity equation defining a 2-cell in 𝒩 iche .

□

Proposition 3.19 (Source and target of restricted loose bimodules) . The following diagram commutes.

![[Towards a double operadic theory of systems.assets/formula-0039.png]]

On objects this means that given a niche,

![[Towards a double operadic theory of systems.assets/formula-0040.png]]

its restriction is a loose bimodule whose source is E 0 and whose target is E 1 .

Proof. This follows by definition of the 2-functor Res given in Theorem 3.18.

□

As a corollary of Theorem 3.18, we conclude that restriction of a loose bimodule M : D 0 p → D 1 along lax symmetric monoidal pseudo-double functors 𝐹𝑖 : E 𝑖 → D 𝑖 induces a symmetric monoidal structure on the restriction M ( 𝐹 0 , 𝐹 1 ) so long as the unitors and laxitors of 𝐹 0 (resp. 𝐹 1 ) are conjoint (resp. companion) commuter transformations. For the remainder of this section, we will expand on this observation.

3.3.2.1 Cartesian and symmetric monoidal structure in 𝒩 iche Next we will investigate the cartesian and symmetric monoidal structure in 𝒩 iche .

Lemma 3.20 ( 𝒩 iche , and 𝒩 iche are cartesian 2-categories) . The domain 𝒩 iche (resp. 𝒩 iche ) of restriction of loose bimodules is a cartesian 2-category, and its cartesian products may be constructed componentwise in ℓ ℬ imod and 𝒟 bl .

In particular, the terminal object is the niche

![[Towards a double operadic theory of systems.assets/figure-0029.png]]

including the endpoints of the walking loose arrow.

Proof. As a pullback of cartesian functors between cartesian 2-categories, 𝒩 iche is cartesian, and its products are constructed componentwise. This relies on knowing that 2 𝒞 at colax ( Δ [ 1 ] , 𝒟 bl ) comp and 2 𝒞 at colax ( Δ [ 1 ] , 𝒟 bl ) conj are cartesian, but they are since 2 𝒞 at colax ( Δ [ 1 ] , 𝒟 bl ) is cartesian and a tight transformation into a product is a commuter if and only if its components are.

To see that 𝒩 iche is also cartesian, it suffices to note that the double functor induced into a product or a pullback is pseudo when both of its components are. □

We can use symmetry of internalization to characterize the symmetric monoidal and cartesian structure in 𝒩 iche .

Lemma 3.21 (Symmetric monoidal objects of 𝒩 iche and 𝒩 iche ) . A symmetric monoidal object of 𝒩 iche (resp. 𝒩 iche ) is equivalently:

1. A symmetric monoidal loose bimodule 𝑀 : M → L oose .
2. Symmetric monoidal double categories E 0 and E 1 .
3. Pseudo (resp. lax) symmetric monoidal pseudo-functors 𝐹𝑖 : E 𝑖 → 𝑀𝑖 , where the unitors and laxators of 𝐹 0 are , and the unitors and laxators of 𝐹 1 are .

Proof. First, we note that the projection 2-functors 𝑀 : 𝒩 iche → ℓ ℬ imod and E 𝑖 : 𝒩 iche → 𝒟 bl 𝑢 are cartesian, and therefore they preserve symmetric monoidal structure. It only remains to show that the colax squares (⊗ 𝑖 , ⊗ 𝑖 ) : 𝐹𝑖 × 𝐹𝑖 → 𝐹𝑖 and ( 1 𝑖 , 1 𝑖 ) : { 𝑖 } → 𝐹𝑖 assemble into a pseudo (resp. lax) monoidal morphism.

![[Towards a double operadic theory of systems.assets/formula-0041.png]]

This follows by the symmetry of internalization (Theorem 7.4) of [ABK24]; specifically, a symmetric pseudo-monoid in maps with pseudo (resp. colax) squares is a pseudo (resp. lax) monoidal morphism. □

Lemma 3.22 (Cartesian objects of 𝒩 iche ) . A cartesian object of 𝒩 iche consists of

1. A cartesian loose bimodule 𝑀 .
2. Cartesian double categories E 0 and E 1 .
3. Cartesian pseudo functors 𝐹𝑖 : E 𝑖 → 𝑀𝑖 , such that the laxators and unitors of 𝐹 0 are conjoints and of 𝐹 1 are companions.

Proof. We may again compute the cartesian objects componentwise in ℓ ℬ imod and 2 𝒞 at ps ( Δ [ 1 ] , 𝒟 bl ) 2 . By definition, a cartesian loose bimodule is a cartesian object in ℓ ℬ imod . On the other hand, by symmetry of internalization (Theorem 7.4 of [ABK24]), a cartesian object in 2 𝒞 at ps ( Δ [ 1 ] , 𝒟 bl ) is equivalently a cartesian functor between cartesian double categories. □

3.3.2.2 Restriction preserves cartesian and symmetric monoidal structure Since restriction of loose bimodules is cartesian, it will preserve some 2-algebraic structure. However, since it is only a pseudofunctor, it won't preserve all 2-algebraic structure. Specifically, fl exible 2-algebraic structure is preserved by cartesian pseudo-functors. Intuitively, 2-algebraic structure is fl exible when it does not require any equations between 1-cells; this includes symmetric monoidal and cartesian structure. If 2-algebraic structure is flexible, then we can pass it through a pseudo-functor by conjugating every 2-cell by the unitors and laxators of the pseudo-functor.

As a corollary, restriction of looes bimodules Res will preserve symmetric monoidal and cartesian structure.

Recall that for a cartesian 2-category 𝒦 ,

- 𝒮 M lax (𝒦) is the 2-category of symmetric monoidal objects in and lax monoidal morphisms.
- 𝒞 art (𝒦) is the 2-category of cartesian objects, cartesian maps, and general 2-cells.

Theorem 3.23 (Restriction of loose bimodules preserves symmetric monoidal and cartesian structure) . extends to pseudo-functors

![[Towards a double operadic theory of systems.assets/formula-0042.png]]

![[Towards a double operadic theory of systems.assets/formula-0043.png]]

Similarly, for Res : 𝒩 iche → ℓ ℬ imod .

Applying this preservation of symmetric monoidal and cartesian structure to the characterizations of symmetric monoidal and cartesian of 𝒩 iche leads to the following conclusions:

- Restriction of a symmetric monoidal loose bimodule by pseudo symmetric monoidal pseudofunctors (whose unitors and laxators are conjoints or companions, respectively) yields a symmetric monoidal loose bimodule.
- Similarly, restriction of a symmetric monoidal loose bimodule by lax symmetric monoidal pseudofunctors (whose unitors and laxators are conjoint or companion commuter transformations, respectively) will yield a symmetric monoidal loose bimodule.
- Finally, restriction of a cartesian bimodule by cartesian pseudofunctors yields a cartesian loose bimodule.

Explication 3.24 (Restriction of a symmetric monoidal loose bimodule) . Let

![[Towards a double operadic theory of systems.assets/formula-0044.png]]

and

be a symmetric monoidal niche.

By Theorem 3.23, the restricted loose bimodule M ( 𝐹 0 , 𝐹 1 ) is a symmetric monoidal loose bimodule. Here we explicate the monoidal structure for loose heteromorphisms in M ( 𝐹 0 , 𝐹 1 ) and show how it uses the conjoints of the laxator of 𝐹 0 and companions of the laxator of 𝐹 1 .

The laxator of 𝐹 0 is depicted in the following diagram.

![[Towards a double operadic theory of systems.assets/formula-0045.png]]

It is a . So for the identity loose morphism on 𝐹 0 𝑒 0 ⊗ 𝐹 0 𝑒 ′ 0 , we have the conjoint ⊗ &lt; 0 : 𝐹 ( 𝑒 0 ⊗ 0 𝑒 ′ 0 ) → 𝐹𝑒 0 ⊗ 𝐹𝑒 ′ 0 .

Likewise let ⊗ 1 be the laxator of 𝐹 1 . It is a companion commuter transformation. In particular, the companion of the laxator ⊗ 1 applied to the identity loose morphism on 𝐹 1 𝑒 1 ⊗ 𝐹 1 𝑒 ′ 1 induces a loose morphism 𝜙 &gt; 1 : 𝐹 1 𝑒 1 ⊗ 𝐹 1 𝑒 ′ 1 → 𝐹 1 ( 𝑒 1 ⊗ 1 𝑒 ′ 1 ) .

Now let 𝑚 : 𝐹 0 𝑒 0 p → 𝐹 1 𝑒 1 and 𝑚 ′ : 𝐹 0 𝑒 ′ 0 p → 𝐹 1 𝑒 ′ 1 be . Then their monoidal product in the restriction M ( 𝐹 0 , 𝐹 1 ) is defined to be the composite

![[Towards a double operadic theory of systems.assets/formula-0046.png]]

This formula works in all the cases above; but if the 𝐹𝑖 are pseudo-symmetric monoidal, then the ⊗ 𝑖 will be isomorphisms, and if everything involved is cartesian, then these will furthermore be cartesian products.

Remark 3.25 (Remark on the preservation of cartesian structure by certain colax 2-functors) . As remarked in the , we could actually end up with a normal colax 2-functor Res lax : 𝒩 iche lax → ℓ ℬ imod lax if we loosened up the definition of 𝒩 iche . This normal colax 2-functor would continue to preserve products, and moreover it would have the special property that the colaxator associated to composition with a product projection, from either side, is an isomorphism.

This suggests a general consideration concering colax ℱ -functors between ℱ -categories. It appears that the correct notion of such a functor is to be a colax 2-functor, but where the counitor is an isomorphism (it is normal) and the colaxator associated to composition with an inert morphism, on either side, is an isomorphism. We may see normality as a nullary case of the latter condition.

Abit of fiddling has made it seem reasonable to expect that such colax ℱ -functors which preserve products would also preserve cartesian objects (this can be straightforwardly verified) and furthermore induce a push-forward on the ℱ -categories of cartesian objects (this would benefit from a theoretical explanation). We leave it for an intrepid 2-algebraist to continue these musings.

We finish this remark by noting that a theorem of the above sort would give us a slight advantage in the double operadic theory of systems: we would know that the restriction of pre-cartesian loose bimodules by pre-cartesian pseudo-functors is still pre-cartesian. This is only a slight improvement on the results of this section; nevertheless, the general question is interesting on its own.

Explication 3.26 (Summary of results of Section 3.3.2) . We may put together the calculations Lemma 3.21 and Lemma 3.22 to conclude the following:

1. Restriction of a symmetric monoidal loose bimodule by pseudo symmetric monoidal pseudofunctors (whose unitors and laxators are conjoints or companions, respectively) yields a symmetric monoidal loose bimodule.
2. Similarly, restriction of a symmetric monoidal loose bimodule by lax symmetric monoidal pseudofunctors (whose unitors and laxators are conjoint or companion commuter transformations, respectively) will yield a symmetric monoidal loose bimodule.
3. Finally, restriction of a cartesian bimodule by cartesian pseudofunctors yields a cartesian loose bimodule.

We will use these constructions liberally to produce examples of systems theories as symmetric monoidal loose right modules.

Explicitly, if 𝑚 0 ∈ M ( 𝐹 0 𝑒 00 , 𝐹 1 𝑒 10 ) and 𝑚 1 ∈ M ( 𝐹 0 𝑒 01 , 𝐹 1 𝑒 11 ) are loose heteromorphisms of the restricted loose bimodule, then their monoidal product 𝑚 0 ⊗ res 𝑚 1 in the restriction is defined to be

![[Towards a double operadic theory of systems.assets/formula-0047.png]]

where ⊗ 𝑖 are the laxators of ⊗ 𝑖 : E 𝑖 × E 𝑖 → E 𝑖 , and we've taken the conjoint and companion respectively. This formula works in all the cases above; but if the 𝐹𝑖 are pseudo-symmetric monoidal, then the ⊗ 𝑖 will be isomorphisms, and if everything involved is cartesian, then these will furthermore be cartesian products.

## 4 Symmetric monoidal loose right modules as modules of systems

In this section, we define symmetric monoidal loose right modules and describe how they appropriately organize a collection of systems, their interactions, and their maps. In other words, we will show how the answers to the questions posed in Informal definition 1.1 form a symmetric monoidal loose right module. To emphasize this attitude we will often refer to a symmetric monoidal loose right module as a module of systems over a double category of interactions . We also give several examples of this attitude that we will make formal in Section 8.3.

## 4.1 Module of systems over interactions

We are now ready to give the main attitude of this section: that of a module of systems over a double category of interactions . We begin by definining symmetric monoidal loose right modules as symmetric monoidal objects of the 2-category of loose right modules.

Definition 4.1 (The 2-category of symmetric monoidal loose right modules) . The 2-category 𝒮 M ( ℓ ℳ od r ) is the 2-category of symmetric pseudo-monoids and pseudo-morphisms in the cartesian 2-category ℓ ℳ od r of loose right modules. We call the objects of this 2-category symmetric monoidal loose right modules .

It is helpful to view a symmetric monoidal loose right module as a symmetric monoidal category with an action.

Explication 4.2 (Symmetric monoidal loose right module) . We can think of a symmetric monoidal loose right module M : · p → D 1 as consisting of:

- Its target, a symmetric monoidal double category D 1 .
- Its carrier, a symmetric monoidal category Car ( M ) .
- A functor from the carrier to the tight category of the target, Car ( M ) → Tight ( D 1 ) .
- An action of the loose category of the target on the carrier Loose ( D 1 ) ↷ Car ( M ) .

By symmetry of internalization, a symmetric monoidal loose right module is a right pseudo-module internal to symmetric monoidal categories.

We now interpret a symmetric monoidal loose right module as an module of systems over a symmetric monoidal double category of interfaces and interactions .

Attitude 4.3 (Module of systems) . We will often consider a symmetric monoidal loose right module to organize the data of systems, their interactions, and their maps. When we do so, we will refer to this module as a module of systems .

Notation 4.4 (Module of systems) . Given a module of systems S : · p → I , we say that:

- The target I is the symmetric monoidal double category of interfaces and interactions mediating them.
- The carrier Car ( S ) is the symmetric monoidal category of systems and system maps .

Following the phrase a "module over a ring", we often call S a module of systems over interactions, I .

To further make sense of how a module of systems organizes the data of systems, their interactions, and their maps, it is helpful to rename the objects, morphisms, and squares of L oose so that the names give attitudes to each objects, morphisms, and squares that they label. These attitudes were introduced in ontology of double categorical systems theory.

Attitude 4.5 (Reinterpretting the walking loose arrow for modules of systems) . Let S → L oose be a module of systems. This functor labels the objects, morphisms, and squares of S by the objects, morphisms, and squares of L oose . When considering S as a module of systems, it is helpful to rename the objects, morphisms, and squares of L oose so that they assign meaningful labels to the different components of the module of systems, S .

First, recall the components of L oose from Explication 3.2.

Explication 4.6. The walking loose arrow double category L oose has two objects, three loose arrows (two identities along with the walking loose arrow 2 ℓ ), two identity tight arrows, and three identity squares. These are all pictured below.

![[Towards a double operadic theory of systems.assets/figure-0030.png]]

Next we strategically name each component.

- The source of a module of systems is the symmetric monoidal double category living over the left object 0 and its identity morphisms and square. Since the source of a systems theory is the terminal double category, we will rename the left object · .
- The target of a module of systems is the symmetric monoidal double category living over the right object 1 and its identity morphisms and square. We adopt the attitude that it represents interfaces and interactions that relate them. Therefore, we name the right object interface , its tight identity interface map , its loose identity interaction , and its identity square interaction map .
- The carrier of a module of systems is the symmetric monoidal category living over the walking arrow and its identity square. We adopt the attitude that the loose morphisms in module of systems labeled by the walking arrow will represent systems while the squares labeled by the identity square for the walking arrow represent system maps . Therefore, we name the walking loose arrow system and its identity square system map .

Collectively, these renamings result in the following new presentation of the walking loose arrow L oose . Note that in this presentation we no longer show the identity morphisms and square for the left object · , because in a systems theory they do not label any non-identity morphisms and squares.

Figure 3: Ontology of double categorical systems theory

![[Towards a double operadic theory of systems.assets/figure-0031.png]]

The labels and their interactions are a scheme for interpretting a module of systems.

Explication 4.7 (Labelling perspective for modules of systems) . Given a module of systems S → L oose , we refer to the objects living over interface as interfaces , the loose morphisms living over system as systems , the loose morphisms living over interaction as interactions , and so forth for the tight morphisms and squares.

To elaborate the notation in Notation 4.4, this means that given a module of systems S : · p → I .

- The target category I is the symmetric monoidal double category whose:
- -Objects are interfaces.
- -Tight morphisms are interface maps.
- -Loose morphisms are interactions.
- -Squares are interaction maps.
- The carrier Car ( S ) is the symmetric monoidal category whose:
- -Objects are systems.
- -Morphisms are system maps.

We can derive features of a systems theory from the structure of L oose . For example,

- Every system has an interface (its codomain).
- The composite of a system and an interaction is again a system. This composition is what we mean by interactions acting on systems .

![[Towards a double operadic theory of systems.assets/figure-0032.png]]

Finally, the symmetric monoidal structure implies that systems, interactions, and their maps can be composed in parallel. This feature is critical for the operadic perspective in which an interaction may act on several independent, component systems, whose result is a single composite system.

We can now re-interpret the explication of a symmetric monoidal loose right module from the perspective of a module of systems.

Explication 4.8 (Module of systems) . Amodule of systems S : · p → I consists of:

- A symmetric monoidal double category of interactions I .
- A symmetric monoidal category of systems Car ( S ) .
- A functor assigning systems to their interface, Car ( S ) → Tight ( I ) .
- An action of interactions on systems Loose ( I ) ↷ Car ( S ) that respects the interface.

Remark 4.9 (Restriction of modules of systems) . If S : · p → I is a module of systems and 𝑟 : J → I is a lax symmetric monoidal double functor (with unitors and laxators 𝜇 companion commuters) which we think of as giving a restriction of the double category of interactions from I to J , then for any two systems 𝑆 1 : · p → 𝑟𝐽 1 and 𝑆 2 : · p → 𝑟𝐽 2 are systems, their parallel product as systems over the interface double category J is the loose composite:

![[Towards a double operadic theory of systems.assets/figure-0033.png]]

## 4.2 Examples of modules of systems

In this section, we will give illustrative examples of modules of systems that are constructed via the doctrines that will be presented in Section 6 and Section 7. We give their full definition in Section 8.3 but introduce them here to exemplify how modules of systems answer the questions posed in Informal definition 1.1. Additionally, these examples either generalize or restructure categorical systems theories presented in the literature.

## 4.2.1 Module of open Petri nets over undirected wiring diagrams

Here we'll give an example of a module of systems

![[Towards a double operadic theory of systems.assets/formula-0048.png]]

by which Petri nets compose via undirected wiring diagrams. This example gives an operadic perspective on the symmetric monoidal double category of open Petri nets introduced in [BCV22b]. This systems theory is generated using the restriction of the port plugging doctrine to a free process.

We begin by defining Petri nets.

## 4.2.1.1 Petri nets

Definition 4.10 (Petri net) . APetri net consists of a finite set of species 𝑆 , a finite set of transitions 𝑇 and two functions 𝑠, 𝑡 : 𝑇 → N [ 𝑆 ] assigning to each transition a source multiset of species and a target multiset of species.

Example 4.11 (Petri net) . The following Petri net has two species 𝑆 and 𝐼 which represent a susceptible and infected population. The single transition represents an infection event whose source is ( 𝑆, 𝐼 ) and whose target is ( 𝐼, 𝐼 ) . In other words, an infection takes a susceptible and an infected individual and transforms them into two infected individuals.

![[Towards a double operadic theory of systems.assets/figure-0034.png]]

The double categorical perspective taken in [BCV22b] extends the single categorical perspective introduced in [BP17] by introducing the concept of maps between Petri nets .

Definition 4.12 (Maps of Petri nets) . Given Petri nets

![[Towards a double operadic theory of systems.assets/formula-0049.png]]

![[Towards a double operadic theory of systems.assets/formula-0050.png]]

a map of Petri nets 𝑃 → 𝑃 ′ consists of maps 𝑓 : 𝑆 → 𝑆 ′ and 𝑔 : 𝑇 → 𝑇 ′ satisfying

![[Towards a double operadic theory of systems.assets/formula-0051.png]]

and Example 4.13 (Maps of Petri nets) . Below depicts a map from a Petri net representing an SIR model of infection to a Petri net representing an SIS model of infection, in which recovered patients are susceptible to the disease once again.

![[Towards a double operadic theory of systems.assets/figure-0035.png]]

Colors outlining the species and transitions indicate the maps between species and transitions. In particular, the susceptible and recovered populations of the domain Petri net are mapped to the susceptible population of the codomain Petri net. The infected population of the domain Petri net is mapped to the intefected population of the codomain Petri net.

Petri nets and their maps form a category.

Definition 4.14 (Category of Petri nets) . Let Petri be the category whose objects are Petri nets and whose morphisms are maps of Petri nets.

From [BM20] this category has small colimits and hence is rex .

4.2.1.2 The double category of interfaces and interactions in the module of open Petri nets Recall the target of a module of systems is a symmetric monoidal double category whose tight category consists of interfaces and interface maps and whose loose category consists of interactions and interaction maps. For the module of open Petri nets, the double category of interfaces and interactions is the double category of cospans of finite sets, C ospan ( Finset ) , which we define below.

Definition 4.15 (The double category C ospan ( Finset ) ) . The double category C ospan ( Finset ) has:

- Objects are finite sets, 𝑀 .
- A tight morphism is a map of finite sets, 𝑓 : 𝑀 → 𝑀 ′ .
- A loose morphism is a cospan of finite sets, 𝑀 → 𝐽 ← 𝑁 .
- A square is a commuting diagram:

![[Towards a double operadic theory of systems.assets/formula-0052.png]]

Next we highlight how we depict the components of C ospan ( Finset ) as interfaces, interactions, and their maps labelled by the objects and morphisms of L oose .

Example 4.16 (Interfaces in the module of open Petri nets) . In the module of open Petri nets, interfaces and their maps are the tight category of C ospan ( Finset ) . Hence, an interface is a finite set and an interface map is a map of finite sets.

We depict an interface 𝑀 as a box with 𝑀 exposed ports. For example, below is the interface 2 .

![[Towards a double operadic theory of systems.assets/figure-0036.png]]

Note that our depiction shows how 𝑀 is an object of C ospan ( Petri )(∅ , C ospan ( Finset )) living over the object interface in L oose .

The following diagram depicts an interface map 3 → 2 . Colors indicate that the first and third ports (resp. second port) of the domain interface are sent to the first port (resp. second port) of the codomain interface.

Example 4.17 (Interactions in the module of open Petri nets) . In the module of open Petri nets, interactions and their maps are the loose category of C ospan ( Finset ) . Hence an interaction is given by a cospan of finite sets and a map of interactions is a map of cospans.

![[Towards a double operadic theory of systems.assets/figure-0037.png]]

For example, an interaction that transforms two systems each with interface 2 into a single system with interface 3 is a cospan 2 + 2 → 𝐽 ← 3 . The following cospan is an example of such an interaction.

![[Towards a double operadic theory of systems.assets/figure-0038.png]]

We depict this interaction as the following undirected wiring diagram living over the loose identity interaction : interface → interface .

![[Towards a double operadic theory of systems.assets/figure-0039.png]]

Let 𝑚 : 𝑀 → 𝑀 ′ and 𝑛 : 𝑁 → 𝑁 ′ be two maps of interfaces and let 𝑀 → 𝐽 ← 𝑁 and 𝑀 ′ → 𝐽 ′ ← 𝑁 ′ be two interactions. Recall, that an interaction map in the module of open Petri nets is a map 𝐽 → 𝐽 ′ such that the following diagram commutes.

![[Towards a double operadic theory of systems.assets/figure-0040.png]]

Below is an example of an interaction map that is the inclusion of an undirected wiring diagram with 3 junctions into an undirected wiring diagram with 4 junctions.

![[Towards a double operadic theory of systems.assets/figure-0041.png]]

It lives over the following identity square in L oose .

![[Towards a double operadic theory of systems.assets/figure-0042.png]]

4.2.1.3 System and system maps in the module of open Petri nets Recall that the carrier of a module of systems is a symmetric monoidal category whose objects are systems and whose morphisms are system maps. In this section, we describe the carrier of the module of open Petri nets.

Example 4.18 (Systems in the module of open Petri nets) . In the module of open Petri nets, a system is an open Petri net , which we define below.

Definition 4.19 (Open Petri net) . An open Petri net consists of:

- A finite set 𝑀 representing its interface.
- A Petri net ( 𝑆, 𝑇, 𝑠 : 𝑇 → N [ 𝑆 ] , 𝑡 : 𝑇 → N [ 𝑆 ]) .
- A map 𝑝 : 𝑀 → 𝑆 which determines the species that each port exposes.

In the module of open Petri nets, an open Petri net is a loose morphism whose codomain is its interface and which lives over the walking loose arrow system : · p → interface .

Below is an example of an open Petri net with interface 2 . This Petri net models an infection event. The first port exposes the susceptiple population 𝑆 and the second port exposes the infected population 𝐼 .

![[Towards a double operadic theory of systems.assets/figure-0043.png]]

Here is a second example of an open Petri net with interface 2 . This Petri net models a recovery event. The first port exposes the infected population 𝐼 and the second port exposes the recovered population 𝑅 .

Example 4.20 (Monoidal product for open Petri nets) . The module of open Petri nets is equipped with a symmetric monoidal structure that we can use to "stack" systems and interfaces.

![[Towards a double operadic theory of systems.assets/figure-0044.png]]

For example, below is the monoidal product of the two open Petri nets representing infection and recovery events. The interface for this monoidal product system is the monoidal product of the interfaces, which in this example is given by coproduct: 2 + 2 .

Example 4.21 (System maps for open Petri nets) . In the module of open Petri nets , a system map is a map of open Petri nets, which we define below.

![[Towards a double operadic theory of systems.assets/figure-0045.png]]

Definition 4.22 (Maps of open Petri nets) . Amap from an open Petri net with interface 𝑀

![[Towards a double operadic theory of systems.assets/formula-0053.png]]

to an open Petri net with interface 𝑀 ′

![[Towards a double operadic theory of systems.assets/formula-0054.png]]

along an interface map

![[Towards a double operadic theory of systems.assets/formula-0055.png]]

consists of a map of Petri nets ( 𝑓 : 𝑆 → 𝑆 ′ , 𝑔 : 𝑇 → 𝑇 ′ ) : 𝑃 → 𝑃 ′ such that the following diagram commutes

![[Towards a double operadic theory of systems.assets/formula-0056.png]]

Note that a system map is between two systems and along a map between the interfaces of those systems. Furthermore, it is labelled by the identity square (below called system map ) for the walking loose arrow (below called system ) in L oose :

![[Towards a double operadic theory of systems.assets/figure-0046.png]]

Below is an example of a system map between an open SIR Petri net and an open SIS Petri net along the interface map exemplified here.

![[Towards a double operadic theory of systems.assets/figure-0047.png]]

This type of system map has the quality of abstraction because it abstracts away the distinction between the susceptible and recovered populations while retaining the overal dynamics of the system.

Next we have an example of a system map from an open SIR Petri net to a open SIRD Petri net - in which infected patients either recover or die - along the indicated map of interfaces.

![[Towards a double operadic theory of systems.assets/figure-0048.png]]

This type of system map has the quality of embedding because it shows how the dynamics of the original SIR model are embedded in a larger model.

Example 4.23 (The action of interactions on systems in the module of open Petri nets) . Finally, we show how interactions (and their map) act on systems (and their maps) in the module of open Petri nets.

Example 4.24 (The action of undirected wiring diagrams on open Petri nets) . Recall that interaction is the loose identity on interface . Therefore, its composite with the walking loose arrow

![[Towards a double operadic theory of systems.assets/formula-0057.png]]

is again the walking loose arrow system . In other words, the diagram below commutes.

![[Towards a double operadic theory of systems.assets/figure-0049.png]]

We intrepret this fact as "an interaction transforms one system into another system". Consider the following composite in the module of open Petri nets.

![[Towards a double operadic theory of systems.assets/figure-0050.png]]

The undirected wiring diagram living over interaction transforms the two systems representing infection and recovery events living over system . As we will see mathematically in a future section, it identifies the infected species exposed by the two open Petri nets.

The composite of this process with these systems is again a system: an open Petri net representing an SIR infection model.

![[Towards a double operadic theory of systems.assets/figure-0051.png]]

Example 4.25 (Maps of composites) . We saw how interactions act on systems follows from the fact that in L oose the composite

![[Towards a double operadic theory of systems.assets/figure-0052.png]]

is the map · system - - - -→ interface .

Likewise, maps of interactions act on maps of systems because in L oose the composite of the squares

![[Towards a double operadic theory of systems.assets/figure-0053.png]]

![[Towards a double operadic theory of systems.assets/figure-0054.png]]

Below is an example of a map of systems (left) acted on by a map of processes (right). For simplicity we have omitted the colors indicating the details of these maps and leave them to be inferred by the reader.

is the square This action produces the following map of systems.

![[Towards a double operadic theory of systems.assets/figure-0055.png]]

![[Towards a double operadic theory of systems.assets/figure-0056.png]]

## 4.2.2 Module of Moore machines over lenses

Here we'll give an example of a module of systems

![[Towards a double operadic theory of systems.assets/formula-0058.png]]

by which deterministic Moore machines composing via lenses. For more on Moore machines, the monograph [Mye21] goes into great detail about these sorts of systems and their behaviors in its first few chapter. In particular, the kinds of Moore machines we will cover here (the traditional ones) are covered in Chapter 1 of [Mye21], their non-deterministic variants are covered in Chapter 2, and their maps and behaviors are covered in Chapter 3. In this paper, we will see Moore machines and their variants again in the guise of generalized Moore machines .

The construction of this module of systems is defined in Section 7.3. In this section we exemplify its systems, interactions, and their maps.

## 4.2.2.1 The double category of interfaces and interactions in the module of deterministic Moore machines

Explication 4.26 (The double category L ens ( proj Set ) ) . The double category of interactions for the module of deterministic Moore machines is the lense double category L ens ( proj Set ) where proj Set is the simple fibration associated with Set , which has:

- An object is a pair of sets which we denote 𝐴 # 𝐴 .
- A loose morphism is a pair of set maps 𝑓 : 𝐴 → 𝐵 and 𝑓 # : 𝐴 × 𝐵 # → 𝐴 # which we notate as a lens 𝑓 # 𝑓 : 𝐴 ♯ 𝐴 ⇆ 𝐵 ♯ 𝐵 . See also Example 2.38.
- A tight morphism is a pair of set maps 𝑓 : 𝐴 → 𝐵 and 𝑓 # : 𝐴 # × 𝐵 → 𝐵 # which we notate as a chart 𝑓 # 𝑓 : 𝐴 ♯ 𝐴 ⇒ 𝐵 ♯ 𝐵 .

Example 4.27 (Interactions in the module of deterministic Moore machines) . Since interactions are lenses interaction that transforms a Moore machine with interface 𝐼 𝑂 into a Moore machine with interface 𝐼 ′ 𝑂 ′ consists of:

- A map of outputs 𝑓 : 𝑂 → 𝑂 ′ .
- A map of inputs in the reverse order 𝑓 # : 𝐼 ′ × 𝑂 → 𝐼 .

Let 2 be the two element set { 0 , 1 } . There is an interaction

![[Towards a double operadic theory of systems.assets/formula-0059.png]]

where

- The map on outputs is the swap ( 𝑏 1 , 𝑏 2 ) ↦→ ( 𝑏 2 , 𝑏 1 ) .
- The map of inputs is given by ( 𝑎, ( 𝑏 1 , 𝑏 2 )) ↦→ ( 𝑎, 𝑏 1 ) .

This interaction is depicted by the directed wiring diagram below where each wire carries a copy of 2 .

![[Towards a double operadic theory of systems.assets/figure-0057.png]]

This interaction transforms two Moore machines (called the components) with interface 2 2 into a single Moore machine (called the composite) with interface 2 2 × 2 .

- The composite machine outputs the pair of outputs generated by the components.
- Given an input to the composite machine, that input is sent directly to the first machine and the output of the first component machine is used as the input to the second component machine.

We will show how this interaction acts on systems in Example 4.31.

## 4.2.2.2 Systems and the action of interactions in the module of deterministic Moore machines

Definition 4.28 (Open deterministic Moore machines) . Adeterministic Moore machine with interface 𝐼 consists of:

𝑂

- A set of states 𝑆 .
- An update 𝑢 : 𝐼 × 𝑆 → 𝑆 .
- A readout 𝑟 : 𝑆 → 𝑂 .

Note that a deterministic Moore machine is equivalently a lens

![[Towards a double operadic theory of systems.assets/formula-0060.png]]

Example 4.29 (Mod 2 counter) . Below is a deterministic Moore machine with interface 2 2 . It has two states, its update function counts modulo 2, and its readout is the identity.

![[Towards a double operadic theory of systems.assets/figure-0058.png]]

Example 4.30 (Mod 4 counter) . Below is a deterministic Moore machine with interface 2 2 . It has 4 states, its update function counts modulo 4, and its readout is the parity of the state.

![[Towards a double operadic theory of systems.assets/figure-0059.png]]

Example 4.31 (The action of lenses on deterministic Moore machines) . Consider composing two mod 2 counters according to the interaction described in Example 4.27. The result is a mod 4 counter.

![[Towards a double operadic theory of systems.assets/figure-0060.png]]

A state of the composite system is the product of the states of the component systems. The first component system is tracking the 1 s digit in the binary representation of a number and the second component system is tracking the 2 s digit.

So far we have seen two examples of Moore machines: the mod 2 counter and the mod 4 counter. In both of these examples, the read out is an isomorphism, which means that the whole state is exposed by the interface.

Consider composing the mod 4 counter with an interaction that 2 2 × 2 p → 2 2 that forgets the first output. The result is a mod 4 counter whose output exposes only the parity of each state. The states 00 and 10 output 0 while the states 01 and 11 output 1 .

4.2.2.3 System maps in the module of deterministic Moore machines In this section, we will show how maps of Moore machines can represent trajectories.

![[Towards a double operadic theory of systems.assets/figure-0061.png]]

Example 4.32 (Trajectories in deterministic Moore machine) . Atrajectory in a Moore machine is a sequence of inputs and a sequence of states that evolves according to the sequence of inputs. For example, in the mod 2 counter, one example trajectory consists of the input sequence

· · · 1 1 1 1 1 1 · · ·

· · · 0 1 0 1 0 · · ·

because if the mod 2 counter receives a sequence of input it will cycle through the four states. Another example of a trajectory consists of the input sequence

· · · 0 0 0 0 0 · · ·

and the state sequence and the state sequence and the state sequence

## · · · 0 0 0 0 0 · · ·

because if the system starts in state 0 and receives only 0 inputs, then it will remain in state 0 . Note that the input sequence

· · ·

· · ·

0 0 0 0 0

1 1 1 1 1

· · ·

· · ·

.

This example shows that the input sequence alone does not uniquely determine a trajectory.

In the remainder of this section we will show how a trajectory in a Moore machine is represented by system maps of a certain sort.

Example 4.33 (The timeline Moore machine) . Consider the Moore machine below. Its interface is 1 Z and states Z . The single input increments the state and the readout outputs the entire state.

![[Towards a double operadic theory of systems.assets/figure-0062.png]]

This Moore machine functions like a timeline. Each state is a time and the input incremements the clock.

Example 4.34 (Interface maps of Moore machines) . Amap of interfaces 𝐼 1 𝑂 1 → 𝐼 2 𝑂 2 consists of

- A map of outputs 𝑂 1 → 𝑂 2 .
- A map of inputs 𝐼 1 × 𝑂 1 → 𝐼 2 .

Given a Moore machine with interface 𝐼 𝑂 . We can index the trajectories by the behavior of the trajectory on its interface. The behavior of a trajectory on its interface is a sequence of inputs and outputs. This behavior is captured by a map of interface 1 Z → 𝐼 𝑂 .

For example, below is a map of interfaces 1 Z → 2 2 consisting of the input sequence of all 1 s and output sequence that alternates between 0 and 1 . This map defines a behavior on the interface 2 2 that is: output alternating 0 s and 1 s when receiving the input 1 .

Example 4.35 (Maps of Moore machines) . Amapof Moore machines along a given interface map consists of a map of states such that at each state the behavior of the systems on their interfaces are compatible according to the correspondence defined by the interface map.

![[Towards a double operadic theory of systems.assets/figure-0063.png]]

Explicitly, for 𝑖 = 1 , 2 suppose we have Moore machines

![[Towards a double operadic theory of systems.assets/formula-0061.png]]

with interfaces 𝐼 𝑖 . A map of Moore machines along the map of interfaces

𝑂𝑖

![[Towards a double operadic theory of systems.assets/formula-0062.png]]

consists of a map of states 𝑠 : 𝑆 1 → 𝑆 2 satisfying:

![[Towards a double operadic theory of systems.assets/figure-0064.png]]

Below is an example of a system map from the timeline Moore machine to the mod 2 counter along the interface map depicted above. The map of states defines a sequence of states (in other words, a trajectory) that produces the desired behavior on the interface.

![[Towards a double operadic theory of systems.assets/figure-0065.png]]

In this example the map of states was uniquely defined by the interface map. However, the next example shows that this is not always the case.

Using the same interface map, we can instead define a trajectory of the mod 4 counter that outputs only the parity of the state as a system map out of the timeline Moore machine. There are two such system maps because states 00 and state 10 produce the same behavior on the interface.

![[Towards a double operadic theory of systems.assets/figure-0066.png]]

![[Towards a double operadic theory of systems.assets/figure-0067.png]]

## 5 Constructing modules of systems via doctrines

In this section, we will introduce the notion of a doctrine of systems theories which is a formula for constructing particular classes of modules of systems from more primitive data than the module itself. In the following sections we will give examples of doctrines which reconstruct modules of systems that are prevalent in the literature.

## 5.1 Doctrines of systems theories

Webegin by giving a definition of a doctrines of systems theory. This definition is intentionally lightweight.

Definition 5.1 (Doctrine of systems theories) . A doctrine of systems theories consists of a cartesian 2-functor 𝜋 𝒟 : 𝒟 sys →𝒟 inter together with a (strictly) commuting square of cartesian pseudo-functors

![[Towards a double operadic theory of systems.assets/formula-0063.png]]

Figure 4: Doctrine of systems theories

into the 2-categories of loose right modules and double categories. We often notate such a doctrine by the triple,

![[Towards a double operadic theory of systems.assets/formula-0064.png]]

Adoctrine induces pseudofunctors

![[Towards a double operadic theory of systems.assets/formula-0065.png]]

![[Towards a double operadic theory of systems.assets/formula-0066.png]]

and similarly on 𝒟 which produce the actual modules of systems.

For a symmetric monoidal object 𝑇 of 𝒟 sys

inter ,

- We call 𝑇 a systems theory in the doctrine 𝒟 sys .
- We call 𝜋 𝒟( 𝑇 ) the interaction theory for the systems theory 𝑇 .
- The systems theory 𝑇 defines a module of systems S ( 𝑇 ) over thte double category of interactions I ( 𝜋 𝒟( 𝑇 )) .

Explication 5.2 (Doctrine of systems theories) . We think of a doctrine S : 𝒟 sys → ℓ ℳ od r as a way of answering the questions of Informal definition 1.1 about what it means to be a system .

1. An object 𝑇 ∈ 𝒮 M (𝒟 sys ) is a theory of 𝒟 -systems . The object 𝑇 itself is really the underlying data needed to specify precise answers to the questions of Informal definition 1.1. The object 𝜋 𝒟( 𝑇 ) ∈ 𝒮 M (𝒟 inter ) is the data needed to specify the interactions.
2. The pseudo-functor S then takes this data 𝑇 and produces a module of systems

![[Towards a double operadic theory of systems.assets/formula-0067.png]]

in which systems are acted on by the symmetric monoidal double category I ( 𝜋 𝒟( 𝑇 )) of interactions.

and Remark 5.3 (On the minimal notion of doctrine) . Our definition of doctrine is rather minimal. We choose to go with this minimal definition so that it can act as an organizing principle, rather than as a mathematical object of study in its own right (which might require us to discover further structure carried by doctrines of systems theories in particular, above their 2-functoriality). That is to say, we will construct examples of doctrines as defined in Definition 5.1, but we will not investigate any higher category of doctrines.

Nevertheless, even with such a minimal definition of doctrine, the notion will help us organize the vast array of systems theories in use by applied category theorists. We may make use of morphisms of doctrines given by precomposition to express that one doctrine is a special case of another. In the upcoming Section 8, we will perform a construction at the doctrine level to restrict a doctrine to wiring diagrams or free processes.

## 5.2 Doctrine of initial processes

Given a symmetric monoidal double category ( D , ⊗ , 1 ) , its

![[Towards a double operadic theory of systems.assets/formula-0068.png]]

is symmetric monoidal as well. To turn this loose bimodule into a module of systems, we collapse the left action. We do this essentially by giving a symmetric monoidal niche,

![[Towards a double operadic theory of systems.assets/figure-0068.png]]

![[Towards a double operadic theory of systems.assets/formula-0069.png]]

The constraint that this niche is symmetric monoidal implies that:

- The map · → D must map the single object of · to 1 .
- The canonical isomorphism 1 ⊗ 1 1 is a conjoint commuter transform.

This first of these features implies that the systems in the module of systems Hom 𝑙 ( D )( 1 , D ) are loose morphisms 𝑥 : 1 p → 𝑑 in D . These systems are acted on by loose morphisms in D .

The second of these features allows us to take the monoidal product of systems in the module of systems theory that is the restriction of this niche. In particular, given two systems 𝑥 : 1 p → 𝑑 and 𝑥 ′ : 1 p → 𝑑 ′ , their monoidal product in D is the loose morphism 𝑥 ⊗ 𝑥 ′ : 1 ⊗ 1 p → 𝑑 ⊗ 𝑑 ′ . Notably, this is not a system in the systems theory Hom 𝑙 ( D )( 1 , D ) , because its domain is not 1 . However, we can apply the conjoint commuter transform of the isomorphism 1 ⊗ 1 1 to modify 𝑥 ⊗ 𝑥 ′ so that its domain is 1 and hence is a system in this systems theory.

![[Towards a double operadic theory of systems.assets/formula-0070.png]]

In the remainder of this section, we define a doctrine of initial processes . A theory in this doctrine will be a symmetric monoidal double category ( D , ⊗ , 1 ) whose canonical isomorphism 1 ⊗ 1 1 is a conjoint commuter transform and it will define the module of systems that is the restriction of the niche shown above.

We begin by defining a 2-category of pointed double categories, whose symmetric monoidal objects objects will be the theories of the doctrine of initial processes.

and taking its restriction Definition 5.4 (Pointed double category) . A pointed double category is a double category D equipped with an object 𝑑 · ∈ D . Equivalently, it is a double functor 𝑑 · : · → D from the terminal double category.

Definition 5.5 (The cartesian 2-category of pointed double functors) . The 2-category 𝒟 bl · of pointed double categories and double functors which preserve the point up to a conjoint tight isomorphism is defined to be the following pullback:

![[Towards a double operadic theory of systems.assets/formula-0071.png]]

which, as a pullback of cartesian 2-functors, is a cartesian 2-category.

Lemma 5.6 (Symmetric monoidal and cartesian objects of 𝒟 bl · ) . A symmetric monoidal object of the 2-category 𝒟 bl · of pointed double categories is equivalent to a symmetric monoidal double category D for which the canonical isomorphism 1 ⊗ 1 1 is a conjoint commuter cell.

Similarly, a cartesian object of 𝒟 bl · is a cartesian double category for which the unique isomorphism 1 × 1 → 1 is a conjoint commuter cell.

Proof. First, note that the point of a symmetric monoidal pointed double category is its identity object.

The remainder follows by symmetry of internalization (Theorem 7.4 of [ABK24]): forgetting for a moment the conjoint commuter condition in 𝒟 bl · , we would have that 𝒮 M (𝒟 bl · ) ∗ ↓ ps 𝒮 M (𝒟 bl ) is the pseudo-slice under the terminal symmetric monoidal category. But a symmetric monoidal double functor from the terminal symmetric monoidal double category must be (up to isomorphism given by the unitor of that functor) be an inclusion of the monoidal unit; since 𝒟 bl · does in fact require the conjoint commuter condition, we see that the laxator of the inclusion of the monoidal unit must be a conjoint commuter.

Asimilar argument applies in the cartesian case.

□

Wecan now describe the doctrine of initial processes. First, by defining right niches and their restriction to looser right modules and then giving a doctrine that factors through this restriction.

Definition 5.7 (The 2-category of right niches) . A right niche is a niche whose left leg is a pseudo double functor out of the terminal double category:

![[Towards a double operadic theory of systems.assets/formula-0072.png]]

There is a 2-category of right niches 𝒩 iche 𝑟 which is the pullback of the following 2-categories.

![[Towards a double operadic theory of systems.assets/formula-0073.png]]

Since 𝒩 iche 𝑟 is the pullback of cartesian 2-categories along cartesian 2-functors, it is cartesian as is the restriction

Res :

$$𝒩 iche 𝑟 → ℓ ℳ od r .$$

Proposition 5.8 (Restriction of right niches) . There is a cartesian 2-functor Res : 𝒩 iche → ℓ ℳ od r that makes the following diagram commute:

![[Towards a double operadic theory of systems.assets/figure-0069.png]]

On objects this implies that the restriction of a right niche is a loose right module.

Proof. The outer diagram in the following commutes by Proposition 3.19.

![[Towards a double operadic theory of systems.assets/figure-0070.png]]

So Res : 𝒩 iche → ℓ ℳ od r is induced by the universal property of pullback. Furthermore, as the pullback of cartesian 2-functors, it is cartesian as well. □

Proposition 5.9 (The right niche of a pointed double category) . There exists a cartesian 2-functor 𝑝 : 𝒟 bl ·→𝒩 iche 𝑟 that takes a pointed double category 𝑑 · : · → D to the right niche

![[Towards a double operadic theory of systems.assets/figure-0071.png]]

Proof. Let 𝜋 : 𝒟 bl ·→𝒟 bl be the functor that forgets the point of a pointed double category. Note that on objects, 𝑠 ∗ 0 : 𝒟 bl → 2 𝒞 at colax ( Δ [ 1 ] , 𝒟 bl ) comp takes a double category to the identity double functor on it. Then, the following diagram of cartesian 2-functors commutes and induces the desired cartesian 2-functor.

![[Towards a double operadic theory of systems.assets/figure-0072.png]]

□

Definition 5.10 (Doctrine of initial processes) . The doctrine of initial processes is given by the following commuting square of cartesian 2-functors:

![[Towards a double operadic theory of systems.assets/figure-0073.png]]

where 𝑝 : 𝒟 bl ·→𝒩 iche 𝑟 is defined in Proposition 5.9.

Applying 𝒮 M to this doctrine, we see that symmetric monoindal objects of 𝒟 bl · are theories that produce modules of systems. Finally, we verify that these theories are indeed what we claimed at the beginning of this section.

Explication 5.11 (Doctrine of initial processes) . Explicitly, the doctrine of initial processes sends a pointed double category 𝑑 · : · → D to the loose bimodule Hom 𝑙 ( D )( 𝑑 · , D ) : · p → D of its loose Hom bimodule. In particular, the objects of its carrier are loose morphisms 𝑑 · p → 𝑑 . The loose morphisms of its target are loose morphisms of D which act by composition.

Recall, that systems theories are symmetric monoidal objects of the doctrine's domain. By Lemma 5.6 the symmetric monoidal objects of 𝒟 bl · are, essentially, just the symmetric monoidal double categories (satisfying a mild condition) pointed by their unit.

Therefore, when we start with a symmetric monoidal double category P (which we refer to as a process theory ) and pass it through the doctrine of initial processes, we end up with a module of systems over P whose systems are loose homs out of its monoidal unit, which we call initial processes .

## 6 Span and cospan doctrines via adequate triples

In this section, we will further specify the doctrine of initial processes includes many of our examples, we now turn to more specific doctrines which have a more uniform flavor. The remaining constructions will all use the same underlying categorical technology: spans .

Some systems theories - those that compose by sharing variables like the Hamiltonian and Langranian mechanics of [BWY21] (see our similar construction, following 1.3.2 of [Sch] in Example 2.19) and the Schultz-Spivak-Vasilakopolou approach to Willems' style behavioral control theory through sheaves ( machines in [SSV19]) - are naturally described by spans and pullback. But many others - those which compose by gluing together subsystems such as Petri nets [BM20] and stock-flow diagrams [Bae+22] are better handled by cospans, as well explored by the decorated and structured cospan literature (see, e.g. [Cou20]). Cospans are, however, just spans in the opposite category.

We begin by defining a doctrine of spans of an adequate triple, which factors through the doctrine of initial processes. We then define doctrines of spans of lex categories and cospans of rex categories, which factor through the doctrine of spans of adequate triples. Respectively, these correspond to the doctrines of variables sharing and port-plugging.

## 6.1 Doctrine of spans of adequate triples

We begin by defining the cartesian category of pointed adequate triples. Symmetric monoidal objects in this category will be theories in the doctrine of spans of adequate triples.

Definition 6.1 (Pointed adequate triple) . A pointed adequate triple consists of an adequate triple ( C , ( 𝐿, 𝑅 )) equipped with an object 𝑐 ∈ C thought of as a map from the terminal adequate triple 𝑐 : (· , ( all , all )) → ( C , ( 𝐿, 𝑅 )) .

The 2-category 𝒜 dTr · of pointed adequate triples consists of maps of adequate triples which preserve the point up to an isomorphism in the left class. That is, we may define 𝒜 dTr · as the full sub-2-category of the pseudo-slice · ↓ ps 𝒜 dTr under the terminal adequate triple, itself constructed by the following pullback:

![[Towards a double operadic theory of systems.assets/formula-0074.png]]

consisting of those 1-cells

![[Towards a double operadic theory of systems.assets/figure-0074.png]]

whose colaxator isomorphism ℓ is in the left class.

Observation 6.2 (Extending the span construction to pointed adequate triples) . The span cartesian 2-functor S pan : 𝒜 dTr → 𝒟 bl extends to a cartesian 2-functor S pan : 𝒜 dTr → 𝒟 bl which maps the adequate triple ( C , ( 𝐿, 𝑅 )) with point 𝑐 ∈ C to the double category S pan ( C , ( 𝐿, 𝑅 )) with point 𝑐 as well.

We note that S pan · does indeed land in 𝒟 bl · since we assumed that the isomorphisms witnessing preservation of the pointings were in the left class, and these are all conjoints in S pan ( C , ( 𝐿, 𝑅 )) .

Finally, we may then restrict the to pointed adequate triples along the span construction to get a doctrine of spans in an adequate triple.

Definition 6.3 (Doctrine of spans in a pointed adequate triple) . By restricting the , we get the following doctrine of spans in a pointed adequate triple.

![[Towards a double operadic theory of systems.assets/formula-0075.png]]

Explication 6.4 (Doctrine of spans in a pointed adequate triple) . In the doctrine of spans in a pointed adequate triple, a theory is a symmetric monoidal pointed adequate triple. As in the case of pointed double categories, a symmetric monoidal object of 𝒜 dTr · consists of a symmetric monoidal adequate triple ( C , ( 𝐿, 𝑅 )) whose point is the monoidal object 1 of C .

This theory produces the module of systems

![[Towards a double operadic theory of systems.assets/formula-0076.png]]

This module of systems has:

- An interface is an object of C .
- A system with interface 𝑐 is a span 1 ℓ ∈ 𝐿 ←- -𝑥 𝑟 ∈ 𝑅 - - - → 𝑐 .
- An interaction is a span in the adequate triple which acts on systems by pullback.
- Maps of systems and maps of interactions are maps of spans.

## 6.2 Span and cospan doctrines for lex and rex categories

We now give two specific examples of this doctrine: the variable sharing doctrine of spans in a lex category and the port-plugging doctrine of cospans in a rex category.

We begin by defining pointed lex and rex categories, whose symmetric monoidal objects will be theories in these doctrines.

Lemma 6.5 (The pointed adequate triple of a lex (resp. rex) category) . The cartesian 2-functor ℒ ex →𝒜 dTr defined in Construction 2.17 extends to a cartesian 2-functor ℒ ex →𝒜 dTr · which on objects sends a lex category C to the adquate triple ( C , ( all , all )) pointed by the initial object 1 ∈ C .

Likewise, the cartesian 2-functor ℛ ex co →𝒜 dTr defined in Construction 2.23 extends to a cartesian 2-functor ℛ ex co →𝒜 dTr · which on objects sends a rex category C to the adquate triple ( C , ( all , all )) pointed by the terminal object 0 ∈ C .

Proof. This follows from the definition of pointed adequate triples and the fact that lex categories preserve initial objects and hence the lex functor from the terminal lex category to a lex category C picks out the initial object of C . Likewise for rex functors from the terminal rex category to a rex category C picks out the terminal object of C . □

Observation 6.6 (Symmetric monoidal pointed lex and rex categories) . We note that ℒ ex has biproducts, so that every lex category is uniquely symmetric monoidal with the symmetric monoidal product given by cartesian product.

Likewise, ℛ ex has biproducts and so every rex category is uniquely symmetric monoidal with the symmetric monoidal product given by coproduct.

We can restrict the adequate triple doctrine along the inclusion ℒ ex →𝒜 dTr of Construction 2.17. We will call the resulting doctrine the variable sharing doctrine.

Definition 6.7 (Variable sharing doctrine) . We define the variable sharing doctrine to be the restriction of the doctrine of spans of adequate triples to adequate triples induced by lex categories, we get the following doctrine:

![[Towards a double operadic theory of systems.assets/formula-0077.png]]

Definition 6.8 (Port-plugging doctrine) . We define the port-plugging doctrine to be the restriction of the span doctrine of a pointed adequate triple to adequate triples induced by rex categories:

![[Towards a double operadic theory of systems.assets/formula-0078.png]]

This sends a rex category C to the loose right module

![[Towards a double operadic theory of systems.assets/formula-0079.png]]

of cospans out of the initial object. We can further dualize (in the tight direction) to get

![[Towards a double operadic theory of systems.assets/formula-0080.png]]

as a pseudo-functor of C ∈ ℛ ex (rather than ℛ ex co ).

## 7 The doctrine of generalized Moore machines

In Section 6, we saw how systems that compose via variable sharing or port plugging are defined by theories in doctrines defined by spans and cospans.

Other systems - those which are generalized Moore machines , such as systems of ODEs and POMDPs and other "automata" - compose best via lenses , as described for example in [VSL14] (see also [Mye21] for a pedagogical overview). However, lenses may also be described as spans of a particular sort (see Definition 2.35).

Roughly, a generalized Moore machine consists of an internal state, an input, and an output. Outputs are determined by the state and states change according to input. In the doctrine of generalized Moore machines that we will describe in this section, a theory (i.e. the data needed to define a module of systems) is a tangency , which consists of:

- A notion of space .
- A notion of bundle over spaces, which may be pulled back.
- An assignment of a "tangent" bundle to each space.

Atangency is the data necessary to construct a module of systems for which systems are generalized Moore machines and interactions are lenses (in the generalized sense of Spivak [Spi19]).

With this data in place, we can now sketch the definition a generalized Moore machine following the discussion in [Jaz21]. A generalized Moore machine consists of:

- A way things may be in the form of a space 𝑆 of states .
- A way things may change in the form of an element 𝑇𝑆 in the fiber over 𝑆 . In many examples of a tangency, such an element is in fact a bundle 𝑇𝑆 → 𝑆 . Then, for a state 𝑠 ∈ 𝑆 , the fiber 𝑇𝑠 𝑆 represents possible changes from 𝑠 .
- An interface in the form of:
- -Aspace 𝑂 of observations that may be made of the system or orientations which the system may take in its environment.
- -An element 𝐼 in the fiber over 𝑂 of inputs . In many examples of a tangency, such an element is in fact a bundle 𝐼 → 𝑂 . For an orientation 𝑜 ∈ 𝑂 , and the space 𝐼 𝑜 represents parameters to the dynamics of the system which are available in that orientation.
- An observation 𝑒 : 𝑆 → 𝑂 of the system, which exposes some aspects of state.
- A (parameterized) dynamics 𝑢 : 𝑒 ∗ 𝐼 → 𝑇𝑆 . In many examples of a tangency, these dynamics assign a state 𝑠 ∈ 𝑆 and a valid parameter 𝑝 ∈ 𝐼 𝑒 ( 𝑠 ) , to a change 𝑢𝑠 ( 𝑝 ) ∈ 𝑇𝑠 𝑆 .

## 7.1 Tangencies

In this section, we give a definition of symmetric monoidal tangencies, which are the theories in the doctrine of generalized Moore machines.

Definition 7.1 (The 2-category of tangencies) . A tangency is a cartesian fibration 𝜋 : 𝐸 → 𝐵 equipped with a section 𝑇 : 𝐵 → 𝐸 (with 𝜋 𝑇 = id 𝐵 ).

The 2-category 𝒯 an of tangencies is defined as the following pullback of 2-categories:

![[Towards a double operadic theory of systems.assets/formula-0081.png]]

where 𝑈 : ℱ ib → 2 𝒞 at ( Δ [ 1 ] , 𝒞 at ) forgets the structure of the fibration, 𝜄 : 2 𝒞 at ( Δ [ 1 ] , 𝒞 at ) → 2 𝒞 at colax ( Δ [ 1 ] , 𝒟 bl ) is the inclusion, and 𝑠 ∗ 0 : 𝒞 at → 2 𝒞 at colax ( Δ [ 1 ] , 𝒟 bl ) takes a category to its identity functor.

Explication 7.2 (The 2-category of tangencies) . Here we explicitly state the objects, morphisms, and 2-cells of 𝒯 an .

- An object is a tangency. In other words, a pair ( 𝜋 : 𝐸 → 𝐵, 𝑇 : 𝐵 → 𝐸 ) where 𝜋 is a cartesian fibration and 𝑇 is a section of 𝜋 .

- A morphism of tangencies

![[Towards a double operadic theory of systems.assets/formula-0082.png]]

consists of a cartesian functor ( 𝑓 , 𝑓 ) : 𝜋 1 → 𝜋 2 together with a colax morphism of sections 𝜙 : 𝑓 ◦ 𝑇 1 ⇒ 𝑇 2 ◦ 𝑓 so that 𝜋 2 𝜙 = id 𝑓 :

![[Towards a double operadic theory of systems.assets/formula-0083.png]]

These compose by whiskering:

![[Towards a double operadic theory of systems.assets/formula-0084.png]]

- A 2-cell of tangency morphisms is a 2-cell ( 𝛼 , 𝛼 ) : ( 𝑓 , 𝑓 ) ⇒ ( 𝑔, 𝑔 ) of ℱ ib for which

![[Towards a double operadic theory of systems.assets/formula-0085.png]]

Attitude 7.3 (Tangencies as states and possible changes) . Atangency is a cartesian fibration 𝜋 : 𝐸 → 𝐵 equipped with a section 𝑇 : 𝐵 → 𝐸 . We think of a tangency as follows:

1. 𝐵 is a category of state spaces .
2. For every state space 𝑆 ∈ 𝐵 , the fiber of 𝜋 : 𝐸 → 𝐵 over 𝑆 is a category 𝐸𝑆 of bundles over 𝑆 , which can be pulled-back along maps of spaces.
3. The section 𝑇 : 𝐵 → 𝐸 assigns to every state space its "tangent bundle", or bundle of possible changes.

A system in a tangency is then a "generalized Moore machine", or a lens 𝑢 𝐸 : 𝑇𝑆 𝑆 p → 𝐼 𝑂 which corresponds to the following span:

![[Towards a double operadic theory of systems.assets/formula-0086.png]]

We think of this as consisting of a morphism 𝑒 : 𝑆 → 𝑂 in 𝐵 which exposes some variables of state, and a parameterized update 𝑢 : 𝑒 ∗ 𝐼 → 𝑇𝑆 . Using lens notation, we notate such a system a lens

![[Towards a double operadic theory of systems.assets/formula-0087.png]]

We refer the reader to [Jaz21] for further discussion.

Attitude 7.4 (Morphisms of tangencies as changing the state space) . Let ( 𝜋 1 , 𝑇 1 ) and ( 𝜋 2 , 𝑇 2 ) be tangencies and let

![[Towards a double operadic theory of systems.assets/formula-0088.png]]

be a morphism of tangencies. We interpret this morphism as transforming the state space 𝑆 in the tangency ( 𝜋 1 , 𝑇 1 ) into the state space 𝑓 ( 𝑆 ) in the tangency ( 𝜋 2 , 𝑇 2 ) . Simply applying 𝑓 to the bundle of changes 𝑇 1 𝑆 over 𝑆 is not the bundle of changes 𝑇 2 ( 𝑓 𝑆 ) over 𝑓 ( 𝑆 ) . However, applying 𝜙 𝑆 to 𝑓 ( 𝑇 1 𝑆 ) maps it into the bundle of changes 𝑇 2 ( 𝑓 𝑆 ) over 𝑓 ( 𝑆 ) .

Wecan interpret this transformation as a lens. For 𝑆 ∈ 𝐵 1 , the morphism 𝜙 𝑆 in 𝐸 2 defines the following lens in L ens ( 𝐸 2 )

![[Towards a double operadic theory of systems.assets/formula-0089.png]]

Using lens notation, 𝜙 induces lenses

![[Towards a double operadic theory of systems.assets/formula-0090.png]]

See Proposition 4.5.1.11 of the manuscript [Mye21] to see the Euler method as an example of a morphism of tangencies from a tangency of ODEs to a tangency for discrete-time, continuous-space Moore machines. We expect that the Runge-Kutta method could also be expressed as such morphism, allowing us to derive the compositionality theorem proved by Ngotiaoco [Ngo17] via the pseudo-functoriality of the tangency doctrine.

Remark 7.5 (Tangencies in [Mye21]) . The definition of a tangency in the context of categorical systems theory first appears as a "dynamical systems doctrine" in Definition 1.1 of [Jaz21]. It appears further in [Mye21] as a "theory of dynamical systems" Definition 3.5.0.4 and Definition 4.5.1.2 respectively.

Here, we have changed the terminology to "tangency" to accomodate the other theories of dynamical systems we find in other doctrines. We also finally add the symmetric monoidal structure necessary for the parallel product of systems; see Lemma 7.7.

Finally, we show that 𝒯 an is cartesian and characterize its symmetric monoidal objects. These are the theories in the doctrine of generalized Moore machines.

Lemma 7.6 (Tangencies form a cartesian 2-category) . The 2-category 𝒯 an of tangencies form a cartesian 2-category with products constructed in ℱ ib (and therefore ultimately in 𝒞 at ).

Proof. The product of ( 𝜋 1 , 𝑇 1 ) and ( 𝜋 2 , 𝑇 2 ) is ( 𝜋 1 × 𝜋 2 , 𝑇 1 × 𝑇 2 ) . We equip the projections with the identity transformations 𝑝𝑖 ( 𝑇 1 × 𝑇 2 ) = 𝑇𝑖 𝑝 𝑖 . It is straightforward to verify the 2-dimensional universal property of the product, since the requisite equations may be checked componentwise. □

Lemma 7.7 (Symmetric monoidal tangency) . By symmetry of internalization (Theorem 7.4 of [ABK24]), a symmetric monoidal tangency ( 𝜋 , 𝑇 ) ∈ 𝒮 M (𝒯 an ) is equivalently a symmetric monoidal fibration 𝜋 : 𝐸 → 𝐵 equipped with a lax monoidal section 𝑇 : 𝐵 → 𝐸 .

## 7.2 Tangencies as systems theories

In this section, we construct a loose bimodule from a tangency. We then this loose bimodule to form a module of systems.

Lemma 7.8 (From tangencies to adequate triples) . Let ( 𝜋 : 𝐸 → 𝐵, 𝑇 : 𝐵 → 𝐸 ) be a tangency. The section 𝑇 induces a map of adequate triples by

![[Towards a double operadic theory of systems.assets/formula-0091.png]]

from the to the adequate triple associated to the fibration 𝜋 . This construction gives a cartesian 2-functor

![[Towards a double operadic theory of systems.assets/formula-0092.png]]

into maps of adequate triples and colax transformations.

Proof. The underlying 2-functor into 𝒞 at is just a projection:

![[Towards a double operadic theory of systems.assets/formula-0093.png]]

It only remains to show that this lifts along the forgetful functor 2 𝒞 at colax ( Δ [ 1 ] , 𝒜 dTr ) → 2 𝒞 at colax ( Δ [ 1 ] , 𝒞 at ) . Since 𝑇 : 𝐵 → 𝐸 gives a map of adequate triples 𝑇 : ( 𝐵, ( id , id )) → ( 𝐸, ( vert , cart )) , and since both the assignments 𝐵 ↦→( 𝐵 ( id , id )) and 𝜋 ↦→( 𝐸, ( vert , cart )) are 2-functorial, and since the forgetful functor 𝒜 dTr →𝒞 at is locally fully faithful, we have demonstrated that the above 2-functor lifts to 2 𝒞 at colax ( Δ [ 1 ] , 𝒜 dTr ) .

Since the projection is evidently cartesian, and since products in 𝒜 dTr are constructed in 𝒞 at , the 2-functor T is cartesian. □

Lemma 7.9 (Span construction of tangency lands in commuter tranformations) . The composite 2-functor

![[Towards a double operadic theory of systems.assets/formula-0094.png]]

lands in 2 𝒞 at colax ( Δ [ 1 ] , 𝒟 bl ) conj . We will refer to the resulting composite as

![[Towards a double operadic theory of systems.assets/formula-0095.png]]

Proof. We need to show that for any 1-cell 𝜙 : 𝑇 2 𝑓 ⇒ 𝑓 𝑇 1 : 𝜋 1 → 𝜋 2 of tangencies, the resulting tight transformation S pan ( 𝜙 ) is a conjoint commuter transformation. Note that by definition, 𝜙 is vertical; it is therefore in the left class of the adequate triple ( 𝐸 2 , ( vert , cart )) and is therefore component-wise a conjoint in S pan ( 𝐸 2 , ( vert , cart )) . It remains to show that it is a commuter; but the only loose morphisms in S pan ( 𝐵 1 , ( id , id )) are identities, and the transpose of the loose identity of a conjoint is always a tight isomorphism. □

Explication 7.10 (From tangencies to spans) . Let's examine the action of the functor S pan ( T ) : 𝒯 an → 2 𝒞 at colax ( Δ [ 1 ] , 𝒟 bl ) conj on objects.

Let ( 𝜋 : 𝐸 → 𝐵, 𝑇 : 𝐵 → 𝐸 ) be a tangency. We perform the span construction to get a map

![[Towards a double operadic theory of systems.assets/formula-0096.png]]

Note that:

- By Observation 2.25, S pan ( 𝐵, ( id , id )) is the loosely discrete double category T ( 𝐵 ) on 𝐵 which has 𝐵 as its tight category and only identity loose arrows.
- As per Definition 2.35 (see also Explication 2.37), S pan ( 𝐸, ( vert , cart )) is the double category L ens ( 𝐸 ) of Spivak lenses.

Therefore, S pan ( 𝑇 ) is given just by the action of 𝑇 in the tight categories; it sends a "base space" 𝑏 ∈ 𝐵 to its "tangent bundle" 𝑇𝑏 ∈ 𝐸 .

To simplify terminology, let's refer to S pan ( 𝑇 ) by 𝑇 so that under S pan ( T ) , the tangency ( 𝜋 , 𝑇 ) maps to the double functor:

![[Towards a double operadic theory of systems.assets/formula-0097.png]]

Lemma 7.11 (From tangencies to niches) . There is a cartesian 2-functor 𝒯 an →𝒩 iche that takes a tangency ( 𝜋 : 𝐸 → 𝐵, 𝑇 : 𝐵 → 𝐸 ) to the niche

![[Towards a double operadic theory of systems.assets/formula-0098.png]]

![[Towards a double operadic theory of systems.assets/formula-0099.png]]

takes a tangency with total space 𝐸 to the double category L ens ( 𝐸 ) of Spviak lenses.

The outer diagram in the following commutes.

![[Towards a double operadic theory of systems.assets/figure-0075.png]]

Hence by the universal property of pullbacks, we have the desired map 𝒯 an →𝒩 iche . □

Explication 7.12 (From tangencies to loose bimodules) . Let Sys : 𝒯 an → ℓ ℬ imod be the composite of the cartesian 2-functor 𝒯 an → 𝒩 iche defined in Lemma 7.11 with the Res : 𝒩 iche → ℓ ℬ imod turns a tangency ( 𝜋 : 𝐸 → 𝐵, 𝑇 : 𝐵 → 𝐸 ) into the loose bimodule

![[Towards a double operadic theory of systems.assets/formula-0100.png]]

We see that a heteromorphism with domain 𝑆 ∈ 𝐵 and codomain 𝐼 𝑂 ∈ L ens ( 𝐸 ) of the resulting bimodule is a lens 𝑢 𝑒 : 𝑇𝑆 𝑆 p → 𝐼 𝑂 . Explicitly, such a lens consists of 𝑒 : 𝑆 → 𝑂 in 𝐵 and 𝑢 : 𝑒 ∗ ( 𝐼 ) → 𝑇𝑆 in 𝐸 and these form the span

![[Towards a double operadic theory of systems.assets/formula-0101.png]]

Proof. The composite in 𝐸 . Such a morphism is precisely a system in the tangency as described in Attitude 7.3.

It is also worth understanding the functoriality of this construction. Let ( 𝜋 1 , 𝑇 1 ) and ( 𝜋 2 , 𝑇 2 ) be tangencies and let

![[Towards a double operadic theory of systems.assets/formula-0102.png]]

be a morphism of tangencies. Recall the attitude for morphisms of tangencies The morphism on tangencies induces a (covariant) action on systems which for 𝑆 ∈ 𝐵 and 𝐼 ∈ 𝐸 sends the system 𝑢 𝑒 : 𝑇 1 𝑆 𝑆 p → 𝐼 𝑂 in L ens ( 𝐸 1 ) to the composite

![[Towards a double operadic theory of systems.assets/formula-0103.png]]

in L ens ( 𝐸 2 ) . This lens corresponds to the following span:

![[Towards a double operadic theory of systems.assets/formula-0104.png]]

Finally, we are ready to define the doctrine of generalized Moore machines.

Definition 7.13 (Doctrine of generalized Moore machines) . We define the doctrine of generalized Moore machines as follows:

![[Towards a double operadic theory of systems.assets/formula-0105.png]]

where M oore is the composite of the collapse of a loose bimodule into a right bimodule of Sys , the loose bimodule of systems associated to a tangency. The 2-functor L ens : ℱ ib →𝒟 bl is the lens construction.

Explication 7.14 (Doctrine of generalized Moore machines) . In the doctrine of generalized Moore machines, a systems theory is a symmetric monoidal tangency ( 𝜋 : 𝐸 → 𝐵, 𝑇 : 𝐵 → 𝐸 ) . It produces the module of systems M oore ( 𝜋 , 𝑇 ) over the double category of interactions L ens ( 𝐸 ) .

- An interface in this module of systems is an object 𝐼 in L ens ( 𝐸 ) .

𝑂

- A system with interface 𝐼 𝑂 consists of a state space 𝑆 ∈ 𝐵 and a lens 𝑢 𝑒 : 𝑇𝑆 𝑆 p → 𝐼 𝑂 in which 𝑒 represents an observation and 𝑢 represents parameterized dynamics.
- An interaction is a lens that acts on systems via lens composition.
- Maps of systems and maps of interactions are given by charts.

Next we investigate the monoidal product of systems in this doctrine. For 𝑖 = 1 , 2 , let 𝑢𝑖 𝑟 𝑖 : 𝑇𝑆𝑖 𝑆𝑖 p → 𝐼 𝑖 𝑂𝑖 be systems in M oore ( 𝜋 , 𝑇 ) . Since ( 𝜋 , 𝑇 ) is a symmetric monoidal object of 𝒯 an , by symmetry of internalization 𝑇 : 𝐵 → 𝐸 has laxator 𝜇 𝑆 1 ,𝑆 2 : 𝑇𝑆 1 ⊗ 𝑇𝑆 2 ⇒ 𝑇 ( 𝑆 1 ⊗ 𝑆 2 ) which defines a lens

![[Towards a double operadic theory of systems.assets/formula-0106.png]]

The monoidal product of the systems 𝑢 1 𝑟 1 and 𝑢 2 𝑟 2 is the composite of lenses

![[Towards a double operadic theory of systems.assets/formula-0107.png]]

which corresponds to the following span

![[Towards a double operadic theory of systems.assets/formula-0108.png]]

We conclude this section with an example of a tangency and the module of systems that it defines.

Example 7.15 (Tangent bundle tangency) . A submersion 𝑝 : 𝑀 → 𝑁 of manifolds is a smooth map whose pushforward 𝑇𝑥 𝑝 : 𝑇𝑥 𝑀 → 𝑇 𝑝 ( 𝑥 ) 𝑁 on tangent spaces is surjective. Submersions stable under pullback, and so equip the category Man of manifolds with the structure of a display map category. Given a submersion 𝑝 : 𝑀 → 𝑁 , the fibers 𝑀𝑦 : = 𝑝 -1 ( 𝑦 ) are also manifolds. There is an associated fibration is 𝜋 : Subm → Man which sends a submersion 𝑝 : 𝑀 → 𝑁 to the manifold 𝑁 . It has a section 𝑇 : Man → Subm which on objects assigns a manifold 𝑀 to its tangent bundle 𝑇𝑀 → 𝑀 . Together, ( 𝜋 , 𝑇 ) is a tangency.

Asystem in the resulting module of systems then consists of a diagram of manifolds like so:

![[Towards a double operadic theory of systems.assets/formula-0109.png]]

which we interpret as follows

1. The interface of this system is a submersion 𝐼 → 𝑂 . The manifold 𝑂 is a space of observations. The submersion defines a manifold 𝐼 𝑜 for every observation 𝑜 ∈ 𝑂 .
2. We have a manifold 𝑆 whose points are states .
3. The map 𝑒 : 𝑆 → 𝑂 exposes an observation for every state.
4. There are smooth maps 𝑢 : 𝐼 𝑒 ( 𝑠 ) → 𝑇𝑠 𝑆 which are organized into a map of bundles 𝑢 : 𝑒 ∗ 𝐼 → 𝑇𝑆 . These maps define a tangent vector 𝑢 ( 𝑠, 𝑖 ) ∈ 𝑇𝑠 𝑆 parameterized by 𝑖 ∈ 𝐼 . These maps express the system of ordinary differential equations

![[Towards a double operadic theory of systems.assets/formula-0110.png]]

These systems interact through lenses which allow us to set the parameters of some systems by exposed observations of other systems.

Recall that a map out of the timeline Moore machine is a trajectory for deterministic Moore machines. Similarly, in this module of systems, there is a 'clock system' defined by the ODE 𝑑𝑡 𝑑𝑡 = 1 which is expressed as the following diagram:

![[Towards a double operadic theory of systems.assets/formula-0111.png]]

System maps out of this clock system are solutions of the codomain system.

## 7.3 Doctrine of open coalgebras

In this section, we will define a doctrine of open coalgebras . Where a coalgebra for an endofunctor 𝐹 is a map 𝑑 : 𝑆 → 𝐹𝑆 , and open coalgebra will be a kind of generalized Moore machine.

Definition 7.16 (Open coalgebras of an endofunctor) . Let C be a cartesian category and let 𝐹 : C → C be an endofunctor. Let 𝐼 and 𝑂 be objects of C . An open coalgebra for 𝑓 with interface 𝐼 𝑂 consists of an object 𝑆 ∈ 𝐶 together with functions

![[Towards a double operadic theory of systems.assets/formula-0112.png]]

If C is cartesian closed, an open coalgebra for 𝐹 with interface 𝐼 𝑂 is equivalently a coalgebra for the endofunctor 𝑋 ↦→ 𝑂 × ( 𝐹𝑋 ) 𝐼 .

We will now define a doctrine of open coalgebras.

Definition 7.17 (2-Category of endofunctors on cartesian categories) . Define the 2-category ℰ nd colax (𝒞 art ) of endofunctors on cartesian categories to be the following pullback of 2-categories:

![[Towards a double operadic theory of systems.assets/formula-0113.png]]

Explicitly:

1. The objects of ℰ nd colax (𝒞 art ) are cartesian endofunctors 𝐹 : C → C of cartesian categories C .
2. Amorphism is a colax square

where 𝐴 : C → D is a cartesian functor.

3. A2-cell is a natural transformation 𝜑 : 𝐴 ⇒ 𝐵 to that the following equation holds:

![[Towards a double operadic theory of systems.assets/formula-0114.png]]

Construction 7.18 (Tangency associated to an endofunctor on a cartesian category) . Let 𝐹 : C → C be an endofunctor of a cartesian category C . Define the section - × 𝐹 -: C → proj C of the simple fibration of C by the following composite:

![[Towards a double operadic theory of systems.assets/formula-0115.png]]

![[Towards a double operadic theory of systems.assets/formula-0116.png]]

where C × C × - → proj C is the functor which on objects is defined by the projection

![[Towards a double operadic theory of systems.assets/formula-0117.png]]

and on morphisms is defined by:

![[Towards a double operadic theory of systems.assets/figure-0076.png]]

colax

This gives a cartesian 2-functor ℰ nd (𝒞 art ) → 𝒯 an . Note that it sends a 1-cell ( 𝐴, 𝛼 ) : ( C , 𝐹 ) → ( D , 𝐺 ) to the following 2-cell:

![[Towards a double operadic theory of systems.assets/formula-0118.png]]

Proof. Verification is straightforward: the 1- and 2-cells of ℰ nd colax (𝒞 art ) appear in the middle of Figure 7.18 almost entirely unaltered. □

In the doctrine of open coalgebras, as systems theory will be a symmetric monoidal object of ℰ nd colax (𝒞 art ) . By symmetry of internalization , it is straightforward to compute what these are.

Lemma 7.19 (Symmetric monoidal object of ℰ nd colax (𝒞 art ) ) . A symmetric monoidal object of the 2-category ℰ nd colax (𝒞 art ) of endofunctors on cartesian categories consists of a lax symmetric monoidal structure on the endofunctor 𝐹 : C → C with respect to the cartesian product of C .

Proof. Explicitly, symmetry of internalization says that a symmetric monoidal object of ℰ nd colax (𝒞 art ) consists of an endofunctor 𝐹 : C → C on a cartesian category together with a symmetric monoidal structure 1 : · → C and ⊗ : × C → C -both cartesian functors - for which 𝐹 is lax symmetric monoidal. But if 1 : · → C is a cartesian functor, it must be the inclusion of the terminal object; and for ⊗ : C × C → C to be cartesian means that we have a coherent interchange isomorphism

![[Towards a double operadic theory of systems.assets/formula-0119.png]]

By the Eckman-Hilton argument, or more generally by the Baez-Dolan stabilization hypothesis (see Corollary 6.2.9 of [GH15]), this implies that the monoidal product and cartesian product must coincide: ⊗ × . Therefore, the data of a symmetric monoidal object in ℰ nd colax (𝒞 art ) consists of a lax monoidal structure on 𝐹 with respect to the cartesian product of C . □

Definition 7.20 (Doctrine of open coalgebras) . We define the doctrine of open coalgebras to be the restriction of the doctrine of generalized Moore machines along the cartesian 2-functor ℰ nd colax (𝒞 art ) → 𝒯 an of Construction 7.18:

![[Towards a double operadic theory of systems.assets/formula-0120.png]]

where Simp : 𝒞 art →ℱ ib is sends a cartesian category C to its simple fibration proj C .

Notation 7.21 (Lenses of simple fibrations) . Let C be a cartesian category. An object of L ens ( proj C ) is a pair 𝑂 × 𝐼 𝑂 indicating that 𝑂 × 𝐼 lives in the fiber over 𝑂 in the simple fibration proj C . We often abbreviate this object to simply 𝐼 .

𝑂

Explication 7.22 (Doctrine of open coalgebras) . From Lemma 7.19, a systems theory in the doctrine of open coalgebras consists of an endofunctor 𝐹 : C → C with a lax monoidal structure with respect to the cartesian product of C . In the module of systems produced by this systems theory

- Interfaces are pairs of objects in C notated 𝐼 𝑂 .
- A system with interface 𝐼 𝑂 is a span in proj C of the form

![[Towards a double operadic theory of systems.assets/formula-0121.png]]

𝑒

which consists ultimately of maps 𝑒 : 𝑆 → 𝑂 and 𝑢 : 𝑆 × 𝐼 → 𝐹𝑆 . This is precisely an open coalgebra.

- The parallel product of open coalgebras 𝑢 1 𝑒 1 : 𝐹𝑆 1 𝑆 1 p → 𝐼 1 𝑂 1 and 𝑢 2 𝑒 2 : 𝐹𝑆 2 𝑆 2 p → 𝐼 2 𝑂 2 is given by 𝑒 1 × 𝑒 2 : 𝑆 1 × 𝑆 2 → 𝑂 1 × 𝑂 2 together with

![[Towards a double operadic theory of systems.assets/formula-0122.png]]

In the remainder of this section we detail examples particular systems theories in the doctrine of open coalgebras.

Example 7.23 (Deterministic Moore machines) . Under the doctrine of open coalgebras, the identity endomorphism on Set is a systems theory that defines a module of determinstic Moore machines

![[Towards a double operadic theory of systems.assets/formula-0123.png]]

via the simple fibration proj Set and the tangency (-) 2 : Set → Set × Set . This module of systems is covered in detail in Section 4.2.2.

Example 7.24 (Non-deterministic Moore machines) . Under the doctrine of open coalgebras, the powerset monad on Set is a systems theory that defines a module of non-determinstic Moore machines.

Example 7.25 (Partially observable Markov decision processes (POMDPs)) . Under the doctrine of open coalgebras, the Giry monad [Gir82] on measurable spaces 𝑓 : Meas → Meas -is a systems theory that defines a module of partially observable Markov decision process (POMDPs).

In this module, we interpret an interface 𝐼 𝑂 as consisting of our set of potential observations 𝑂 as well as our menu of actions 𝐼 , and interpret a system 𝑢 𝑒 : 𝑓 𝑆 𝑆 p → 𝐼 𝑂 as consisting of a deterministic observation 𝑒 : 𝑆 → 𝑂 as well as a stochastic update 𝑢 : 𝑆 × 𝐼 → 𝑓 𝑆 that defines a conditional probability kernel 𝑃 (- | 𝑠, 𝑖 ) : = 𝑢 ( 𝑠, 𝑖 ) of the next state on the current state.

We can augment the Giry monad to include a reward term R . For example, we can consider the endofunctor on measureable spaces that is defined on objects by 𝑋 ↦→ R × 𝑓 ( 𝑋 ) . Or by 𝑋 ↦→ 𝑓 ( R × 𝑋 ) if we want to preserve monadicity.

There are of course many different probability monads, such as the monad of finitary distributions on Set [Fri09], the Radon monad on the category of compact Hausdorff spaces [Kei08], the probability monad on quasi-Borel spaces [HKSY17], and many more. All of these give specific definitions of POMDPs with particular notions of state space and probability distribution.

Example 7.26 (Other non-deterministic coalgebras) . There are many different sorts of non-deterministic coalgebras other than the one captured by powerset. For example, Fritz, Perrone, and Rezagholi [FPR21] construct a Hoare hyperspace monad on topological spaces sending a topological space to a space of its closed subsets. They also construct a probability monad on topological spaces and show that the support of a distribution gives a commutative monad morphism to the Hoare hyperspace monad. This gives an example of a morphism 𝐹 ⇒ 𝐺 of endofunctors which, by the pseudo-functoriality of the doctrine, gives us a compositionality theorem relating POMDPs (with respect to their probability monad) and non-deterministic Moore machines (with repsect to the Hoare hyperspace monad).

## 7.4 Doctrine of ODEs in tangent categories

In this section, we present a doctrine of ordinary differential equations in tangent categories [CC13], expressed as parameterized sections of tangent bundles. This expands the approach taken in Section 3.5.2 of [Mye21].

In [CCGZ24], Capucci, Crutwell, Ghani, and Zanasi consider a notion of fi rst order differentiable structures (FODS) (Definition 58 of [CCGZ24]) in a 2-category 𝒦 and compare this notion to various notions of tangent category appearing prior in the literature. A FODS in 𝒦 consists of a fibration 𝜋 : 𝐸 → 𝐵 in 𝒦 with structured biproducts together with a section 𝑇 : 𝐵 → 𝐸 .

Definition 7.27 (First order differential structures (FODS)) . Let 𝒦 be a 2-category with finite 2-limits and a finite 2-limit preserving forgetful functor 𝑈 : 𝒦 → 𝒞 at . Define the 2-category ℱ ODS (𝒦) of fi rst order differential structures in 𝒦 (following Definition 58 of [CCGZ24]) as the following pullback of 2-categories:

![[Towards a double operadic theory of systems.assets/formula-0124.png]]

where ℱ ib + (𝒦) is the 2-category of fibrations with biproducts in 𝒦 .

Remark 7.28 (Remark on tangency morphisms and tangent categories) . While morphisms of FODS aren't considered in [CCGZ24], Lanfranchi does define a 2-category of tangent categories and 'lax' morphisms in [Lan25] (see Definitions 2.5, 2.7 and 2.10 of [Lan25]). What Lanfranchi calls a 'lax' morphism of tangent categories (Definition 2.7 of [Lan25]) corresponds to our (colax) morphisms of tangencies when considered as a FODS by Theorem 56 of [CCGZ24]. For this reason, we feel justified in using our morphisms of tangencies as those of tangent categories or FODS more generally.

In [Leu17], Leung shows (Theorem 14.1 of [Leu17]) that a tangent category structure on a category 𝐶 is equivalent to a pseudo-monoidal functor Weil 1 → End ( 𝐶 ) from the monoidal category of first order Weil algebras satisfying two limit preservation properties. Such a monoidal functor corresponds to a pseudofunctor ℬ Weil 1 →𝒞 at . The morphisms Lanfranchi consideres in Definition 2.7 of [Lan25] should correspond to colax morphisms of these pseudo-functors.

A core idea of [Lan25] is that Leung's tangent structures as pseudo-functors ℬ Weil 1 →𝒞 at can be thought of as generalized monads (themselves functors ℬ Δ + → 𝒞 at ). Colax morphisms of monads are the kind for which the Kleisli construction is functorial; colax morphisms of tangent categories (what Lanfranchi unfortunately calls "lax") are the kind for which vector fields are functorial. This is ultimately why our use of colax morphisms of tangencies is the correct choice for understanding the compositionality of systems of ODEs.

Next we will see that if 𝒦 is a concrete 2-category with a finite 2-limit preserving forgetful 2-functor 𝑈 : 𝒦 → 𝒞 at , then a FODS will induce a tangency.

Definition 7.29 (Doctrine of ODEs in first order differential structures) . Let 𝒦 be a concrete 2-category with a finite 2-limit preserving forgetful 2-functor 𝑈 : 𝒦 → 𝒞 at . The forgetful functor 𝑈 : 𝒦 → 𝒞 at determines a square of cartesian 2-functors:

![[Towards a double operadic theory of systems.assets/formula-0125.png]]

which when post composing with the doctrine of systems in a tangency gives us a doctrine of ordinary differential equations in a first order differential structure:

![[Towards a double operadic theory of systems.assets/formula-0126.png]]

There are many examples of FODS, tangent categories, and cartesian differential categories. Each of these is a systems theory that will produce a module of systems whose systems are generalized ordinary differential equations expressed as a parameterized section of a tangent bundle:

![[Towards a double operadic theory of systems.assets/formula-0127.png]]

Example 7.30 (Euclidean ODEs) . Let Euc be the category whose objects are natural numbers 𝑛 and whose maps are smooth functions R 𝑛 → R 𝑚 . The category Euc is a cartesian differential category , which are an example of a first-order differential structure [CCGZ24]. Explicitly, the underlying fibration of the FODS induced by Euc is the simple fibration associated to Euc . The section of the FODS induced by Euc on objects sends R 𝑛 to R 𝑛 × R 𝑛 → R 𝑛 , and on morphisms sends 𝑓 : R 𝑛 → R 𝑚 to its derivative

![[Towards a double operadic theory of systems.assets/formula-0128.png]]

The FODS induced by Euc is a systems theory which produces a module of systems whose:

- Interfaces consist of numbers 𝑛𝑜 and 𝑛𝑖 of exposed variable and parameters, respectively.
- Systems consist of:
- -Anumber 𝑛𝑠 of state variables .
- -Amap fi 𝑒 : R 𝑛𝑠 → R 𝑛𝑜 exposing 𝑛𝑜 variables of state.
- -A map fi 𝑢 : R 𝑛𝑠 × R 𝑛𝑖 → R 𝑛𝑠 giving a vector of state displacement vectors, representing the system of ODEs

![[Towards a double operadic theory of systems.assets/formula-0129.png]]

## 8 Restricting doctines to free interactions

In Section 5, Section 6, and Section 7, we constructed a number of examples of doctrines. However, the resulting modules of systems produced by these doctrines were over double categories of interactions which were qualitatively complex, often including the systems and system maps themselves as special cases. therefore, composing systems theories through these interactions could have arbitarily complex effects. For example:

1. The were loose right modules on the double category of all (co)spans in C . These (co)spans could include arbitary component systems; they certainly do more than just compose.
2. The systems theories of generalized Moore machines associated to tangencies are acted on by all generalized lenses; these do more than compose, since they can allow arbitrary intermediate transformations of the outputs and parameters of the Moore machines.

In this section, we will show how to restrict these more general interactions to simpler coupling schemes or wiring diagrams . We base our approach on the following observation.

Observation 8.1 (Wiring diagrams are free interactions) . Awiring diagram for a given doctrine is an interaction in a free theory of interactions in that doctrine.

## 8.1 Wiring diagrams are free interactions

Recall that given a doctrine is a commuting diagram as follows.

![[Towards a double operadic theory of systems.assets/formula-0130.png]]

Given a systems theory 𝑇 ∈ 𝒟 sys , we call 𝜋 𝒟( 𝑇 ) the interaction theory . Under I , 𝑇 produces a double category of interactions which acts on the systems in the modulee of systems defined by 𝑇 . The loose arrows of this double category of interactions are what we term interactions . In the literature, many interactions are in the form of wiring diagrams and that these are freely generated interactions (see [Spi13], [VSL14], [LBPF22]).

Let's see Observation 8.1 borne out in a few special cases.

Example 8.2 (Undirected wiring diagrams are free interactions) . Systems in the are well known to form hypergraph categories , which by the work of Fong and Spivak [FS18c] are equivalently described as algebras for operads of cospans of typed finite sets (see [FS18c] for a review of hypergraph categories and how they arise as (co)spans and (co)relations).

If 𝑋 is a set of "types", then the category of typed finite sets is defined to be the slice category Finset ↓ 𝑋 consisting of finite sets 𝐼 equipped with a typing map 𝜏 : 𝐼 → 𝑋 . Cospans of typed finite sets are interpreted as undirected wiring diagrams ([Spi13]).

The following undirected wiring diagram - introduced in Example 4.17 - is an undirected wiring diagram over a single set of types.

![[Towards a double operadic theory of systems.assets/figure-0077.png]]

Composition of such cospans gives nesting.

Next, we will show how these undirected wiring diagrams arise as free interactions in the portplugging doctrine. As the variable sharing nad port-plugging doctrines are highly related, we treat them together.

The variable sharing doctrine and the port-plugging doctrine have ℒ ex and ℛ ex as their interaction theory, respectively. Both ℒ ex and ℛ ex are monadic over 𝒞 at via adjunctions 𝑈 : ℒ ex ⇆ 𝒞 at : 𝐹 and 𝑈 : ℛ ex ⇆ 𝒞 at : 𝐹 . If 𝑋 is a set of "types", considered as a discrete category, then it generates a free interaction theory 𝐹𝑋 in ℒ ex or ℛ ex (considering 𝑋 as a discrete category).

Let us first consider the case of ℛ ex . The free finite colimit completion on a category is given by the finite colimits of representable presheaves. In the case that 𝑋 is a discrete category, the category Psh ( 𝑋 ) of presheaves on 𝑋 is equivalent to the slice category Set ↓ 𝑋 . Therefore, the free rex category 𝐹𝑋 on 𝑋 is the slice category Finset ↓ 𝑋 of 𝑋 -typed finite sets . So under the port-plugging doctrine, the interaction theory 𝐹𝑋 defines the double category of interactions the symmetric monoidal double category of cospans of 𝑋 -typed finite sets, C ospan ( Finset ↓ 𝑋 ) . We therefore see that a free interaction in the port-plugging doctrine is precisely an undirected wiring diagram in then sense of [Spi13].

Now consider the case of ℒ ex . The free finite limit category on a category 𝐶 is the opposite of the free finite colimit completion of 𝐶 op . By the reasoning above, we therefore see that the free lex category on a discrete category 𝑋 is ( Finset ↓ 𝑋 ) op . Therefore under the variable sharing doctrine, the interaction theory 𝐹𝑋 defines the double category of interactions S pan (( Finset ↓ 𝑋 ) op ) ; but this is equivalently C ospan ( Finset ↓ 𝑋 ) op . Again, we find that free interactions in the span doctrine are precisely undirected wiring diagrams.

Example 8.3 (Directed wiring diagrams are free interactions) . In [VSL14], Vagner, Spivak, and Lerman consider algebras of dynamical systems (specifically, ODEs) on operads of directed wiring diagrams . These diagrams are defined to be prisms in the cocartesian category of typed finite sets, which are by definition lenses in the cartesian opposite of the category of typed finite sets.

The following is a directed wiring diagram with a single type.

![[Towards a double operadic theory of systems.assets/figure-0078.png]]

Now, the doctrine of simple Moore machines in a cartesian category has cartesian categories as its interaction theories. The 2-category 𝒞 art of cartesian categories is monadic over 𝒞 at via the adjunction 𝑈 : 𝒞 art ⇆ 𝒞 at : 𝐹 , where for a category C the free cartesian category 𝐹 C may be constructed as the opposite of a colax slice:

![[Towards a double operadic theory of systems.assets/formula-0131.png]]

In particular, we find that free cartesian categories on a discrete category (set) 𝑇 are the opposite categories of typed finite sets. Therefore, interactions in the theory of simple Moore machines - which are lenses in these free cartesian categories are precisely directed wiring diagrams. This observation was made in Section 1.3.3 of [Mye21].

Furthermore, Observation 8.1 suggests ways to define wiring diagrams which may have "function boxes" that transform values on the wires, or other such decorations: simply work in the free interaction theories generated by algebraic theories of the "functions" which you would like to place on the boxes (see Section 1.3.4 of [Mye21]). For example, the free interaction theory consisting of lenses in the Lawvere theory generated by a single unary operation 𝑑 : 𝑋 → 𝑋 gives directed wiring diagrams with delays .

## 8.2 Restricting a doctrine to free interactions

We will now describe a general construction that lets us restrict a doctrine so that its interaction theories are freely generated.

In what follows, assume that we are given a doctrine:

![[Towards a double operadic theory of systems.assets/formula-0132.png]]

and a pair of functors 𝐹 : 𝒞 ⇆ 𝒟 inter : 𝑈 which form a 2-adjunction 𝐹 ⊣ 𝑈 .

Definition 8.4 (The 2-category of restricted systems theories to free interactions) . Define the cartesian 2-category 𝒞 ↓ adm 𝑈 𝜋 𝒟 to be the sub-2-category of the colax slice 𝒞 ↓ colax 𝑈 𝜋 𝒟 spanned by all objects and 1-cells

![[Towards a double operadic theory of systems.assets/formula-0133.png]]

whose colaxator 𝑓 is admissible meaning that I sends its transpose tr ( 𝑓 ) in 𝒟 inter along the 𝐹 ⊣ 𝑈 adjunction to a companion commuter transformation.

For notational clarity we define

![[Towards a double operadic theory of systems.assets/formula-0134.png]]

Explication 8.5 (The 2-category of restricted systems theories to free interactions) . The cartesian 2-category 𝒟 sys | 𝐹 is the 2-category of systems theories when we restrict the doctrine ( 𝜋 𝒟 : 𝒟 sys →𝒟 inter , S , I ) along the left adjoint 𝐹 : 𝒞 → 𝒟 inter .

Atheory in this restricted systems theory consists of an object 𝑐 ∈ 𝒞 , a theory 𝑇 ∈ 𝒟 sys , and a marking 𝑚 : 𝑐 → 𝑈 𝜋 𝒟( 𝑇 ) , which defines the generating interactions for the restricted systems theories.

Note that the transpose of a marking is the morphism tr ( 𝑚 ) : 𝐹𝑐 → 𝜋 𝒟( 𝑇 ) in 𝒟 inter .

We give several examples of restricted doctrines in Section 8.3. In the meantime, we focus on a restriction of the port-plugging doctrine in order to make sense of these definitions.

Example 8.6 (Systems theories in the port-plugging doctrine restricted along 𝒞 at →ℛ ex ) . In the portplugging doctrine the module of systems induced by the rex category Petri of Petri nets is over the double category of interactions C ospan ( Petri ) . In other words, Petri nets interact by gluing along any sub-Petri net. This formulation of interaction is too unrestricted. We may want - following the original work [BP17] - to have Petri nets interact by gluing along species .

We can restrict the port-plugging doctrine along the free rex category construction 𝐹 : 𝒞 at →ℛ ex . An example of a theory of this restricted systems theory consists of the terminal category · , the rex category Petri , and a marking 𝑚 : · → Petri which sends · to the Petri net with a single species. We will continue this example in Example 8.10.

Next we will define a functor from a restricted systems theory to right niches and then restrict to get a module of systems.

Lemma 8.7 (Restricted systems theories to right niches) . There is a cartesian 2-functor 𝒟 sys | 𝐹 →𝒩 iche 𝑟 that maps a restricted theory ( 𝑐 ∈ 𝒞 , 𝑇 ∈ 𝒟 sys , 𝑚 : 𝑐 → 𝑈 𝜋 𝒟( 𝑇 )) to the right niche and

![[Towards a double operadic theory of systems.assets/formula-0135.png]]

Proof. We begin by observing that the 𝐹 ⊢ 𝑈 adjunction defines an isomorphism

![[Towards a double operadic theory of systems.assets/formula-0136.png]]

where 𝐹 ↓ adm 𝜋 𝒟 is the sub-2-category of the colax slice 𝐹 ↓ colax 𝜋 𝒟 spanned by all objects and 1-cells which are sent to a companion commuter transformation under I .

Explicitly, the 1-cells of 𝐹 ↓ adm 𝜋 𝒟 are objects of the following pullback

![[Towards a double operadic theory of systems.assets/formula-0137.png]]

while the 2-category 𝐹 ↓ adm 𝜋 𝒟 is itself the pullback

![[Towards a double operadic theory of systems.assets/formula-0138.png]]

Thedesired map from restricted systems theory to right niches is induced by the following commutative diagram.

![[Towards a double operadic theory of systems.assets/figure-0079.png]]

0

0

where the map 𝐹 ↓ adm 𝜋 𝒟 → 𝒟 bl ·× 2 𝒞 at colax ( Δ [ 1 ] , 𝒟 bl ) comp is constant at the terminal pointed double category on the left and the composite of the forgetful 2-functors

![[Towards a double operadic theory of systems.assets/formula-0139.png]]

![[Towards a double operadic theory of systems.assets/formula-0140.png]]

defined by the pullbacks above.

![[Towards a double operadic theory of systems.assets/formula-0141.png]]

Definition 8.8 (Restriction of a doctrine to free interactions) . The restricted doctrine of the doctrine ( 𝜋 𝒟 : 𝒟 sys →𝒟 inter , S , I ) along the left adjoint 𝐹 : 𝒞 → 𝒟 inter is defined by the square where S | 𝐹 is the composite of the 2-functor defined in Lemma 8.7 and the restriction Res 𝑟 : 𝒩 iche 𝑟 → ℓ ℳ od r .

![[Towards a double operadic theory of systems.assets/figure-0080.png]]

Explication 8.9 (Restriction of a doctrine to free interactions) . Recall that a restricted systems theory is a triple ( 𝑐 ∈ 𝒞 , 𝑇 ∈ 𝒟 sys , 𝑚 : 𝑐 → 𝑈 𝜋 𝒟( 𝑇 )) . Under the restricted doctrine this systems theory produces a module of systems that is the restriction of the right niche presented in Lemma 8.7. This module essentially restricts the double category of interactions to those freely produced by the data 𝑐 ∈ 𝒞 and contains all systems and system maps whose interfaces and interface maps live in this restricted double category of interactions. The action of interactions on systems is the same as in the original doctrine.

Example 8.10 (The port-plugging doctrine restricted along 𝒞 at →ℛ ex ) . In Example 8.6, we saw that an example of a systems theory in the port plugging doctrine restricted along the free rex construction 𝒞 at →ℛ ex consists of the triple

![[Towards a double operadic theory of systems.assets/formula-0142.png]]

which sends · to the Petri net with a single species.

The free rex category of the terminal category is Finset . Therefore, in the restricted doctrine, this restricted theory produces a module of systems over the double category of interactions C ospan ( Finset ) which is the restriction of the right niche

![[Towards a double operadic theory of systems.assets/figure-0081.png]]

where C ospan ( Finset ) → C ospan ( Petri ) is induced by interpretting finite sets as discrete Petri nets with no transitions.

In this module of systems:

- An interface is a finite set.
- A system with interface 𝑀 consists of a Petri net 𝑃 and a map from 𝑀 to the species of 𝑃 . Note that this map is equivalent to a map of Petri nets from the Petri net with 𝑀 species and no transitions to 𝑃 .
- An interaction is a cospan of finite sets.
- Interactions act on Petri nets by gluing along species identified in the interaction.

This is exactly the data of the hypergraph double category of Petri nets defined in [BM20]. We illustrated this module of systems in Section 4.2.1.

## 8.3 Examples of restricting doctrines

In this section, we construct the systems theories defined in Section 4.2 and others, using the machinery built up in Section 5, Section 6, Section 7, and Section 8.1.

Example 8.11 (Examples of the port-plugging doctrine restricted along 𝒞 at →ℛ ex ) . Let 𝐹 : 𝒞 at →ℛ ex be the left-adjoint that maps a category to its free rex category. Following [FS18c], which gives an equivalence between hypergraph categories (with symmetric monoidal structure free on objects) and algebras over operads of cospans, we may think of a module of systems over C ospan ( 𝐹 C ) as a hypergraph double category . Systems theories in the port-plugging doctrine restricted along the left adjoint 𝒞 at → ℛ ex produce modules of systems of this form.

In Example 8.10 we gave an example of a systems theory in the restricted port-plugging doctrine that marked Petri nets by their places. We then saw how the module of systems produced by this marking consists open Petri nets that glue along their places. Here we will give several other examples of systems theories in this restricted doctrine and describe the module of systems that they define.

- Directed graphs with edge-labels in a set 𝐿 (including, for example, circuit diagrams as in Fong's thesis [Fon16]) may be expressed as the slice category Graph ↓ 𝐵𝐿 where 𝐵𝐿 is the graph with a single node and edge set 𝐿 ; as a slice category of a presheaf category, this is a rex category. There is a systems theory in the restricted port-plugging doctrine that consists of the terminal category · , the rex category of directed labeled graphs Graph ↓ 𝐵𝐿 , and the marking · → Graph ↓ 𝐵𝐿 that selects the graph with a single vertex with its unique trivial edge-labelling. This systems theory produces a a module of labelled graphs over the double category C ospan ( Finset ) of cospans of finite sets. This module of systems is equivalent to the hypergraph double category of labelled graphs whose objects and loose morphisms form the hypergraph category of labelled graphs, per [FS18c] and whose tight morphisms account for label-preserving graph homomorphisms.
- Similar to marking Petri nets by places and labeled graphs by vertices, we can form hypeter graph double category of causal loop diagrams by marking objects.
- In Section 3.5 of [Bae+23], the authors describe a schema for stock-flow diagrams and a restricted schema for their interfaces (see also [Bae+22]). A full-fledged stock-flow diagram is a presheaf on the schema for stock-flow diagrams along with an auxiliary function. There is a systems theory which consists of the free category on the graph

· ← · → ·

,

the rex category of full-fledged stock-flow diagrams, and a marking which selects the representable stock-flow diagrams defined by the interface schema. This systems theory defines a module of full-fledged stock-flow diagrams over cospans of presheaves on this restricted interface that recovers the compositionality of full-fledged stock-flow diagrams in [Bae+23].

Remark 8.12 (The operadic approach to systems defined as structured cospans) . Many of the module of systems defined in Example 8.11 are a direct repackaging of symmetric monoidal double categories of structured cospans. In his thesis [Cou20], Courser proves that given a category C with pushouts and a functor 𝐿 : I → C , there is a symmetric monoidal double category of structured cospans 𝐿 C ospan ( C ) whose objects are the objects in I and where a loose morphism is a structured cospan 𝐿𝑖 → 𝑠 ← 𝐿𝑗 .

In many examples, these structured cospans represent open systems which interact only via the monoidal product (the trivial parallel product interaction) or via composition (series interaction) in 𝐿 C ospan ( C ) . For example, systems 𝐿𝑖 → 𝑠 ← 𝐿𝑗 and 𝐿𝑖 ′ → 𝑠 ′ ← 𝐿𝑗 ′ can only interact non-trivially if 𝑗 = 𝑖 ′ in which they may be composed in series to produce the system 𝐿𝑖 → 𝑠 + 𝐿𝑗 𝑠 ′ ← 𝐿 ′ 𝑗 . Or conversely if 𝑖 = 𝑗 ′ in which case they may be composed in series in the opposite order.

Since non-trivial interactions are limited to composition and composition depends on the interface of systems, this framework leads one to the practice of designing a system's interface with a particular interaction in mind. As an example, consider the diagram on page 2 of [BM20] where the place 𝐸 of a Petri net is double labeled (that is, we have interface 𝑖 = { 4 , 5 } and map 𝐿𝑖 → 𝑠 sending both 4 and 5 to the stock 𝐸 ∈ 𝑠 ) so that it can compose with two different places 𝐶 and 𝐷 of another Petri net.

By contrast, the operadic approach taken in modules of systems allows one to design the interface up-front for many potential interactions. This feature is critical for best practices in modular design.

We can repackage the data of a symmetric monoidal double category of structured cospans in to a module of systems, thereby applying an operadic approach to systems defined as structured cospans. A rex category C and a functor 𝐿 : I → C is a systems theory in the restricted port-plugging doctrine. It produces a module of systems in which

- A system is a cospan ∅ → 𝑠 ← 𝐿𝑖 in C which is equivalent to a morphism 𝐿𝑖 → 𝑠 in C .
- An interaction is a cospan in I .

Component systems 𝐿𝑖 → 𝑠 and 𝐿𝑖 ′ → 𝑠 ′ interacting via the cospan 𝑖 + 𝑖 ′ → 𝑚 ← 𝑗 defines the composite system 𝐿𝑗 →( 𝐿𝑚 ) + 𝐿𝑖 + 𝐿𝑖 ′ ( 𝑠 + 𝑠 ′ ) .

![[Towards a double operadic theory of systems.assets/figure-0082.png]]

In this operadic point of view, which we take from Fong and Spivak's Hypergraph Categories [FS18c], the systems have their boundaries set up front and they remain valid for all compositions down the line. Changes in system boundary can happen though specific interactions (for example, an interaction whose left leg is the identity will re-label the boundary without any gluing), rather than being a meta-theoretic operation performed to prepare a system for a particular interaction.

We can also adjust the double category of interactions for such modules of systems.

For example, we can assume that the right leg of each interaction is a monomorphism -disallowing double labelling entirely - with no loss of expressability for composition, since all the gluing happens along the left leg of the interaction.

As a second example, we could expand the double category of interactions to include all structured cospans 𝐿𝑖 → 𝑡 ← 𝐿𝑘 . We can interpret these structured cospans as processes by which systems may interact. Such a process may arise by partial interaction. For example, consider how the interaction 𝑖 + 𝑖 ′ → 𝑚 ← 𝑗 acts on the system 𝐿𝑖 → 𝑠 and the trivial system 𝐿𝑖 ′ → 𝐿𝑖 ′ . It produces a composite system 𝐿𝑗 → 𝑡 where 𝑡 = ( 𝐿𝑚 + 𝐿𝑖 𝑠 ) + 𝐿𝑖 ′ .

![[Towards a double operadic theory of systems.assets/figure-0083.png]]

We may interpret the cospan 𝐿𝑖 ′ → 𝑡 ← 𝐿𝑗 as an interaction that acts on a system with interface 𝑖 ′ by the composing it with the system 𝐿𝑖 → 𝑠 along the interaction 𝑖 + 𝑖 ′ → 𝑚 ← 𝑗 . This idea draws from the Katis-Sabadini-Walters line of thought, considering symmetric monoidal double (or bi-)categories to be process theories [KSW97].

Example 8.13 (Graphical regular logic in the restricted variable sharing doctrine) . Similar to the examples in Example 8.11, we can restrict the variable sharing doctrine along the left adjoint 𝐹 : 𝒞 at →ℒ ex that maps a category to its free lex category. Here we give an example a systems theory in this restricted theory that produces a module of system specifications that packages the data of a graphical regular logic [FS18b].

Let C be a lex category and let 𝑃 : C op → Cat be a regular hyperdoctrine. Its Grothendieck construction ∫ 𝑃 is a lex category. Let 𝑆 ⊆ ob 𝐶 be a set of sorts . There is a systems theory in the restricted variable sharing doctrine that consists of the discrete category on 𝑆 , the lex category ∫ 𝑃 , and the marking that maps the object 𝑐 ∈ 𝑆 to the object ( 𝑐, ⊤) ∈ ∫ 𝑃 where ⊤ is the limit of the empty set in 𝑃𝑐 . We denote this marking 𝐿𝑆 : 𝑆 ↩ → ∫ 𝑃 .

This systems theory produces the module of systems

![[Towards a double operadic theory of systems.assets/formula-0143.png]]

which is the module of 𝑃 -predicates over the double category of interfaces C ospan ( Finset ↓ 𝑆 ) . Since the cospans which form the interactions of C ospan ( Finset ↓ 𝑆 ) are undirected wiring diagrams (as discussed in Example 8.2), we recover a form of graphical regular logic [FS18b].

Example 8.14 (Restricting to double categories of directed wiring diagrams) . In [Spi13] Spivak constructs an operad of directed wiring diagrams and shows that ODEs form an algebra over this operad. We exemplified in Section 7.4 a module of ODEs over double categories of lenses, and in Example 8.3 we observed that lenses in free cartesian categories are directed wiring diagrams. We can recover this observation by marking they systems theory Euc of Example 7.30 by R 1 : 1 → Euc with the real numbers; the resulting module of systems consists of systems of ordinary differential equations that interact via directed wiring diagrams. This observation extends to all the lens-based systems, giving us modules of Moore machines, POMDPs, and so on over double categories of directed wiring diagrams.

## References

- [ABK24] Nathanael Arkor, John Bourke, and Joanna Ko. Enhanced 2-categorical structures, twodimensional limit sketches and the symmetry of internalisation . 2024. doi: 10.48550/ARXIV. 2412.07475 . url: https://arxiv.org/abs/2412.07475 .
- [AMT25] Aaron D. Ames, Joe Moeller, and Paulo Tabuada. Categorical Lyapunov Theory I: Stability of Flows . 2025. doi: 10.48550/ARXIV.2502.15276 . url: https://arxiv.org/abs/2502.15276 .
- [Bae+22] John C. Baez, Xiaoyan Li, Sophie Libkind, Nathaniel D. Osgood, and Eric Redekopp. 'A Categorical Framework for Modeling with Stock and Flow Diagrams'. In: (2022). doi: 10.48550/ARXIV.2211.01290 . url: https://arxiv.org/abs/2211.01290 .
- [Bae+23] John Baez, Xiaoyan Li, Sophie Libkind, Nathaniel D. Osgood, and Evan Patterson. 'Compositional Modeling with Stock and Flow Diagrams'. In: Electronic Proceedings in Theoretical Computer Science 380 (Aug. 2023), pp. 77-96. issn: 2075-2180. doi: 10.4204/eptcs.380.5 . url: http://dx.doi.org/10.4204/EPTCS.380.5 .
- [BC17] John C. Baez and Kenny Courser. 'Coarse-Graining Open Markov Processes'. In: (2017). doi: 10.48550/ARXIV.1710.11343 . url: https://arxiv.org/abs/1710.11343 .
- [BCLJ25] Jason Brown, Kevin Carlson, Sophie Libkind, and David Jaz Myers. Loose bimodules as double barrels (in preparation) . 2025. url: https://forest.topos.site/ssl-0030 .
- [BCR17] John C. Baez, Brandon Coya, and Franciscus Rebro. 'Props in Network Theory'. In: (2017). doi: 10.48550/ARXIV.1707.08321 . url: https://arxiv.org/abs/1707.08321 .
- [BCV22a] John C. Baez, Kenny Courser, and Christina Vasilakopoulou. 'Structured versus Decorated Cospans'. In: Compositionality 4 (Sept. 2022), p. 3. issn: 2631-4444. doi: 10.32408/ compositionality-4-3 . url: http://dx.doi.org/10.32408/compositionality-4-3 .
- [BCV22b] John C. Baez, Kenny Courser, and Christina Vasilakopoulou. 'Structured versus Decorated Cospans'. In: Compositionality 4 (Sept. 2022), p. 3. issn: 2631-4444. doi: 10.32408/ compositionality-4-3 . url: http://dx.doi.org/10.32408/compositionality-4-3 .

- [BE14] John C. Baez and Jason Erbele. 'Categories in Control'. In: (2014). doi: 10.48550/ARXIV. 1405.6881 . url: https://arxiv.org/abs/1405.6881 .
- [BF15] John C. Baez and Brendan Fong. 'A Compositional Framework for Passive Linear Networks'. In: (2015). doi: 10.48550/ARXIV.1504.05625 . url: https://arxiv.org/abs/1504.05625 .
- [BF21] John C Baez and John D Foley. 'Keystones'. In: Notices of the American Mathematical Society 68.06 (June 2021), p. 1. issn: 1088-9477. doi: 10.1090/noti2295 . url: http://dx.doi.org/ 10.1090/noti2295 .
- [BFMP17] John C. Baez, John Foley, Joe Moeller, and Blake S. Pollard. 'Network Models'. In: (2017). doi: 10.48550/ARXIV.1711.00037 . url: https://arxiv.org/abs/1711.00037 .
- [BFP16] John C. Baez, Brendan Fong, and Blake S. Pollard. 'A compositional framework for Markov processes'. In: Journal of Mathematical Physics 57.3 (Mar. 2016). issn: 1089-7658. doi: 10.1063/ 1.4941578 . url: http://dx.doi.org/10.1063/1.4941578 .
- [BLLL23] Guido Boccali, Andrea Laretto, Fosco Loregian, and Stefano Luneia. 'Bicategories of Automata, Automata in Bicategories'. In: Electronic Proceedings in Theoretical Computer Science 397 (Dec. 2023), pp. 1-19. issn: 2075-2180. doi: 10.4204/eptcs.397.1 . url: http: //dx.doi.org/10.4204/EPTCS.397.1 .
- [BM20] John C. Baez and Jade Master. 'Open Petri nets'. In: Mathematical Structures in Computer Science 30.3 (Mar. 2020), pp. 314-341. issn: 1469-8072. doi: 10.1017/s0960129520000043 . url: http://dx.doi.org/10.1017/S0960129520000043 .
- [BP17] John C. Baez and Blake S. Pollard. 'A compositional framework for reaction networks'. In: Reviews in Mathematical Physics 29.09 (Sept. 2017), p. 1750028. issn: 1793-6659. doi: 10.1142/s0129055x17500283 . url: http://dx.doi.org/10.1142/S0129055X17500283 .
- [BPSM20] Spencer Breiner, Blake Pollard, Eswaran Subrahmanian, and Olivier Marie-Rose. 'Modeling Hierarchical System with Operads'. In: Electronic Proceedings in Theoretical Computer Science 323 (Sept. 2020), pp. 72-83. issn: 2075-2180. doi: 10.4204/eptcs.323.5 . url: http: //dx.doi.org/10.4204/EPTCS.323.5 .
- [BS10] J. Baez and M. Stay. 'Physics, Topology, Logic and Computation: A Rosetta Stone'. In: New Structures for Physics . Springer Berlin Heidelberg, 2010, pp. 95-172. isbn: 9783642128219. doi: 10.1007/978-3-642-12821-9\_2 . url: http://dx.doi.org/10.1007/978-3-642-12821-9\_2 .
- [BWY21] John C. Baez, David Weisbart, and Adam M. Yassine. 'Open systems in classical mechanics'. In: Journal of Mathematical Physics 62.4 (Apr. 2021). issn: 1089-7658. doi: 10.1063/5.0029885 . url: http://dx.doi.org/10.1063/5.0029885 .
- [CC13] J. R. B. Cockett and G. S. H. Cruttwell. 'Differential Structure, Tangent Structure, and SDG'. In: Applied Categorical Structures 22.2 (May 2013), pp. 331-417. issn: 1572-9095. doi: 10.1007/s10485-013-9312-0 . url: http://dx.doi.org/10.1007/s10485-013-9312-0 .
- [CCGZ24] Matteo Capucci, Geoffrey S. H. Cruttwell, Neil Ghani, and Fabio Zanasi. A Fibrational Theory of First Order Differential Structures . 2024. doi: 10.48550/ARXIV.2409.05763 . url: https://arxiv.org/abs/2409.05763 .
- [CCL19] J. R. B. Cockett, G. S. H. Cruttwell, and J. -S. P . Lemay. Differential equations in a tangent category I: Complete vector fields, flows, and exponentials . 2019. doi: 10.48550/ARXIV.1911.12120 . url: https://arxiv.org/abs/1911.12120 .
- [CFS16] Bob Coecke, Tobias Fritz, and Robert W. Spekkens. 'A mathematical theory of resources'. In: Information and Computation 250 (Oct. 2016), pp. 59-86. issn: 0890-5401. doi: 10.1016/j. ic.2016.02.008 . url: http://dx.doi.org/10.1016/j.ic.2016.02.008 .

- [CGHR22] Matteo Capucci, Bruno Gavranović, Jules Hedges, and Eigil Fjeldgren Rischel. 'Towards Foundations of Categorical Cybernetics'. In: Electronic Proceedings in Theoretical Computer Science 372 (Nov. 2022), pp. 235-248. issn: 2075-2180. doi: 10.4204/eptcs.372.17 . url: http://dx.doi.org/10.4204/EPTCS.372.17 .
- [Cir13] Corina Cirstea. 'From Branching to Linear Time, Coalgebraically'. In: Electronic Proceedings in Theoretical Computer Science 126 (Aug. 2013), pp. 11-27. issn: 2075-2180. doi: 10.4204/ eptcs.126.2 . url: http://dx.doi.org/10.4204/EPTCS.126.2 .
- [Cou20] Kenny Courser. Open Systems: A Double Categorical Perspective . 2020. doi: 10.48550/ARXIV. 2008.02394 . url: https://arxiv.org/abs/2008.02394 .
- [Di +20] Elena Di Lavore, Alessandro Gianola, Mario Román, Nicoletta Sabadini, and Paweł Sobociński. Span(Graph): a Canonical Feedback Algebra of Open Transition Systems . 2020. doi: 10.48550/ARXIV.2010.10069 . url: https://arxiv.org/abs/2010.10069 .
- [DL25] Keri D'Angelo and Sophie Libkind. Dependent Directed Wiring Diagrams for Composing Instantaneous Systems . 2025. doi: 10.48550/ARXIV.2503.05457 . url: https://arxiv.org/ abs/2503.05457 .
- [DPP10] Robert Dawson, Robert Pare, and Dorette Pronk. 'the span construction'. In: Theory and Applications of Categories 24.13 (2010), pp. 302-377. url: http://www.tac.mta.ca/tac/ volumes/24/13/24-13abs.html .
- [Dub79] Eduardo J. Dubuc. 'Sur les modèles de la géométrie différentielle synthétique'. fr. In: Cahiers de topologie et géométrie différentielle 20.3 (1979), pp. 231-279. url: https://www.numdam.org/ item/CTGDC\_1979\_\_20\_3\_231\_0/ .
- [FBSD21] John D. Foley, Spencer Breiner, Eswaran Subrahmanian, and John M. Dusel. 'Operads for complex system design specification, analysis and synthesis'. In: Proceedings of the Royal Society A: Mathematical, Physical and Engineering Sciences 477.2250 (June 2021). issn: 1471-2946. doi: 10.1098/rspa.2021.0099 . url: http://dx.doi.org/10.1098/rspa.2021.0099 .
- [Fon16] Brendan Fong. The Algebra of Open and Interconnected Systems . 2016. doi: 10.48550/ARXIV. 1609.05382 . url: https://arxiv.org/abs/1609.05382 .
- [FPR21] Tobias Fritz, Paolo Perrone, and Sharwin Rezagholi. 'Probability, valuations, hyperspace: Three monads on top and the support as a morphism'. In: Mathematical Structures in Computer Science 31.8 (Sept. 2021), pp. 850-897. issn: 1469-8072. doi: 10.1017/s0960129521000414 . url: http://dx.doi.org/10.1017/S0960129521000414 .
- [Fri09] Tobias Fritz. Convex Spaces I: Definition and Examples . 2009. doi: 10.48550/ARXIV.0903.5522 . url: https://arxiv.org/abs/0903.5522 .
- [Fri20] Tobias Fritz. 'A synthetic approach to Markov kernels, conditional independence and theorems on sufficient statistics'. In: Advances in Mathematics 370 (Aug. 2020), p. 107239. issn: 0001-8708. doi: 10.1016/j.aim.2020.107239 . url: http://dx.doi.org/10.1016/j.aim. 2020.107239 .
- [FS18a] Brendan Fong and Maru Sarazola. 'A recipe for black box functors'. In: (2018). doi: 10.48550/ARXIV.1812.03601 . url: https://arxiv.org/abs/1812.03601 .
- [FS18b] Brendan Fong and David I Spivak. Graphical Regular Logic . 2018. doi: 10.48550/ARXIV.1812. 05765 . url: https://arxiv.org/abs/1812.05765 .
- [FS18c] Brendan Fong and David I Spivak. Hypergraph Categories . 2018. doi: 10.48550/ARXIV.1806. 08304 . url: https://arxiv.org/abs/1806.08304 .
- [GH15] David Gepner and Rune Haugseng. 'Enriched ∞ -categories via non-symmetric ∞ -operads'. In: Advances in Mathematics 279 (July 2015), pp. 575-716. issn: 0001-8708. doi: 10.1016/j.aim. 2015.02.007 . url: http://dx.doi.org/10.1016/j.aim.2015.02.007 .

- [GHL99] Fabio Gadducci, Reiko Heckel, and Mercé Llabrés. 'A Bi-Categorical Axiomatisation of Concurrent Graph Rewriting'. In: Electronic Notes in Theoretical Computer Science 29 (1999), pp. 80-100. issn: 1571-0661. doi: 10.1016/s1571-0661(05)80309-3 . url: http: //dx.doi.org/10.1016/S1571-0661(05)80309-3 .
- [Gir82] Michèle Giry. 'A categorical approach to probability theory'. In: Categorical Aspects of Topology and Analysis . Springer Berlin Heidelberg, 1982, pp. 68-85. isbn: 9783540390411. doi: 10.1007/bfb0092872 . url: http://dx.doi.org/10.1007/BFb0092872 .
- [Gra19] Marco Grandis. Higher Dimensional Categories: From Double to Multiple Categories . WORLD SCIENTIFIC, Sept. 2019. isbn: 9789811205101. doi: 10.1142/11406 . url: http://dx.doi. org/10.1142/11406 .
- [GS23] Grigorios Giotopoulos and Hisham Sati. Field Theory via Higher Geometry I: Smooth Sets of Fields . 2023. doi: 10.48550/ARXIV.2312.16301 . url: https://arxiv.org/abs/2312.16301 .
- [HHLN20] Rune Haugseng, Fabian Hebestreit, Sil Linskens, and Joost Nuiten. Two-variable fibrations, factorisation systems and ∞ -categories of spans . 2020. doi: 10.48550/ARXIV.2011.11042 . url: https://arxiv.org/abs/2011.11042 .
- [HKSY17] Chris Heunen, Ohad Kammar, Sam Staton, and Hongseok Yang. 'A convenient category for higher-order probability theory'. In: 2017 32nd Annual ACM/IEEE Symposium on Logic in Computer Science (LICS) . IEEE, June 2017, pp. 1-12. doi: 10.1109/lics.2017.8005137 . url: http://dx.doi.org/10.1109/LICS.2017.8005137 .
- [Jaz21] David Jaz Myers. 'Double Categories of Open Dynamical Systems (Extended Abstract)'. In: Electronic Proceedings in Theoretical Computer Science 333 (Feb. 2021), pp. 154-167. issn: 2075-2180. doi: 10.4204/eptcs.333.11 . url: http://dx.doi.org/10.4204/EPTCS.333.11 .
- [JY20] Niles Johnson and Donald Yau. 2-Dimensional Categories . 2020. doi: 10.48550/ARXIV.2002. 06055 . url: https://arxiv.org/abs/2002.06055 .
- [Kei08] Klaus Keimel. 'The monad of probability measures over compact ordered spaces and its Eilenberg-Moore algebras'. In: Topology and its Applications 156.2 (Dec. 2008), pp. 227-239. issn: 0166-8641. doi: 10.1016/j.topol.2008.07.002 . url: http://dx.doi.org/10.1016/j. topol.2008.07.002 .
- [KSW97] P. Katis, N. Sabadini, and R.F.C. Walters. 'Bicategories of processes'. In: Journal of Pure and Applied Algebra 115.2 (1997), pp. 141-178. issn: 0022-4049. doi: https://doi.org/10.1016/ S0022-4049(96)00012-6 . url: https://www.sciencedirect.com/science/article/pii/ S0022404996000126 .
- [Kur01] Alexander Kurz. 'Coalgebras and Modal Logic'. In: (2001). Lecture Notes from ESSLLI 2001. url: https://alexhkurz.github.io/papers/cml.pdf .
- [Lac05] Stephen Lack. 'Limits for Lax Morphisms'. In: Applied Categorical Structures 13.3 (June 2005), pp. 189-203. issn: 1572-9095. doi: 10.1007/s10485-005-2958-5 . url: http://dx.doi.org/ 10.1007/s10485-005-2958-5 .
- [Lac09] Stephen Lack. 'A 2-Categories Companion'. In: Towards Higher Categories . Springer New York, Sept. 2009, pp. 105-191. isbn: 9781441915245. doi: 10.1007/978-1-4419-1524-5\_4 . url: http://dx.doi.org/10.1007/978-1-4419-1524-5\_4 .
- [Lan25] Marcello Lanfranchi. The formal theory of tangentads I . 2025. doi: 10.48550/ARXIV.2503.18354 . url: https://arxiv.org/abs/2503.18354 .
- [LBPF22] Sophie Libkind, Andrew Baas, Evan Patterson, and James Fairbanks. 'Operadic Modeling of Dynamical Systems: Mathematics and Computation'. In: Electronic Proceedings in Theoretical Computer Science 372 (Nov. 2022), pp. 192-206. issn: 2075-2180. doi: 10.4204/eptcs.372.14 . url: http://dx.doi.org/10.4204/EPTCS.372.14 .

- [Lei04] Tom Leinster. Higher Operads, Higher Categories . Cambridge University Press, July 2004. isbn: 9780511525896. doi: 10.1017/cbo9780511525896 . url: http://dx.doi.org/10.1017/ CBO9780511525896 .
- [Leu17] Poon Leung. 'Classifying tangent structures using Weil algebras'. In: Theory and Applications of Categories 32.9 (Feb. 2017), pp. 286-337. url: http://www.tac.mta.ca/tac/volumes/32/ 9/32-09abs.html .
- [Lib+22] Sophie Libkind, Andrew Baas, Micah Halter, Evan Patterson, and James P. Fairbanks. 'An algebraic framework for structured epidemic modelling'. In: Philosophical Transactions of the Royal Society A: Mathematical, Physical and Engineering Sciences 380.2233 (Aug. 2022). issn: 14712962. doi: 10.1098/rsta.2021.0309 . url: http://dx.doi.org/10.1098/rsta.2021.0309 .
- [Lor25] Fosco Loregian. Monads and limits in bicategories of circuits . 2025. doi: 10.48550/ARXIV.2501. 01882 . url: https://arxiv.org/abs/2501.01882 .
- [LP24] Michael Lambert and Evan Patterson. 'Cartesian double theories: A double-categorical framework for categorical doctrines'. In: Advances in Mathematics 444 (May 2024), p. 109630. issn: 0001-8708. doi: 10.1016/j.aim.2024.109630 . url: http://dx.doi.org/10.1016/j. aim.2024.109630 .
- [LS12] Stephen Lack and Michael Shulman. 'Enhanced 2-categories and limits for lax morphisms'. In: Advances in Mathematics 229.1 (Jan. 2012), pp. 294-356. issn: 0001-8708. doi: 10.1016/j. aim.2011.08.014 . url: http://dx.doi.org/10.1016/j.aim.2011.08.014 .
- [Mas21] Jade Master. Composing Behaviors of Networks . 2021. doi: 10.48550/ARXIV.2105.12905 . url: https://arxiv.org/abs/2105.12905 .
- [Mye20] David Jaz Myers. Cartesian Factorization Systems and Grothendieck Fibrations . 2020. doi: 10. 48550/ARXIV.2006.14022 . url: https://arxiv.org/abs/2006.14022 .
- [Mye21] David Jaz Myers. Categorical Systems Theory . 2021. url: http://davidjaz.com/Papers/ DynamicalBook.pdf .
- [Ngo17] Timothy Ngotiaoco. Compositionality of the Runge-Kutta Method . 2017. doi: 10.48550/ARXIV. 1707.02804 . url: https://arxiv.org/abs/1707.02804 .
- [Par23] Robert Paré. Retrocells . 2023. doi: 10.48550/ARXIV.2306.06436 . url: https://arxiv.org/ abs/2306.06436 .
- [Rut00] J.J.M.M. Rutten. 'Universal coalgebra: a theory of systems'. In: Theoretical Computer Science 249.1 (Oct. 2000), pp. 3-80. issn: 0304-3975. doi: 10.1016/s0304-3975(00)00056-6 . url: http://dx.doi.org/10.1016/S0304-3975(00)00056-6 .
- [Sch] Urs Schreiber. 'Differential Cohomology in a Cohesive Infinity Topos (version 2)'. In: (). url: https://ncatlab.org/schreiber/files/dcct170811.pdf .
- [Spi13] David I. Spivak. The operad of wiring diagrams: formalizing a graphical language for databases, recursion, and plug-and-play circuits . 2013. doi: 10.48550/ARXIV.1305.0297 . url: https: //arxiv.org/abs/1305.0297 .
- [Spi15] David I. Spivak. The steady states of coupled dynamical systems compose according to matrix arithmetic . 2015. doi: 10.48550/ARXIV.1512.00802 . url: https://arxiv.org/abs/1512. 00802 .
- [Spi19] David I. Spivak. Generalized Lens Categories via functors 𝒞 op → Cat . 2019. doi: 10.48550/ ARXIV.1908.02202 . url: https://arxiv.org/abs/1908.02202 .
- [SSV19] Patrick Schultz, David I. Spivak, and Christina Vasilakopoulou. 'Dynamical Systems and Sheaves'. In: Applied Categorical Structures 28.1 (Apr. 2019), pp. 1-57. issn: 1572-9095. doi: 10.1007/s10485-019-09565-x . url: http://dx.doi.org/10.1007/s10485-019-09565-x .

- [SSWC25] John H. Selby, Maria E. Stasinou, Matt Wilson, and Bob Coecke. Generalised Process Theories . 2025. doi: 10.48550/ARXIV.2502.10368 . url: https://arxiv.org/abs/2502.10368 .
- [VSL14] Dmitry Vagner, David I. Spivak, and Eugene Lerman. Algebras of Open Dynamical Systems on the Operad of Wiring Diagrams . 2014. doi: 10.48550/ARXIV.1408.1598 . url: https: //arxiv.org/abs/1408.1598 .
- [Wei09] Alan Weinstein. Symplectic Categories . 2009. doi: 10.48550/ARXIV.0911.4133 . url: https: //arxiv.org/abs/0911.4133 .
- [Wil07] Jan Willems. 'The Behavioral Approach to Open and Interconnected Systems'. In: IEEE Control Systems 27.6 (Dec. 2007), pp. 46-99. issn: 1941-000X. doi: 10.1109/mcs.2007.906923 . url: http://dx.doi.org/10.1109/MCS.2007.906923 .
- [Yau18] Donald Yau. Operads of Wiring Diagrams . Springer International Publishing, 2018. isbn: 9783319950013. doi: 10.1007/978-3-319-95001-3 . url: http://dx.doi.org/10.1007/9783-319-95001-3 .
