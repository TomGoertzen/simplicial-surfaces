################################################################################
################################################################################
#####		Test three triangles that have exactly one edge in common
################################################################################
################################################################################


TestIsomorphicThreeTrianglesOnEdge := function( surface, messageSurfaceOrigin )
	local check;

	check := SimplicialSurfaceByDownwardIncidence( 5, 7, [2,3,4],
		[ [1,2],[1,3],[2,3],[1,4],[2,4],[1,5],[2,5] ],
		[ , [1,3,2], [1,4,5], [1,6,7] ] );
	if not IsIsomorphic( surface, check ) then
		Print( messageSurfaceOrigin );
		Print( " is not isomorphic to three triangles with a common edge.\n");
	fi;
end;

##
##	Test whether a simplicial surface consists of three triangles that have 
##	exactly one edge in common.
##
TestIsThreeTrianglesOnEdge := function( surface, messageSurfaceOrigin )
	local snipp;

	TestSimplicialSurfaceAttributes( surface, messageSurfaceOrigin, rec(
		vertexNr := 5, 		# number of vertices
		edgeNr := 7, 		# number of edges
		faceNr := 3,		# number of faces
		isEdgesLikeSurface := false,	# do the edges look like on a surface?
		isVerticesLikeSurface := false,	# do the vertices look like on a surface?
		isTriangleSurface := true,	# is every face a triangle?
		isClosedSurface := false,	# is it closed?
		isOrientable := false,	# is it orientable?
		connectedComponentNr := 1, 	# is it connected?
                pathConnectedComponentNr := 1,
		sortDeg := [1,1,1,3,3],		# the sorted degrees
		vertexSym := [,3,,2],			# the vertex symbol
		faceAnomalyClassNr := 3,		# the number of anomaly classes
                edgeAnomalyClassNr := 7,
		isSnippable := true	# does ear-removal reduce the surface?
            )
	);

	snipp := SnippOffEars(surface);
	if NrOfVertices(snipp) > 0 or NrOfEdges(snipp) > 0 or NrOfFaces(snipp) > 0 then
		Print( messageSurfaceOrigin );
		Print( " should be destroyed by removal of ears.\n");
	fi;

	
	TestIsomorphicThreeTrianglesOnEdge( surface, messageSurfaceOrigin );
	
end;



##########################################################################
## This method tests the functionality for the example of three triangles that
## have exactly one edge in common and its representation as simplicial surface
TestThreeTrianglesOnEdge := function()
	local surf, name;

	name := "ThreeTrianglesOnEdge";

	surf := SimplicialSurfaceByVerticesInFaces( 5,3, [[1,2,3],[1,2,4],[1,2,5]] );

	TestIsThreeTrianglesOnEdge( surf, Concatenation(name," definition") );

	# We also test the simplest version of the coloured simplicial surfaces
	TestColouredSimplicialSurfaceConsistency( 
		ColouredSimplicialSurface( surf ), 
		Concatenation(name," as coloured simplicial surface") );
end;



