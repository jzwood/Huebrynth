module Level1 exposing (..)

import HuebrynthTypes exposing (..)

n0 = Node 0 Empty
n1 = Node 1 Empty
n2 = Node 2 End
n3 = Node 3 Empty
n4 = Node 4 Empty
n5 = Node 5 Start
n6 = Node 6 Empty
n7 = Node 7 Empty
n8 = Node 8 Empty
n9 = Node 9 Empty
n10 = Node 10 Empty
n11 = Node 11 Empty

boardL1 =
    [ [ n0, n1, n2 ]
    , [ n3, n4, n5 ]
    , [ n6, n7, n8 ]
    , [ n9, n10, n11 ]
    ]

e0 = Edge 0 (Gated 7) n0 n1
e16 = Edge 16 Wall n1 n2

e1 = Edge 1 (Gated 1) n0 n3
e2 = Edge 2 (Gated 3) n1 n4
e3 = Edge 3 (Gated 2) n2 n5

e4 = Edge 4 Open n3 n4
e5 = Edge 5 Open n4 n5

e6 = Edge 6 Open n3 n6
e7 = Edge 7 (Gated 1) n4 n7
e8 = Edge 8 Open n5 n8

e9 = Edge 9 (Gated 1) n6 n7
e10 = Edge 10 (Gated 1) n7 n8

e11 = Edge 11 Open n6 n9
e12 = Edge 12 (Gated 1) n7 n10
e13 = Edge 13 Open n8 n11

e14 = Edge 14 Open n9 n10
e15 = Edge 15 Open n10 n11

edgesL1 = [ e0, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14, e15, e16 ]
