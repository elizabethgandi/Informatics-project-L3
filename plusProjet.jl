#=
function propagerDjikstra(A::Matrix{Char}, pointDirection::Tuple{Int64,Int64},matriceNumerique::Matrix{Int64},matriceOriginelle::Matrix{Tuple{Int64,Int64}},pointCourant::Tuple{Int64,Int64},coutMvt::Int64)

    @show pointCourant
    @show pointDirection

    if ( appartient(pointDirection, A) == true )
        if (A[pointDirection[1],pointDirection[2]] != '@' && A[pointDirection[1],pointDirection[2]] != 'T' && matriceOriginelle[pointDirection[1],pointDirection[2]] == (-1,-1))
             if (A[pointDirection[1],pointDirection[2]] == 'S')
                 coutMvt = 5
             elseif (A[pointDirection[1],pointDirection[2]] == 'W')
                 coutMvt = 8
             else
                 coutMvt = 1
             end
             matriceOriginelle[pointDirection[1],pointDirection[2]] = (pointCourant[1],pointCourant[2])
             matriceNumerique[pointDirection[1],pointDirection[2]]  = matriceNumerique[pointCourant[1],pointCourant[2]] + coutMvt
             push!(h, (matriceNumerique[pointDirection[1],pointDirection[2]], pointDirection))
         end
     end
     return nothing

end

function affichageResDjikstra(matriceNumerique::Matrix{Int64},matriceOriginelle::Matrix{Tuple{Int64,Int64}},
    pointArrivee::Tuple{Int64,Int64},trouve::Bool,listeFinale::Queue{Tuple{Int64,Int64}})

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

    h = BinaryMinHeap{Tuple{Int64, Tuple{Int64, Int64}}}()
    push!(h, (0,pointDepart)) 

    matriceOriginelle[pointDepart[1],pointDepart[2]] = (0,0)

    coutMvt::Int64 = 0

    while  (trouve == false) 

        inutile, pointCourant = pop!(h) 

        if (pointCourant == pointArrivee) 
            trouve = true
        else

            N = (pointCourant[1]-1 ,pointCourant[2]  )
            E = (pointCourant[1]   ,pointCourant[2]+1)
            S = (pointCourant[1]+ 1,pointCourant[2]  )
            O = (pointCourant[1]   ,pointCourant[2]-1)
       
            @show 'N'
            propagerDjikstra(A,N,matriceNumerique,matriceOriginelle,pointCourant,coutMvt)

            @show 'E'
            propagerDjikstra(A,E,matriceNumerique,matriceOriginelle,pointCourant,coutMvt)

            @show 'S'
            propagerDjikstra(A,S,matriceNumerique,matriceOriginelle,pointCourant,coutMvt)
            
            @show 'O'
            propagerDjikstra(A,O,matriceNumerique,matriceOriginelle,pointCourant,coutMvt)
            #@assert false "stop"
        end
    end
    return  affichageResDjikstra(matriceNumerique,matriceOriginelle,pointArrivee,trouve,listeFinale)
end
=#
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

function propagerFF(N::Tuple{Int64,Int64}, A::Matrix{Char}, matriceNumerique::Matrix{Int64}, matriceOriginelle::Matrix{Tuple{Int64,Int64}})
    
    if ( appartient(N, A) == true && A[N[1],N[2]] != '@' && A[N[1],N[2]] != 'T' && matriceOriginelle[N[1],N[2]] == (-1,-1))
        enqueue!(q,N)

        matriceOriginelle[N[1],N[2]] = (pointCourant[1],pointCourant[2])
        matriceNumerique[N[1],N[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] +1

        if (N == pointArrivee) 
            empty!(q)
            trouve = true
        end

    end
    return 
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

        propagerFF(N,A,matriceNumerique,matriceOriginelle)
        propagerFF(E,A,matriceNumerique,matriceOriginelle)
        propagerFF(S,A,matriceNumerique,matriceOriginelle)
        propagerFF(O,A,matriceNumerique,matriceOriginelle)
        
        #=if ( appartient(N, A) == true && A[N[1],N[2]] != '@' && A[N[1],N[2]] != 'T' && matriceOriginelle[N[1],N[2]] == (-1,-1))
            enqueue!(q,N)

            matriceOriginelle[N[1],N[2]] = (pointCourant[1],pointCourant[2])
            matriceNumerique[N[1],N[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] +1

            if (N == pointArrivee) 
                empty!(q)
                trouve = true
            end

        end
        
        if ( appartient(E, A) == true && A[E[1],E[2]] != '@' && A[E[1],E[2]] != 'T'  && matriceOriginelle[E[1],E[2]] == (-1,-1))
            
            enqueue!(q,E)

            matriceOriginelle[E[1],E[2]] = (pointCourant[1],pointCourant[2])

            if (E == pointArrivee) 
                empty!(q)
                trouve = true
            end
            
            matriceNumerique[E[1],E[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] +1
            
        end
        
        if ( appartient(S, A) == true && A[S[1],S[2]] != '@' && A[S[1],S[2]] != 'T' && matriceOriginelle[S[1],S[2]] == (-1,-1))
            
            enqueue!(q,S)

            matriceOriginelle[S[1],S[2]] = (pointCourant[1],pointCourant[2])

            if (S == pointArrivee) 
                empty!(q)
                trouve = true
            end
            
            matriceNumerique[S[1],S[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] +1

        end
        
        if ( appartient(O, A) == true && A[O[1],O[2]] != '@' && A[O[1],O[2]] != 'T'  && matriceOriginelle[O[1],O[2]] == (-1,-1))
            
            enqueue!(q,O)

            matriceOriginelle[O[1],O[2]] = (pointCourant[1],pointCourant[2])

            if (O == pointArrivee) 
                empty!(q)
                trouve = true
            end
            
            matriceNumerique[O[1],O[2]] = matriceNumerique[pointCourant[1],pointCourant[2]] +1
        
        end=#
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


depart::Tuple{Int64,Int64} = (5,13)
arrivee::Tuple{Int64,Int64} = (10,14)

A[depart[1],depart[2]] = 'D'
A[arrivee[1],arrivee[2]] = 'A'


R, zR, li = floodFill(A, depart, arrivee)
RD, zRD, liD = dijkstra(A, depart, arrivee)

@show zR
@show li

@show RD
@show zRD
@show liD