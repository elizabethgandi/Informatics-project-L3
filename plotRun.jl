# --------------------------------------------------------------------------- #
function showMapChar(mapchar::Matrix{Char}, crayonactivated::Bool)

  height,width = size(mapchar)

  if height > 50 || width > 50
    println("No text display of the map (too large)")
    return nothing
  end

  print("\n  ")
  for j in 1:width
    print(mod(j,10))
  end
  println("")
  for i in 1:height
    print(mod(i,10)," ")
    for j in 1:width
      if crayonactivated
        if      (mapchar[i,j]=='@')
          print(Crayon(background=:black,foreground=:black), mapchar[i,j]) # black
        elseif  (mapchar[i,j]=='T')
          print(Crayon(background=088,foreground=088), mapchar[i,j])       # brown
        elseif  (mapchar[i,j]=='W')
          print(Crayon(background=026,foreground=026), mapchar[i,j])       # blue
        elseif  (mapchar[i,j]=='S')
          print(Crayon(background=003,foreground=:black), mapchar[i,j])       # gray  
        elseif  (mapchar[i,j]=='D')
          print(Crayon(background=:light_green,foreground=:black), mapchar[i,j])  # Departure 
        elseif  (mapchar[i,j]=='A')
          print(Crayon(background=:light_green,foreground=:black), mapchar[i,j])    # Arrival 
        elseif  (mapchar[i,j]=='P')
          print(Crayon(background=:light_red,foreground=:black), 'x')    # path                                               
        else
          print(Crayon(background=255,foreground=:black), mapchar[i,j])    # white
        end
      else
        print(mapchar[i,j])
      end
    end
    if crayonactivated
      println(Crayon(reset=true)," ")
    else
      println(" ")
    end
  end

  return nothing

end

# --------------------------------------------------------------------------- #

function showMapGraphic(mapchar::Matrix{Char}, algorithm::String, fname::String)

  height,width = size(mapchar)

  # color codes of pixels appearing in the map
  noir  = [0,     0,   0]
  brun  = [128,   0,   0]
  blanc = [255, 255, 255]
  jaune = [255, 255, 0]
  vert  = [  0, 255,   0]
  rouge = [255,   0,   0]
  bleu  = [0,     0, 255]
  olive = [128, 128,   0]
 
 
  carte = fill(blanc,height,width)

  for i in 1:height
    for j in 1:width
      if      (mapchar[i,j]=='@')
        carte[i,j] = noir # wall (no passage)
      elseif  (mapchar[i,j]=='T')
        carte[i,j] = brun # tree (no passage)
      elseif  (mapchar[i,j]=='W')
        carte[i,j] = bleu # water (penalized passage)
      elseif  (mapchar[i,j]=='S')
        carte[i,j] = olive # sand (penalized passage) 
      elseif  (mapchar[i,j]=='D')
        carte[i,j] = vert # Departure 
      elseif  (mapchar[i,j]=='A')
        carte[i,j] = rouge # Arrival 
      elseif  (mapchar[i,j]=='P')
        carte[i,j] = jaune  # path                                               
      end
    end
  end

  # Commands for drawing the figure ----------------------------------------- #
  figure(algorithm, figsize=(6,6))
  xticks([]);  yticks([])
  imshow(carte)
  #  imshow(A,extent=[0,20, 0,20])

  title(fname) # * " | " * "\$z_{Opt}=  $nbStates\$")

  if height > 40 || width > 40
    # no value diplayed on the graphic map
  else
    for i in 1:height
      for j in 1:width
          if mapDist[i,j] > 0
              text(j-1,i-1,mapDist[i,j],va="center", ha="center", color="gray", size="x-small")
          elseif mapDist[i,j] == -1
              text(j-1,i-1,"0",va="center", ha="center", color="gray", size="x-small") 
          else
              text(j-1,i-1,".",va="center", ha="center", color="gray", size="x-small")           
          end 
      end
    end
  end

  return nothing

end

# --------------------------------------------------------------------------- #