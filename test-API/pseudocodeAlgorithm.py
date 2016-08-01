What do i need?

min. max, break case, midpoint(find that in our array), value


def timeOfPassenger(coordinates) 
	#returns the time to a destination given a set of coordinates

def timeOfDriver(coordinates)
	#returns the time to a destination 

def getMidPoint(origin, destination)
	#returns the coordinates of the midpoint of the 
	[ on this rn ]

#USE waypoints INSTEAD!!! parse through json data

def BinarySearch(origin, destination)
	
	midpointOfOriginalRoute = getMidPoint(origin,destination)

	if (timeOfPassenger(midpointOfOriginalRoute) == timeOfDriver(midpointOfOriginalRoute) //will have a bit of a buffer
	
		return pickupLocation #coordinates

	if (timeOfPassenger(midpointOfOriginalRoute) < timeOfDriver(midpointOfOriginalRoute)

		BinarySearch(midpointOfOriginalRoute, destination)

	else if (timeOfPassenger(midpointOfOriginalRoute) > timeOfDriver(midpointOfOriginalRoute)

		BinarySearch(midpointOfOriginalRoute, destination)
	
	
             
1) Retrieve driving directions from point A to Point B
2) Construct Array of "step" objects from JSON driving directions
3) Construct Second array of "step" objects from the same JSON driving directions array
    3a) Reverse this array from A to B , to , B to A.
    3b) Recompute time for each step using the distances * 3mph
4) Iterate through the driving steps, summative time. ((a to b) to c) to d ...)
5)Iterate through the walking steps, summative time (d to c) to b ...)
6) Subtract the sums from the respective indices.
    6a) take the absolute value of these sums (each sum refers to a coordinate)
7) Find the minimum of the differences
8) This coordinate is the meetup point.
    8a) can this be further optimizied??????????????? maybe

             