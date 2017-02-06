################################################################################
################################################################################
#####							Test a pentagon
################################################################################
################################################################################


TestIsomorphicPentagon := function( surface, messageSurfaceOrigin )
	local check;

	check := SimplicialSurfaceByDownwardIncidence( [1,2,3,4,5,10], 10, 5,
		[ [1,10],[2,10],[3,10],[4,10],[5,10],[1,2],[2,3],[3,4],[4,5],[5,1] ],
		[ [1,2,6], [2,3,7], [3,4,8], [9,5,4], [10,1,5] ] );
	if not IsIsomorphic( surface, check ) then
		Print( messageSurfaceOrigin );
		Print( " is not isomorphic to a pentagon.\n");
	fi;
end;

##
##	Test whether a simplicial surface is a pentagon.
##
TestIsPentagon := function( surface, messageSurfaceOrigin )
	local conCom, vertexNr, edgeNr, faceNr, euler, sortDeg, vertexSym,
		anomalyClassCount;

	TestSimplicialSurfaceConsistency( surface, messageSurfaceOrigin );

	vertexNr := 6;
	edgeNr := 10;
	faceNr := 5;

	if NrOfVertices(surface) <> vertexNr then
		Print( messageSurfaceOrigin );
		Print( " does not have " );
		Print( vertexNr );
		Print( " vertices.\n");
	fi;
	if NrOfEdges(surface) <> edgeNr then
		Print( messageSurfaceOrigin );
		Print( " does not have " );
		Print( edgeNr );
		Print( " edges.\n");
	fi;
	if NrOfFaces(surface) <> faceNr then
		Print( messageSurfaceOrigin );
		Print( " does not have " );
		Print( faceNr );
		Print( " faces.\n");
	fi;
	euler := vertexNr - edgeNr + faceNr;
	if EulerCharacteristic(surface) <> euler then
		Print( messageSurfaceOrigin );
		Print( " does not have Euler-Characteristic " );
		Print( euler );
		Print( ".\n");
	fi;


	# The pentagon is an actual surface
	if not IsActualSurface( surface ) then
		Print( messageSurfaceOrigin );
		Print( " must be an actual surface.\n" );
	fi;

	# The pentagon is orientable
	if not IsOrientable( surface ) then
		Print( messageSurfaceOrigin );
		Print( " must be orientable.\n");
	fi;

	# The pentagon is connected
	if not IsConnected( surface ) then
		Print( messageSurfaceOrigin );
		Print( " must be connected.\n");
	fi;

	# TODO also test for different orders of function calls
	conCom := ConnectedComponentsAttributeOfSimplicialSurface( surface );
	if Length(conCom) <> 1 then
		Print( messageSurfaceOrigin );
		Print( " must have exactly one connected component.\n" );
	fi;
	if conCom[1] <> surface then
		Print( messageSurfaceOrigin );
		Print( " should equal its one connected component.\n");
	fi;

	sortDeg := [2,2,2,2,2,5];
	if SortedDegrees(surface) <> sortDeg then
		Print( messageSurfaceOrigin );
		Print( " does not have degrees " );
		Print( sortDeg );
		Print( ".\n");
	fi;

	vertexSym := [,,5,,1];
	if VertexSymbol(surface) <> vertexSym then
		Print( messageSurfaceOrigin );
		Print( " does not have the vertex symbol " );
		Print( vertexSym );
		Print( ".\n");
	fi;

	anomalyClassCount := 5;
	if Length( FaceAnomalyClasses(surface) ) <> anomalyClassCount then
		Print( messageSurfaceOrigin );
		Print( " should have exactly " );
		Print( anomalyClassCount );
		Print( " face anomaly class(es).\n");
	fi;

	if surface <> SnippOffEars(surface) then
		Print( messageSurfaceOrigin );
		Print( " should not be changed by removal of ears.\n");
	fi;

	
	TestIsomorphicPentagon( surface, messageSurfaceOrigin );
	
end;



##########################################################################
## This method tests the functionality for the example of a pentagon
## and the representation of a simplicial surface
TestPentagon := function()
	local surf, name;

	name := "Pentagon";

	surf := SimplicialSurfaceByVerticesInFaces( 6,5, 
							[[1,2,6],[2,3,6],[3,6,4],[6,4,5],[1,6,5]] );

	TestIsPentagon( surf, Concatenation(name," definition") );

	# We also test the simplest version of the coloured simplicial surfaces
	TestColouredSimplicialSurfaceConsistency( 
		ColouredSimplicialSurface( surf ), 
		Concatenation(name," as coloured simplicial surface") );
