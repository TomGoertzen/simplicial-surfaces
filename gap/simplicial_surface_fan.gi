##############################################################################
##
#W  simplicial_surface_fan.gi      SimplicialSurfaces         Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Markus Baumeister, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##
##  The functions in this file compute with fans.
##

DeclareRepresentation("IsSimplicialSurfaceFanRep", IsSimplicialSurfaceFan,
     []);

##	accompanying type
SimplicialSurfaceFanType := 
    NewType( SimplicialSurfaceFanFamily, IsSimplicialSurfaceFanRep );



#############################################################################
#############################################################################
##
##						Start of constructors
##
##
##

#!	@Description
#!	Return a fan by defining all necessary attributes. Begin and End have to be
#!	different.
#!	The NC-version doesn't check if Begin and End are different.
#!	@Arguments two positive integers, one cyclic permutation
#!	@Returns a fan
InstallMethod( SimplicialSurfaceFanNC, 
	"for two positive integers and a permutation",
	[IsPosInt, IsPosInt, IsPerm and IsCyclic],
	function( start, fin, perm )
		local fan, corona;

		fan := Objectify( SimplicialSurfaceFanType, rec() );
		SetBeginAttributeOfSimplicialSurfaceFan( fan, start );
		SetEndAttributeOfSimplicialSurfaceFan( fan, fin );
		SetPermutationAttributeOfSimplicialSurfaceFan( fan, perm );

		# Check the corona
		corona := ValueOption( "Corona" );
		if not corona = fail then
			SetCoronaOfFanAttributeOfSimplicialSurfaceFan( fan, corona );
		fi;

		return fan;
	end
);
InstallMethod( SimplicialSurfaceFan, 
	"for two positive integers and a permutation",
	[IsPosInt, IsPosInt, IsPerm and IsCyclic],
	function( start, fin, perm )
		local corona;

		if start = fin then
			Error("SimplicialSurfaceFan: Begin and End have to be different.");
		fi;

		# Check the corona
		corona := ValueOption( "Corona" );
		if not corona = fail then
			if perm <> () and MovedPoints(perm) <> corona then
				Error("SimplicialSurfaceFan: The corona has to be equal to the moved points of the permutation.");
			fi;
		fi;

		return SimplicialSurfaceFanNC( start, fin, perm);
	end
);

#!	@Description
#!	Return the fan of the edge of a simplicial surface. For this to be unique
#!	at most two faces can be incident to the edge (otherwise the permutation
#!	of those is not unique). This is guaranteed to be the case if the simplicial
#!	surface is an actual surface.
#!
#!	@Arguments a simplicial surface, a positive integer
#!	@Returns a fan
InstallMethod( SimplicialSurfaceFanByEdgeInSimplicialSurface,
	"for a simplicial surface and a positive integer",
	[IsSimplicialSurface, IsPosInt],
	function( surface, edge )
		local fan, vertices, faces, perm;

		if not edge in Edges(surface) then
			Error("SimplicialSurfaceFanByEdgeInSimplicialSurface: Given edge has to lie in given surface.");
		fi;

		faces := EdgesByFaces(surface)[edge];
		if Size(faces) = 1 then
			perm := ();
		elif Size(faces) = 2 then
			perm := PermListList( faces, Reversed(faces) );
		else
			Error("SimplicialSurfaceFanByEdgeInSimplicialSurface: There have to be at most two faces incident to the given edge.");
		fi;

		vertices := EdgesByVertices(surface)[edge];

		return SimplicialSurfaceFanNC( vertices[1], vertices[2], perm, 
															Corona := faces);
	end
);


##
##
##							End of constructors
##
#############################################################################
#############################################################################


#! @Description
#! Return the begin of the fan (which is one part of the orientation)
#! @Arguments a simplicial surface fan
#! @Returns a positive integers
InstallMethod( BeginOfFan, "for a simplicial surface fan", 
	[IsSimplicialSurfaceFan],
	function( fan )
		return BeginOfFanAttributeOfSimplicialSurfaceFan( fan );
	end
);


#! @Description
#! Return the end of the fan (which is one part of the orientation)
#! @Arguments a simplicial surface fan
#! @Returns a positive integers
InstallMethod( EndOfFan, "for a simplicial surface fan", 
	[IsSimplicialSurfaceFan],
	function( fan )
		return EndOfFanAttributeOfSimplicialSurfaceFan( fan );
	end
);