##
##	Test simplicial surface identifications
##
TestThreeTrianglesOnEdgeIdentification := function()
	local surf, id12, id23, id13, colSurf, exA, exB, exC, exAB, exAC, exBC;

	surf := SimplicialSurfaceByVerticesInFaces( 5,3, [[1,2,3],[1,2,4],[1,2,5]] );
	colSurf := ColouredSimplicialSurface( surf );


	# Try a definition of neighbour identification
	id12 := NeighbourIdentification( surf, 1, 2 );
	if id12 <> NeighbourIdentification( colSurf, 1, 2) then
		Error("Can't define three triangles on edge neighbour identification (1,2) independent of colour.");
	fi;
	TestSimplicialSurfaceIdentificationConsistency( id12, "Neighbour identification (1,2) of three triangles on edge" );
	TestColouredIdentificationConsistency( colSurf, id12, "Neighbour identification (1,2) of three triangles on edge and three triangles on edge" );
	if not IsConstantOnIntersection(colSurf, id12) then
		Error("Neighbour identification (1,2) of three triangles on edge should be constant on intersection.");
	fi;
	if not IsApplicableExtension( colSurf, id12 ) then
		Error("Neighbour identification (1,2) of three triangles on edge should be applicable.");
	fi;


	id23 := NeighbourIdentification( surf, 2, 3 );
	if id23 <> NeighbourIdentification( colSurf, 2, 3) then
		Error("Can't define three triangles on edge neighbour identification (2,3) independent of colour.");
	fi;
	TestSimplicialSurfaceIdentificationConsistency( id23, "Neighbour identification (2,3) of three triangles on edge" );
	TestColouredIdentificationConsistency( colSurf, id23, "Neighbour identification (2,3) of three triangles on edge and three triangles on edge" );
	if not IsConstantOnIntersection(colSurf, id23) then
		Error("Neighbour identification (2,3) of three triangles on edge should be constant on intersection.");
	fi;
	if not IsApplicableExtension( colSurf, id23 ) then
		Error("Neighbour identification (2,3) of three triangles on edge should be applicable.");
	fi;


	id13 := NeighbourIdentification( surf, 1, 3 );
	if id13 <> NeighbourIdentification( colSurf, 1, 3) then
		Error("Can't define three triangles on edge neighbour identification (1,3) independent of colour.");
	fi;
	TestSimplicialSurfaceIdentificationConsistency( id13, "Neighbour identification (1,3) of three triangles on edge" );
	TestColouredIdentificationConsistency( colSurf, id13, "Neighbour identification (1,3) of three triangles on edge and three triangles on edge" );
	if not IsConstantOnIntersection(colSurf, id13) then
		Error("Neighbour identification (1,3) of three triangles on edge should be constant on intersection.");
	fi;
	if not IsApplicableExtension( colSurf, id13 ) then
		Error("Neighbour identification (1,3) of three triangles on edge should be applicable.");
	fi;


	exA := ExtendByIdentification( colSurf, id12 );
	exB := ExtendByIdentification( colSurf, id23 );
	exC := ExtendByIdentification( colSurf, id13 );

	exAB := ExtendByIdentification( exA, id23 );
	exAC := ExtendByIdentification( exA, id13 );
	exBC := ExtendByIdentification( exB, id13 );

	if not IsApplicableExtension( exAB, id13 ) then
		Error("Neighbour identification (1,3) should be applicable after extending by (1,2) and (2,3) for three triangles on edge");
	fi;
	if exAB <> ExtendByIdentificationNC( exAB, id13 ) then
		Error("Neighbour identification (1,3) should not change three triangles on edge after extending by (1,2) and (2,3).");
	fi;
	if not IsApplicableExtension( exAC, id23 ) then
		Error("Neighbour identification (2,3) should be applicable after extending by (1,3) and (1,2) for three triangles on edge");
	fi;
	if exAC <> ExtendByIdentificationNC( exAC, id23 ) then
		Error("Neighbour identification (2,3) should not change three triangles on edge after extending by (1,3) and (1,2).");
	fi;
	if not IsApplicableExtension( exBC, id12 ) then
		Error("Neighbour identification (1,2) should be applicable after extending by (1,3) and (2,3) for three triangles on edge");
	fi;
	if exBC <> ExtendByIdentificationNC( exBC, id12 ) then
		Error("Neighbour identification (1,2) should not change three triangles on edge after extending by (1,3) and (2,3).");
	fi;
	
end;



##
##	Test simplicial surface fans
##
TestThreeTrianglesOnEdgeFan := function()
	local surf, colSurf, fan, name, edge;

	surf := SimplicialSurfaceByDownwardIncidence( 5, 7, [2,3,4],
		[ [1,2],[1,3],[2,3],[1,4],[2,4],[1,5],[2,5] ],
		[ , [1,3,2], [1,4,5], [1,6,7] ] );
	colSurf := ColouredSimplicialSurface( surf );

	name := "Fan for three triangles on edge";

	# Construct some fans that works
	fan := SimplicialSurfaceFan( 1, 3, () : Corona := [2] );
	TestFanAttributes( fan, name, 1, 3, (), [2] );
	TestFanEdge( fan, name, surf, 2, colSurf, 2 );
	
	fan := SimplicialSurfaceFan( 1, 2, (2,3,4) );
	TestFanAttributes( fan, name, 1, 2, (2,3,4), [2,3,4] );
	TestFanEdge( fan, name, surf, 1, colSurf, 1 );

	# Construct some fans explicitly that do not work
	fan := SimplicialSurfaceFan( 1, 3, () : Corona := [1] );
	TestFanAttributes( fan, name, 1, 3, (), [1] );
	TestFanEdge( fan, name, surf, fail, colSurf, fail );

	fan := SimplicialSurfaceFan( 1, 2, (4,2) );
	TestFanAttributes( fan, name, 1, 2, (4,2), [2,4] );
	TestFanEdge( fan, name, surf, fail, colSurf, fail );

	
	# Construct some fans with direct reference to the (coloured) simplicial surface
	fan := SimplicialSurfaceFanByEdgeInColouredSimplicialSurface( colSurf, 5 );
	TestFanAttributes( fan, name, 2, 4, (), [3] );
	TestFanEdge( fan, name, surf, 5, colSurf, 5 );
