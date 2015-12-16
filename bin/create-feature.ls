require! <[fs]>
all-protein = JSON.parse fs.read-file-sync \../output/protein2predata.json
feature-log = \../output/feature.json
train-data = ''

for protein, content of all-protein
  train-data += get-feature content
  # break
# console.log train-data
fs.write-file-sync feature-log, train-data

function get-feature content
  feature = []
  [ data, hydro ] = [ content.label, content.hydro ]
  feature ++= pnh-ratio hydro
  feature ++= pnh-length hydro
  for value, index in feature then data += " #{index+1}:#value"
  return data + \\n

function pnh-ratio hydro-seq
  [ polar, netral, hydrophobic ] = [0] * 3
  for amoni-hydro in hydro-seq
    switch amoni-hydro | \P => polar++ | \N => netral++ | \H => hydrophobic++
  return [ polar, netral, hydrophobic ]

function pnh-length hydro-seq
  [ polar, hydrophobic ] = [0] * 2
  mark = []; before-hydro = \N
  for amoni-hydro, index in hydro-seq
    num = switch amoni-hydro
      | \N => 0
      | \P =>
        switch that | before-hydro => mark[index - 1] + 1 | _ => 1
      | \H =>
        switch that | before-hydro => mark[index - 1] - 1 | _ =>  -1
    mark.push num; before-hydro = amoni-hydro
    #console.log mark[index - 1]
    if num > polar then polar = num
    if num < hydrophobic then hydrophobic = num
  # console.log mark
  return [ polar, -hydrophobic ]

# vi:et:sw=2:ts=2
