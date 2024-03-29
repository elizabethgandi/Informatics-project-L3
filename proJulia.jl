using Printf, Crayons#, PyPlot
using REPL.TerminalMenus
using DataStructures

include("plotRun.jl")

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

function belongTo(T::Tuple{Int64,Int64}, A::Matrix{Char})
    mL, nC = size(A)
    
    if (T[1] >=1 && T[1] <= mL && T[1] <= nC && T[2]>=1 && T[2] <= nC && T[1] <= mL) 
        return true 
    else 
        return false
    end
end

function dijkstra(A::Matrix{Char}, startPoint::Tuple{Int64,Int64}, finalPoint::Tuple{Int64,Int64})
    
    m, n = size(A)
    
    initialMatrix = fill((-1,-1), (m, n))
    numberMatrix  = zeros(Int, m, n)

    findBool::Bool = false
    finalList = Queue{Tuple{Int64,Int64}}()
    pathValue::Int64 = 0

    h = BinaryMinHeap{Tuple{Int64, Tuple{Int64, Int64}}}()
    push!(h, (0,startPoint)) 

    initialMatrix[startPoint[1],startPoint[2]] = (0,0)

    coutMovement::Int64 = 0
    
    while  (findBool == false) 

        useless, currentPoint = pop!(h) 
        
        if (currentPoint == finalPoint) 
            findBool = true
        else

            N = (currentPoint[1]-1,currentPoint[2])
            E = (currentPoint[1],currentPoint[2]+1)
            S = (currentPoint[1]+ 1,currentPoint[2])
            O = (currentPoint[1],currentPoint[2]-1)
           
            if ( belongTo(N, A) == true )
               if (A[N[1],N[2]] != '@' && A[N[1],N[2]] != 'T' && initialMatrix[N[1],N[2]] == (-1,-1))
                    if (A[N[1],N[2]] == 'S')
                        coutMovement = 5
                    elseif (A[N[1],N[2]] == 'W')
                        coutMovement = 8
                    else
                        coutMovement = 1
                    end
                    initialMatrix[N[1],N[2]] = (currentPoint[1],currentPoint[2])
                    numberMatrix[N[1],N[2]] = numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement
                    push!(h, (numberMatrix[N[1],N[2]], N))
                end
            end
         
            if ( belongTo(E, A) == true )
                if ( A[E[1],E[2]] != '@' && A[E[1],E[2]] != 'T' && initialMatrix[E[1],E[2]] == (-1,-1))
                    if (A[E[1],E[2]] == 'S')
                        coutMovement = 5
                    elseif ( A[E[1],E[2]] == 'W')
                        coutMovement = 8
                    else
                        coutMovement = 1
                    end
                    initialMatrix[E[1],E[2]] = (currentPoint[1],currentPoint[2])
                    numberMatrix[E[1],E[2]] = numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement
                    push!(h, (numberMatrix[E[1],E[2]], E)) 
                end
            end
        
            if ( belongTo(S, A) == true )
                if ( A[S[1],S[2]] != '@' && A[S[1],S[2]] != 'T' && initialMatrix[S[1],S[2]] == (-1,-1))
                    if ( A[S[1],S[2]] == 'S' )
                        coutMovement = 5
                    elseif ( A[S[1],S[2]] == 'W')
                        coutMovement = 8
                    else
                        coutMovement = 1
                    end
                    initialMatrix[S[1],S[2]] = (currentPoint[1],currentPoint[2])
                    numberMatrix[S[1],S[2]] = numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement
                    push!(h, (numberMatrix[S[1],S[2]], S))
                end
            end
        
            if ( belongTo(O, A) == true )
                if ( A[O[1],O[2]] != '@' && A[O[1],O[2]] != 'T' && initialMatrix[O[1],O[2]] == (-1,-1))
                    if (A[O[1],O[2]] == 'S')
                        coutMovement = 5
                    elseif ( A[O[1],O[2]] == 'W')
                        coutMovement = 8
                    else
                        coutMovement = 1
                    end
                    initialMatrix[O[1],O[2]] = (currentPoint[1],currentPoint[2])
                    numberMatrix[O[1],O[2]] = numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement
                    push!(h, (numberMatrix[O[1],O[2]], O))
                end
            end
        end
    end
    
    CVS = calculVisitSates(numberMatrix)

    pC = initialMatrix[finalPoint[1],finalPoint[2]]
    A[pC[1],pC[2]] = 'P'

    if (findBool == true)
        finalList  = enqueue!(finalList, (finalPoint[1],finalPoint[2]))

        while  pC != startPoint
            finalList  = enqueue!(finalList, pC)
            pC = initialMatrix[pC[1],pC[2]]
            A[pC[1],pC[2]] = 'P'
        end
        A[pC[1],pC[2]] = 'D'
        pathValue = numberMatrix[finalPoint[1],finalPoint[2]]

    else
        finalList = (0,0)
    end
    A[finalPoint[1],finalPoint[2]] = 'A'
    #showMapChar(A,true)
    return initialMatrix, pathValue, finalList, CVS