end;



##
##	Test simplicial surface identifications
##
TestPentagonIdentification := function()
	local surf, colSurf, id12, id23, id43, exA, exB, exC, exAB, exBC;

	surf := SimplicialSurfaceByVerticesInFaces( 6,5, 
							[[1,2,6],[2,3,6],[3,6,4],[6,4,5],[1,6,5]] );
	colSurf := ColouredSimplicialSurface( surf );


	# Try a definition of neighbour identification
	id12 := NeighbourIdentification( surf, 1, 2 );
	if id12 <> NeighbourIdentification( colSurf, 1, 2) then
		Error("Can't define pentagon neighbour identification (1,2) independent of colour.");
	fi;
	TestSimplicialSurfaceIdentificationConsistency( id12, "Neighbour identification (1,2) of pentagon" );
	TestColouredIdentificationConsistency( colSurf, id12, "Neighbour identification (1,2) of pentagon and pentagon" );
	if not IsConstantOnIntersection(colSurf, id12) then
		Error("Neighbour identification (1,2) of pentagon should be constant on intersection.");
	fi;
	if not IsApplicableExtension( colSurf, id12 ) then
		Error("Neighbour identification (1,2) of pentagon should be applicable.");
	fi;


	id23 := NeighbourIdentification( surf, 2, 3 );
	if id23 <> NeighbourIdentification( colSurf, 2, 3) then
		Error("Can't define pentagon neighbour identification (2,3) independent of colour.");
	fi;
	TestSimplicialSurfaceIdentificationConsistency( id23, "Neighbour identification (2,3) of pentagon" );
	TestColouredIdentificationConsistency( colSurf, id23, "Neighbour identification (2,3) of pentagon and pentagon" );
	if not IsConstantOnIntersection(colSurf, id23) then
		Error("Neighbour identification (2,3) of pentagon should be constant on intersection.");
	fi;
	if not IsApplicableExtension( colSurf, id23 ) then
		Error("Neighbour identification (2,3) of pentagon should be applicable.");
	fi;


	id43 := NeighbourIdentification( surf, 4, 3 );
	if id43 <> NeighbourIdentification( colSurf, 4, 3) then
		Error("Can't define pentagon neighbour identification (4,3) independent of colour.");
	fi;
	TestSimplicialSurfaceIdentificationConsistency( id43, "Neighbour identification (4,3) of pentagon" );
	TestColouredIdentificationConsistency( colSurf, id43, "Neighbour identification (4,3) of pentagon and pentagon" );
	if not IsConstantOnIntersection(colSurf, id43) then
		Error("Neighbour identification (4,3) of pentagon should be constant on intersection.");
	fi;
	if not IsApplicableExtension( colSurf, id43 ) then
		Error("Neighbour identification (4,3) of pentagon should be applicable.");
	fi;


	exA := ExtendByIdentification( colSurf, id12 );
	exB := ExtendByIdentification( colSurf, id23 );
	exC := ExtendByIdentification( colSurf, id43 );

	exAB := ExtendByIdentification( exA, id23 );
	exBC := ExtendByIdentification( exB, id43 );

	if not IsConstantOnIntersection( exA, id43 ) then
		Error("Neighbour identification (4,3) should be constant on intersection after extending pentagon by (1,2).");
	fi;
	if IsApplicableExtension( exA, id43 ) then
		Error("Neighbour identification (4,3) should not be applicable after extending pentagon by (1,2).");
	fi;

	if not IsConstantOnIntersection( exC, id12 ) then
		Error("Neighbour identification (1,2) should be constant on intersection after extending pentagon by (4,3).");
	fi;
	if IsApplicableExtension( exC, id12 ) then
		Error("Neighbour identification (1,2) should not be applicable after extending pentagon by (4,3).");
	fi;



	if not IsConstantOnIntersection( exAB, id43 ) then
		Error("Neighbour identification (4,3) should be constant on intersection after extending pentagon by (1,2) and (2,3).");
	fi;
	if IsApplicableExtension( exAB, id43 ) then
		Error("Neighbour identification (4,3) should not be applicable after extending pentagon by (1,2) and (2,3).");
	fi;

	if not IsConstantOnIntersection( exBC, id12 ) then
		Error("Neighbour identification (1,2) should be constant on intersection after extending pentagon by (2,3) and (4,3).");
	fi;
	if IsApplicableExtension( exBC, id12 ) then
		Error("Neighbour identification (1,2) should not be applicable after extending pentagon by (2,3) and (4,3).");
	fi;
end;