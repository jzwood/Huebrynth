module Huebrynth exposing (..)

type NodePos = Coordinate Int Int
type NodeType = Start | Empty | End
type Node = Node NodePos NodeType
type alias Lock = Int
type Edge = Open | Gated Lock

n1 = Node (Coordinate 0 1) Empty
n2 = Node (Coordinate 0 2) Empty
n3 = Node (Coordinate 0 3) Empty
n4 = Node 4 Empty
n5 = Node 5 Empty
n6 = Node 6 Empty
n7 = Node 7 Empty
n8 = Node 8 Empty
n9 = Node 9 Empty
n10 = Node 10 Empty
n11 = Node 11 Empty
n12 = Node 12 Empty

-- each node in grid is connected via an edge to its adjacent neighbors (von Neumann neighborhood)
-- the idea is to start with every node connected with a generic gated edge and to
e1 = Edge 1 (Gated 0) n1 n2
e2 = Edge 2 (Gated 0) n2 n3
e3 = Edge 3 (Gated 0) n3 n4
e4 = Edge 4 (Gated 0) n1 n5
e5 = Edge 5 (Gated 0) n2 n6
e6 = Edge 6 (Gated 0) n3 n7
e7 = Edge 7 (Gated 0) n4 n8
e8 = Edge 8 (Gated 0) n5 n6
e9 = Edge 9 (Gated 0) n6 n7
e10 = Edge 10 (Gated 0) n7 n8
e11 = Edge 11 (Gated 0) n5 n9
e12 = Edge 12 (Gated 0) n6 n10
e13 = Edge 13 (Gated 0) n7 n11
e14 = Edge 14 (Gated 0) n8 n12
e15 = Edge 15 (Gated 0) n9 n10
e16 = Edge 16 (Gated 0) n10 n11
e17 = Edge 17 (Gated 0) n11 n12

es = [e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14, e15, e16, e17]