end


function calculheuristic(startPoint::Tuple{Int64,Int64}, finalPoint::Tuple{Int64,Int64})
    
    xA = startPoint[1]
    yA = startPoint[2]
    xB = finalPoint[1]
    yB = finalPoint[2]

    heuristic = abs(xA-xB) + abs(yA-yB)

    return heuristic
end

function a(A::Matrix{Char}, startPoint::Tuple{Int64,Int64}, finalPoint::Tuple{Int64,Int64})
    m, n = size(A)
    
    initialMatrix = fill((-1,-1), (m, n))
    numberMatrix  = zeros(Int, m, n)

    findBool::Bool = false
    finalList = Queue{Tuple{Int64,Int64}}()
    pathValue::Int64 = 0

    heuristic = calculheuristic(startPoint,finalPoint)

    h = BinaryMinHeap{Tuple{Int64, Tuple{Int64, Int64}}}()
    push!(h, (0+heuristic,startPoint)) 
    
    initialMatrix[startPoint[1],startPoint[2]] = (0,0)

    coutMovement::Int64 = 0

    while  (findBool == false) 

        useless, currentPoint = pop!(h) 

        if (currentPoint == finalPoint) 
            findBool = true
        else

            N = (currentPoint[1]-1,currentPoint[2])
            E = (currentPoint[1],currentPoint[2]+1)
            S = (currentPoint[1]+ 1,currentPoint[2])
            O = (currentPoint[1],currentPoint[2]-1)
       
            if ( belongTo(N, A) == true )
               if (A[N[1],N[2]] != '@' && A[N[1],N[2]] != 'T')
                    if (A[N[1],N[2]] == 'S')
                        coutMovement = 5 
                    elseif (A[N[1],N[2]] == 'W')
                        coutMovement = 8 
                    else
                        coutMovement = 1 
                    end
                    if (initialMatrix[N[1],N[2]] == (-1,-1) || numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement < numberMatrix[N[1],N[2]])
                        initialMatrix[N[1],N[2]] = (currentPoint[1],currentPoint[2])
                        numberMatrix[N[1],N[2]] = numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement
                        push!(h, (numberMatrix[N[1],N[2]]+ calculheuristic(N,finalPoint), N))
                    end
                end
            end

            if ( belongTo(E, A) == true )
                if ( A[E[1],E[2]] != '@' && A[E[1],E[2]] != 'T')
                    if (A[E[1],E[2]] == 'S')
                        coutMovement = 5 
                    elseif ( A[E[1],E[2]] == 'W')
                        coutMovement = 8 
                    else
                        coutMovement = 1 
                    end
                    if (initialMatrix[E[1],E[2]] == (-1,-1) || numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement < numberMatrix[E[1],E[2]])
                        initialMatrix[E[1],E[2]] = (currentPoint[1],currentPoint[2])
                        numberMatrix[E[1],E[2]] = numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement
                        push!(h, (numberMatrix[E[1],E[2]]+ calculheuristic(E,finalPoint), E)) 
                    end
                end
            end
        
            if ( belongTo(S, A) == true )
                if ( A[S[1],S[2]] != '@' && A[S[1],S[2]] != 'T')
                    if ( A[S[1],S[2]] == 'S' )
                        coutMovement = 5 
                    elseif ( A[S[1],S[2]] == 'W')
                        coutMovement = 8 
                    else
                        coutMovement = 1 
                    end
                    if (initialMatrix[S[1],S[2]] == (-1,-1) || numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement < numberMatrix[S[1],S[2]])
                        initialMatrix[S[1],S[2]] = (currentPoint[1],currentPoint[2])
                        numberMatrix[S[1],S[2]] = numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement
                        push!(h, (numberMatrix[S[1],S[2]]+ calculheuristic(S,finalPoint), S))
                    end
                end
            end

            if ( belongTo(O, A) == true )
                if ( A[O[1],O[2]] != '@' && A[O[1],O[2]] != 'T')
                    if (A[O[1],O[2]] == 'S')
                        coutMovement = 5 
                    elseif ( A[O[1],O[2]] == 'W')
                        coutMovement = 8 
                    else
                        coutMovement = 1 
                    end
                    if (initialMatrix[O[1],O[2]] == (-1,-1) || numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement < numberMatrix[O[1],O[2]])
                        initialMatrix[O[1],O[2]] = (currentPoint[1],currentPoint[2])
                        numberMatrix[O[1],O[2]] = numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement
                        push!(h, (numberMatrix[O[1],O[2]]+ calculheuristic(O,finalPoint), O))
                    end
                end
            end
        end
    end

    CVS = calculVisitSates(numberMatrix)

    pC = initialMatrix[finalPoint[1],finalPoint[2]]
    A[pC[1],pC[2]] = 'P'

    if (findBool == true)
        finalList  = enqueue!(finalList, (finalPoint[1],finalPoint[2]))

        while  pC != startPoint
            finalList  = enqueue!(finalList, pC)
            pC = initialMatrix[pC[1],pC[2]]
            A[pC[1],pC[2]] = 'P'
        end
        A[pC[1],pC[2]] = 'D'
        pathValue = numberMatrix[finalPoint[1],finalPoint[2]]

    else
        finalList = (0,0)
    end
    A[finalPoint[1],finalPoint[2]] = 'A'
    #showMapChar(A,true)

    return initialMatrix, pathValue, finalList, CVS