#! @Description
#! Return the permutation of the fan.
#! @Arguments a simplicial surface fan
#! @Returns a positive integers
InstallMethod( PermutationOfFan, "for a simplicial surface fan", 
	[IsSimplicialSurfaceFan],
	function( fan )
		return PermutationOfFanAttributeOfSimplicialSurfaceFan( fan );
	end
);


#! @Description
#! Return the corona of the fan.
#! @Arguments a simplicial surface fan
#! @Returns a set of positive integers
InstallMethod( CoronaOfFanAttributeOfSimplicialSurfaceFan,
	"for a simplicial surface fan", [IsSimplicialSurfaceFan],
	function( fan )
		if PermutationOfFan( fan ) <> () then
			return MovedPoints( fan );
		fi;
		TryNextMethod();
	end
);
InstallMethod( CoronaOfFan, "for a simplicial surface fan", 
	[IsSimplicialSurfaceFan],
	function( fan )
		return CoronaOfFanAttributeOfSimplicialSurfaceFan( fan );
	end
);


#! @Description
#! Return the inverse of the fan. You get the inverse of a fan by switching
#! Begin and End in addition to inverting the permutation.
#! @Arguments a simplicial surface fan
#! @Returns a positive integers
InstallMethod( InverseOfFanAttributeOfSimplicialSurfaceFan, 
	"for a simplicial surface fan", [IsSimplicialSurfaceFan],
	function( fan )
		local inv;

		inv := SimplicialSurfaceFan( EndOfFan(fan), BeginOfFan(fan),
			PermutationOfFan(fan)^(-1) );

		# The inverse of the inverse is the original
		SetInverseOfFanAttributeOfSimplicialSurfaceFan( inv, fan);

		return inv;
	end
);
InstallMethod( InverseOfFan, "for a simplicial surface fan", 
	[IsSimplicialSurfaceFan],
	function( fan )
		return InverseOfFanAttributeOfSimplicialSurfaceFan( fan );
	end
);


#!	@Description
#!	Return the reduct of a given fan with respect to the given set. The reduct
#!	of a fan is another fan with the same Begin and End but a modified
#!	permutation. The permutation is derived from the cycle-presentation of the
#!	permutation by ignoring all values that doesn't lie in the given set. the
#!	set has to be a subset of the corona.
#!
#!	@Arguments a simplicial surface fan, a set of positive integers
#!	@Returns a simplicial surface fan
InstallMethod( ReducedFanAttributeOfSimplicialSurfaceFanOp, 
	"for a simplicial surface fan and a subset of its corona", 
	[IsSimplicialSurfaceFan, IsSet],
	function( fan, set )
		local source, image, i, p, el, reduct;

		if not IsSubset( CoronaOfFan(fan), set ) then
			Error("ReducedFan: Given set has to be a subset of the fan-corona.");
		fi;

		# Check the trivial case
		if CoronaOfFan(fan) = set then
			return fan;
		fi;

		# Modify the permutation by constructing two lists, source and image
		source := Filtered( CoronaOfFan(fan), x -> x in set );
		image := [];
		for i in [1..Length(source)] do
			p := source[i];
			el := p^PermutationOfFan(fan);
			while not el in set do
				el := el^PermutationOfFan(fan);
			od;
			image[i] := el;
		od;

		return SimplicialSurfaceFanNC( BeginOfFan(fan), EndOfFan(fan), 
			PermListList( source, image), Corona := set );
	end
);
InstallMethod( ReducedFan, 
	"for a simplicial surface fan and a subset of its corona", 
	[IsSimplicialSurfaceFan, IsSet],
	function( fan, set )
		return ReducedFanAttributeOfSimplicialSurfaceFan( fan, set );
	end
);


#
###  This program is free software: you can redistribute it and/or modify
###  it under the terms of the GNU General Public License as published by
###  the Free Software Foundation, either version 3 of the License, or
###  (at your option) any later version.
###
###  This program is distributed in the hope that it will be useful,
###  but WITHOUT ANY WARRANTY; without even the implied warranty of
###  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
###  GNU General Public License for more details.
###
###  You should have received a copy of the GNU General Public License
###  along with this program.  If not, see <http://www.gnu.org/licenses/>.
###