end;


##
##	Test this example as a folding complex
##
TestFoldingComplexThreeTrianglesOnEdge := function()
	local surf, i, fan, complex, name, id12, plan, extension, id23, ext23;

	surf := SimplicialSurfaceByVerticesInFaces( 5,3, [[1,2,3],[1,2,4],[1,2,5]] );
	# The oriented faces +1 and -2 are opposite, as well as +2 and -3. Finally
	# +3 and -1 are opposites of each other. The natural direction that is
	# defined by the edge [1,2] leads to the cycle of faces (1,2,3).

	# Define the central fan
	fan := SimplicialSurfaceFan( 1, 2, (1,2,3) );
	
	# Construct the folding complex
	complex := FoldingComplexByFans( surf, [fan] ); # relies on the fact that this is the first edge
	name := "Folding complex of three triangles on edge";
	TestFoldingComplexConsistency( complex, name );
	
	# Check the orientation of the fan
	for i in Faces(surf) do
		if FaceOrientationInducedByFan( UnderlyingColouredSimplicialSurface( complex ), fan, i ) <> +1 then
			Error("Fan does not recognize correct face orientation.");
		fi;
		if FaceOrientationInducedByFan( UnderlyingColouredSimplicialSurface( complex ), InverseOfFan(fan), i ) <> -1 then
			Error("Fan does not recognize inverted correct face orientation.");
		fi;

		if FaceNameInducedByFan( UnderlyingColouredSimplicialSurface( complex ), fan, i ) <> +i then
			Error("Fan does not recognize correct face name.");
		fi;
		if FaceNameInducedByFan( UnderlyingColouredSimplicialSurface( complex ), InverseOfFan(fan), i ) <> -i then
			Error("Fan does not recognize inverted correct face name.");
		fi;
	od;
	
	
	# Check application of fans to oriented faces
	if ApplyFanToOrientedFace(complex,1,1) <> 2 then
		Error("Application of fan to adjacent oriented face failed.");
	fi;
	if ApplyFanToOrientedFace(complex,1,2) <> 3 then
		Error("Application of fan to adjacent oriented face failed.");
	fi;
	if ApplyFanToOrientedFace(complex,1,3) <> 1 then
		Error("Application of fan to adjacent oriented face failed.");
	fi;

	if ApplyFanToOrientedFace(complex,1,-1) <> 3 then
		Error("Application of fan to adjacent oriented face failed.");
	fi;
	if ApplyFanToOrientedFace(complex,1,-2) <> 1 then
		Error("Application of fan to adjacent oriented face failed.");
	fi;
	if ApplyFanToOrientedFace(complex,1,-3) <> 2 then
		Error("Application of fan to adjacent oriented face failed.");
	fi;


	# Construct the folding plan between +1 and -2
	id12 := NeighbourIdentification( surf, 1, 2 );
	TestExtensionOfIdentificationToFoldingPlan(complex, id12, [[1,-2]], 
		"Identification (1,2) of three triangles on edge" );

	plan := FoldingPlanByIdentification( id12, [1,-2] );
	extension := ApplyFoldingPlanNCApplicable(complex,plan);


	# Check the folding plan between +2 and -3
	id23 := NeighbourIdentification( surf, 3, 2 );

	TestExtensionOfIdentificationToFoldingPlan(complex, id23, [[-3,2]], 
		"Identification (3,2) of three triangles on edge" );
	TestExtensionOfIdentificationToFoldingPlan(extension, id23, [[-3,2]], 
		"Identification (3,2) of extension (1,2) of three triangles on edge" );
end;

