module Level3 exposing (..)

import HuebrynthCore exposing (..)

n0 = Node 0 Start
n1 = Node 1 End
n2 = Node 2 Empty
n3 = Node 3 Empty
n4 = Node 4 Empty
n5 = Node 5 Empty
n6 = Node 6 Empty
n7 = Node 7 Empty
n8 = Node 8 Empty
n9 = Node 9 Empty

boardL3 =
    [ [ n0, n1 ]
    , [ n2, n3 ]
    , [ n4, n5 ]
    , [ n6, n7 ]
    , [ n8, n9 ]
    ]

e0 = Edge 0 Wall n0 n1
e1 = Edge 1 (Gated 2) n2 n3
e2 = Edge 2 Wall n4 n5
e3 = Edge 3 (Gated 1) n6 n7
e4 = Edge 4 Open n8 n9

e5 = Edge 5 (Gated 1) n0 n2
e6 = Edge 6 (Gated 1) n2 n4
e7 = Edge 7 (Gated 2)  n4 n6
e8 = Edge 8 Open n6 n8

e9 = Edge 9 (Gated 2) n1 n3
e10 = Edge 10 (Gated 5) n3 n5
e11 = Edge 11 (Gated 4) n5 n7
e12 = Edge 12 Open n7 n9


edgesL3 = [ e0, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12 ]