end


function WAstar(A::Matrix{Char}, startPoint::Tuple{Int64,Int64}, finalPoint::Tuple{Int64,Int64}, w::Float64)
    m, n = size(A)
    
    initialMatrix = fill((-1,-1), (m, n))
    numberMatrix  = zeros(Int, m, n)

    findBool::Bool = false
    finalList = Queue{Tuple{Int64,Int64}}()
    pathValue::Int64 = 0

    heuristic = (w*calculheuristic(startPoint,finalPoint))

    h = BinaryMinHeap{Tuple{Int64, Tuple{Int64, Int64}}}()
    push!(h, (0+heuristic,startPoint)) 
    
    initialMatrix[startPoint[1],startPoint[2]] = (0,0)

    coutMovement::Int64 = 0

    while  (findBool == false) 

        useless, currentPoint = pop!(h) 

        if (currentPoint == finalPoint) 
            findBool = true
        else

            N = (currentPoint[1]-1,currentPoint[2])
            E = (currentPoint[1],currentPoint[2]+1)
            S = (currentPoint[1]+ 1,currentPoint[2])
            O = (currentPoint[1],currentPoint[2]-1)
       
            if ( belongTo(N, A) == true )
               if (A[N[1],N[2]] != '@' && A[N[1],N[2]] != 'T')
                    if (A[N[1],N[2]] == 'S')
                        coutMovement = 5 
                    elseif (A[N[1],N[2]] == 'W')
                        coutMovement = 8 
                    else
                        coutMovement = 1 
                    end
                    if (initialMatrix[N[1],N[2]] == (-1,-1) || numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement < numberMatrix[N[1],N[2]])
                        initialMatrix[N[1],N[2]] = (currentPoint[1],currentPoint[2])
                        numberMatrix[N[1],N[2]] = numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement
                        push!(h, (numberMatrix[N[1],N[2]]+ (w*calculheuristic(N,finalPoint)), N))
                    end
                end
            end

            if ( belongTo(E, A) == true )
                if ( A[E[1],E[2]] != '@' && A[E[1],E[2]] != 'T')
                    if (A[E[1],E[2]] == 'S')
                        coutMovement = 5 
                    elseif ( A[E[1],E[2]] == 'W')
                        coutMovement = 8 
                    else
                        coutMovement = 1 
                    end
                    if (initialMatrix[E[1],E[2]] == (-1,-1) || numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement < numberMatrix[E[1],E[2]])
                        initialMatrix[E[1],E[2]] = (currentPoint[1],currentPoint[2])
                        numberMatrix[E[1],E[2]] = numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement
                        push!(h, (numberMatrix[E[1],E[2]]+ (w*calculheuristic(E,finalPoint)), E)) 
                    end
                end
            end
        
            if ( belongTo(S, A) == true )
                if ( A[S[1],S[2]] != '@' && A[S[1],S[2]] != 'T')
                    if ( A[S[1],S[2]] == 'S' )
                        coutMovement = 5 
                    elseif ( A[S[1],S[2]] == 'W')
                        coutMovement = 8 
                    else
                        coutMovement = 1 
                    end
                    if (initialMatrix[S[1],S[2]] == (-1,-1) || numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement < numberMatrix[S[1],S[2]])
                        initialMatrix[S[1],S[2]] = (currentPoint[1],currentPoint[2])
                        numberMatrix[S[1],S[2]] = numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement
                        push!(h, (numberMatrix[S[1],S[2]]+ (w*calculheuristic(S,finalPoint)), S))
                    end
                end
            end

            if ( belongTo(O, A) == true )
                if ( A[O[1],O[2]] != '@' && A[O[1],O[2]] != 'T')
                    if (A[O[1],O[2]] == 'S')
                        coutMovement = 5 
                    elseif ( A[O[1],O[2]] == 'W')
                        coutMovement = 8 
                    else
                        coutMovement = 1 
                    end

                    if (initialMatrix[O[1],O[2]] == (-1,-1) || numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement < numberMatrix[O[1],O[2]])
                        initialMatrix[O[1],O[2]] = (currentPoint[1],currentPoint[2])
                        numberMatrix[O[1],O[2]] = numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement
                        push!(h, (numberMatrix[O[1],O[2]]+ (w*calculheuristic(O,finalPoint)), O))
                    end
                end
            end
        end
    end

    CVS = calculVisitSates(numberMatrix)

    pC = initialMatrix[finalPoint[1],finalPoint[2]]
    A[pC[1],pC[2]] = 'P'

    if (findBool == true)
        finalList  = enqueue!(finalList, (finalPoint[1],finalPoint[2]))

        while  pC != startPoint
            finalList  = enqueue!(finalList, pC)
            pC = initialMatrix[pC[1],pC[2]]
            A[pC[1],pC[2]] = 'P'
        end
        A[pC[1],pC[2]] = 'D'
        pathValue = numberMatrix[finalPoint[1],finalPoint[2]]
    else
        finalList = (0,0)
    end
    A[finalPoint[1],finalPoint[2]] = 'A'
    #showMapChar(A,true)
    return initialMatrix, pathValue, finalList, CVS
