#using Images
using REPL.TerminalMenus
using DataStructures

function loadImg(fname)

    #f=open("arena1.map")
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

function floodFill(A::Matrix{Char}, pointDepart::Tuple{Int64,Int64}, pointArrivee::Tuple{Int64,Int64})
    m, n = size(A)
    
    matriceOriginelle = fill((-1,-1), (m, n))
    matriceNumerique  = zeros(Int, m, n)

    trouve::Bool = false
    listeFinale = Queue{Tuple{Int64,Int64}}()
    valeurChemin::Int64 = 0

    q = Queue{Tuple{Int64,Int64}}()
    enqueue!(q,pointDepart)
    matriceOriginelle[pointDepart[1],pointDepart[2]] = (0,0)

    while length(q)!= 0  

        pointCourant = dequeue!(q)

        N = (pointCourant[1]-1,pointCourant[2])
        E = (pointCourant[1],pointCourant[2]+1)
        S = (pointCourant[1]+ 1,pointCourant[2])
        O = (pointCourant[1],pointCourant[2]-1)
        
        if ( appartient(N, A) == true && A[N[1],N[2]] != '@' && A[N[1],N[2]] != 'T' && A[N[1],N[2]] != 'S' && matriceOriginelle[N[1],N[2]] == (-1,-1))
            enqueue!(q,N)

            matriceOriginelle[N[1],N[2]] = (pointCourant[1],pointCourant[2])
            matriceNumerique[N[1],N[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] +1

            if (N == pointArrivee) 
                empty!(q)
                trouve = true
            end

        end
        
        if ( appartient(E, A) == true && A[E[1],E[2]] != '@' && A[E[1],E[2]] != 'T' && A[E[1],E[2]] != 'S'  && matriceOriginelle[E[1],E[2]] == (-1,-1))
            
            enqueue!(q,E)

            matriceOriginelle[E[1],E[2]] = (pointCourant[1],pointCourant[2])

            if (E == pointArrivee) 
                empty!(q)
                trouve = true
            end
            
            matriceNumerique[E[1],E[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] +1
            
        end
        
        if ( appartient(S, A) == true && A[S[1],S[2]] != '@' && A[S[1],S[2]] != 'T' && A[S[1],S[2]] != 'S'  && matriceOriginelle[S[1],S[2]] == (-1,-1))
            
            enqueue!(q,S)

            matriceOriginelle[S[1],S[2]] = (pointCourant[1],pointCourant[2])

            if (S == pointArrivee) 
                empty!(q)
                trouve = true
            end
            
            matriceNumerique[S[1],S[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] +1

        end
        
        if ( appartient(O, A) == true && A[O[1],O[2]] != '@' && A[O[1],O[2]] != 'T' && A[O[1],O[2]] != 'S'  && matriceOriginelle[O[1],O[2]] == (-1,-1))
            
            enqueue!(q,O)

            matriceOriginelle[O[1],O[2]] = (pointCourant[1],pointCourant[2])

            if (O == pointArrivee) 
                empty!(q)
                trouve = true
            end
            
            matriceNumerique[O[1],O[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] +1
        
        end
    end

    pC = matriceOriginelle[pointArrivee[1],pointArrivee[2]]

    if (trouve == true)
        listeFinale  = enqueue!(listeFinale, (pointArrivee[1],pointArrivee[2]))

        while  pC != (0,0)
            listeFinale  = enqueue!(listeFinale, pC)
            pC = matriceOriginelle[pC[1],pC[2]]
        end
        valeurChemin = matriceNumerique[pointArrivee[1],pointArrivee[2]]

    else
        listeFinale = (0,0)
    end
    return matriceOriginelle, valeurChemin, listeFinale
end

function dijkstra(A::Matrix{Char}, pointDepart::Tuple{Int64,Int64}, pointArrivee::Tuple{Int64,Int64})
    m, n = size(A)
    
    matriceOriginelle = fill((-1,-1), (m, n))
    matriceNumerique  = zeros(Int, m, n)

    trouve::Bool = false
    listeFinale = Queue{Tuple{Int64,Int64}}()
    valeurChemin::Int64 = 0
    
    pQ = PriorityQueue()
    enqueue!(pQ, (pointDepart[1],pointDepart[2]), 1) 
    matriceOriginelle[pointDepart[1],pointDepart[2]] = (0,0)

    while length(pQ)!= 0  

        pointCourant = dequeue!(pQ) # remove and return the lowest priority key

        N = (pointCourant[1]-1,pointCourant[2])
        E = (pointCourant[1],pointCourant[2]+1)
        S = (pointCourant[1]+ 1,pointCourant[2])
        O = (pointCourant[1],pointCourant[2]-1)
        
        if ( appartient(N, A) == true )
            
            if (A[N[1],N[2]] != '@' || A[N[1],N[2]] != 'T' || A[N[1],N[2]] != 'S' || matriceOriginelle[N[1],N[2]] == (-1,-1))
                enqueue!(pQ, N, 3)
            else
                enqueue!(pQ, N, 1) 
            end
            
            matriceOriginelle[N[1],N[2]] = (pointCourant[1],pointCourant[2])
            matriceNumerique[N[1],N[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] +1

            end
        end
        
        if ( appartient(E, A) == true )

            if ( A[E[1],E[2]] != '@' || A[E[1],E[2]] != 'T' || A[E[1],E[2]] != 'S'  || matriceOriginelle[E[1],E[2]] == (-1,-1))
                enqueue!(pQ, E, 3)
            else
                enqueue!(pQ, E, 1) 
            end

            matriceOriginelle[E[1],E[2]] = (pointCourant[1],pointCourant[2])
            matriceNumerique[E[1],E[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] +1

        end
        
        if ( appartient(S, A) == true )

            if ( A[S[1],S[2]] != '@' || A[S[1],S[2]] != 'T' || A[S[1],S[2]] != 'S'  || matriceOriginelle[S[1],S[2]] == (-1,-1))
                enqueue!(pQ, S, 3) 
            else
                enqueue!(pQ, S, 1) 
            end

            matriceOriginelle[S[1],S[2]] = (pointCourant[1],pointCourant[2])
            matriceNumerique[S[1],S[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] +1

        end
        
        if ( appartient(O, A) == true )

            if ( A[O[1],O[2]] != '@' || A[O[1],O[2]] != 'T' || A[O[1],O[2]] != 'S'  || matriceOriginelle[O[1],O[2]] == (-1,-1))
                enqueue!(pQ, O, 3) 
            else 
                enqueue!(pQ, O, 1) 
            end

            matriceOriginelle[O[1],O[2]] = (pointCourant[1],pointCourant[2])
            matriceNumerique[O[1],O[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] +1
        
        end
    end

 #=   pC = matriceOriginelle[pointArrivee[1],pointArrivee[2]]

    if (trouve == true)
        listeFinale  = enqueue!(listeFinale, (pA[1],pA[2]), 1)

        while  pC != (0,0)
            listeFinale  = enqueue!(listeFinale, pC,1)
            pC = matriceOriginelle[pC[1],pC[2]]
        end
        valeurChemin = matriceNumerique[pointArrivee[1],pointArrivee[2]]

    else
        listeFinale = (0,0)
    end
    return matriceOriginelle, valeurChemin, listeFinale
end=#


# menu general--------------------------------------------------------

# m lignes n colonnes

path = "data/" # car pas dans un sous repertoire attention a changer!

options = ["arena1.map",
           "didactic.map"]

menu   = RadioMenu(options, pagesize=2)
choice = request("Menu a choisir:", menu)
fname = options[choice]

println(" ")

A = loadImg(path*fname)
println("Instance : ",fname)


depart::Tuple{Int64,Int64} = (1,1)
arrivee::Tuple{Int64,Int64} = (7,5)

A[depart[1],depart[2]] = 'D'
A[arrivee[1],arrivee[2]] = 'A'


R, zR, li = floodFill(A, depart, arrivee)
RD, zRD, liD = dijkstra(A,depart,arrivee)

@show zR
@show li