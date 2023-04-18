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
    
    if (T[1] >=1 && T[1] <= mL && T[2]>=1 && T[2] <= nC) 
        return true 
    else 
        return false
    end
end

function floodFill(A::Matrix{Char}, startPoint::Tuple{Int64,Int64}, finalPoint::Tuple{Int64,Int64})
    m, n = size(A)
    
    initialMatrix = fill((-1,-1), (m, n))
    numberMatrix  = zeros(Int, m, n)

    findBool::Bool = false
    finalList = Queue{Tuple{Int64,Int64}}()
    pathValue::Int64 = 0

    q = Queue{Tuple{Int64,Int64}}()
    enqueue!(q,startPoint)
    initialMatrix[startPoint[1],startPoint[2]] = (0,0)

    while length(q)!= 0  

        currentPoint = dequeue!(q)

        N = (currentPoint[1]-1,currentPoint[2])
        E = (currentPoint[1],currentPoint[2]+1)
        S = (currentPoint[1]+ 1,currentPoint[2])
        O = (currentPoint[1],currentPoint[2]-1)
        
        if ( belongTo(N, A) == true && A[N[1],N[2]] != '@' && A[N[1],N[2]] != 'T' && initialMatrix[N[1],N[2]] == (-1,-1))
            enqueue!(q,N)

            initialMatrix[N[1],N[2]] = (currentPoint[1],currentPoint[2])
            numberMatrix[N[1],N[2]] = numberMatrix[currentPoint[1],currentPoint[2]] +1

            if (N == finalPoint) 
                empty!(q)
                findBool = true
            end

        end
        
        if ( belongTo(E, A) == true && A[E[1],E[2]] != '@' && A[E[1],E[2]] != 'T'  && initialMatrix[E[1],E[2]] == (-1,-1))
            
            enqueue!(q,E)

            initialMatrix[E[1],E[2]] = (currentPoint[1],currentPoint[2])

            if (E == finalPoint) 
                empty!(q)
                findBool = true
            end
            
            numberMatrix[E[1],E[2]] = numberMatrix[currentPoint[1],currentPoint[2]] +1
            
        end
        
        if ( belongTo(S, A) == true && A[S[1],S[2]] != '@' && A[S[1],S[2]] != 'T' && initialMatrix[S[1],S[2]] == (-1,-1))
            
            enqueue!(q,S)

            initialMatrix[S[1],S[2]] = (currentPoint[1],currentPoint[2])

            if (S == finalPoint) 
                empty!(q)
                findBool = true
            end
            
            numberMatrix[S[1],S[2]] = numberMatrix[currentPoint[1],currentPoint[2]] +1

        end
        
        if ( belongTo(O, A) == true && A[O[1],O[2]] != '@' && A[O[1],O[2]] != 'T'  && initialMatrix[O[1],O[2]] == (-1,-1))
            
            enqueue!(q,O)

            initialMatrix[O[1],O[2]] = (currentPoint[1],currentPoint[2])

            if (O == finalPoint) 
                empty!(q)
                findBool = true
            end
            
            numberMatrix[O[1],O[2]] = numberMatrix[currentPoint[1],currentPoint[2]] +1
        
        end
    end

    calculVisitSates(numberMatrix)

    pC = initialMatrix[finalPoint[1],finalPoint[2]]
    A[pC[1],pC[2]] = 'P'

    if (findBool == true)
        enqueue!(finalList, (finalPoint[1],finalPoint[2]))

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
    showMapChar(A,true)
    return initialMatrix, pathValue, finalList
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
                    elseif ( A[S[1],S[2]] == 'W')
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
    
    calculVisitSates(numberMatrix)

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
    @show finalList
    A[finalPoint[1],finalPoint[2]] = 'A'
    showMapChar(A,true)
    return initialMatrix, pathValue, finalList
    

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

    #cpt=0
    while  (findBool == false) 

        useless, currentPoint = pop!(h) 

        #println("cpt:",cpt, " ", useless, " ", currentPoint)
        #cpt+=1

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
                    push!(h, (numberMatrix[N[1],N[2]]+ calculheuristic(N,finalPoint), N))
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
                    push!(h, (numberMatrix[E[1],E[2]]+ calculheuristic(E,finalPoint), E)) 
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
                    push!(h, (numberMatrix[S[1],S[2]]+ calculheuristic(S,finalPoint), S))
                end
            end

            if ( belongTo(O, A) == true )
                if ( A[O[1],O[2]] != '@' && A[O[1],O[2]] != 'T' && initialMatrix[O[1],O[2]] == (-1,-1))
                    if (A[O[1],O[2]] == 'S')
                        coutMovement = 5 
                    elseif ( A[S[1],S[2]] == 'W')
                        coutMovement = 8 
                    else
                        coutMovement = 1 
                    end
                    initialMatrix[O[1],O[2]] = (currentPoint[1],currentPoint[2])
                    numberMatrix[O[1],O[2]] = numberMatrix[currentPoint[1],currentPoint[2]] + coutMovement
                    push!(h, (numberMatrix[O[1],O[2]]+ calculheuristic(O,finalPoint), O))
                end
            end
        end
    end


    calculVisitSates(numberMatrix)

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
    showMapChar(A,true)
    return initialMatrix, pathValue, finalList
end

function printAlgorithms(A::Matrix{Char}, startPoint::Tuple{Int64,Int64}, finalPoint::Tuple{Int64,Int64})
    ACopy = copy(A)

    options= ["FloodFill",
              "Dijkstra",
              "A*",
              "Tous"]

    menu = RadioMenu(options,pagesize=3)
    choice = request("Algorithme(s) choisit(s):", menu)
    algo = options[choice]

    if (algo == "FloodFill") 
        R, zR, li = floodFill(A, startPoint, finalPoint)
        
        @show zR
        @show li

    elseif (algo == "Dijkstra") 
        A = copy(ACopy)
        RD, zRD, liD = dijkstra(A, startPoint, finalPoint)
        
        @show zRD
        @show liD

    elseif (algo == "A*")
        A = copy(ACopy)
        RA, zRA, liA = a(A, start, final)
        
        @show zRA
        @show liA

    else
        R, zR, li = floodFill(A, startPoint, finalPoint)
        A = copy(ACopy)
        RD, zRD, liD = dijkstra(A, startPoint, finalPoint)
        A = copy(ACopy)
        RA, zRA, liA = a(A, start, final)

        @show zR
        @show li

        @show zRD
        @show liD

        @show zRA
        @show liA
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
    #@show visitStates
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

ACopy = copy(A)

start::Tuple{Int64,Int64} = (1,1)
final::Tuple{Int64,Int64} = (5,7)

A[start[1],start[2]] = 'D'
A[final[1],final[2]] = 'A'

mapColor = true
#showMapChar(A,mapColor)

printAlgorithms(A, start, final)