require! <[fs]>
[type] = process.argv .slice
all-protein = JSON.parse fs.read-file-sync "../output/protein2#type.json"
feature-log = "../output/#type.feature"
train-data = ''
hindex-table = do
  R: -4.5 K: -3.9 N: -3.5 D: -3.5 Q: -3.5
  E: -3.5 H: -3.2 P: -1.6 Y: -1.3 W: -0.9
  S: -0.8 T: -0.7 G: -0.4 A: 1.8 M: 1.9
  C: 2.5 F: 2.8 L: 3.8 V: 4.2 I: 4.5

for protein, content of all-protein
  train-data += get-feature content
  break
console.log train-data
# fs.write-file-sync feature-log, train-data

function get-feature content
  feature = []
  [ data, seq, hydro ] = [ content.label, content.seq, content.hydro ]
  feature ++= pnh-ratio hydro
  feature ++= pnh-length seq, hydro
  feature ++= pnh-turning-point hydro
  for value, index in feature then data += " #{index+1}:#value"
  return data + \\n

function pnh-ratio hydro-seq
  [ polar, netral, hydrophobic ] = [0] * 3
  for amoni-hydro in hydro-seq
    switch amoni-hydro | \P => polar++ | \N => netral++ | \H => hydrophobic++
  return [ polar , netral, hydrophobic ]

function pnh-length seq, hydro-seq
  polar = [ 0 ] * 2; hydrophobic = [ 0 ] * 2
  mark = []; value-seq = []; before-hydro = \N
  for amoni-hydro, index in hydro-seq
    num = switch amoni-hydro
      | \N => 0
      | \P =>
        switch that | before-hydro => mark[index - 1] + 1 | _ => 1
      | \H =>
        switch that | before-hydro => mark[index - 1] - 1 | _ =>  -1
    mark.push num; before-hydro = amoni-hydro
    value = if (in [ 1, 0, -1 ]) num then hindex-table[seq[index]] else value + hindex-table[seq[index]]
    value-seq.push value
    # console.log mark[index - 1]
    if num > polar[0] then polar = [ num, index ]
    if num < hydrophobic[0] then hydrophobic = [ num, index ]
  # console.log mark
  # console.log value-seq
  return [polar[0], value-seq[polar[1]], -hydrophobic[0], value-seq[hydrophobic[1]], (Math.max ...value-seq), (Math.min ...value-seq)]

function pnh-turning-point hydro-seq
  [ np, ph, hn ] = [0] * 3
  for let acid, i in hydro-seq by 1 when i isnt hydro-seq.length - 1
    if acid is \N and hydro-seq[i+1] is \P => np++
    else if acid is \P and hydro-seq[i+1] is \N => np++
    else if acid is \P and hydro-seq[i+1] is \H => ph++
    else if acid is \H and hydro-seq[i+1] is \P => ph++
    else if acid is \H and hydro-seq[i+1] is \N => hn++
    else if acid is \N and hydro-seq[i+1] is \H => hn++
  return [ np, ph, hn ]

# function evaluate hydro-seq, label
#   l = hydro-seq.length; type = hydro-seq.0; i = 1; count = 1; result = []
#   while i < l
#     if hydro-seq[i] is type then count++
#     else result.push "#type|#count" if count > 9 and type isnt \N; count = 1; type = hydro-seq[i]
#     i++
#   console.log "#label | #result"
#   process.exit 1

# vi:et:sw=2:ts=2
