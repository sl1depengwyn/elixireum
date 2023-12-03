{:defmodule,
 [do: [line: 0, column: 23], end: [line: 16, column: 1], line: 0, column: 0],
 [
   ETH.StorageA,
   [
     do: {:__block__, [],
      [
        {:alias,
         [
           end_of_expression: [newlines: 1, line: 1, column: 27],
           line: 1,
           column: 3
         ], [Blockchain.Storage]},
        {:alias,
         [
           end_of_expression: [newlines: 2, line: 2, column: 13],
           line: 2,
           column: 3
         ], [Enum]},
        {:@,
         [
           end_of_expression: [newlines: 2, line: 4, column: 20],
           line: 4,
           column: 3
         ], [{:var_name, [line: 4, column: 4], [:number]}]},
        {:@,
         [
           end_of_expression: [newlines: 1, line: 6, column: 29],
           line: 6,
           column: 3
         ],
         [
           {:spec, [line: 6, column: 4],
            [
              {:"::", [line: 6, column: 23],
               [
                 {:store, [closing: [line: 6, column: 21], line: 6, column: 9],
                  [
                    {:u256,
                     [closing: [line: 6, column: 20], line: 6, column: 15], []}
                  ]},
                 :ok
               ]}
            ]}
         ]},
        {:def,
         [
           end_of_expression: [newlines: 2, line: 10, column: 6],
           do: [line: 7, column: 18],
           end: [line: 10, column: 3],
           line: 7,
           column: 3
         ],
         [
           {:store, [closing: [line: 7, column: 16], line: 7, column: 7],
            [{:num, [line: 7, column: 13], nil}]},
           [
             do: {:__block__, [],
              [
                {:=,
                 [
                   end_of_expression: [newlines: 1, line: 8, column: 15],
                   line: 8,
                   column: 10
                 ], [{:test, [line: 8, column: 5], nil}, 123]},
                {{:., [line: 9, column: 12], [Storage, :store]},
                 [closing: [line: 9, column: 33], line: 9, column: 13],
                 [
                   {:@, [line: 9, column: 19],
                    [{:var_name, [line: 9, column: 20], nil}]},
                   {:num, [line: 9, column: 30], nil}
                 ]}
              ]}
           ]
         ]},
        {:@,
         [
           end_of_expression: [newlines: 1, line: 12, column: 29],
           line: 12,
           column: 3
         ],
         [
           {:spec, [line: 12, column: 4],
            [
              {:"::", [line: 12, column: 20],
               [
                 {:retrieve,
                  [closing: [line: 12, column: 18], line: 12, column: 9], []},
                 {:u256,
                  [closing: [line: 12, column: 28], line: 12, column: 23], []}
               ]}
            ]}
         ]},
        {:def,
         [
           do: [line: 13, column: 18],
           end: [line: 15, column: 3],
           line: 13,
           column: 3
         ],
         [
           {:retrieve, [closing: [line: 13, column: 16], line: 13, column: 7],
            []},
           [
             do: {{:., [line: 14, column: 12], [Storage, :get]},
              [closing: [line: 14, column: 26], line: 14, column: 13],
              [
                {:@, [line: 14, column: 17],
                 [{:var_name, [line: 14, column: 18], nil}]}
              ]}
           ]
         ]}
      ]}
   ]
 ]}
