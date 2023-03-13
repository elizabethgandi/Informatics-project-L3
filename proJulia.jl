using Printf, Crayons
using REPL.TerminalMenus
using DataStructures

include("plotRun.jl")

function loadImg(fname)

    f=open(fname)
    readline(f) # lit la premiere ligne du code
    b, m1 = split(readline(f), " ") # lit la seconde -> readline, separe les deux chaines -> split
    a, n1 = split(readline(f), " ")
    readline(f)
    
    m = parse(Int, m1) # parse transforme les chaines en int (dans notre cas)
    n = parse(Int, n1)
    
    A =  Matrix{Char}(undef, m, n) 
    
    for i in 1:m
        A[i,:] = collect(readline(f)) # :-> obtient tous les elements de la ligne i et collect-> itere chaque elements de la chaine de caracteres
    end
    
    close(f)
    return A
    
end

function appartient(T::Tuple{Int64,Int64}, A::Matrix{Char})
    mL, nC = size(A)
    
    if (T[1] >=1 && T[1] <= mL && T[2]>=1 && T[2] <= nC) 
        return true 
    else 
        return false
    end
end


function dijkstra(A::Matrix{Char}, pointDepart::Tuple{Int64,Int64}, pointArrivee::Tuple{Int64,Int64})
    m, n = size(A)
    
    matriceOriginelle = fill((-1,-1), (m, n))
    matriceNumerique  = zeros(Int, m, n)

    trouve::Bool = false
    listeFinale = Queue{Tuple{Int64,Int64}}()
    valeurChemin::Int64 = 0

    h = BinaryMinHeap{Tuple{Int64, Tuple{Int64, Int64}}}()
    push!(h, (0,pointDepart)) 

    matriceOriginelle[pointDepart[1],pointDepart[2]] = (0,0)

    coutMvt::Int64 = 0

    while  (trouve == false) 

        inutile, pointCourant = pop!(h) 

        if (pointCourant == pointArrivee) 
            trouve = true
        else

            N = (pointCourant[1]-1,pointCourant[2])
            E = (pointCourant[1],pointCourant[2]+1)
            S = (pointCourant[1]+ 1,pointCourant[2])
            O = (pointCourant[1],pointCourant[2]-1)
       
            if ( appartient(N, A) == true )
               if (A[N[1],N[2]] != '@' && A[N[1],N[2]] != 'T' && matriceOriginelle[N[1],N[2]] == (-1,-1))
                    if (A[N[1],N[2]] == 'S')
                        coutMvt = 5
                    elseif (A[N[1],N[2]] == 'W')
                        coutMvt = 8
                    else
                        coutMvt = 1
                    end
                    matriceOriginelle[N[1],N[2]] = (pointCourant[1],pointCourant[2])
                    matriceNumerique[N[1],N[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] + coutMvt
                    push!(h, (matriceNumerique[N[1],N[2]], N))
                end
            end
         
            if ( appartient(E, A) == true )
                if ( A[E[1],E[2]] != '@' && A[E[1],E[2]] != 'T' && matriceOriginelle[E[1],E[2]] == (-1,-1))
                    if (A[E[1],E[2]] == 'S')
                        coutMvt = 5
                    elseif ( A[E[1],E[2]] == 'W')
                        coutMvt = 8
                    else
                        coutMvt = 1
                    end
                    matriceOriginelle[E[1],E[2]] = (pointCourant[1],pointCourant[2])
                    matriceNumerique[E[1],E[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] + coutMvt
                    push!(h, (matriceNumerique[E[1],E[2]], E)) 
                end
            end
        
            if ( appartient(S, A) == true )
                if ( A[S[1],S[2]] != '@' && A[S[1],S[2]] != 'T' && matriceOriginelle[S[1],S[2]] == (-1,-1))
                    if ( A[S[1],S[2]] == 'S' )
                        coutMvt = 5
                    elseif ( A[S[1],S[2]] == 'W')
                        coutMvt = 8
                    else
                        coutMvt = 1
                    end
                    matriceOriginelle[S[1],S[2]] = (pointCourant[1],pointCourant[2])
                    matriceNumerique[S[1],S[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] + coutMvt
                    push!(h, (matriceNumerique[S[1],S[2]], S))
                end
            end
        
            if ( appartient(O, A) == true )
                if ( A[O[1],O[2]] != '@' && A[O[1],O[2]] != 'T' && matriceOriginelle[O[1],O[2]] == (-1,-1))
                    if (A[O[1],O[2]] == 'S')
                        coutMvt = 5
                    elseif ( A[S[1],S[2]] == 'W')
                        coutMvt = 8
                    else
                        coutMvt = 1
                    end
                    matriceOriginelle[O[1],O[2]] = (pointCourant[1],pointCourant[2])
                    matriceNumerique[O[1],O[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] + coutMvt
                    push!(h, (matriceNumerique[O[1],O[2]], O))
                end
            end
        end
    end
    
    resEtatsVisites =  calculEtatsVisites(matriceNumerique)

    pC = matriceOriginelle[pointArrivee[1],pointArrivee[2]]
    A[pC[1],pC[2]] = 'P'

    if (trouve == true)
        listeFinale  = enqueue!(listeFinale, (pointArrivee[1],pointArrivee[2]))

        while  pC != pointDepart
            listeFinale  = enqueue!(listeFinale, pC)
            pC = matriceOriginelle[pC[1],pC[2]]
            A[pC[1],pC[2]] = 'P'
        end
        A[pC[1],pC[2]] = 'D'
        valeurChemin = matriceNumerique[pointArrivee[1],pointArrivee[2]]

    else
        listeFinale = (0,0)
    end

    A[pointArrivee[1],pointArrivee[2]] = 'A'
    showMapChar(A,true)
    return matriceOriginelle, valeurChemin, listeFinale, resEtatsVisites
    

end

function calculHeuristique(pointDepart::Tuple{Int64,Int64}, pointArrivee::Tuple{Int64,Int64})
    
    xA = pointDepart[1]
    yA = pointDepart[2]
    xB = pointArrivee[1]
    yB = pointArrivee[2]

    heuristique = abs(xA-xB) + abs(yA-yB)

    return heuristique
end

function a(A::Matrix{Char}, pointDepart::Tuple{Int64,Int64}, pointArrivee::Tuple{Int64,Int64})
    m, n = size(A)
    
    matriceOriginelle = fill((-1,-1), (m, n))
    matriceNumerique  = zeros(Int, m, n)

    trouve::Bool = false
    listeFinale = Queue{Tuple{Int64,Int64}}()
    valeurChemin::Int64 = 0

    heuristique = calculHeuristique(pointDepart,pointArrivee)

    h = BinaryMinHeap{Tuple{Int64, Tuple{Int64, Int64}}}()
    push!(h, (0+heuristique,pointDepart)) 
    
    matriceOriginelle[pointDepart[1],pointDepart[2]] = (0,0)

    coutMvt::Int64 = 0

    while  (trouve == false) 

        inutile, pointCourant = pop!(h) 

        if (pointCourant == pointArrivee) 
            trouve = true
        else

            N = (pointCourant[1]-1,pointCourant[2])
            E = (pointCourant[1],pointCourant[2]+1)
            S = (pointCourant[1]+ 1,pointCourant[2])
            O = (pointCourant[1],pointCourant[2]-1)
       
            if ( appartient(N, A) == true )
               if (A[N[1],N[2]] != '@' && A[N[1],N[2]] != 'T' && matriceOriginelle[N[1],N[2]] == (-1,-1))
                    if (A[N[1],N[2]] == 'S')
                        coutMvt = 5 
                    elseif (A[N[1],N[2]] == 'W')
                        coutMvt = 8 
                    else
                        coutMvt = 1 
                    end
                    matriceOriginelle[N[1],N[2]] = (pointCourant[1],pointCourant[2])
                    matriceNumerique[N[1],N[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] + coutMvt
                    push!(h, (matriceNumerique[N[1],N[2]]+ calculHeuristique(N,pointArrivee), N))
                end
            end

            if ( appartient(E, A) == true )
                if ( A[E[1],E[2]] != '@' && A[E[1],E[2]] != 'T' && matriceOriginelle[E[1],E[2]] == (-1,-1))
                    if (A[E[1],E[2]] == 'S')
                        coutMvt = 5 
                    elseif ( A[E[1],E[2]] == 'W')
                        coutMvt = 8 
                    else
                        coutMvt = 1 
                    end
                    matriceOriginelle[E[1],E[2]] = (pointCourant[1],pointCourant[2])
                    matriceNumerique[E[1],E[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] + coutMvt
                    push!(h, (matriceNumerique[E[1],E[2]]+ calculHeuristique(E,pointArrivee), E)) 
                end
            end
        
            if ( appartient(S, A) == true )
                if ( A[S[1],S[2]] != '@' && A[S[1],S[2]] != 'T' && matriceOriginelle[S[1],S[2]] == (-1,-1))
                    if ( A[S[1],S[2]] == 'S' )
                        coutMvt = 5 
                    elseif ( A[S[1],S[2]] == 'W')
                        coutMvt = 8 
                    else
                        coutMvt = 1 
                    end
                    matriceOriginelle[S[1],S[2]] = (pointCourant[1],pointCourant[2])
                    matriceNumerique[S[1],S[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] + coutMvt
                    push!(h, (matriceNumerique[S[1],S[2]]+ calculHeuristique(S,pointArrivee), S))
                end
            end

            if ( appartient(O, A) == true )
                if ( A[O[1],O[2]] != '@' && A[O[1],O[2]] != 'T' && matriceOriginelle[O[1],O[2]] == (-1,-1))
                    if (A[O[1],O[2]] == 'S')
                        coutMvt = 5 
                    elseif ( A[S[1],S[2]] == 'W')
                        coutMvt = 8 
                    else
                        coutMvt = 1 
                    end
                    matriceOriginelle[O[1],O[2]] = (pointCourant[1],pointCourant[2])
                    matriceNumerique[O[1],O[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] + coutMvt
                    push!(h, (matriceNumerique[O[1],O[2]]+ calculHeuristique(O,pointArrivee), O))
                end
            end
        end
    end


    etatsVisi = calculEtatsVisites(matriceNumerique)

    pC = matriceOriginelle[pointArrivee[1],pointArrivee[2]]
    A[pC[1],pC[2]] = 'P'

    if (trouve == true)
        listeFinale  = enqueue!(listeFinale, (pointArrivee[1],pointArrivee[2]))

        while  pC != pointDepart
            listeFinale  = enqueue!(listeFinale, pC)
            pC = matriceOriginelle[pC[1],pC[2]]
            A[pC[1],pC[2]] = 'P'
        end
        A[pC[1],pC[2]] = 'D'
        valeurChemin = matriceNumerique[pointArrivee[1],pointArrivee[2]]

    else
        listeFinale = (0,0)
    end
    A[pointArrivee[1],pointArrivee[2]] = 'A'
    showMapChar(A,true)
    return matriceOriginelle, valeurChemin, listeFinale, etatsVisi
end

function algoDijkstra(fname::String, D::Tuple{Int64,Int64}, A::Tuple{Int64,Int64})

    println("\nDijkstra Algorithme ...")

    matA = loadImg(path*fname)
    ACopy = copy(matA)

    matA[D[1],D[2]] = 'D'
    matA[A[1],A[2]] = 'A'

    mapColor = true

    Aprime = copy(ACopy)
    RD, zRD, liD, etatsVisi = dijkstra(Aprime, D, A)
    println("\nDistance D → A: ", zRD)
    println("Number of states evaluated: ", etatsVisi)

    println("Dijkstra fait ...")

end

function algoAstar(fname::String, D::Tuple{Int64,Int64}, A::Tuple{Int64,Int64})

    println("\nA* Algorithme ...")
    
    matA = loadImg(path*fname)
    ACopy = copy(matA)

    matA[D[1],D[2]] = 'D'
    matA[A[1],A[2]] = 'A'

    mapColor = true

    Aprime = copy(ACopy)
    RA, zRA, liA, etatsVisi = a(Aprime, D, A)

    println("\nDistance D → A: ", zRA)
    println("Number of states evaluated: ", etatsVisi)

    println("A* fait ...")
end


function calculEtatsVisites(MatNumerique::Matrix{Int64})
    m, n = size(MatNumerique)
    etatsVisites::Int64 = 0

    for i in 1:m 
        for j in 1:n
            if (MatNumerique[i,j] != 0)
                etatsVisites +=1
            end
        end
    end
    return etatsVisites
end

# menu general--------------------------------------------------------

println("\nElizabeth-Gandibleux-681")
println("Projet-Informatique-Scientifique\n ")

path = "data/" # car pas dans un sous repertoire attention a changer!

fname = "didactic.map"

println("Instance choisie: ",fname)

D::Tuple{Int64,Int64} = (1,1)
Ar::Tuple{Int64,Int64} = (15,14)

matA[D[1],D[2]] = 'D'
matA[Ar[1],Ar[2]] = 'A'

mapColor = true

algoDijkstra(fname, D, Ar)
println(" \n---------------------- ")
algoAstar(fname, D, Ar)