end


function printAlgorithms(A::Matrix{Char}, startPoint::Tuple{Int64,Int64}, finalPoint::Tuple{Int64,Int64}, w::Float64)

    ACopy = copy(A)

    options= ["Dijkstra",
              "A*",
              "WA*",
              "Tous"]

    menu = RadioMenu(options,pagesize=3)
    choice = request("\nAlgorithme(s) à choisir:", menu)
    algo = options[choice]

    if (algo == "Dijkstra") 
        A = copy(ACopy)
        RD, zRD, liD, nbEtatsVisitesDj = dijkstra(A, startPoint, finalPoint)
        
        @show zRD
        @show liD
        @show nbEtatsVisitesDj

    elseif (algo == "A*")
        A = copy(ACopy)
        RA, zRA, liA, nbEtatsVisitesA = a(A, start, final)
        
        @show zRA
        @show liA
        @show nbEtatsVisitesA

    elseif (algo == "WA*")
        A = copy(ACopy)
        RWA, zRWA, liWA, nbEtatsVisitesWA = WAstar(A, start, final, w)
        
        @show zRWA
        @show liWA
        @show nbEtatsVisitesWA

    else
        RD, zRD, liD, nbEtatsVisitesDj = dijkstra(A, startPoint, finalPoint)
        A = copy(ACopy)
        RA, zRA, liA, nbEtatsVisitesA = a(A, start, final)
        Ap = copy(ACopy)
        RWA, zRWA, liWA, nbEtatsVisitesWA = WAstar(Ap, start, final, w)

        println("\n")
        println("\nRésultats: ----------------------------------------------")
        println("\nSolutions pour le point de départ: ", startPoint, " et le point d'arrivé: ", finalPoint, " avec w = ", w)

        println("\nDistance D -> A: ", zRD)
        #println("Liste des états visités par l'Algorithme Dijkstra = ", liD)
        println("Nombre d'états visités par l'Algorithme Dijkstra = ", nbEtatsVisitesDj)
        println(" ")

        println("\nDistance D -> A: ", zRA)
        #println("Liste des états visités par l'Algorithme Dijkstra = ", liA)
        println("Nombre d'états visités par l'Algorithme A* = ", nbEtatsVisitesA)
        println(" ")

        println("\nDistance D -> A: ", zRWA)
        #println("Liste des états visités par l'Algorithme Dijkstra = ", liWA)
        println("Nombre d'états visités par l'Algorithme WA* = ", nbEtatsVisitesWA)

        println("\nFin des résultats: --------------------------------------")
        println("\n")
    end

end

function calculVisitSates(matNumber::Matrix{Int64})
    m, n = size(matNumber)
    visitStates::Int64 = 0

    for i in 1:m 
        for j in 1:n
            if (matNumber[i,j] != 0)
                visitStates +=1
            end
        end
    end
    return visitStates
end

# menu general--------------------------------------------------------

path = "data/" 

options = ["arena.map",
           "didactic.map",
           "den009d.map",
           "test.map",
           "maze512-4-9.map"]

menu   = RadioMenu(options, pagesize=2)
choice = request("\n Instances numériques à choisir:", menu)
fname = options[choice]

println(" ")

A = loadImg(path*fname)
println("Instance : ",fname)

ACopy = copy(A)

#start::Tuple{Int64,Int64} = (464,2)
#final::Tuple{Int64,Int64} = (139,509)

start::Tuple{Int64,Int64} = (471,26)
final::Tuple{Int64,Int64} = (4,351)

#start::Tuple{Int64,Int64} = (4,5)
#final::Tuple{Int64,Int64} = (13,19)

w::Float64 = 3.0

A[start[1],start[2]] = 'D'
A[final[1],final[2]] = 'A'

mapColor = true
#showMapChar(A,mapColor)

printAlgorithms(A, start, final, w)  