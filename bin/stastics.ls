require! <[fs json2csv]>
all-protein = JSON.parse fs.read-file-sync \../output/train.hydro.json
hindex-table = do
  R: -4.5 K: -3.9 N: -3.5 D: -3.5 Q: -3.5
  E: -3.5 H: -3.2 P: -1.6 Y: -1.3 W: -0.9
  S: -0.8 T: -0.7 G: -0.4 A: 1.8 M: 1.9
  C: 2.5 F: 2.8 L: 3.8 V: 4.2 I: 4.5
# deformation =
#   positive: {}, negative:{}
deformation =
  positive: [], negative: []
# fields = <[protein stas.ratio.polar stas.ratio.netual stas.ratio.hydrophobic stas.length.length]>
fields = [\protein]
# fields ++= for i from 1 to 30 then "stas.length.polar.#i"
# fields ++= for i from 1 to 30 then "stas.length.netual.#i"
fields ++= for i from 1 to 30 then "stas.length.hydrophobic.#i"

for protein, content of all-protein
  stas = {}
  stas <<< ratio: pnh-ratio content.hydro
  stas <<< length: pnh-length content.hydro
  # if content.label is \1 then deformation.positive <<< "#protein": stas else deformation.negative <<< "#protein": stas
  if content.label is \1 then deformation.positive ++= {protein, stas} else deformation.negative ++= {protein, stas}
# console.log fields
json2csv({data: deformation.positive, fields: fields}, (err, csv)->
# json2csv({data: deformation.negative, fields: fields}, (err, csv)->
  console.log err if err
  fs.write-file-sync \file.csv, csv
)
# console.log JSON.stringify deformation, null, 2
# lay-out-table!

function pnh-ratio hydro-seq
  [ polar, netual, hydrophobic ] = [0] * 3
  for amoni-hydro in hydro-seq
    switch amoni-hydro | \P => polar++ | \N => netual++ | \H => hydrophobic++
  polar = Math.round( polar / hydro-seq.length * 10000) / 100
  netual = Math.round( netual / hydro-seq.length * 10000) / 100
  hydrophobic = Math.round( hydrophobic / hydro-seq.length * 10000) / 100
  return { polar , netual, hydrophobic }

function pnh-length hydro-seq
  polar = {}; netual = {}; hydrophobic = {}; length = hydro-seq.length; len = 1
  for amoni-hydro, index in hydro-seq
    if index is -1 then marker = amoni-hydro # record previous hydro
    else
      if amoni-hydro is marker then len++
      else
        switch marker
        | \N =>
          if !netual[len]? then netual <<< "#len": 1 else netual[len]++
        | \P =>
          if !polar[len]? then polar <<< "#len": 1 else polar[len]++
        | \H =>
          if !hydrophobic[len]? then hydrophobic <<< "#len": 1 else hydrophobic[len]++
        marker = amoni-hydro; len = 1
  switch marker # record last length amoni data
  | \N =>
    if !netual[len]? then netual <<< "#len": 1 else netual[len]++
  | \P =>
    if !polar[len]? then polar <<< "#len": 1 else polar[len]++
  | \H =>
    if !hydrophobic[len]? then hydrophobic <<< "#len": 1 else hydrophobic[len]++
  return { length, polar, netual, hydrophobic }

!function lay-out-table
  console.log "\t\t ratio \t\t\t\t length"
  console.log "\t polar  netual  hydrophobic  length  polar  netual  hydrophobic"
  for protein, labol of deformation.positive
    arrays = ''
    for k,v of labol.ratio then arrays ++= "#v "
    console.log protein + " " + arrays

# vi:et:sw=2:ts=2
